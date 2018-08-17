function(stevedore command)
    if(${command} STREQUAL "internal-unpack")
        list(GET ARGN 0 repo_name)
        list(GET ARGN 1 artifact_id)
        list(GET ARGN 2 target_path)
    else()
        message(FATAL_ERROR "Unsupported command `${command}'")
    endif()

    if(${CMAKE_SYSTEM_NAME} STREQUAL "Darwin" OR ${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
        find_program(MONO mono)
    else()
        set(MONO "")
    endif()

    find_program(BEE bee.exe HINTS ${CMAKE_SOURCE_DIR})
    find_program(7ZA 7za)

    message(STATUS "Stevedore fetching ${repo_name}:${artifact_id} to ${target_path}")
        execute_process(COMMAND ${CMAKE_COMMAND} -E env "BEE_INTERNAL_STEVEDORE_7ZA=${7ZA}" ${MONO} ${BEE} steve internal-unpack ${repo_name} ${artifact_id} ${target_path})
endfunction()