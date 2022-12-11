/*
 ELEMENT DISTINCTNESS ALGORITHM
 There are multiple ways of detecting whether the elements are distinct or not.
 One of the ways is to sort the elements in the array and check if the elements next to each other
 are equal or not.
 On the other hand an n^2 loop can be used to select an element from the array and check if the
 the element exists.
 The approach used in this algorithm is adding the elements in an array implementation of a binary tree
 If the elements already exists in the tree then the elements are not distinct else it is. The function
 performing the algorithm is isDistinct function.
*/
#include <iostream>
#include <limits>
#include <vector>

#include <sstream>

#include "../config.h"

using namespace std;

#define SIZE 2
#define MAX numeric_limits<int>::max()

VIP_ENCBOOL isDistinct(VIP_ENCINT elements[], VIP_ENCINT &dup)
{
	dup = MAX;
	for (int i = SIZE - 1; i >= 0; i--)
	{
		for (int j = 0; j < SIZE; j++)
		{
#if defined(VIP_DO_MODE) || defined(VIP_DO_BROKEN)
#ifdef VIP_DO_BROKEN
			bool cond = (elements[i] == elements[j]) && (i != j) && (dup == MAX);
			dup = VIP_CMOV(cond, elements[j], dup);
#else
			bool cond = (elements[i] == elements[j]) & (i != j) & (dup == MAX);
			dup = VIP_CMOV(cond, elements[j], dup);
#endif
#else  /* !VIP_DO_MODE AND !VIP_DO_BROKEN */
			if (elements[i] == elements[j] && i != j)
				dup = elements[j];
#endif /* VIP_DO_MODE AND !VIP_DO_BROKEN */
		}
	}
	return (dup == MAX);
}

int main(int argc, char **argv)
{
	VIP_ENCINT dup1;

	int seed = 0;
	if (argc > 1)
	{
		seed = atoi(*(argv + 1));
	}
	mysrand(seed);

	VIP_ENCINT elements[SIZE];

	for (int i = 0; i < SIZE; i++)
	{
		int x = myrand() % 5;
		elements[i] = x;
	}

	VIP_ENCBOOL res1 = isDistinct(elements, dup1);

	/***** Printing Result *****/
	// cout << "SEED: " << seed;
	// if (VIP_DEC(res1))
	// 	cout << " The elements of 'elements' [" << VIP_DEC(elements[0]) << ", " << VIP_DEC(elements[1]) << "] are distinct" << endl;
	// else
	// 	cout << " The elements of 'elements' [" << VIP_DEC(elements[0]) << ", " << VIP_DEC(elements[1]) << "] are not distinct (e.g., " << VIP_DEC(dup1) << " is duplicated)" << endl;

	return 0;
}
