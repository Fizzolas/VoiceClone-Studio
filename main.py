#!/usr/bin/env python3
"""
VoiceClone Studio - Main Application Entry Point

An open-source voice cloning application with real-time training,
intuitive GUI, and API integration for external AI assistants.

Author: VoiceClone Studio Contributors
License: MIT
"""

import sys
import argparse
import logging
from pathlib import Path

# Add src directory to Python path
sys.path.insert(0, str(Path(__file__).parent / "src"))


def setup_logging(level: str = "INFO", log_file: bool = True) -> None:
    """Configure application logging."""
    log_format = "%(asctime)s - %(name)s - %(levelname)s - %(message)s"
    handlers = [logging.StreamHandler()]
    
    if log_file:
        log_dir = Path("logs")
        log_dir.mkdir(exist_ok=True)
        handlers.append(
            logging.FileHandler(log_dir / "voiceclone.log")
        )
    
    logging.basicConfig(
        level=getattr(logging, level.upper()),
        format=log_format,
        handlers=handlers
    )


def check_dependencies() -> bool:
    """Check if all required dependencies are installed."""
    required_packages = [
        "torch",
        "torchaudio",
        "PyQt6",
        "librosa",
        "soundfile",
        "TTS",
    ]
    
    missing_packages = []
    for package in required_packages:
        try:
            __import__(package)
        except ImportError:
            missing_packages.append(package)
    
    if missing_packages:
        logging.error(f"Missing required packages: {', '.join(missing_packages)}")
        logging.error("Please install dependencies: pip install -r requirements.txt")
        return False
    
    return True


def run_gui() -> int:
    """Launch the GUI application."""
    try:
        from PyQt6.QtWidgets import QApplication
        from gui.main_window import MainWindow
        
        app = QApplication(sys.argv)
        app.setApplicationName("VoiceClone Studio")
        app.setOrganizationName("VoiceClone Studio")
        
        window = MainWindow()
        window.show()
        
        return app.exec()
    
    except Exception as e:
        logging.exception(f"Failed to start GUI: {e}")
        return 1


def run_cli(args: argparse.Namespace) -> int:
    """Run command-line interface."""
    try:
        from utils.cli import CLIHandler
        
        cli = CLIHandler()
        
        if args.command == "train":
            return cli.train(
                audio_path=args.audio,
                voice_name=args.name,
                transcript=args.transcript
            )
        
        elif args.command == "generate":
            return cli.generate(
                text=args.text,
                voice=args.voice,
                output=args.output,
                speed=args.speed,
                pitch=args.pitch
            )
        
        elif args.command == "list":
            return cli.list_voices()
        
        else:
            logging.error(f"Unknown command: {args.command}")
            return 1
    
    except Exception as e:
        logging.exception(f"CLI error: {e}")
        return 1


def run_api(host: str = "0.0.0.0", port: int = 8080) -> int:
    """Start the API server."""
    try:
        from api.server import start_server
        
        logging.info(f"Starting API server on {host}:{port}")
        start_server(host=host, port=port)
        return 0
    
    except Exception as e:
        logging.exception(f"Failed to start API server: {e}")
        return 1


def main() -> int:
    """Main application entry point."""
    parser = argparse.ArgumentParser(
        description="VoiceClone Studio - Open-source voice cloning application"
    )
    
    parser.add_argument(
        "--mode",
        choices=["gui", "cli", "api"],
        default="gui",
        help="Application mode (default: gui)"
    )
    
    parser.add_argument(
        "--log-level",
        choices=["DEBUG", "INFO", "WARNING", "ERROR"],
        default="INFO",
        help="Logging level (default: INFO)"
    )
    
    parser.add_argument(
        "--no-log-file",
        action="store_true",
        help="Disable logging to file"
    )
    
    # API mode arguments
    parser.add_argument(
        "--host",
        default="0.0.0.0",
        help="API server host (default: 0.0.0.0)"
    )
    
    parser.add_argument(
        "--port",
        type=int,
        default=8080,
        help="API server port (default: 8080)"
    )
    
    # CLI mode subcommands
    subparsers = parser.add_subparsers(dest="command", help="CLI commands")
    
    # Train command
    train_parser = subparsers.add_parser("train", help="Train a new voice model")
    train_parser.add_argument("audio", help="Path to audio file or directory")
    train_parser.add_argument("--name", required=True, help="Voice profile name")
    train_parser.add_argument("--transcript", help="Path to transcript file")
    
    # Generate command
    generate_parser = subparsers.add_parser("generate", help="Generate speech")
    generate_parser.add_argument("text", help="Text to synthesize")
    generate_parser.add_argument("--voice", required=True, help="Voice profile name")
    generate_parser.add_argument("--output", required=True, help="Output audio file")
    generate_parser.add_argument("--speed", type=float, default=1.0, help="Speech speed")
    generate_parser.add_argument("--pitch", type=int, default=0, help="Pitch shift")
    
    # List command
    subparsers.add_parser("list", help="List available voice profiles")
    
    args = parser.parse_args()
    
    # Setup logging
    setup_logging(level=args.log_level, log_file=not args.no_log_file)
    
    logging.info("Starting VoiceClone Studio")
    logging.info(f"Mode: {args.mode}")
    
    # Check dependencies
    if not check_dependencies():
        return 1
    
    # Run appropriate mode
    if args.mode == "gui":
        return run_gui()
    
    elif args.mode == "cli":
        if not args.command:
            logging.error("CLI mode requires a command (train, generate, or list)")
            parser.print_help()
            return 1
        return run_cli(args)
    
    elif args.mode == "api":
        return run_api(host=args.host, port=args.port)
    
    else:
        logging.error(f"Invalid mode: {args.mode}")
        return 1


if __name__ == "__main__":
    sys.exit(main())