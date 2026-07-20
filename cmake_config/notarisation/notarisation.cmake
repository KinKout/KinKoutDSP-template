# ================================================================================
# Notarisation settings
# ================================================================================
#
# File:     notarisation.cmake
# Author:   KinKout
# Date:     11-May-2026
#
# Purpose:  enable or disable _HARDENED_RUNTIME_ENABLED.
#           Required for final notarisation.
#
# ================================================================================


# -------------------------------------------------------------------------------- 
# Enables macOS' hardened runtime for this target. Required for notarisation.
set(_HARDENED_RUNTIME_ENABLED FALSE)

# --------------------------------------------------------------------------------
# A set of space-separated entitlement keys
# that will be added to this target's entitlements plist
set(_HARDENED_RUNTIME_OPTIONS "")

# TODO: fetch pluginConfig.cmake options to build automatic '_HARDENED_RUNTIME_OPTIONS' setting

# AI source
#1. Core Code Signing Entitlements (com.apple.security.cs...)
#These are the most critical for plugins loading external libraries or using specific memory features.
#
#com.apple.security.cs.disable-library-validation: Essential if your plugin loads third-party dynamic libraries (DLLs/dylibs) or other plugins that are not signed with the same Team ID. This is the most common requirement for VST hosts or complex plugins.
#com.apple.security.cs.allow-unsigned-executable-memory: Required if your plugin uses JIT (Just-In-Time) compilation (e.g., Lua scripting engines, custom DSP compilers).  Most standard DSP plugins do not need this.
#com.apple.security.cs.disable-executable-page-protection: Rarely needed; allows executing code on pages marked writable. Only use if you have a specific legacy requirement that fails without it.
#com.apple.security.cs.allow-dyld-environment-variables: Allows the dynamic linker to use environment variables. Usually not needed for standard plugins.
#
#2. File & Network Access Entitlements
#If your plugin accesses files outside its bundle or connects to the internet.
#
#com.apple.security.assets.music.read-write: Grants access to the user's Music library (~/Music) and often the standard Audio Plug-Ins folder (~/Library/Audio/Plug-Ins). Useful if your plugin scans or saves presets in these specific locations manually.
#com.apple.security.files.user-selected.read-write: Required if you use a standard macOS "Open/Save File" dialog to let the user pick a file. The system usually handles this via the dialog, but explicit entitlements ensure robustness in sandboxed environments.
#com.apple.security.network.client: Required if your plugin makes outgoing network connections (e.g., for license validation, analytics, or downloading presets).
#
#3. Audio Unit Specific (Rare for VST3/AAX)
#com.apple.security.temporary-exception.audio-unit-host: A special entitlement primarily for hosts that need to load unsigned Audio Units. Generally not needed for standard effect plugins.

