# ================================================================================
# Format and category lists
# ================================================================================
#
# File:     _formatAndCategoryLists.cmake
# Author:   KinKout
# Date:     11-May-2026
#
# Purpose:  list of all possible variables for formats and categories
#           shown in DAWs.
#           Used to control the data written in pluginConfig.cmake.
#
# ================================================================================
#
# This file contains validation lists for CMake projects
# based on the JUCE Plugin API.
#
# 							!!! Do NOT edit here !!!
#
# ================================================================================


# -------------------------------------------------------------------------------- Valid plugin formats
set(_VALID_FORMATS
    VST3
    AU
    Standalone
    LV2
    AUv3 
    AAX
    Unity
    VST
)


# -------------------------------------------------------------------------------- Valid VST3 categories
set(_VALID_VST3_CATEGORIES
    Fx
    Instrument
    Analyzer
    Delay
    Distortion
    Drum
    Dynamics
    EQ
    External
    Filter
    Generator
    Mastering
    Modulation
    Mono
    Network
    NoOfflineProcess
    OnlyOfflineProcess
    OnlyRT
    PitchShift
    Restoration
    Reverb
    Sampler
    Spatial
    Stereo
    Surround
    Synth
    Tools
    Up-Downmix
)


# -------------------------------------------------------------------------------- Valid AU main types
set(_VALID_AU_MAIN_TYPE
    kAudioUnitType_Effect
    kAudioUnitType_FormatConverter
    kAudioUnitType_Generator
    kAudioUnitType_MIDIProcessor
    kAudioUnitType_Mixer
    kAudioUnitType_MusicDevice
    kAudioUnitType_MusicEffect
    kAudioUnitType_OfflineEffect
    kAudioUnitType_Output
    kAudioUnitType_Panner
)


# -------------------------------------------------------------------------------- Valid AAX categories
set(_VALID_AAX_CATEGORY
    AAX_ePlugInCategory_None
    AAX_ePlugInCategory_EQ
    AAX_ePlugInCategory_Dynamics
    AAX_ePlugInCategory_PitchShift
    AAX_ePlugInCategory_Reverb
    AAX_ePlugInCategory_Delay
    AAX_ePlugInCategory_Modulation
    AAX_ePlugInCategory_Harmonic
    AAX_ePlugInCategory_NoiseReduction
    AAX_ePlugInCategory_Dither
    AAX_ePlugInCategory_SoundField
    AAX_ePlugInCategory_HWGenerators
    AAX_ePlugInCategory_SWGenerators
    AAX_ePlugInCategory_WrappedPlugin
    AAX_ePlugInCategory_Effect
    AAX_ePlugInCategory_MIDIEffect
)