# ================================================================================
# Create main source files
# ================================================================================
#
# File:     createSourceTemplate.cmake
# Author:   KinKout
# Date:     11-May-2026
#
# Purpose:  Create source files from templates .txt in /_cmake-config/template/.
#           Uses configure_file() to replace @PLUGIN_NAME@ and @BUILD_DATE@.
#
# ================================================================================


string(TIMESTAMP BUILD_DATE "%d-%b-%Y")
set(PLUGIN_NAME ${_PROJECT_NAME})

set(TEMPLATE_DIR "${_THIS_DIR}/_cmake-config/template")
set(_OPTIONAL_SOURCE_LOADED TRUE)

set(TEMPLATE_FILES
        "essential:source:PluginProcessor_h"
        "essential:source:PluginProcessor_cpp"
        "essential:source:PluginEditor_h"
        "essential:source:PluginEditor_cpp"
)

foreach(LIST ${TEMPLATE_FILES})
    string(REPLACE ":" ";" LIST ${LIST})
    list(GET LIST 0 TYPE)
    list(GET LIST 1 SUBDIR)
    list(GET LIST 2 TEMPLATE)

    string(REPLACE "_h" ".h" OUT_NAME ${TEMPLATE})
    string(REPLACE "_cpp" ".cpp" OUT_NAME ${OUT_NAME})
 
    set(SOURCE_FILE "${_THIS_DIR}/${SUBDIR}/${OUT_NAME}")
 
    if(NOT EXISTS "${SOURCE_FILE}")
        if(TYPE STREQUAL "optional" AND _OPTIONAL_SOURCE_LOADED STREQUAL TRUE)
            message(STATUS "Skipped (deleted by user): [${TYPE}] ${OUT_NAME}")
            continue()
        endif()
        configure_file(
            "${TEMPLATE_DIR}/${TEMPLATE}.txt"
            "${SOURCE_FILE}"
            @ONLY
        )
        message(STATUS "Generated: [${TYPE}] ${SUBDIR}/${OUT_NAME}")
    else()
        message(STATUS "Skipped (already exists): [${TYPE}] ${OUT_NAME}")
    endif()
endforeach()

if(NOT _OPTIONAL_SOURCE_LOADED)
    file(READ "_cmake-config/_scripts/createSourceTemplate.cmake" THIS_FILE)
    set(F FALSE)
    string(REPLACE
            "set(_OPTIONAL_SOURCE_LOADED ${F})"
            "set(_OPTIONAL_SOURCE_LOADED TRUE)"
            THIS_FILE_UPDATED
            "${THIS_FILE}")
    file(WRITE "_cmake-config/_scripts/createSourceTemplate.cmake" "${THIS_FILE_UPDATED}")
endif()