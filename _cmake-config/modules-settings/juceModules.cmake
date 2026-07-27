# ================================================================================
# JUCE Modules Configuration
# ================================================================================
#
# File:     juceModules.cmake
# Author:   KinKout
# Date:     11-May-2026
#
# Purpose:  manage Juce modules.
#
# ================================================================================
#
# This file contains the list of JUCE modules used by this plugin.
# Add or remove modules based to the plugin requirements.
#
# ================================================================================
#
# Do not include CUSTOM or third-party modules here.
# Do not include KinKout modules here.

# See customModules.cmake for custom module configuration.
# See kkModulesLib.cmake for KinKnout module configuration.

#
# ================================================================================


# -------------------------------------------------------------------------------- Core audio modules
set(JUCE_CORE_AUDIO_MODULES
    juce::juce_audio_basics			    # AudioBuffer, sample management, basic MIDI helpers
    juce::juce_audio_devices			# Audio I/O: input/output devices, driver management
    juce::juce_audio_formats			# Audio file support: WAV, AIFF, FLAC, MP3
    juce::juce_audio_plugin_client		# Plugin client support: VST3, AU, AAX, host integration
    juce::juce_audio_processors			# Core plugin processing: parameters, buses, automations, processBlock
    juce::juce_audio_utils			    # Audio playback, MIDI helpers, file player utilities
)


# -------------------------------------------------------------------------------- Core system modules
set(JUCE_CORE_SYSTEM_MODULES
    juce::juce_core				        # Core utilities: strings, containers, threads, timers, file system
    juce::juce_data_structures			# PropertyTree, JSON/XML parsing, advanced data structures
    juce::juce_events				    # Event handling, callbacks, listeners
)


# -------------------------------------------------------------------------------- DSP modules
set(JUCE_DSP_MODULES
    juce::juce_dsp				        # DSP classes: filters, LFOs, FFT, delay lines, modulation
)


# -------------------------------------------------------------------------------- GUI modules
set(JUCE_GUI_MODULES
    juce::juce_graphics				    # 2D graphics: paths, gradients, images, bitmap rendering
    juce::juce_gui_basics			    # Basic GUI components: windows, buttons, sliders, labels, panels
    juce::juce_gui_extra			    # Advanced GUI components: treeview, listbox, tabbedComponent, drag/drop
)


# -------------------------------------------------------------------------------- Optional JUCE modules
set(JUCE_OPTIONAL_MODULES
    # juce::juce_analytics			    # Telemetry and usage analytics
    # juce::juce_animation			    # GUI animation utilities, tweening, interpolations
    # juce::juce_box2d				    # Physics engine wrapper for 2D simulations (Box2D)
    # juce::juce_cryptography			# Cryptography: hashing, encryption, digital signatures
    # juce::juce_javascript			    # Embedded JS engine (V8), for scripting inside the app
    # juce::juce_opengl				    # OpenGL rendering in GUI components
    # juce::juce_osc				    # Open Sound Control (OSC) support for networking & device control
    # juce::juce_product_unlocking		# License management and product unlocking
    # juce::juce_video				    # Video playback, frame management, video texture integration
    # juce::juce_midi_ci			    # MIDI CoreMIDI support and advanced MIDI processing
)