#!/bin/bash
#BOS
#
builtin read -p 'Set WT Version: ' WTV
[ ! -d wt-${WTV}-ccm-wsgi ] && echo "No Project: wt-${WTV}-ccm-wsgi" && exit -1
sed -i \
    -e 's|^\(cmake_minimum_required(VERSION \).*\(\.\.\.\).*\()\)$|\13.25\23.30\3|g' \
    -e 's|^\(OPTION(ENABLE_QT[4|5].* \)ON\()\)$|\1OFF\2|g' \
    -e '/^IF(NOT CMAKE_CXX_STANDARD)$/i IF(NOT CMAKE_C_STANDARD)' \
    -e '/^IF(NOT CMAKE_CXX_STANDARD)$/i \ \ SET(CMAKE_C_STANDARD 11)' \
    -e '/^IF(NOT CMAKE_CXX_STANDARD)$/i \ \ #SET(CMAKE_C_STANDARD 17)' \
    -e '/^IF(NOT CMAKE_CXX_STANDARD)$/i ENDIF(NOT CMAKE_C_STANDARD)' \
    -e '/^IF(NOT CMAKE_CXX_STANDARD)$/i SET(CMAKE_C_EXTENSIONS OFF)' \
    -e '/^IF(NOT CMAKE_CXX_STANDARD)$/i SET(CMAKE_C_STANDARD_REQUIRED ON)' \
    -e '/^IF(NOT CMAKE_CXX_STANDARD)$/i\\' \
    -e 's|^\(  SET(CMAKE_CXX_STANDARD \).*\()\)$|\120\2|g' \
    -e '/^ENDIF(NOT CMAKE_CXX_STANDARD)$/i \ \ #SET(CMAKE_CXX_STANDARD 17)' \
    -e '/^ADD_DEFINITIONS(-DWT_WITH_OLD_INTERNALPATH_API)$/i ADD_DEFINITIONS(-D_DEFAULT_SOURCE)' \
    -e '/^SET(WTHTTP_CONFIGURATION.*)$/a SET(WSFCGI_CONFIGURATION "${CONFIGDIR}/wsfcgid" CACHE PATH "Path for the wthttpd configuration file")' \
    -e '/^  SET(CONNECTOR_FCGI FALSE)$/a \ \ SET(CONNECTOR_WSGI FALSE)' \
    -e '/^  OPTION(CONNECTOR_FCGI.*) ?" ON)$/a \ \ OPTION(CONNECTOR_WSGI "Compile in WSGI connector (libwsfcgi) ?" ON)' \
    wt-${WTV}-ccm-wsgi/CMakeLists.txt
sed -i \
    -e '/^#define WTHTTP_CONFIGURATION.*$/a #define WSFCGI_CONFIGURATION "${WSFCGI_CONFIGURATION}"' \
    wt-${WTV}-ccm-wsgi/WConfig.h.in
sed -i \
    -e 's|^\(SUBDIRS(isapi.*\))$|\1 wsgi)|g' \
    wt-${WTV}-ccm-wsgi/src/CMakeLists.txt
sed -i \
    -e '/^namespace Wt {$/i namespace ws {\n  namespace server {\n    class ProxyReply;\n  }\n}\n' \
    -e '/^  friend class http::server::ProxyReply;$/a \ \ friend class ws::server::ProxyReply;' \
    wt-${WTV}-ccm-wsgi/src/web/WebController.h
mkdir -p wt-${WTV}-ccm-wsgi/build/{CCMake-Debug,CCMake-MinSizeRel,CCMake-Profile,CCMake-Release,CCMake-RelWithDebInfo}
ccmake -B wt-${WTV}-ccm-wsgi/build/CCMake-Debug -S wt-${WTV}-ccm-wsgi \
	-D CMAKE_BUILD_TYPE=Debug \
	-D BUILD_FUZZ=OFF \
	-D DEBUG=ON \
	-D ENABLE_SAML=ON \
	-D ENABLE_UNWIND=ON \
	-D EXAMPLES_CONNECTOR=wsfcgi \
	-D IBPP_SRC_DIRECTORY=/home/sib/Projects/ibpp.d/core \
	-D INSTALL_DOCUMENTATION=ON \
	-D INSTALL_EXAMPLES=ON \
	-D UNWIND_PREFIX=/usr \
	-D WEBGROUP=www-data \
	-D WEBUSER=www-data \
	-D WT_CPP20_DATE_TZ_IMPLEMENTATION=std \
	-D WT_WRASTERIMAGE_IMPLEMENTATION=GraphicsMagick
#
#EOS
