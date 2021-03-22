#include <stdio.h>

#if 0
#include "tta_util.h"
#else
#include <openssl/evp.h>
#include <openssl/err.h>
#include <openssl/pem.h>
#include <openssl/rsa.h>
#include <string.h>
#include <unistd.h>
#include <string>
#include <vector>
#include <iostream>

#define ttrace(...) do {\
	fprintf(stderr, "%s:%d>>> ",strrchr(__FILE__,'/')? strrchr(__FILE__,'/')+1:__FILE__,__LINE__);\
	fprintf(stderr,__VA_ARGS__);}while(0)
#define RSA_KEYLEN 2048
typedef std::vector<unsigned char> ustring;

void handleErrors(void)
{
    ERR_print_errors_fp(stderr);
	ttrace("<~~openssl error! abort.\n");
    abort();
}

EVP_PKEY* genKeyPair()
{
	EVP_PKEY_CTX *ctx;
	EVP_PKEY *keypair = 0;

	ctx = EVP_PKEY_CTX_new_id(EVP_PKEY_RSA, NULL);

	if (EVP_PKEY_keygen_init(ctx) <= 0)
		handleErrors();

	if (EVP_PKEY_CTX_set_rsa_keygen_bits(ctx, RSA_KEYLEN) <= 0)
		handleErrors();

	if (EVP_PKEY_keygen(ctx, &keypair) <= 0)
		handleErrors();

	EVP_PKEY_CTX_free(ctx);

	return keypair;
}

std::string getPemPKey(EVP_PKEY *pKey)
{
	BIO *pub = BIO_new(BIO_s_mem());
	PEM_write_bio_PUBKEY(pub, pKey);
	int pub_len = BIO_pending(pub);

	ttrace("~~pub_len %d\n", pub_len);

	//read
	std::vector<char> buf(pub_len);//init 0
	BIO_read(pub, &buf[0], pub_len);
	BIO_free_all(pub);

	return std::string(buf.begin(), buf.end());
}

ustring rsaenc(const std::string& pem, const unsigned char* in, size_t inlen)
{
	//pem
	BIO *pub = BIO_new(BIO_s_mem());
	BIO_write(pub, pem.c_str(), pem.size());
	EVP_PKEY *key = PEM_read_bio_PUBKEY(pub, 0,0,0);
	if (key == 0)
		handleErrors();

	/* NB: assumes eng, key, in, inlen are already set up,
	* and that key is an RSA public key
	*/
	EVP_PKEY_CTX *ctx = EVP_PKEY_CTX_new(key, NULL);
	if (!ctx)
		handleErrors();/* Error occurred */

	if (EVP_PKEY_encrypt_init(ctx) <= 0)
		handleErrors();/* Error */

	if (EVP_PKEY_CTX_set_rsa_padding(ctx, RSA_PKCS1_OAEP_PADDING) <= 0)
		handleErrors();/* Error */

	/* Determine buffer length */
	size_t outlen;
	if (EVP_PKEY_encrypt(ctx, NULL, &outlen, in, inlen) <= 0)
		handleErrors();/* Error */

	ustring  buf(outlen);
	if (EVP_PKEY_encrypt(ctx, &buf[0], &outlen, in, inlen) <= 0)
		handleErrors();/* Error */

	//clean up
	BIO_free_all(pub);
	EVP_PKEY_CTX_free(ctx);
	EVP_PKEY_free(key);

	return buf;
}

ustring rsaenc(const ustring& der, const unsigned char* in, size_t inlen)
{
	const unsigned char* p = &der[0];
	EVP_PKEY *key = d2i_PublicKey(EVP_PKEY_RSA, 0, &p, der.size());
	if (key == 0)
		handleErrors();

	/* NB: assumes eng, key, in, inlen are already set up,
	* and that key is an RSA public key
	*/
	EVP_PKEY_CTX *ctx = EVP_PKEY_CTX_new(key, NULL);
	if (!ctx)
		handleErrors();/* Error occurred */

	if (EVP_PKEY_encrypt_init(ctx) <= 0)
		handleErrors();/* Error */

	if (EVP_PKEY_CTX_set_rsa_padding(ctx, RSA_PKCS1_OAEP_PADDING) <= 0)
		handleErrors();/* Error */

	/* Determine buffer length */
	size_t outlen;
	if (EVP_PKEY_encrypt(ctx, NULL, &outlen, in, inlen) <= 0)
		handleErrors();/* Error */

	ustring  buf(outlen);
	if (EVP_PKEY_encrypt(ctx, &buf[0], &outlen, in, inlen) <= 0)
		handleErrors();/* Error */

	//clean up
	EVP_PKEY_CTX_free(ctx);
	EVP_PKEY_free(key);

	return buf;
}

#if 0//diing
ustring rsadec(const std::string& pem, const unsigned char* in, size_t inlen)
{
	//pem
	BIO *pri = BIO_new(BIO_s_mem());
	BIO_write(pri, pem.c_str(), pem.size());
	EVP_PKEY *key = PEM_read_bio_PrivateKey(pri, 0,0,0);
	if (key == 0)
		handleErrors();
#elif 1

ustring rsadec(EVP_PKEY *key, const unsigned char* in, size_t inlen)
{
	/* NB: assumes eng, key, in, inlen are already set up,
	* and that key is an RSA public key
	*/
	EVP_PKEY_CTX *ctx = EVP_PKEY_CTX_new(key, NULL);
	if (!ctx)
		handleErrors();/* Error occurred */

#else //이건 die
ustring rsadec(EVP_PKEY_CTX *ctx, const unsigned char* in, size_t inlen)
{
#endif
	if (EVP_PKEY_decrypt_init(ctx) <= 0)
		handleErrors();/* Error */

	if (EVP_PKEY_CTX_set_rsa_padding(ctx, RSA_PKCS1_OAEP_PADDING) <= 0)
		handleErrors();/* Error */

	/* Determine buffer length */
	size_t outlen;
	if (EVP_PKEY_decrypt(ctx, NULL, &outlen, in, inlen) <= 0)
		handleErrors();/* Error */

	ustring  buf(outlen);
	if (EVP_PKEY_decrypt(ctx, &buf[0], &outlen, in, inlen) <= 0)
		handleErrors();/* Error */

	//clean up
//	BIO_free_all(pri);
	EVP_PKEY_CTX_free(ctx);
//	EVP_PKEY_free(key);

	return buf;
}
#endif

ustring getDerKey(EVP_PKEY *pKey)
{
	int keysz = EVP_PKEY_size(pKey);

	int pkeyLen;
#if 1
	pkeyLen = i2d_PublicKey(pKey, NULL);
	ustring buf(pkeyLen);
	unsigned char* tmp = &buf[0];
	i2d_PublicKey(pKey, &tmp);

	ttrace("~~pkey sz %d, pkeyLen %d\n", keysz, pkeyLen);

	return buf;

#elif 0
	ucBuf = (unsigned char *)malloc(pkeyLen+1);
	pkeyLen = i2d_PublicKey(pKey, &ucBuf);
	ttrace("~~pkey sz %d, pkeyLen %d\n", keysz, pkeyLen);
#elif 0
	BIO *pub = BIO_new(BIO_s_mem());
	i2d_RSAPublicKey_bio(pub, pKey);
	int pub_len = BIO_pending(pub);
#else

	pkeyLen = i2d_PublicKey(pKey, &ucBuf);
	ttrace("~~pub_len %d\n", pub_len);

	//read
	ustring buf(pub_len);//init 0
	pkeyLen = i2d_PublicKey(EVP_PKEY_RSA, pKey, &ucBuf);

	return buf;
#endif
}

using namespace std;
int main()
{
	const char* hi = "hi";
/*
	auto a64 = tta::toAes64(hi);
	printf("'%s'\n", a64.c_str());

	auto plain = tta::fromAes64(a64);
	printf("'%s'\n", plain.c_str());
*/
//attempting free on address which was not malloc()-ed	tta::ttrsa();
	unsigned char *plain = (unsigned char*)"123456789012345678901234567890123456789012345678";

	auto key = genKeyPair();
//?	EVP_PKEY_CTX_free(context);

//ng.gg	auto buf = test_rsa(pkey);
	auto pem = getPemPKey(key);
//	std::cout << pem << std::endl;

	cout << pem << endl;
	//enc
	ttrace("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~enc\n");
	auto ctext = rsaenc(pem, plain, 48);
	for(auto a: ctext)
		printf("%02x ", a);
	printf("\n<--size %d\n", ctext.size());

	//dec
	ttrace("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~dec\n");
	auto ptext = rsadec(key, &ctext[0], ctext.size());
	std::string tmp(ptext.begin(), ptext.end());
	std::cout << tmp << std::endl;

	//der
	ttrace("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~der\n");
	auto dkey = getDerKey(key);
	for(auto a:dkey)
		printf("%02x ", a);
	printf("\n<--size %d\n", dkey.size());

	//der - enc
	ttrace("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~der - enc, ksz %d\n", dkey.size());
	ctext = rsaenc(dkey, plain, 48);
	for(auto a: ctext)
		printf("%02x ", a);
	printf("\n<--size %d\n", ctext.size());

	//der - dec
	ttrace("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~der - dec\n");
	ptext = rsadec(key, &ctext[0], ctext.size());
	std::string ttt(ptext.begin(), ptext.end());
	std::cout << ttt << std::endl;

	//clean up
	EVP_PKEY_free(key);

	{
		ustring pubk = {
				0x30,0x82,0x01,0x0a,0x02,0x82,0x01,0x01,0x00,0xc2,0x5e,0x3b,0xa9,0xec,
				0xb7,0xac,0x39,0x9b,0x83,0x6a,0x50,0x1e,0x83,0xcb,0x50,0x93,0xbb,0x0b,0x5f,0x11,
				0x58,0xe6,0xdf,0x73,0x17,0x6c,0xee,0x3d,0xfd,0xa7,0xe0,0x4d,0x9c,0xf2,0xf3,0x8c,
				0x08,0x36,0x8d,0x8f,0x2c,0x99,0x58,0x37,0x02,0xdc,0xd1,0x03,0x9d,0xa7,0x7f,0x4f,
				0xcd,0x3a,0x2a,0x6e,0xf9,0x23,0x6f,0x0d,0x55,0x00,0xbe,0x35,0x93,0x11,0xfd,0x48,
				0x54,0x6a,0x4d,0xf0,0x89,0x53,0xc2,0xac,0x26,0xbb,0xe7,0xe2,0x58,0xa7,0xa4,0xd3,
				0x59,0xfa,0xf0,0x12,0xbe,0x47,0x20,0xb9,0xed,0x20,0xc4,0x83,0x80,0x59,0x2e,0xdb,
				0x29,0xcb,0x48,0x97,0xb9,0x7c,0xbf,0xe7,0xdc,0x99,0xee,0x14,0x22,0xbe,0xc0,0x10,
				0x69,0xd5,0x99,0x93,0x32,0xad,0x4d,0x9c,0xe6,0x98,0x79,0xce,0x34,0x75,0x1e,0x77,
				0x5f,0x05,0x06,0xab,0x59,0xd4,0x86,0x9b,0xc9,0x04,0x67,0xc6,0x5b,0x93,0x6c,0xe8,
				0x5b,0xf1,0x57,0xd1,0x6b,0x16,0xc6,0x2a,0x62,0x34,0xde,0xf7,0x67,0xe6,0xed,0x53,
				0xd1,0xde,0xdc,0xf0,0x3e,0xf3,0x28,0x32,0x5d,0x78,0x81,0xaf,0xa8,0x15,0x50,0x22,
				0x79,0x83,0xdb,0xac,0xd7,0xcd,0xab,0x39,0xb7,0x85,0x21,0x31,0xea,0x2b,0xed,0xaa,
				0xd9,0x4b,0x4e,0xb9,0x5e,0xa2,0xee,0xa2,0x03,0xc0,0x1b,0xfe,0xfd,0x01,0x3c,0x7b,
				0xdf,0xa5,0xab,0xfa,0x36,0x71,0xd1,0xd3,0xe5,0xc1,0x42,0x1c,0xee,0x08,0xbc,0xdc,
				0xcc,0x60,0x47,0xbe,0x92,0x55,0x1d,0xb8,0xc2,0x4b,0xe2,0x25,0x1d,0x0b,0x0b,0x33,
				0x31,0x7b,0x57,0x04,0xf0,0x1f,0xd4,0x76,0x23,0xc6,0x27,0x02,0x03,0x01,0x00,0x01
		};
		ttrace("~~한나꺼 테스트. sz %d\n", pubk.size());

		auto ctext = rsaenc(dkey, plain, 48);
		for(auto a: ctext)
			printf("%02x ", a);
		printf("\n<--size %d\n", ctext.size());
	}

	return 0;
}
