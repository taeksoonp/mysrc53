#include <stdio.h>

#if 1
#include "tta_util.h"
#else
#include <openssl/evp.h>
#include <openssl/err.h>
#include <openssl/pem.h>
#include <openssl/rsa.h>
#include <string>
#include <vector>
#endif
#include <string.h>
#include <unistd.h>
#include <iostream>
#include <assert.h>
#include <openssl/evp.h>

#define ttrace(...) do {\
	fprintf(stderr, "%s:%d>>> ",strrchr(__FILE__,'/')? strrchr(__FILE__,'/')+1:__FILE__,__LINE__);\
	fprintf(stderr,__VA_ARGS__);}while(0)
#define RSA_KEYLEN 2048
typedef std::vector<unsigned char> ustring;

using namespace std;
int main()
{
	auto a = tta::init_defaultcrt("test.webgateinc.com", "hihi"/*pp*/);
	cout << a.first <<endl;
	cout << a.second <<endl;

	return 0;
}
