cmake_minimum_required(VERSION 3.12.4)

project(qflowwebsockets)

set(QT_MIN_VERSION "5.6.0")
find_package(Qt5 ${QT_MIN_VERSION} CONFIG REQUIRED
    Core
    Qml
    Network
    )
if(TARGET core)
    add_library(QFlow::core ALIAS core)
else()
    find_package(QFlowCore REQUIRED)
endif()
find_package(websocketpp REQUIRED)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)

file(GLOB_RECURSE CORE_SOURCES
    RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/*.cpp
    )
file(GLOB_RECURSE INSTALL_HEADERS
    RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/*.h
    )
    
add_library(qflowwebsockets SHARED ${CORE_SOURCES})
target_compile_definitions(qflowwebsockets PUBLIC WEBSOCKETS_LIBRARY)
set_target_properties(qflowwebsockets PROPERTIES CXX_STANDARD 14)
target_link_libraries(qflowwebsockets
    QFlow::core
    Qt5::Core
    Qt5::Qml
    Qt5::Network
    websocketpp::websocketpp
    $<$<BOOL:${WIN32}>:ws2_32>
    )

set(WEBSOCKETS_INSTALL_PATH "modules/QFlow/Websockets" CACHE PATH "qFlow Websockets Library Install Path")

define_property(TARGET PROPERTY QMLModulePath
    BRIEF_DOCS "Path to the module"
    FULL_DOCS "Path to the module"
    )
define_property(TARGET PROPERTY QMLModuleName
    BRIEF_DOCS "Name of the module"
    FULL_DOCS "Name of the module"
    )
set_target_properties(qflowwebsockets PROPERTIES
    QMLModulePath ${CMAKE_INSTALL_PREFIX}/modules
    QMLModuleName QFlow.Websockets
    )
set_target_properties(qflowwebsockets PROPERTIES
    EXPORT_PROPERTIES "QMLModulePath;QMLModuleName"
    )

set(PACKAGE_NAME "QFlowWebsockets")
install(TARGETS qflowwebsockets
    EXPORT ${PACKAGE_NAME}Config
    RUNTIME DESTINATION ${WEBSOCKETS_INSTALL_PATH}
    ARCHIVE DESTINATION lib
    COMPONENT qflow
    )
install(FILES ${INSTALL_HEADERS} DESTINATION include/${PACKAGE_NAME} COMPONENT qflow)
install(EXPORT ${PACKAGE_NAME}Config
    NAMESPACE QFlow::
    DESTINATION lib/cmake/${PACKAGE_NAME}
    )
install(FILES qmldir plugins.qmltypes DESTINATION ${WEBSOCKETS_INSTALL_PATH} COMPONENT qflow)
