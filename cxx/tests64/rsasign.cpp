/* rsa-sign+verify.c */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <openssl/sha.h>
#include <openssl/rsa.h>
#include <openssl/objects.h>  // for NID_sha1.

#define eprintf(...) fprintf(stderr, __VA_ARGS__)

int RSA_genkey(RSA **rsaKey, int bits)
{
	BIGNUM *bne=NULL;

	bne=BN_new();
	if(BN_set_word(bne, RSA_F4)!=1)
		return 0;

	*rsaKey=RSA_new();
	if(RSA_generate_key_ex(*rsaKey, bits, bne, NULL)!=1)
	{
		BN_free(bne);
		return 0;
	}

	return 1;
}

int RSA_sign_sha1(unsigned char *m, unsigned int mlen, unsigned char *sigout, unsigned int *siglen, RSA *rsaKey)
{
	unsigned char hash[SHA_DIGEST_LENGTH];

	if(!SHA1(m, mlen, hash))
		return 0;

	return RSA_sign(NID_sha1, hash, SHA_DIGEST_LENGTH, sigout, siglen, rsaKey);
}

int RSA_verify_sha1(unsigned char *m, unsigned int mlen, unsigned char *sig, unsigned int siglen, RSA *rsaKey)
{
	unsigned char hash[SHA_DIGEST_LENGTH];
	BN_CTX *c;
	int ret;

	if(!(c=BN_CTX_new()))
		return 0;

	// RSA_bliding_on() function is used for protect a timing attack.
	// refer RSA_blinding_on() man page.
	if(!SHA1(m, mlen, hash) || !RSA_blinding_on(rsaKey, c))
	{
		BN_CTX_free(c);
		return 0;
	}

	// compare calculated hash value with input sig value.
	ret=RSA_verify(NID_sha1, hash, SHA_DIGEST_LENGTH, sig, siglen, rsaKey);

	RSA_blinding_off(rsaKey);
	BN_CTX_free(c);

	return ret;
}

int main()
{
	RSA *rsa;
	BIGNUM *bne;
	char msg[]="This is RSA signature example.";
	unsigned char *sign; // SHA1 output length is 160bits, but RSA sign output is 256 bytes if RSA size is 2048 bits.
	unsigned int signLen;

	if(!RSA_genkey(&rsa, 2048))
	{
		eprintf("RSA_genkey() error.\n");
		exit(1);
	}

	signLen=RSA_size(rsa);
	sign = (unsigned char*)malloc(signLen);
	memset(sign, 0, signLen);

	RSA_sign_sha1((unsigned char*)msg, sizeof(msg), sign, &signLen, rsa);

	// sign[signLen-5]=0xF2;	// modify intentionally.

	if(RSA_verify_sha1((unsigned char*)msg, sizeof(msg), sign, signLen, rsa)==1)
		printf("OK. Verified.\n");
	else
		printf("Wrong. Invaild sign.\n");

	return 0;
}
