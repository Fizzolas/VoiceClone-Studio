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


def check_python_version() -> bool:
    """Check if Python version is compatible."""
    version_info = sys.version_info
    
    if version_info.major != 3:
        logging.error(f"Python 3 required, but running Python {version_info.major}")
        return False
    
    if version_info.minor < 10:
        logging.error(
            f"Python 3.10+ required, but running Python {version_info.major}.{version_info.minor}"
        )
        logging.error("Please install Python 3.10, 3.11, or 3.12")
        return False
    
    if version_info.minor >= 13:
        logging.error(
            f"Python 3.13+ is not supported (running Python {version_info.major}.{version_info.minor})"
        )
        logging.error("The coqui-tts library does not support Python 3.13+")
        logging.error("Please install Python 3.10, 3.11, or 3.12")
        logging.error("\nTo fix:")
        logging.error("  1. Install Python 3.11: winget install -e --id Python.Python.3.11")
        logging.error("  2. Delete existing venv: rmdir /s /q venv")
        logging.error("  3. Create new venv: py -3.11 -m venv venv")
        logging.error("  4. Run installer: install.bat")
        return False
    
    return True


def check_dependencies() -> bool:
    """Check if all required dependencies are installed."""
    required_packages = [
        "torch",
        "torchaudio",
        "PyQt6",
        "librosa",
        "soundfile",
        ("TTS", "coqui-tts"),  # Either package name works
    ]
    
    missing_packages = []
    for package in required_packages:
        if isinstance(package, tuple):
            # Try multiple package names
            found = False
            for pkg_name in package:
                try:
                    __import__(pkg_name)
                    found = True
                    break
                except ImportError:
                    continue
            if not found:
                missing_packages.append(package[0])
        else:
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
        from PyQt6.QtWidgets import QApplication, QMessageBox
        
        app = QApplication(sys.argv)
        app.setApplicationName("VoiceClone Studio")
        app.setOrganizationName("VoiceClone Studio")
        
        # Try to import main window
        try:
            from gui.main_window import MainWindow
            window = MainWindow()
            window.show()
            return app.exec()
        except ImportError:
            # GUI not implemented yet - show message
            msg = QMessageBox()
            msg.setIcon(QMessageBox.Icon.Information)
            msg.setWindowTitle("VoiceClone Studio - Alpha Version")
            msg.setText("GUI Not Yet Implemented")
            msg.setInformativeText(
                "VoiceClone Studio v0.1.0-alpha\n\n"
                "The graphical user interface is currently under development.\n\n"
                "The GUI will be available in v0.2.0 (Q1 2026).\n\n"
                "Current status:\n"
                "• ✅ Installation and dependencies\n"
                "• ✅ Project structure and documentation\n"
                "• 🚧 GUI implementation (coming soon)\n"
                "• 🚧 Voice training pipeline (coming soon)\n"
                "• 🚧 Voice generation (coming soon)\n\n"
                "For updates, visit:\n"
                "https://github.com/Fizzolas/VoiceClone-Studio"
            )
            msg.setStandardButtons(QMessageBox.StandardButton.Ok)
            msg.exec()
            return 0
    
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
    
    except ImportError:
        logging.error("CLI functionality not yet implemented (coming in v0.2.0)")
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
    
    except ImportError:
        logging.error("API functionality not yet implemented (coming in v0.3.0)")
        return 1
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
    
    logging.info("="*50)
    logging.info("VoiceClone Studio v0.1.0-alpha")
    logging.info("="*50)
    logging.info(f"Python version: {sys.version}")
    logging.info(f"Mode: {args.mode}")
    
    # Check Python version
    if not check_python_version():
        return 1
    
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