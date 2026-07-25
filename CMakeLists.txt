# =============================================================================
# CMakeLists project builder
# =============================================================================
#
# File:     CMakeLists.txt
# Author:   KinKout
# Date:     11-May-2026
#
# Purpose:  build juce project for CLion IDE.
#
# =============================================================================


cmake_minimum_required(VERSION 3.24)

include(cmake_config/companyInfo.cmake)
include(cmake_config/pluginConfig.cmake)
include(cmake_config/modules_settings/juceModules.cmake)
include(cmake_config/modules_settings/kkModulesLib.cmake)
include(cmake_config/modules_settings/customModules.cmake)
include(cmake_config/other_settings/formatAndCategoryLists.cmake)
include(cmake_config/other_settings/pathConfig.cmake)
include(cmake_config/notarisation/notarisation.cmake)


message("\n"
        "| =========================================================================== |\n"
        "|                             INCLUDE FILE LOADED                             |\n"
        "| =========================================================================== |")
        
        
# -------------------------------------------------------------------------------- Folders
set(_THIS_DIR ${CMAKE_CURRENT_SOURCE_DIR})

# ================================================================================
# PLATFORM DETECTION AND SETUP
# ================================================================================

if(APPLE)
    set(_SYSTEM_NAME "APPLE")
    set(CMAKE_OSX_ARCHITECTURES "arm64;x86_64" CACHE STRING "")
    set(CMAKE_OSX_DEPLOYMENT_TARGET "11.0" CACHE STRING "")
    set(_BUILD_PATH "${_THIS_DIR}/builds/macos")
elseif (WIN32)
    set(_SYSTEM_NAME "WIN32")
    set(_BUILD_PATH "${_THIS_DIR}/builds/windows")
elseif (UNIX AND NOT APPLE)
    set(_SYSTEM_NAME "LINUX")
    set(_BUILD_PATH "${_THIS_DIR}/builds/linux")
else()
    message(FATAL_ERROR "Unsupported platform!")
endif ()


message("| =========================================================================== |\n"
        "|                                ${_SYSTEM_NAME} DETECTED                               |\n"
        "| =========================================================================== |")


# ================================================================================
# Init build with the name of product

message("| =========================================================================== |\n"
        "|                               BUILD IS RUNNING                              |\n"
        "| =========================================================================== |\n")

message(STATUS "${_PRODUCT_NAME}")
message("\n\t\twill now be built...\n\n")


# ================================================================================
# Failure message function 
function(build_failure_msg)
    message("\n\n\n"
            "| =========================================================================== |\n"
            "|                                 BUILD FAILURE                               |\n"
            "| =========================================================================== |\n\n")
endfunction()


# ================================================================================
# MANUFACTURER / PLUGIN NAMES VALIDATION
# ================================================================================

# -------------------------------------------------------------------------------- Manufacturer Code:
# -------------------------------------------------------------------------------- 4 characters, fist uppercase, the rest lowercase
if(NOT _PLUGIN_MANUFACTURER_CODE MATCHES "^[A-Z][a-z][a-z][a-z]$")
    build_failure_msg()
    message(FATAL_ERROR "_PLUGIN_MANUFACTURER_CODE must be exactly 4 letters\n"
            "The first letter, uppercase [A-Z]\n"
            "the other 3, lowercase [a-z]\n"
            "Exemple: Fila, Cuqo, Tiys")
endif()

# -------------------------------------------------------------------------------- Plugin Code:
# -------------------------------------------------------------------------------- 4 characters, fist uppercase, the rest lowercase
if(NOT _PLUGIN_CODE MATCHES "^[A-Z][a-z][a-z][a-z]$")
    build_failure_msg()
    message(FATAL_ERROR "_PLUGIN_CODE must be must be exactly 4 letters\n"
            "The first letter, uppercase [A-Z]\n"
            "the other 3, lowercase [a-z]\n"
            "Exemple: Curs, Shnt, Anfl")
endif()

# -------------------------------------------------------------------------------- Print validated plugin codes
message(STATUS
    "Plugin identity validated:\n"
    "\t-> Manufacturer Code   : ${_PLUGIN_MANUFACTURER_CODE}\n"
    "\t-> Plugin Code         : ${_PLUGIN_CODE}\n")


# ================================================================================
# FORMATS VALIDATION
# ================================================================================

# -------------------------------------------------------------------------------- Split _PLUGIN_FORMATS in single format
set(_PF ${_PLUGIN_FORMATS})
string(REPLACE ", " ";" _PF "${_PF}")
list(LENGTH _PF _PFCOUNT)
message(STATUS "Loading formats:")
set(_FORMATS)
set(_AU_ON_OTHER FALSE)
# -------------------------------------------------------------------------------- Check valid formats
if(_PFCOUNT EQUAL 0)
    message(WARNING "No Formats loaded!")
else()
    foreach(_F ${_PF})
        if (_F STREQUAL "AU" AND NOT _SYSTEM_NAME STREQUAL "APPLE")
            set(_AU_ON_OTHER TRUE)
        else()
            list(FIND _VALID_FORMATS "${_F}" _FORMAT_INDEX)

            if(_FORMAT_INDEX EQUAL -1)
                build_failure_msg()
            message(FATAL_ERROR "_PLUGIN_FORMATS '${_F}' is not a valid format!\n"
                        "Valid formats are: ${_VALID_FORMATS}")
            else()
                list(APPEND _FORMATS "${_F}")
                message("\t-> ${_F}" )
            endif()
        endif ()
    endforeach()
endif()
message("")


# ================================================================================
# VST3_CATEGORIES VALIDATION
# ================================================================================

message(STATUS "Loading categories:")

# -------------------------------------------------------------------------------- Split _PLUGIN_VST3_CATEGORIES in single category
set(_V3C ${_PLUGIN_VST3_CATEGORIES})
string(REPLACE ", " ";" _V3C "${_V3C}")
list(LENGTH _V3C _V3C_COUNT)
message("\t- Loading VST3 categories:")
set(_VST3_CATEGORIES)
# -------------------------------------------------------------------------------- Check valid types
if (_V3C_COUNT EQUAL 0)
    message(WARNING "No VST3 categories loaded!")
else()
    foreach(_C ${_V3C})
        list(FIND _VALID_VST3_CATEGORIES "${_C}" _CATEGORY_INDEX)
        if(_CATEGORY_INDEX EQUAL -1)
            build_failure_msg()
            message(FATAL_ERROR "Invalid '${_C}' VST3 category!")
        else()
            list(APPEND _VST3_CATEGORIES "${_C}")
            message("\t\t-> ${_C}" )
        endif()
    endforeach()
endif()


# ================================================================================
# AU_MAIN_TYPE VALIDATION
# ================================================================================

# -------------------------------------------------------------------------------- Split _PLUGIN_AU_MAIN_TYPE in single type
set(_AU ${_PLUGIN_AU_MAIN_TYPE})
string(REPLACE ", " ";" _AU "${_AU}")
list(LENGTH _AU _AU_COUNT)
message("\t- Loading AU category:")
set(_AU_MAIN_TYPE)
if(NOT _AU_ON_OTHER)
# -------------------------------------------------------------------------------- Check valid types
    if(_AU_COUNT EQUAL 0)
        message(WARNING "No AU category loaded!")
# -------------------------------------------------------------------------------- Must be exactly one type
    elseif(_AU_COUNT EQUAL 1)
        list(FIND _VALID_AU_MAIN_TYPE "${_AU}" _CATEGORY_INDEX)
        if(_CATEGORY_INDEX EQUAL -1)
            build_failure_msg()
            message(FATAL_ERROR "Invalid '${_AU}' AU category!")
        else()
            set(_AU_MAIN_TYPE "${_AU}")
            message("\t\t-> ${_AU}" )
        endif()
    elseif(_AU_COUNT GREATER 1)
        build_failure_msg()
        message(FATAL_ERROR "_PLUGIN_AU_MAIN_TYPE must be exactly one value!")
    endif()
else()
    set(_AU_MAIN_TYPE "")
    message("\t\t -< AU format is loaded in this project, but not in this session with different OS >")
endif()


# ================================================================================
# AAX_CATEGORY VALIDATION
# ================================================================================

# -------------------------------------------------------------------------------- Split _PLUGIN_AAX_CATEGORY in single category
set(_AAX ${_PLUGIN_AAX_CATEGORY})
string(REPLACE ", " ";" _AAX "${_AAX}")
list(LENGTH _AAX _AAXCOUNT)
message("\t- Loading AAX types:")
set(_AAX_CATEGORY)
# -------------------------------------------------------------------------------- Check valid types
if(_AAXCOUNT EQUAL 0)
    message(WARNING "No AAX category loaded!")
else()
    foreach(_C ${_AAX})
        list(FIND _VALID_AAX_CATEGORY "${_C}" _CATEGORY_INDEX)
        if(_CATEGORY_INDEX EQUAL -1)
            build_failure_msg()
            message(FATAL_ERROR "Invalid '${_C}' AAX category!")
        else()
            list(APPEND _AAX_CATEGORY "${_C}")
            message("\t\t-> ${_C}" )
        endif()
    endforeach()
endif()
message("\n")


# ================================================================================
# PROJECT CONFIGURATION
# ================================================================================

project(
        ${_PROJECT_NAME}
        VERSION ${_VERSION}
        DESCRIPTION ${_DESCRIPTION}
        LANGUAGES C CXX
)

# -------------------------------------------------------------------------------- Set C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED TRUE)
set(CMAKE_EXPORT_COMPILE_COMMANDS TRUE)

# -------------------------------------------------------------------------------- Disable automatic Xcode scheme generation
# -------------------------------------------------------------------------------- not needed in CLion
set(CMAKE_XCODE_GENERATE_SCHEME FALSE)

# -------------------------------------------------------------------------------- Allow CLion and IDEs to organize targets in folders
set_property(GLOBAL PROPERTY USE_FOLDERS TRUE)

# -------------------------------------------------------------------------------- Platform build directories
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG   "${_BUILD_PATH}/debug")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG   "${_BUILD_PATH}/debug")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG   "${_BUILD_PATH}/debug")

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE "${_BUILD_PATH}/release")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE "${_BUILD_PATH}/release")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE "${_BUILD_PATH}/release")


# ================================================================================
# INCLUDE JUCE, MODULES, BINARY DATA AND SOURCE FILES
# ================================================================================

message(STATUS "Check and adding modules...\n")

# INCLUDE JUCE
# -------------------------------------------------------------------------------- Check & add JUCE
if(NOT DEFINED _JUCE_PATH OR _JUCE_PATH STREQUAL "")
    build_failure_msg()
    message(FATAL_ERROR "JUCE folder not defined!")
elseif(NOT EXISTS "${_JUCE_PATH}")
    build_failure_msg()
    message(FATAL_ERROR "JUCE not found at ${_JUCE_PATH}!")
elseif(NOT EXISTS "${_JUCE_PATH}/CMakeLists.txt")
    build_failure_msg()
    message(FATAL_ERROR "CMakeLists.txt not found in JUCE folder! Install JUCE...")
else()
    add_subdirectory(${_JUCE_PATH} juce EXCLUDE_FROM_ALL)
    message("")
    message(STATUS "✓ JUCE added to ${_PRODUCT_NAME}!\n")
endif()


# INCLUDE KINKOUT Modules (KKModulesLib)
# -------------------------------------------------------------------------------- Check & add KKModulesLib
if(NOT DEFINED _KKML_PATH OR _KKML_PATH STREQUAL "")
    message(WARNING "No KKModulesLib path defined, skipping.")
elseif(NOT EXISTS "${_KKML_PATH}")
    build_failure_msg()
    message(FATAL_ERROR "KKModulesLib not found at ${_KKML_PATH}!")
else()
    if(NOT DEFINED _KKML OR _KKML STREQUAL "")
        message(WARNING "No KKModulesLib modules defined, skipping.")
    else()
        foreach(_KK ${_KKML})
            string(REPLACE "${_KK_NAMESPACE}" "" _KK_MODULE_NAME ${_KK})
            set(_KK_MODULE_PATH "${_KKML_PATH}/${_KK_MODULE_NAME}")
            if(NOT EXISTS "${_KK_MODULE_PATH}")
                build_failure_msg()
                message(FATAL_ERROR "KKModulesLib module '${_KK_MODULE_NAME}' not found at ${_KK_MODULE_PATH}!")
            else()
                add_subdirectory(${_KK_MODULE_PATH})
                message(STATUS "    >>> ${_KK_MODULE_NAME} added to ${_PRODUCT_NAME}!\n")
            endif()
        endforeach()
    endif()
endif()


# INCLUDE CUSTOM Modules
# -------------------------------------------------------------------------------- Check & add Custom modules
if(NOT DEFINED _CSTM_PATH OR _CSTM_PATH STREQUAL "")
    message(WARNING "No Custom Modules path defined, skipping.")
elseif(NOT EXISTS "${_CSTM_PATH}")
    build_failure_msg()
    message(FATAL_ERROR "Custom Modules not found at ${_CSTM_PATH}!")
else()
    if(NOT DEFINED _CSTM OR _CSTM STREQUAL "")
        message(WARNING "No Custom Modules modules defined, skipping.")
    else()
        foreach(_CM_NAME ${_CSTM})
            set(_CUSTOM_MODULE_PATH "${_CSTM_PATH}/${_CM_NAME}")
            if(NOT EXISTS "${_CUSTOM_MODULE_PATH}")
                build_failure_msg()
                message(FATAL_ERROR "Custom Modules module '${_CM_NAME}' not found at ${_CUSTOM_MODULE_PATH}!")
            else()
                add_subdirectory(${_CUSTOM_MODULE_PATH})
                message(STATUS "    >>> ${_CM_NAME} added to ${_PRODUCT_NAME}!\n")
            endif()
        endforeach()
    endif()
endif()


# INCLUDE BINARY DATA (assets folder)
# ---------------------------------------------------------- Check & add binary files
message(STATUS "Check and adding binary files...")

set(_A "assets")
set(_ASSETS_PATH "${_THIS_DIR}/${_A}")

# Add here the new asset formats supported by the project
# Remember to add only the BINARY formats in .gitattributes to avoid corruption
file(GLOB_RECURSE _BINARY_FILES CONFIGURE_DEPENDS
        # ------------------ BINARY files
        # Image files
        "${_A}/*.png"
        "${_A}/*.jpg"

        # Font files
        "${_A}/*.ttf"
        "${_A}/*.otf"

        # Audio files
        "${_A}/*.wav"
        "${_A}/*.aiff"

        # ------------------ TEXT files
        "${_A}/*.svg"
        "${_A}/*.json"
        "${_A}/*.xml"
)

list(LENGTH _BINARY_FILES _BINARY_COUNT)
if(_BINARY_COUNT GREATER 0)
    set(_BINARY_LIST ${_PROJECT_NAME}_BinaryData)
    juce_add_binary_data(${_BINARY_LIST} SOURCES ${_BINARY_FILES})
    message("\t\t    >>> BinaryData: ${_BINARY_COUNT} assets loaded\n")
else()
    message(WARNING "No BinaryData found, skipping.")
endif()


# INCLUDE SOURCE FILES
# -------------------------------------------------------------------------------- Check & add source files
message(STATUS "Check and adding source files...\n")

set(_S "source")
set(_SOURCE_PATH "${_THIS_DIR}/${_S}")

macro(load_source_files)
    file(GLOB_RECURSE _SOURCE_FILES
        "${_S}/*.cpp"
        "${_S}/*.h"
    )
    list(LENGTH _SOURCE_FILES _SOURCE_COUNT)
endmacro()

load_source_files()

if(_SOURCE_COUNT GREATER_EQUAL 4)
    message("\t\t    >>> source files: ${_SOURCE_COUNT} files loaded\n")
else()
    message(STATUS "No source files found, generating from templates...")
    include(cmake_config/other_settings/createSource.cmake)
    load_source_files()
    if(_SOURCE_COUNT LESS 4)
        message(FATAL_ERROR "Template generation failed, source/ still empty!")
    endif()
    message("\t\t    >>> source files: ${_SOURCE_COUNT} files created\n")
endif()

# ================================================================================
# PLUGIN CONFIGURATION
# ================================================================================

juce_add_plugin(
    ${_PROJECT_NAME}

    PRODUCT_NAME ${_PRODUCT_NAME}
    PLUGIN_CODE ${_PLUGIN_CODE}
    FORMATS ${_FORMATS}

    IS_SYNTH ${_IS_SYNTH}
    NEEDS_MIDI_INPUT ${_NEEDS_MIDI_INPUT}
    NEEDS_MIDI_OUTPUT ${_NEEDS_MIDI_OUTPUT}
    IS_MIDI_EFFECT ${_IS_MIDI_EFFECT}

    VST3_CATEGORIES ${_VST3_CATEGORIES}
    AU_MAIN_TYPE ${_AU_MAIN_TYPE}
    AAX_CATEGORY ${_AAX_CATEGORY}

    COMPANY_NAME ${_COMPANY_NAME}
    PLUGIN_MANUFACTURER_CODE ${_PLUGIN_MANUFACTURER_CODE}
    COMPANY_WEBSITE ${_COMPANY_WEBSITE}
    COMPANY_EMAIL ${_COMPANY_EMAIL}

    COPY_PLUGIN_AFTER_BUILD ${_COPY_PLUGIN_AFTER_BUILD}

    MICROPHONE_PERMISSION_ENABLED ${_MICROPHONE_PERMISSION_ENABLED}
    EDITOR_WANTS_KEYBOARD_FOCUS ${_EDITOR_WANTS_KEYBOARD_FOCUS}

    HARDENED_RUNTIME_ENABLED ${_HARDENED_RUNTIME_ENABLED}
    HARDENED_RUNTIME_OPTIONS ${_HARDENED_RUNTIME_OPTIONS}
)

juce_generate_juce_header(${_PROJECT_NAME})


# ================================================================================
# LV2 WRAPPER
# ================================================================================

set_target_properties("${_PROJECT_NAME}_LV2" PROPERTIES
        LIBRARY_OUTPUT_DIRECTORY_DEBUG   "${_BUILD_PATH}/debug/${_PROJECT_NAME}.lv2"
        LIBRARY_OUTPUT_DIRECTORY_RELEASE "${_BUILD_PATH}/release/${_PROJECT_NAME}.lv2")


# ================================================================================
# ORGANIZE FILES IN IDE and target sources
# ================================================================================

source_group(TREE ${CMAKE_CURRENT_SOURCE_DIR} FILES ${_SOURCE_FILES})

target_sources(${_PROJECT_NAME}
        PRIVATE
        ${_SOURCE_FILES}
)


# ================================================================================
# COMPILER DEFINITIONS
# ================================================================================

target_compile_definitions(
    ${_PROJECT_NAME}
    PUBLIC
        JUCE_WEB_BROWSER=0		# Disable web browser module
        JUCE_USE_CURL=0			# Disable CURL support
        JUCE_VST3_CAN_REPLACE_VST2=0
)


# ================================================================================
# TARGET LINK LIBRARIES
# ================================================================================

# JUCE MODULES
# --------------------------------------------------------------------------------
target_link_libraries(${_PROJECT_NAME}
        PRIVATE
        ${JUCE_CORE_AUDIO_MODULES}
        ${JUCE_CORE_SYSTEM_MODULES}
        ${JUCE_DSP_MODULES}
        ${JUCE_GUI_MODULES}
        ${JUCE_OPTIONAL_MODULES}
# -------------------------------------------------------------------------------- Recommended flags
        juce::juce_recommended_config_flags
        juce::juce_recommended_warning_flags
        juce::juce_recommended_lto_flags
)


# KINKOUT MODULES LIBRARY
# --------------------------------------------------------------------------------
if(DEFINED _KKML)
    target_link_libraries(
            ${_PROJECT_NAME}
            PRIVATE
            ${_KKML}
    )
endif()


# CUSTOM MODULES
# --------------------------------------------------------------------------------
if(DEFINED _CSTM)
    target_link_libraries(
            ${_PROJECT_NAME}
            PRIVATE
            ${_CSTM}
    )
endif()


# ================================================================================
# Post-build info
# ================================================================================

message("| =========================================================================== |\n"
        "|                         BUILD SUMMARY CONFIGURATION                         |\n"
        "| =========================================================================== |\n")

# -------------------------------------------------------------------------------- Print company Info
message(STATUS "COMPANY INFORMATION")
message("\t\t-> COMPANY_NAME                :${_COMPANY_NAME}")
message("\t\t-> COMPANY_EMAIL               :${_COMPANY_EMAIL}")
message("\t\t-> COMPANY_WEBSITE             :${_COMPANY_WEBSITE}")
message("\t\t-> PLUGIN_MANUFACTURER_CODE    :${_PLUGIN_MANUFACTURER_CODE}")
message("")


# -------------------------------------------------------------------------------- Print project Info
message(STATUS "PROJECT INFORMATION")
message("\t\t-> PROJECT_NAME                :${_PROJECT_NAME}")
message("\t\t-> PRODUCT_NAME                :${_PRODUCT_NAME}")
message("\t\t-> VERSION                     :${_VERSION}")
message("\t\t-> DESCRIPTION                 :${_DESCRIPTION}")
message("")


# -------------------------------------------------------------------------------- Print plug-in setting
message(STATUS "PLUGIN CONFIGURATION")
message("\t\t-> PLUGIN_CODE                 :${_PLUGIN_CODE}")
message("\t\t-> FORMATS                     :${_FORMATS}")
message("\t\t-> IS_SYNTH                    :${_IS_SYNTH}")
message("\t\t-> NEEDS_MIDI_INPUT            :${_NEEDS_MIDI_INPUT}")
message("\t\t-> NEEDS_MIDI_OUTPUT           :${_NEEDS_MIDI_OUTPUT}")
message("\t\t-> VST3_CATEGORIES             :${_VST3_CATEGORIES}")
message("\t\t-> AU_MAIN_TYPE                :${_AU_MAIN_TYPE}")
message("\t\t-> AAX_CATEGORY                :${_AAX_CATEGORY}")
message("")


# -------------------------------------------------------------------------------- Print paths
message(STATUS "PATHS")
message("\t\t-> Project Root                :${_THIS_DIR}")
message("\t\t-> Build                       :${_BUILD_PATH}")
message("\t\t-> CMake                       :${CMAKE_BINARY_DIR}")
message("\t\t-> Source                      :${_SOURCE_PATH}")
message("\t\t-> JUCE Path                   :${_JUCE_PATH}")
message("\t\t-> KinKout Modules             :${_KKML_PATH}")
message("\t\t-> Custom Modules              :${_CSTM_PATH}")
message("")


# -------------------------------------------------------------------------------- Print source files
message(STATUS "SOURCE FILES")
message("\t- Total files found: ${_SOURCE_COUNT}")
if(_SOURCE_COUNT GREATER 0)
    list(SORT _SOURCE_FILES)
    foreach(_SF ${_SOURCE_FILES})
        get_filename_component(FILENAME ${_SF} NAME)
        message("\t\t• ${FILENAME}")
    endforeach()
else()
    message(WARNING "No source files found in source/ directory!")
endif()
message("\n")


# -------------------------------------------------------------------------------- Print JUCE modules
function(print_juce_modules _MODULE_TYPE _MODULE_TYPE_NAME)
    message("\t- ${_MODULE_TYPE_NAME}:")

    set(_COUNT 0)
    foreach(_ML ${${_MODULE_TYPE}})
        message("\t\t• ${_ML}")
        math(EXPR _COUNT "${_COUNT} + 1")
    endforeach()

    message("\t\t\tselected: ${_COUNT}\n")
endfunction()

message(STATUS "JUCE MODULES STATUS\n")
print_juce_modules(JUCE_CORE_AUDIO_MODULES  "Core Audio Modules")
print_juce_modules(JUCE_CORE_SYSTEM_MODULES "Core System Modules")
print_juce_modules(JUCE_DSP_MODULES "DSP Modules")
print_juce_modules(JUCE_GUI_MODULES "GUI Modules")
print_juce_modules(JUCE_OPTIONAL_MODULES "Optional Modules")


# -------------------------------------------------------------------------------- Print KKModulesLib status
if(NOT DEFINED _KKML_PATH OR _KKML_PATH STREQUAL "")
    message(STATUS "No KKModulesLib path defined\n")
else()
    file(GLOB _KKML_CHILDREN RELATIVE "${_KKML_PATH}" "${_KKML_PATH}/*")

    set(_KKML_FOUND_DIRS "")
    foreach(_CHILD ${_KKML_CHILDREN})
        if(IS_DIRECTORY "${_KKML_PATH}/${_CHILD}")
            list(APPEND _KKML_FOUND_DIRS "${_CHILD}")
        endif()
    endforeach()

    list(LENGTH _KKML_FOUND_DIRS _KKML_TOTAL)
    list(LENGTH _KKML _KKML_LINKED)

    message(STATUS "KinKoutDSP MODULES STATUS")
    message("\t\t-> Path                        :${_KKML_PATH}")
    message("\t\t-> Modules physically present  :${_KKML_TOTAL}")
    message("\t\t-> Modules linked in project   :${_KKML_LINKED}")
    message("")

    foreach(_DIR ${_KKML_FOUND_DIRS})
        if(TARGET ${_DIR})
            message("\t\t    >>> ${_DIR}")
        else()
            message("\t\t    XXX ${_DIR}")
        endif()
    endforeach()

    message("")
endif()


# -------------------------------------------------------------------------------- Print Custom Modules status
if(NOT DEFINED _CSTM_PATH OR _CSTM_PATH STREQUAL "")
    message(STATUS "No Custom Modules path defined\n")
else()
    file(GLOB _CSTM_CHILDREN RELATIVE "${_CSTM_PATH}" "${_CSTM_PATH}/*")

    set(_CSTM_FOUND_DIRS "")
    foreach(_CHILD ${_CSTM_CHILDREN})
        if(IS_DIRECTORY "${_CSTM_PATH}/${_CHILD}")
            list(APPEND _CSTM_FOUND_DIRS "${_CHILD}")
        endif()
    endforeach()

    list(LENGTH _CSTM_FOUND_DIRS _CSTM_TOTAL)
    list(LENGTH _CSTM _CSTM_LINKED)

    message(STATUS "CUSTOM MODULES STATUS")
    message("\t\t-> Path                        :${_CSTM_PATH}")
    message("\t\t-> Modules physically present  :${_CSTM_TOTAL}")
    message("\t\t-> Modules linked in project   :${_CSTM_LINKED}")
    message("")

    foreach(_DIR ${_CSTM_FOUND_DIRS})
        if(TARGET ${_DIR})
            message("\t\t    >>> ${_DIR}")
        else()
            message("\t\t    XXX ${_DIR}")
        endif()
    endforeach()

    message("")
endif()


message("\n\n\n"
        "| =========================================================================== |\n"
        "|                                BUILD SUCCEEDED                              |\n"
        "| =========================================================================== |\n\n\n")

