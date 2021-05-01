project(temp)
find_package(MPI REQUIRED)
include_directories(${MPI_INCLUDE_DIRS})
add_executable(temp main.cpp)
target_link_libraries(temp ${MPI_LIBRARIES})

