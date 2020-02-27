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
	const char* plain =
			"aaaaaaaa" "aaaaaaaa" "aaaaaaaa" "aaaaaaaa"
			"aaaaaaaa" "aaaaaaaa"
			, *pp = "hi";
#if 0
	tta::salt_t salt = tta::getSalt();
	auto ukey = tta::getKey(pp, salt);

	tta::dvrkey_t key;
	memcpy(key.key, &ukey[0], sizeof key.key);
	tta::set_dvrkey(key);
	auto aes64 = tta::toAes64(plain);
	auto aes = tta::fromBase64(aes64);

	unsigned char buf[tta::kni_len + tta::iv_len + 8 + 8];

	strcpy((char*)buf, "Salted__");
	memcpy(buf + 8, salt.salt, sizeof salt.salt);
	memcpy(buf + 16, &aes[0], aes.size());
	assert(aes.size() == 32 + 16 + 16);

	auto salted64 = tta::toBase64(buf, sizeof buf);
	for(int i=0; i<sizeof buf; i++)
	{
		printf("%02x ", buf[i]);
		if (i % 16 == 15)
			printf("\n");
	}
	cout << endl;
#else

	auto salted64 = tta::toSalted64((unsigned char*)plain, strlen(plain), pp);
#endif

	cout << endl << endl << salted64 << endl;
	printf("salted64 size %d\n", salted64.size());

	auto newplain = tta::fromSalted64(salted64.c_str(), pp);
	string plains((char*)&newplain[0], newplain.size());

	cout << plains << endl;
	assert(plains == plain);
	printf("size %d, OK\n", plains.size());

	return 0;
}

/*
 * 검사
echo U2FsdGVkX19tDttKF1jLMTn1J3HEYX6BtziaW93WClY= |openssl enc -a -d -aes-256-cbc -pass pass:hi -md sha256 -p
 */
