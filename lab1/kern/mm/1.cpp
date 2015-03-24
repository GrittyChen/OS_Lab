#include "memlayout.h"
#include "pmm.h"
#include "mmu.h"
#include <iostream>
#include "stdint.h"

using namespace std;

int main()
{
	unsigned intr;
	intr = 8;
	SETGATE(intr, 0, 1, 2, 3);
	cout << intr;
	return 0;
}
