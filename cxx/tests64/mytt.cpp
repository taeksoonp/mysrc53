#include <stdio.h>
#include <string.h>
#include <openssl/evp.h>
#include <string>
#include <iostream>

std::string openssl_version(unsigned vno)
{
	//MNNFFPPS
	unsigned char major, minor, fix, patch, status;

	major = vno >> (8*3 + 4);
	minor = vno >> (8*2 + 4);
	fix = vno >> (8 + 4);
	patch = vno >> 4;

	char buff[100];

	std::string p;
	if (patch)
		p = '`' + patch;

	snprintf(buff, sizeof buff, "%u.%u.%u%s", major, minor, fix, p.c_str());
	buff[sizeof buff - 1] = 0;

	return std::string(buff);
}

int main()
{
	unsigned vno = SSLeay();
	auto vstr = openssl_version(vno);

	printf("openssl_version_number %x\n", vno);
	std::cout << vstr << std::endl;

	auto ul = std::stoul("123");
	printf("ul %u, sizeof ul %d\n", ul, sizeof ul);

	char prog[] = "A";
	prog[0] += 4;

	printf("자 A는 이제 %s\n", prog);

	unsigned char type = 0;
	const char *val = type == 0? "Ethernet":"xDSL";

	printf("type: '%s'임\n", val);
	return (0);
}
