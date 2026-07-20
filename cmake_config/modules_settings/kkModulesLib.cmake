# ================================================================================
# KinKout Modules Configuration
# ================================================================================
#
# File:     kkModulesLib.cmake
# Author:   KinKout
# Date:     11-May-2026
#
# Purpose:  manage KinKout modules.
#
# ================================================================================
#
# This file contains the list of KinKoutDSP modules
# used by this plugin.
#
# ================================================================================
#
# Do not include standard JUCE modules here.
# Do not include CUSTOM modules here.
#
# See juceModules.cmake for JUCE module configuration.
# See customModules.cmake for custom module configuration.
#
# ================================================================================


# -------------------------------------------------------------------------------- Add the user modules target

set(_KK_NAMESPACE "kiko::")

set(_KKML
    # Add here custom library
    # *** e.g. -> eg. yourNamespace::YourLib
    # *** e.g. -> eg. third-party::third-party
    
#        kiko::KKAudioLibs
)


