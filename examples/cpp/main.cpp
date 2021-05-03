#include <stdio.h>
#include <unistd.h>
#include <mpi.h>

int main(int argc, char* argv[]){
  MPI_Init(&argc, &argv);
  /* Get Rank and Comm from MPI*/
  int rank, comm_sz;
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  MPI_Comm_size(MPI_COMM_WORLD, &comm_sz);
  /* Get PID from process. */
  int pid = getpid();
  printf("%d\n", pid);
  fflush(stdout);
  if (rank == 0) {
    printf("press any key to continue executation.\n");
    fflush(stdout);
    getchar();
  }
  MPI_Barrier(MPI_COMM_WORLD);
  /* App logic goes here. */
  printf("hello1\n");
  printf("hello2\n");
  printf("hello3\n");
  return 0;
}
//gdb--sessions
