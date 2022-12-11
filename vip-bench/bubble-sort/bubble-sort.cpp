#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "utils.h"

// include build configuration defines
#include "../config.h"

#define DATASET_SIZE 256
VIP_ENCINT data[DATASET_SIZE];

// total swaps executed so far
unsigned long swaps = 0;

void print_data(VIP_ENCINT *data, unsigned size)
{
  fprintf(stdout, "DATA DUMP:\n");
  for (unsigned i = 0; i < size; i++)
    fprintf(stdout, "  data[%u] = %d\n", i, VIP_DEC(data[i]));
}

void bubblesort(VIP_ENCINT *data, unsigned size)
{
  for (unsigned i = size; i > 1; i--)
  {
#if !defined(VIP_DO_MODE) && !defined(VIP_DO_BROKEN)
    bool swapped = false;
#endif /* !VIP_DO_MODE */
    for (unsigned j = 0; j < i - 1; j++)
    {
#if !defined(VIP_DO_MODE) && !defined(VIP_DO_BROKEN)
      if (data[j] > data[j + 1])
      {
        VIP_ENCINT tmp = data[j];
        data[j] = data[j + 1];
        data[j + 1] = tmp;
        swapped = true;
        swaps++;
      }
#else  /* VIP_DO_MODE */
      VIP_ENCBOOL do_swap = data[j] > data[j + 1];
      VIP_ENCINT tmp = data[j];
      data[j] = VIP_CMOV(do_swap, data[j + 1], data[j]);
      data[j + 1] = VIP_CMOV(do_swap, tmp, data[j + 1]);
      swaps++;
#endif /* VIP_DO_MODE */
    }
#if !defined(VIP_DO_MODE) && !defined(VIP_DO_BROKEN)
    // done?
    if (!swapped)
      break;
#endif /* !VIP_DO_MODE */
  }
}

int main(int argc, char **argv)
{
  // initialize the privacy enhanced execution target
  VIP_INIT;
  int seed = 0;
  if (argc > 1)
  {
    seed = atoi(*(argv + 1));
  }

  // initialize the pseudo-RNG
  mysrand(seed);
  // mysrand(time(NULL));

  // initialize the array to sort
  for (unsigned i = 0; i < DATASET_SIZE; i++)
    data[i] = myrand();
  // print_data(data, DATASET_SIZE);

  // {
  // Stopwatch s("VIP_Bench Runtime");
  bubblesort(data, DATASET_SIZE);
  // }
  // print_data(data, DATASET_SIZE);

  // check the array
  // for (unsigned i = 0; i < DATASET_SIZE - 1; i++)
  // {
  //   if (VIP_DEC(data[i]) > VIP_DEC(data[i + 1]))
  //   {
  //     fprintf(stdout, "ERROR: data is not properly sorted.\n");
  //     return -1;
  //   }
  // }
  // fprintf(stderr, "INFO: %lu swaps executed.\n", swaps);
  // fprintf(stdout, "INFO: data is properly sorted.\n");
  return 0;
}
