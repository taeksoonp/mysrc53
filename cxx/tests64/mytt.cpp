#include <stdio.h>
#include <string.h>
#include <openssl/rand.h>
#include <string>
#include <iostream>
#include <assert.h>

/*
 * https://wiki.openssl.org/index.php/Random_Numbers
 */
using namespace std;
int main()
{
	const RAND_METHOD* rm = RAND_get_rand_method();
	if(rm == RAND_SSLeay())
	{
	    printf("Using default generator\n");
	}

	int rnum;
	int ret = RAND_bytes((unsigned char*)&rnum, sizeof rnum);
	assert(ret > 0);

	printf("rand test: %d vs %d\n", rnum, rand());

	return (0);
}
