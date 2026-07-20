# =============================================================================
# Open Juce project in CLion
# =============================================================================
#
# File:     OpenInCLion.py
# Author:   KinKout
# Date:     11-May-2026
#
# Purpose:  - detect system platform
#           - read CMakePresets.json
#           - change CMakePresets.json based on platform if needed
#           - read /cmake_config/definePathConfig.json
#           - open CLion based on platform
#
# Project structure:
# 
#   /root/
#       OpenInCLion.py
#       CMakePresets.json
#       cmake_config/
#           definePathConfig.json
#           cmake_presets/
#               darwin.json
#               windows.json
#
# 						!!! Do NOT edit paths here !!!
#
# =============================================================================


# =============================================================================
# Init program, imports, variables, check system platform
# =============================================================================

import json
import platform
import subprocess
import sys
from pathlib import Path


# -------------------------------------------------------------------------------- Paths
ROOT = Path(__file__).parent.resolve()
CMAKE_PRESETS = ROOT / "CMakePresets.json"
CMAKE_CONFIG_DIR = ROOT / "cmake_config"
CMAKE_PRESETS_DIR = CMAKE_CONFIG_DIR / "cmake_presets"
DEFINE_PATH_CONFIG = CMAKE_CONFIG_DIR / "definePathConfig.json"


# -------------------------------------------------------------------------------- Platform detection
SYSTEM = platform.system()  # 'Darwin' | 'Windows'

PLATFORM_KEY = {
    "Darwin":  "darwin",
    "Windows": "windows",
}.get(SYSTEM)

if PLATFORM_KEY is None:
    print(f"[ERROR] Unsupported platform: '{SYSTEM}'.")
    print(f"        Add an entry in PLATFORM_KEY and create the matching preset file.")
    sys.exit(1)


# =============================================================================
# Function definition
# =============================================================================

# -------------------------------------------------------------------------------- JSON reader
def read_json(path: Path) -> dict:
    if not path.exists():
        print(f"[ERROR] File not found: {path}")
        sys.exit(1)
    try:
        with open(path, "r", encoding="utf-8") as f:
            return json.load(f)
    except json.JSONDecodeError as e:
        print(f"[ERROR] Invalid JSON in {path}: {e}")
        sys.exit(1)


# -------------------------------------------------------------------------------- Open CLion
def open_clion(clion_path: Path) -> None:
    print(f"[INFO]  Opening CLion: {clion_path}")
    print(f"[INFO]  Project: {ROOT}")

    try:
        if PLATFORM_KEY == "darwin":
            clion_bin = clion_path / "Contents" / "MacOS" / "clion"
            if not clion_bin.exists():
                print(f"[ERROR] CLion binary not found at: {clion_bin}")
                print(f"        Expected: <YourCLion.app>/Contents/MacOS/clion")
                sys.exit(1)
            subprocess.Popen(
                [str(clion_bin), str(ROOT)],
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
            )

        elif PLATFORM_KEY == "windows":
            subprocess.Popen(
                [str(clion_path), str(ROOT)],
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
            )

    except OSError as e:
        print(f"[ERROR] Failed to start CLion: {e}")
        sys.exit(1)

    print(f"[INFO]  CLion launched successfully.")


# -------------------------------------------------------------------------------- CLion path
def get_clion_path() -> Path:
    config = read_json(DEFINE_PATH_CONFIG)

    platform_config = config.get(PLATFORM_KEY)
    if platform_config is None:
        print(f"[ERROR] Key '{PLATFORM_KEY}' not found in definePathConfig.json.")
        sys.exit(1)

    clion_str = platform_config.get("clion", "").strip()
    if not clion_str:
        print(f"[ERROR] CLion path for '{PLATFORM_KEY}' is empty in definePathConfig.json.")
        sys.exit(1)

    clion_path = Path(clion_str)
    if not clion_path.exists():
        print(f"[ERROR] CLion not found at: {clion_path}")
        print(f"        Check the path in definePathConfig.json.")
        sys.exit(1)

    return clion_path


# -------------------------------------------------------------------------------- CMakePresets sync
def get_preset_rhs(presets: dict) -> str | None:
    """Returns condition.rhs of the first configurePreset (e.g. 'Darwin', 'Windows')."""
    try:
        return presets["configurePresets"][0]["condition"]["rhs"]
    except (KeyError, IndexError):
        return None

def sync_cmake_presets() -> None:
    # SYSTEM matches condition.rhs directly ('Darwin' or 'Windows')
    expected_rhs = SYSTEM

    platform_preset = CMAKE_PRESETS_DIR / f"{PLATFORM_KEY}.json"
    if not platform_preset.exists():
        print(f"[ERROR] Preset file not found: {platform_preset}")
        print(f"        Create '{PLATFORM_KEY}.json' in {CMAKE_PRESETS_DIR}")
        sys.exit(1)

    if CMAKE_PRESETS.exists():
        cmake_presets_file = read_json(CMAKE_PRESETS)
        current_rhs = get_preset_rhs(cmake_presets_file)
        if current_rhs == expected_rhs:
            print(f"[INFO]  CMakePresets.json already configured for '{PLATFORM_KEY}'. No changes needed.")
            return
        print(f"[INFO]  CMakePresets.json is set for '{current_rhs}', current platform is '{expected_rhs}'.")
        print(f"[INFO]  Updating CMakePresets.json...")
    else:
        print(f"[INFO]  CMakePresets.json not for this platform. Creating for '{PLATFORM_KEY}'...")

    preset_data = read_json(platform_preset)
    with open(CMAKE_PRESETS, "w", encoding="utf-8") as f:
        json.dump(preset_data, f, indent=2, ensure_ascii=False)
    print(f"[INFO]  CMakePresets.json updated.")


# -------------------------------------------------------------------------------- Main
def main() -> None:
    sync_cmake_presets()
    clion_path = get_clion_path()
    open_clion(clion_path)


# =============================================================================
# main function (entry point)
# =============================================================================

main()
sys.exit(0)

