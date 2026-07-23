# ================================================================================
# Open Juce project in CLion
# ================================================================================
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
# ================================================================================
#
#                   ! ! !    Do NOT edit paths here    ! ! !
#
# ================================================================================

import json
import platform
import subprocess
import sys
from pathlib import Path
from typing import NoReturn

# --------------------------------------------------------------------------------
# Global Variables
# --------------------------------------------------------------------------------

# ---------------------- Here you can add the new platforms ----------------------

# ------------------------------------------- Linux is not supported at the moment
PLATFORM_CONFIG = {
    "Darwin": {
        "platform_name": "darwin",
        "app_name": "CLion.app",
        "sub_path": "/Contents/MacOS/clion",
    },
    "Windows": {
        "platform_name": "windows",
        "app_name": "clion64.exe",
        "sub_path": "",
    },
}

# --------------------- ! ! ! Don't edit this section ! ! ! ----------------------

SYSTEM = platform.system() # Capitalized, used in CMakePresets.json for CLion settings

ROOT = Path(__file__).parent.resolve()
CMAKE_PRESETS_JSON = "CMakePresets.json"
DEFINE_PATH_CONFIG_JSON = "definePathConfig.json"
CMAKE_CONFIG_DIR = "cmake_config"
CMAKE_PRESETS_DIR = "cmake_presets"

CMAKE_PRESETS_JSON_PATH = ROOT / CMAKE_PRESETS_JSON
CMAKE_CONFIG_PATH = ROOT / CMAKE_CONFIG_DIR
CMAKE_PRESETS_PATH = ROOT / CMAKE_CONFIG_DIR / CMAKE_PRESETS_DIR
DEFINE_PATH_CONFIG_PATH = ROOT / CMAKE_CONFIG_DIR / DEFINE_PATH_CONFIG_JSON

THIS_PLATFORM = PLATFORM_CONFIG.get(SYSTEM)
PLATFORM_NAME = "" # Lowercase, used in definePathConfig.json
CLION_APP_NAME = ""
CLION_SUB_PATH = ""
CLION_PATH = ""

GITHUB_URL = "https://github.com/KinKout/KinKoutDSP-template"
GITHUB_MAIN = "/blob/main/"

J_PATH_CONFIG = {}
J_CMAKE_PRESETS = {}

# ================================================================================
# Exit codes:
GENERIC_ERROR = 1
DATA_NOT_FOUND = 2
INVALID_DATA = 3
UNSUPPORTED_PLATFORM = 99
# ================================================================================

# --------------------------------------------------------------------------------
#  Print helpers
# --------------------------------------------------------------------------------

def print_title():
    print(
        " --------------------------------------------------------------------------- \n"
        "|                                                                           |\n"
        "|                    KinKout — Open JUCE project in CLion                   |\n"
        "|                                                                           |\n"
        " --------------------------------------------------------------------------- \n\n")

def print_section(s: str):
    print(f" - {s}")

def print_loading(s: str):
    print(f" - loading {s}")

def print_ok(s: str):
    print(f"\n    >>>    done: {s}\n\n")

def print_warn(s: str):
    print(f"\n    !    {s}    !")

def print_line():
    print("-" * 80 + "\n\n")

def print_error(s: str):
    print_line()
    print(f"\n    x x x    {s}    x x x\n")

# ================================================================================
# Function definition
# ================================================================================

# -------------------------------------------------------------------------------- Exit with code number
def exit_with_code(code: int) -> NoReturn:
    print(f"\n\nexit code: {code}\n\n")
    sys.exit(code)

# -------------------------------------------------------------------------------- manage JSON
def read_json(path: Path) -> dict:
    if not path.exists():
        print_error(f"File not found: {path}")
        exit_with_code(DATA_NOT_FOUND)
    try:
        with open(path, "r", encoding="utf-8") as f:
            return json.load(f)
    except json.JSONDecodeError as e:
        print_error(f"Problem reading {path}")
        print_error(f"{e}")
        exit_with_code(INVALID_DATA)

def write_preset_json(data: dict) -> None:
    try:
        with open(CMAKE_PRESETS_JSON_PATH, "w", encoding="utf-8") as f:
            json.dump(data, f, indent=2, ensure_ascii=False)
    except OSError as e:
        print_error(f"Problem writing {CMAKE_PRESETS_JSON}")
        print_error(f"{e}")
        exit_with_code(GENERIC_ERROR)

# -------------------------------------------------------------------------------- Open CLion
def open_clion() -> None:

    try:
        subprocess.Popen(
                [str(CLION_PATH), str(ROOT)],
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
            )

    except OSError as e:
        print_error("Failed to start CLion")
        print_error(f"{e}")
        exit_with_code(GENERIC_ERROR)

    print_ok("CLion launched successfully.")

# -------------------------------------------------------------------------------- CMakePresets sync
def sync_cmake_presets() -> None:
    print_section("Validating CMakePresets.json...")

    try:
        preset_rhs = J_CMAKE_PRESETS["configurePresets"][0]["condition"]["rhs"]
    except (KeyError, IndexError, TypeError) as e:
        print_error("Invalid 'rhs' in 'CMakePresets.json'")
        print_error(f"{e}")
        print_warn(f"Please check {CMAKE_PRESETS_JSON_PATH}")
        exit_with_code(INVALID_DATA)
    
    if preset_rhs == SYSTEM:
        print_ok(f"CMakePresets.json already configured for '{PLATFORM_NAME}'. No changes needed.")
    else:
        print_section(f"CMakePresets.json is set for '{preset_rhs}', current platform is '{SYSTEM}'.")
        print_section("Updating CMakePresets.json...")
        print_loading("preset file...")

        platform_preset = CMAKE_PRESETS_PATH / f"{PLATFORM_NAME}.json"

        if not platform_preset.exists():
            print_error(f"Preset file not found: {platform_preset}")
            print_warn(f"Create a preset file '{PLATFORM_NAME}.json' in {CMAKE_PRESETS_PATH}")
            exit_with_code(UNSUPPORTED_PLATFORM)

        print_ok(f"{platform_preset}")

        preset_data = read_json(platform_preset)

        write_preset_json(preset_data)

        print_ok(f"{CMAKE_PRESETS_JSON} updated for '{SYSTEM}'.")

# -------------------------------------------------------------------------------- get CLion path
def get_clion_path() -> Path:

    config = J_PATH_CONFIG.get(PLATFORM_NAME)
    if config is None:
        print_error(f"Key '{PLATFORM_NAME}' not found in definePathConfig.json.")
        print_warn(f"You can add the '{PLATFORM_NAME}' platform entry in '{DEFINE_PATH_CONFIG_PATH}'.")
        print_warn(f"Go to {GITHUB_URL}{GITHUB_MAIN}{CMAKE_CONFIG_DIR}/readme.md for more info.")
        exit_with_code(INVALID_DATA)

    clion_str = config.get("clion", "").strip()
    clion_path = Path(clion_str + CLION_SUB_PATH) 

    if not clion_path.exists() or CLION_APP_NAME not in clion_path.parts:
        print_error(f"CLion not found at: {clion_path}")
        print_warn("Check the path of CLion.")
        exit_with_code(INVALID_DATA)

    return clion_path

# -------------------------------------------------------------------------------- Define system variables
def define_system_variables() -> None:
    global PLATFORM_NAME, CLION_APP_NAME, CLION_SUB_PATH, CLION_PATH

    print_section("Defining system variables...")

    if THIS_PLATFORM is None:
        print_error(f"Unsupported platform: '{SYSTEM}'.")
        print_warn(f"You can add the '{SYSTEM}' platform entry in 'PLATFORM_CONFIG'.")
        print_warn(f"Go to {GITHUB_URL}{GITHUB_MAIN}{CMAKE_CONFIG_DIR}/readme.md for more info.")
        exit_with_code(UNSUPPORTED_PLATFORM)

    PLATFORM_NAME = THIS_PLATFORM["platform_name"]
    CLION_APP_NAME = THIS_PLATFORM["app_name"]
    CLION_SUB_PATH = THIS_PLATFORM["sub_path"]
    CLION_PATH = get_clion_path()

    print_section(f"Platform name: {PLATFORM_NAME}")
    print_section(f"Clion app name: {CLION_APP_NAME}")
    print_section(f"Clion path: {CLION_PATH}")
    print_ok("System variables defined.")

# -------------------------------------------------------------------------------- Read Files
def read_files() -> None:
    global J_CMAKE_PRESETS, J_PATH_CONFIG

    print_section("Reading files...")

    J_PATH_CONFIG = read_json(DEFINE_PATH_CONFIG_PATH)
    print_ok("definePathConfig.json")

    J_CMAKE_PRESETS = read_json(CMAKE_PRESETS_JSON_PATH)
    print_ok("CMakePresets.json")

# -------------------------------------------------------------------------------- Control Paths
def control_paths() -> None:
    print_section("Checking paths...")

    # Control _CMakeConfig folder
    if not CMAKE_CONFIG_PATH.exists():
        print_error(f"Directory not found: '{CMAKE_CONFIG_DIR}' in '{ROOT}'")
        print_warn(f"KinKoutDSP-template is corrupted. Re-download '{CMAKE_CONFIG_DIR}' from {GITHUB_URL}{GITHUB_MAIN}{CMAKE_CONFIG_DIR}")
        print_warn(f"or download the whole template project from {GITHUB_URL}")
        exit_with_code(DATA_NOT_FOUND)
    
    # Control definePathConfig.json
    if not DEFINE_PATH_CONFIG_PATH.exists():
        print_error(f"File not found: '{DEFINE_PATH_CONFIG_JSON}' in '{CMAKE_CONFIG_PATH}'")
        print_warn(f"KinKoutDSP-template is corrupted. Re-download '{DEFINE_PATH_CONFIG_JSON}' from {GITHUB_URL}{GITHUB_MAIN}{CMAKE_CONFIG_DIR}/{DEFINE_PATH_CONFIG_JSON}")
        exit_with_code(DATA_NOT_FOUND)
    
    # Control CMakePresets folder
    recovery_preset = None
    if CMAKE_PRESETS_PATH.exists():
        p = 0
        for preset in CMAKE_PRESETS_PATH.iterdir():
            if preset.name.endswith(".json"):
                if recovery_preset is None:
                    recovery_preset = preset
                p += 1
        if p == 0:
            print_error(f"Directory is empty: '{CMAKE_PRESETS_DIR}' in '{CMAKE_PRESETS_PATH}'")
            print_warn(f"KinKoutDSP-template is corrupted. Re-download '{CMAKE_PRESETS_DIR}' from {GITHUB_URL}{GITHUB_MAIN}{CMAKE_CONFIG_DIR}/{CMAKE_PRESETS_DIR}")
            exit_with_code(DATA_NOT_FOUND)
    else:
        print_error(f"Directory not found: '{CMAKE_PRESETS_DIR}' in '{CMAKE_CONFIG_PATH}'")
        print_warn(f"KinKoutDSP-template is corrupted. Re-download '{CMAKE_PRESETS_DIR}' from {GITHUB_URL}{GITHUB_MAIN}{CMAKE_CONFIG_DIR}/{CMAKE_PRESETS_DIR}")
        exit_with_code(DATA_NOT_FOUND)

    # Control CMakePresets.json from main folder
    if not CMAKE_PRESETS_JSON_PATH.exists():
        print_warn(f"File not found: '{CMAKE_PRESETS_JSON}' in '{ROOT}', restoring from presets file...")
        preset_data = read_json(recovery_preset)
        write_preset_json(preset_data)
        print_ok(f"{CMAKE_PRESETS_JSON} restored.")

    print_ok("Valid paths.")

# -------------------------------------------------------------------------------- Main
def main() -> None:
    print_title()
       
    control_paths()
    read_files()
    define_system_variables()
    sync_cmake_presets()
    open_clion()

# ================================================================================
# Entry point
# ================================================================================

if __name__ == "__main__":
    main()
    sys.exit(0)

