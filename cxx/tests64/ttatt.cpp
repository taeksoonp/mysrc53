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
	ttrace("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~der - enc\n");
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

	return 0;
}
