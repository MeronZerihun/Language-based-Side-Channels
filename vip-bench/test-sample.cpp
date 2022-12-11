#define SIZE 2
#define MAX numeric_limits<int>::max()

VIP_ENCBOOL isDistinct(VIP_ENCINT elements[], VIP_ENCINT &dup)
{
	dup = MAX;
	for (int i = SIZE - 1; i >= 0; i--)
	{
		for (int j = 0; j < SIZE; j++)
		{
#if defined(VIP_DO_MODE) || defined(VIP_DO_LEAKY)
#ifdef VIP_DO_LEAKY
			bool cond = (elements[i] == elements[j]) && (i != j) && (dup == MAX);
			dup = VIP_CMOV(cond, elements[j], dup);
#else
			bool cond = (elements[i] == elements[j]) & (i != j) & (dup == MAX);
			dup = VIP_CMOV(cond, elements[j], dup);
#endif
#else  /* !VIP_DO_MODE AND !VIP_DO_LEAKY */
			if (elements[i] == elements[j] && i != j && dup == MAX)
				dup = elements[j];
#endif /* VIP_DO_MODE AND !VIP_DO_LEAKY */
		}
	}
	return (dup == MAX);
}

bool CheckPatientRisk(MedicalRecord patient)
{
	bool in_danger = false;
	if (patient.has_high_blood_sugar() && patient.has_heart_condition())
		in_danger = true;
	return in_danger;
}
