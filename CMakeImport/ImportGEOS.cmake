#
# Set up GEOS library
#
# This script will locate GEOS based on GEOS_DIR.
# The purpose is to install the DLL / SO dependencies
# into INSTALLSETTINGS_SHARED_LIBRARY_DIR.
#

# No need to continue if not doing installation
if(DEFINED INSTALL_THIRDPARTY_LIBRARIES AND NOT INSTALL_THIRDPARTY_LIBRARIES)
    return()
endif()

set(LIBRARYNAME GEOS)
set(GEOS_VERSION 3.7.3)
set(GEOS_C_VERSION 1.11.3)
set(${LIBRARYNAME}_INSTALL_COMPONENT ThirdPartyLibs)

# Setup search paths
initialize_ENV(GEOS_DIR)

# Find the root for GEOS
find_path(GEOS_DIR
    NAMES include/geos_c.h
    HINTS
        $ENV{GEOS_DIR}
        ${THIRD_DIR}/GEOS/${${LIBRARYNAME}_VERSION}
    NO_DEFAULT_PATH
)

# Install the libraries into the shared library runtime location
macro(geos_install_library SUBDIR NAME)
    set(_RELEASE_LIB "${GEOS_DIR}/${SUBDIR}/${NAME}")
    if(EXISTS "${_RELEASE_LIB}")
        # Pull out all the share links too
        get_symlinks("${_RELEASE_LIB}" _RELEASE_LIBS)
        install(PROGRAMS ${_RELEASE_LIBS}
            DESTINATION "${INSTALLSETTINGS_SHARED_LIBRARY_DIR}"
            COMPONENT ${${LIBRARYNAME}_INSTALL_COMPONENT}
        )
    endif()
endmacro()

# Install each library
if(WIN32)
    geos_install_library(bin geos.dll)
    geos_install_library(bin geos_c.dll)
else()
    geos_install_library(lib libgeos.so)
    geos_install_library(lib libgeos_c.so)
endif()

# Mark variables as advanced
if(IS_DIRECTORY "${GEOS_DIR}")
    mark_as_advanced(FORCE GEOS_DIR)
else()
    mark_as_advanced(CLEAR GEOS_DIR)
endif()
