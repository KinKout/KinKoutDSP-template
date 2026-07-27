# ================================================================================
# Create main source files
# ================================================================================
#
# File:     createSource.cmake
# Author:   KinKout
# Date:     11-May-2026
#
# Purpose:  Create source files from templates in /_cmake-config/template/ if not present.
#           Uses configure_file() to replace @PLUGIN_NAME@ and @BUILD_DATE@.
#
# ================================================================================


string(TIMESTAMP BUILD_DATE "%d-%b-%Y")
set(PLUGIN_NAME ${_PROJECT_NAME})
 
set(TEMPLATE_DIR "${CMAKE_SOURCE_DIR}/_cmake-config/template")
set(SOURCE_DIR   "${CMAKE_SOURCE_DIR}/source")
 
set(TEMPLATE_FILES
    PluginProcessor_h
    PluginProcessor_cpp
    PluginEditor_h
    PluginEditor_cpp
)
 
foreach(TMPL ${TEMPLATE_FILES})
    string(REPLACE "_h"   ".h"   OUT_NAME ${TMPL})
    string(REPLACE "_cpp" ".cpp" OUT_NAME ${OUT_NAME})
 
    set(SRC_FILE "${SOURCE_DIR}/${OUT_NAME}")
 
    if(NOT EXISTS "${SRC_FILE}")
        configure_file(
            "${TEMPLATE_DIR}/${TMPL}.txt"
            "${SRC_FILE}"
            @ONLY
        )
        message(STATUS "Generated: ${OUT_NAME}")
    else()
        message(STATUS "Skipped (already exists): ${OUT_NAME}")
    endif()
endforeach()
 


