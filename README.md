# KinKoutDSP-template
___

## What is it

A CMake starting point for JUCE audio plugins for CLion IDE.

Born out of a simple need: stop rebuilding the same build system from scratch for every plugin, and keep the same project folder on a synced drive to build on different machines platform.

- Set only one configuration file for every new project:
    - [pluginConfig.cmake][link_pluginConfig] with your plugin data *(name, code, formats, categories, etc.)*
- Set two configuration files at the first download:
    - [companyInfo.cmake][link_companyInfo] with your company data
    - [definePath.json][link_definePath] with your personal paths
- Modify [juceModules.cmake][link_juceModules] to add or remove modules if needed
- Double-click on a launcher, and the project opens in CLion ready to build on either macOS, Windows, and Linux machines.

___
## What it does

- **One place to configure everything**
Company data, plugin name, code, formats, categories and module lists all live in [_cmake-config][link_cmake-config] folder.
<br>
- **Validates before it builds**
Manufacturer/plugin codes are checked against the 4-character rule, formats and categories against the valid lists, JUCE against its actual location. Errors say what is wrong and how to fix it.
<br>
- **Generates the source files**
On first runs, `PluginProcessor.h/cpp`,`PluginEditor.h/cpp`, and the rest of the structure codes are created from the .txt templates files in [template][link_template] folder, stamped with the plugin name and build date.
Existing files are never overwritten.

!!! Note: TODO: The rest of the structure codes are not implemented yet.

- **Cross-platform without duplicating the project**
The launcher detects the OS, swaps in the matching CMake preset settings and opens CLion.
The same project folder can live on a synced drive and build on different platform machines. (one machine for each platform)
<br>
- **Build summary**
Every CMake loading ends with a full report: company info, plugin settings, paths, source files, assets, module status etc.

___
## Minimum Requirements

- CMake 3.24+
- [JUCE 8][link_juce_download] installed locally (not bundled)
- CLion 2025
- Python 3.10+
- macOS 11+ / Windows 10+ (tested on 11) / Linux (tested on Mint 22.1 Cinnamon)

___
## Setup

1. Go to `_cmake-config/` folder.
2. Duplicate `definePathExample.json` and rename it `definePath.json`.
Here you can set your local JUCE, custom modules and CLion paths for each platform.
3. Duplicate `companyInfoExample.cmake` and rename it `companyInfo.cmake`.
Here you can set your company data.
4. Edit `pluginConfig.cmake` with your plugin name, version, description, formats, categories and other main settings.
5. In the `root` folder, double-click on:
 - `OpenProject_Mac.command`* on macOS,
 - `OpenProject_Win.bat`* on Windows,
 - `OpenProject_Linux.sh`* on Linux. *(needs to be run manually)*
6. Configure and build in CLion.
On first startup, and every time the platform changes, CLion asks which build profile to use. Disable the `Debug` profile *(default CLion profile)* and enable the profile shown based on the system from:
 - `macos-debug`, `macos-release` on macOS,
 - `windows-debug`, `windows-release` on Windows,
 - `linux-debug`, `linux-release` on Linux.

> Both `definePath.json` and `companyInfo.cmake` are gitignored: they
> hold personal specific data and stay out of version control.
>
>  **These commands open the same `OpenInCLion.py` script which manages the different paths of different platform, the CLion build settings on `CMakePresets.json` and the automatic opening of CLion*

___
## Folder Layout

- **[_cmake-config][link_cmake-config] - the main folder for configuration files, contains the structure of CMake divided by type of file:**
    - [*_scripts*][link_scripts]: contains the modules/files extracted from `CMakeLists.txt` for lightening itself.
    - [*modules-settings*][link_modules-settings]: JUCE, KinKout and custom modules lists, settable by the user based on the plugin requirements.
    This folder contains also the `_formatAndCategoryLists.cmake`, a list of all valid formats and categories used for validation. 
    - [*notarisation*][link_notarisation]: macOS notarisation settings needed for final notarisation and publication.
    - [*platform-presets*][link_platform-presets]: the .json presets for each platform needed by CLion to build the project.
    - [*template*][link_template]: source .txt templates used at first CMake load to generate base code, makes the empty project ready to build.
    This folder contains also the `_createSource.cmake`, a script to generate the base code from the templates.
- **[assets][link_assets] - for raw binary data divided into 4 categories:**
    - *audio, data, fonts and images*
- **[source][link_source] - for the main codes divided into 5 subfolders:**
    - *assets-helper, core, dsp, engine and ui*
    <u>*'dsp' and 'ui' folder are more detailed:*</U>
    - [dsp][link_dsp]: for audio processing code divided into 9 subfolders:
        - *amplitude, analysis, distortion, dynamics, filters, generators, modulation, time and utility*
    - [ui][link_ui]: for user interface code divided into 3 subfolders:
        - *components, shared-parts and style*
        <u>*'components' folder is more detailed*</U>, see [source/ui/README.md][link_ui_readme] for more info
        
___
## Notes

I moved to CLion so I could build on both macOS and Windows. At first I found more problems than solutions.
The same project needs different CMake presets on each OS (paths, generator, build folder). I also keep my projects on a synced drive, so the same folder is open on both machines. Editing `CMakePresets.json` by hand every time was slow and easy to get wrong. Making two copies of the project meant I had to keep them in sync.

At the same time, I was tired of building the same setup again for every new plugin. So I put the two things together: a personal template with a launcher. The launcher checks the OS, writes the right preset, reads the paths for that platform and opens CLion.
One project folder, two machines, nothing to remember.

Built with the JUCE CMake API docs, a lot of trial and error, and AI help.

`OpenInCLion.py` started as an AI-generated draft that I reviewed and reworked.

___
## License

This template's own code — the CMake build system, the Python launcher, the structure — is MIT licensed. See [LICENSE][link_mit_license].

The `PluginProcessor` / `PluginEditor` templates in `source/template/` derive from the JUCE examples [boilerplate][link_juce_boilerplate],
Copyright (c) Raw Material Software Limited, licensed under the [ISC License][link_isc_license].

JUCE itself is not included here. Plugins built with this template link against JUCE, which is dual-licensed under the [AGPLv3][link_agplv3_license] and the commercial [JUCE license][link_juce_license].

Choosing a license for *your* plugin is up to you, and neither MIT nor ISC affects that choice.




[link_juce_download]: https://juce.com/download
[link_juce_boilerplate]: https://github.com/juce-framework/JUCE/tree/master/examples/CMake/AudioPlugin
[link_mit_license]: https://github.com/KinKout/KinKoutDSP-template/tree/main/LICENSE
[link_isc_license]: https://www.isc.org/licenses
[link_agplv3_license]: https://www.gnu.org/licenses/agpl-3.0
[link_juce_license]: https://juce.com/legal/


[link_pluginConfig]: https://github.com/KinKout/KinKoutDSP-template/tree/main/_cmake-config/pluginConfig.cmake
[link_companyInfo]: https://github.com/KinKout/KinKoutDSP-template/tree/main/_cmake-config/companyInfoExample.cmake
[link_definePath]: https://github.com/KinKout/KinKoutDSP-template/tree/main/_cmake-config/definePathExample.json
[link_juceModules]: https://github.com/KinKout/KinKoutDSP-template/tree/main/_cmake-config/modules-settings/juceModules.cmake


[link_cmake-config]: https://github.com/KinKout/KinKoutDSP-template/tree/main/_cmake-config
[link_scripts]: https://github.com/KinKout/KinKoutDSP-template/tree/main/_cmake-config/_scripts
[link_modules-settings]: https://github.com/KinKout/KinKoutDSP-template/tree/main/_cmake-config/modules-settings
[link_notarisation]: https://github.com/KinKout/KinKoutDSP-template/tree/main/_cmake-config/notarisation
[link_platform-presets]: https://github.com/KinKout/KinKoutDSP-template/tree/main/_cmake-config/platform-presets
[link_template]: https://github.com/KinKout/KinKoutDSP-template/tree/main/_cmake-config/template
[link_assets]: https://github.com/KinKout/KinKoutDSP-template/tree/main/assets
[link_source]: https://github.com/KinKout/KinKoutDSP-template/tree/main/source
[link_dsp]: https://github.com/KinKout/KinKoutDSP-template/tree/main/source/dsp
[link_ui]: https://github.com/KinKout/KinKoutDSP-template/tree/main/source/ui


[link_ui_readme]: https://github.com/KinKout/KinKoutDSP-template/tree/main/source/ui/README.md