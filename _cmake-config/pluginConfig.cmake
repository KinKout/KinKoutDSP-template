# ================================================================================
# Plugin Configuration
# ================================================================================
#
# File:     pluginConfig.cmake
# Author:   KinKout
# Date:     11-May-2026
#
# Purpose:  manage plugin data
#
# ================================================================================
#
# This file contains all plugin-specific metadata used by the build system.
# Edit this file to update the plugin name, description, version, and categories.
#
# ================================================================================
#
# !!! WARNING !!! -->   set _PLUGIN_CODE, 4 characters
#                       first uppercase, the rest lowercase
#                       for best compatibility (AU/VST/AAX)
#
# more info: https://forum.juce.com/t/platform-specific-manufacturer-and-plugin-code/50862/2
#
# ================================================================================
#
# Valid formats and  categories lists: formatAndCategoryLists.cmake
# or on: https://github.com/juce-framework/JUCE/blob/master/docs/CMake%20API.md
# 
# ================================================================================


# -------------------------------------------------------------------------------- Info
set(_PROJECT_NAME "MyNewPlugin") # !!! NO whitespace !!! - max 30 characters
set(_PRODUCT_NAME "My New Plugin") # The name displayed in the DAW - max 30 characters
set(_DESCRIPTION "Something magna with elit something, officia something lorem ipsum with dolor and laboris commodo.") # max 255 characters
set(_PLUGIN_CODE "Mnpg") # WARNING !!!
set(_VERSION 1.0.0)

# -------------------------------------------------------------------------------- MIDI settings
set(_IS_SYNTH FALSE)
set(_NEEDS_MIDI_INPUT FALSE)
set(_NEEDS_MIDI_OUTPUT FALSE)
set(_IS_MIDI_EFFECT FALSE)

# -------------------------------------------------------------------------------- Formats
# *** e.g. -> set(_PLUGIN_FORMATS "first, second, third, etc.")
set(_PLUGIN_FORMATS "AU, VST3, LV2, Standalone")

# -------------------------------------------------------------------------------- Copy plugin
# Copy the plugins on default system folders after the build
set(_COPY_PLUGIN_AFTER_BUILD FALSE)

# ================================================================================
# PLUGIN CATEGORIES         *** e.g. -> set(_VAR "first, second, third, etc.") ***
# ================================================================================
# full list in the link below
# /cmake_config/formatAndCategoryLists.cmake
# ================================================================================

# -------------------------------------------------------------------------------- VST3
# One or more, separated by comma and spaces.
# Default: "Fx"
# "Instrument Synth" if IS_SYNTH is TRUE
# e.g: set(_PLUGIN_VST3_CATEGORIES "Fx, Dynamics, etc.")

set(_PLUGIN_VST3_CATEGORIES "Fx")

# -------------------------------------------------------------------------------- AU
# Exactly one value.

set(_PLUGIN_AU_MAIN_TYPE "kAudioUnitType_Effect")

# -------------------------------------------------------------------------------- AAX
# Default: "None"
# "SWGenerators" if IS_SYNTH TRUE
# "MIDIEffect" if IS_MIDI_EFFECT TRUE
# e.g: set(_PLUGIN_AAX_CATEGORY "AAX_ePlugInCategory_Effect, AAX_ePlugInCategory_Dynamics, etc.")

set(_PLUGIN_AAX_CATEGORY "AAX_ePlugInCategory_Effect")

# -------------------------------------------------------------------------------- Copy plugin
# Copy the plugins to the default system folders after the build
set(_COPY_PLUGIN_AFTER_BUILD FALSE)

# -------------------------------------------------------------------------------- Other plugin settings
set(_MICROPHONE_PERMISSION_ENABLED FALSE)
set(_EDITOR_WANTS_KEYBOARD_FOCUS FALSE)

