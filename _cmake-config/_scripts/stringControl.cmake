# ================================================================================
# Project name, product name, description, and version validation
# ================================================================================
#
# File:     stringControl.cmake
# Author:   KinKout
# Date:     15-Aug-2026
#
# Purpose:  Strip, validate length and characters of "_PROJECT_NAME", "_PRODUCT_NAME",
#           "_DESCRIPTION", and "_VERSION" variables from "_cmake-config/pluginConfig.cmake" file
#           using  regular expressions.
#           Visit https://regex101.com/ for testing regular expressions
#
# ================================================================================

set(_PROJECT_REGEX "^[A-Za-z0-9_.+-]+$")
set(_PRODUCT_REGEX "^[^/\\\"*:|<>?]+$")
set(_VERSION_REGEX "^(0|[1-9][0-9]*)\\.(0|[1-9][0-9]*)\\.(0|[1-9][0-9]*)$")
set(_NAME_LENGTH 30)
set(_DESCRIPTION_LENGTH 255)

# -------------------------------------------------------------------------------- Check RegEx
function(check_name_regex _VAR_NAME _STRING _REGEX)

    string(REGEX MATCH ${_REGEX} _MATCHED ${_STRING})

    if(NOT _MATCHED)
        build_failure_msg()
        message(FATAL_ERROR
            "- Invalid character in \"${_VAR_NAME}\" -> \"${_STRING}\"\n"
            "- RegEx character allowed -> ${_REGEX}\n"
            "- You can test the name at https://regex101.com/\n"
            "- Check the variable in \"_cmake-config/pluginConfig.cmake\" file\n")
    endif()
endfunction()

# -------------------------------------------------------------------------------- Check Length
function(check_name_length _VAR_NAME _STRING _MAX_LENGTH )

    string(LENGTH ${_STRING} _N_CHAR)

    if(_N_CHAR GREATER _MAX_LENGTH)
        build_failure_msg()
        message(FATAL_ERROR
                "- \"${_N_CHAR}\" characters in \"${_VAR_NAME}\" -> \"${_STRING}\"\n"
                "- max length -> ${_MAX_LENGTH}\n"
                "- Check the variable in \"_cmake-config/pluginConfig.cmake\" file\n")
    endif()
endfunction()

# -------------------------------------------------------------------------------- Strip and check empty string
function(strip_name _OUTPUT_STRING _STRING)

    foreach(i RANGE 1)

        if(_STRING STREQUAL "")
            build_failure_msg()
            message(FATAL_ERROR
                "- No characters in \"${_OUTPUT_STRING}\"\n"
                "- Check the variable in \"_cmake-config/pluginConfig.cmake\" file\n")
        endif()

        if(i EQUAL 0)
            string(STRIP ${_STRING} _STRING)
        endif()

    endforeach()
    set(${_OUTPUT_STRING} ${_STRING} PARENT_SCOPE)
endfunction()
    
# -------------------------------------------------------------------------------- Check _PROJECT_NAME:
# -------------------------------------------------------------------------------- max 30 characters
strip_name(_PROJECT_NAME ${_PROJECT_NAME})

check_name_length(_PROJECT_NAME ${_PROJECT_NAME} ${_NAME_LENGTH})

check_name_regex(_PROJECT_NAME ${_PROJECT_NAME} ${_PROJECT_REGEX})

# -------------------------------------------------------------------------------- Check _PRODUCT_NAME:
# -------------------------------------------------------------------------------- max 30 characters
strip_name(_PRODUCT_NAME ${_PRODUCT_NAME})

check_name_length(_PRODUCT_NAME ${_PRODUCT_NAME} ${_NAME_LENGTH})

check_name_regex(_PRODUCT_NAME ${_PRODUCT_NAME} ${_PRODUCT_REGEX})

# -------------------------------------------------------------------------------- Check _DESCRIPTION:
# -------------------------------------------------------------------------------- max 255 characters
string(STRIP ${_DESCRIPTION} _DESCRIPTION)

check_name_length(_DESCRIPTION ${_DESCRIPTION} ${_DESCRIPTION_LENGTH})

# -------------------------------------------------------------------------------- Check _VERSION:
check_name_regex(_VERSION ${_VERSION} ${_VERSION_REGEX})