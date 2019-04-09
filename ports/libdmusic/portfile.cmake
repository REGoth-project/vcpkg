include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO frabert/libdmusic
    REF v0.1.6-2
    HEAD_REF master
    SHA512 b61917deddb9e55f5f86007e147defa349916ae0a0eeb9392645ea2dab09582b685a07d6aa5444bb59d6a923993fa69f7913b581e7ec4c25f06e974ae39b13d4
)

set(BUILD_TOOLS OFF)

if("tools" IN_LIST FEATURES)
    set(BUILD_TOOLS ON)
endif()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DDMUSIC_BUILD_UTILS=${BUILD_TOOLS}
    OPTIONS_DEBUG
        -DUTILS_DESTINATION=tools/libdmusic
    OPTIONS_RELEASE
        -DUTILS_DESTINATION=${CURRENT_PACKAGES_DIR}/tools/libdmusic
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)

# Handle copyright
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/libdmusic RENAME copyright)

if(BUILD_TOOLS)
  vcpkg_copy_tool_dependencies(${CURRENT_PACKAGES_DIR}/tools/libdmusic)
endif()

# Post-build test for cmake libraries
vcpkg_test_cmake(PACKAGE_NAME dmusic)
