#include "mpi.h"
#include <stdio.h>
#include <unistd.h>
#include <mpi.h>

int main(){
  MPI_Init(NULL, NULL);
  int rank, comm_sz;
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  MPI_Comm_size(MPI_COMM_WORLD, &comm_sz);

  int pid = getpid();
  printf("%d\n", pid);
  fflush(stdout);
  if(rank == 0) {
    getchar();
  }
  MPI_Barrier(MPI_COMM_WORLD);
  printf("hello1\n");
  printf("hello2\n");
  printf("hello3\n");
  return 0;
}
//gdb--sessions
