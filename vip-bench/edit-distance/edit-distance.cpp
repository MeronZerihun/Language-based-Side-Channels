/*
 *        Levenshtein distance is a string metric for measuring the
 *  difference between two sequences.
 *  the Levenshtein distance between two words is the minimum number
 *  of single-character edits (insertions, deletions or substitutions) required
 *  to change one word into the other. It is named after the Soviet mathematician
 *  Vladimir Levenshtein, who considered this distance in 1965.
 *
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <vector>
#include <string>
using namespace std;

#include "../config.h"

// test data
extern vector<string> random_s;

VIP_ENCUINT
EditDistance(vector<VIP_ENCCHAR> &str1, vector<VIP_ENCCHAR> &str2)
{
  VIP_ENCUINT dist;
  unsigned i, j;
  unsigned strlen1 = str1.size(), strlen2 = str2.size();
  vector<vector<VIP_ENCUINT>> edit_matrix(strlen1 + 1, vector<VIP_ENCUINT>(strlen2 + 1));

  if (strlen1 == 0)
    dist = strlen2;
  else if (strlen2 == 0)
    dist = strlen1;
  else
  {
    for (i = 0; i < strlen1 + 1; i++)
      edit_matrix[i][0] = i;

    for (j = 0; j < strlen2 + 1; j++)
      edit_matrix[0][j] = j;

    for (i = 0; i < strlen1; i++)
    {
      for (j = 0; j < strlen2; j++)
      {
        VIP_ENCUINT edit;
#if defined(VIP_DO_MODE) || defined(VIP_DO_BROKEN)
        edit = VIP_CMOV((str1[i] == str2[j]), (VIP_ENCUINT)0, (VIP_ENCUINT)1);
#else
        if (str1[i] == str2[j])
          edit = 0;
        else
          edit = 1;
#endif /* VIP_DO_MODE */

#ifdef VIP_DO_BROKEN
#define MIN(x, y, z) (VIP_CMOV((x) < (y) && (x) < (z), (x), VIP_CMOV((y) < (z), (y), (z))))
#elif VIP_DO_MODE
#define MIN(x, y, z) (VIP_CMOV((x) < (y) & (x) < (z), (x), VIP_CMOV((y) < (z), (y), (z))))
#else
#define MIN(x, y, z) ((x) < (y) && (x) < (z) ? (x) : (y) < (z) ? (y) \
                                                               : (z))
#endif
        edit_matrix[i + 1][j + 1] = MIN(edit_matrix[i][j + 1] + 1, edit_matrix[i + 1][j] + 1, edit_matrix[i][j] + edit);
      }
    }
    dist = edit_matrix[strlen1][strlen2];
  }
  return dist;
}

void FindDistanceWithinArray(vector<string> &arr)
{
  // unsigned len = arr.size();

  // for (unsigned i = 0; i < len; i++)
  // {
  //   for (unsigned j = 0; j < len; j++)
  //   {
  // prep the input data
  int i = 0, j = 1;
  vector<VIP_ENCCHAR> arr_i(arr[i].length());
  for (unsigned k = 0; k < arr[i].length(); k++)
    arr_i[k] = arr[i][k];

  vector<VIP_ENCCHAR> arr_j(arr[j].length());
  for (unsigned k = 0; k < arr[j].length(); k++)
    arr_j[k] = arr[j][k];

  VIP_ENCUINT ed = EditDistance(arr_i, arr_j);

  // cout << "INFO: edit_distance(" << arr[0] << ", " << arr[1] << ") == " << VIP_DEC(ed) << endl;
}
//   }
// }

int main(int argc, char **argv)
{
  // cout << "Distance: "<< editDistance(str2, str1)<< endl;
  // fprintf(stdout, "------Within the randoms array------\n");
  // {
  //   Stopwatch s("VIP_Bench Runtime");

  vector<string> args;
  if (argc > 1)
  {
    args.assign(argv + 1, argv + argc);
  }

  FindDistanceWithinArray(args);
  // }
  // cout<<"------Between random array and biased array (sequences of the same length)------"<<endl;
  // findDistanceBetweenArray(random_s, biased_s);
  // cout<<"------check for same and empty sequences------"<<endl;
  // checkForSameAndEmpty();

  return 0;
}

// tuck the test data at the end of the file
