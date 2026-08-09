# ================================================================================
# Local machine path configuration
# ================================================================================
#
# File:     pathConfig.cmake
# Author:   KinKout
# Date:     11-May-2026
#
# Purpose:  Reads definePath.json and exposes path variables for use in CMakeLists.txt
#
# 							!!! Do NOT edit paths here !!!
#
# edit definePath.json instead
#
# ================================================================================

# -------------------------------------------------------------------------------- Read paths.json
set(_PATHS_JSON_FILE "${CMAKE_CURRENT_SOURCE_DIR}/_cmake-config/definePath.json")
 
if(NOT EXISTS "${_PATHS_JSON_FILE}")
    message("\n\n\n"
            "| =========================================================================== |\n"
            "|                                 BUILD FAILURE                               |\n"
            "| =========================================================================== |\n")
    message(FATAL_ERROR "definePath.json not found at ${_PATHS_JSON_FILE}\n\n")
endif()
 
file(READ "${_PATHS_JSON_FILE}" _PATHS_JSON)
 
 
# -------------------------------------------------------------------------------- Extract paths by platform
if(APPLE)
    string(JSON _JUCE_PATH GET ${_PATHS_JSON} darwin juce)
    string(JSON _KKML_PATH GET ${_PATHS_JSON} darwin kkmoduleslib)
    string(JSON _CSTM_PATH GET ${_PATHS_JSON} darwin custommodules)
elseif(WIN32)
    string(JSON _JUCE_PATH GET ${_PATHS_JSON} windows juce)
    string(JSON _KKML_PATH GET ${_PATHS_JSON} windows kkmoduleslib)
    string(JSON _CSTM_PATH GET ${_PATHS_JSON} windows custommodules)
elseif(UNIX AND NOT APPLE)
    string(JSON _JUCE_PATH GET ${_PATHS_JSON} linux juce)
    string(JSON _KKML_PATH GET ${_PATHS_JSON} linux kkmoduleslib)
    string(JSON _CSTM_PATH GET ${_PATHS_JSON} linux custommodules)
endif()



