#include <stdio.h>

int array[10] = {24, 10, 56, 62, 50, 43, 21, 17, 35, 55};

void swap(int indx_1, int indx_2) {
	int tmp = array[indx_1];
	array[indx_1] = array[indx_2];
	array[indx_2] = tmp;
}

int findMin(int cmp, int now, int stop) {
	int this_is_min;

	if (array[now] < array[cmp]) 
		this_is_min = now;
	else
		this_is_min = cmp;
	
	if (now == stop)
		return this_is_min;
	
	return findMin(this_is_min, now + 1, stop);
}

void sort(int stage, int lim) {
	if (stage == lim)
		return;
	
	int min_indx = findMin(stage, stage + 1, lim);
	
	swap(stage, min_indx);
	sort(stage + 1, lim);
}

int main() {
	sort(0, 9);

	return 0;
}
