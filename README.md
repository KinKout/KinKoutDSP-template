# KinKoutDSP-template

A CMake starting point for JUCE audio plugins.

Born out of a simple need: stop rebuilding the same build system from scratch for every plugin. Set four config files, double-click a launcher, and the project opens in CLion ready to build on either macOS, Windows, and Linux.

## What it does

- **One place to configure everything** — company data, plugin name, code, formats, categories and module lists all live in `cmake_config/`
- **Validates before it builds** — manufacturer/plugin codes are checked against the 4-character rule, formats and categories against the valid lists, JUCE against its actual location. Errors say what is wrong and how to fix it
- **Generates the source files** — on first configure, `PluginProcessor` and `PluginEditor` are created from the templates in `source/template/`, stamped with the plugin name. Existing files are never overwritten
- **Cross-platform without duplicating the project** — the launcher detects the OS, swaps in the matching CMake preset and opens CLion. The same project folder can live on a synced drive and build on several machines
- **Build summary** — every configure ends with a full report: company info, plugin settings, paths, source files, assets, module status

## Minimum Requirements

- CMake 3.24+
- [JUCE 8](https://juce.com/download/) installed locally (not bundled)
- CLion 2025
- Python 3.10+
- macOS 11+ / Windows 10+ (tested on 11) / Linux (tested on Mint 22.1 Cinnamon)

## Setup

1. Go to `cmake_config` folder.
2. Duplicate `definePathConfigExample.json` and rename it `definePathConfig.json`. Here you can set your local JUCE and CLion paths.
3. Duplicate `companyInfoExample.cmake` and rename it `companyInfo.cmake`. Here you can set your company data.
4. Edit `pluginConfig.cmake` with your plugin name, version, description, formats and categories.
5. In the `root` folder, double-click:
 - `OpenProject_Mac.command`* on macOS,
 - `OpenProject_Win.bat`* on Windows,
 - `OpenProject_Linux.sh`* on Linux. *(needs to be run manually)*
6. Configure and build in CLion. On first startup, and every time the platform changes, CLion asks which build profile to use. Disable the `Debug` profile *(default CLion profile)* and enable the profile shown based on the system:
 - `macos-debug`, `macos-release` on macOS,
 - `windows-debug`, `windows-release` on Windows,
 - `linux-debug`, `linux-release` on Linux.

> Both `definePathConfig.json` and `companyInfo.cmake` are gitignored: they
> hold personal specific data and stay out of version control.
>
>  **These commands open the same `OpenInCLion.py` script which manages: the different paths of different platform, the CLion build settings on `CMakePresets.json` and the automatic opening of CLion*

## Layout

    _cmake-config/
      cmake-presets/                per-platform CMake presets
      modules-settings/             JUCE, KinKout and custom module lists
      notarisation/                 macOS notarisation
      other-settings/               path reading, validation lists, source generation
      template/                     source templates used at first configure
      companyInfoExample.cmake      company data (duplicate and rename companyInfo.cmake)
      definePathConfigExample.json  local paths (duplicate and rename definePathConfig.json)
      pluginConfig.cmake            plugin name, code, version, formats, categories
      
    assets/                         user raw binary data split into 4 categories
      audio/
      data/
      fonts/
      images/
      
    source/                         main codes folder
      assets-helper                 assets wrapper folder
      
    CMakeLists.txt                  the main cmake builder
    CMakePresets.json               CLion builder preset based on platform
    OpenInCLion.py                  platform detection, preset sync, CLion launch
    OpenProject_Linux.sh            Linux launcher
    OpenProject_Mac.command         macOS launcher
    OpenProject_Win.bat             Windows launcher


## Notes

I moved to CLion so I could build on both macOS and Windows. At first I found more problems than solutions.
The same project needs different CMake presets on each OS (paths, generator, build folder). I also keep my projects on a synced drive, so the same folder is open on both machines. Editing `CMakePresets.json` by hand every time was slow and easy to get wrong. Making two copies of the project meant I had to keep them in sync.

At the same time, I was tired of building the same setup again for every new plugin. So I put the two things together: a personal template with a launcher. The launcher checks the OS, writes the right preset, reads the paths for that platform and opens CLion.
One project folder, two machines, nothing to remember.

Built with the JUCE CMake API docs, a lot of trial and error, and AI help.

`OpenInCLion.py` started as an AI-generated draft that I reviewed and reworked.

## License

This template's own code — the CMake build system, the Python launcher, the structure — is MIT licensed: see [LICENSE](LICENSE).

The `PluginProcessor` / `PluginEditor` templates in `source/template/` derive from the JUCE examples [boilerplate](https://github.com/juce-framework/JUCE/tree/master/examples/CMake/AudioPlugin),
Copyright (c) Raw Material Software Limited, licensed under the [ISC License](https://opensource.org/license/isc).

JUCE itself is not included here. Plugins built with this template link against JUCE, which is dual-licensed (AGPLv3 or commercial): choosing a license for *your* plugin is up to you, and neither MIT nor ISC affects that choice.