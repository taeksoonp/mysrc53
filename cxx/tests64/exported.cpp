#include <string>
#include <iostream>
#include <boost/property_tree/ptree.hpp>
#include <boost/property_tree/ini_parser.hpp>
#include <boost/algorithm/string.hpp>
#include "tta_util.h"

namespace pt = boost::property_tree;
using namespace std;

#define ttrace(...) do {\
	fprintf(stderr, "%s:%d>>> ",strrchr(__FILE__,'/')? strrchr(__FILE__,'/')+1:__FILE__,__LINE__);\
	fprintf(stderr,__VA_ARGS__);}while(0)

int main(int argc, char** argv)
{
	using namespace std;

	if (argc < 2)
	{
		printf("Usage: exported <filename> [passphrase]\n");
		return 0;
	}

	bool dec = false;
	string arg1 = argv[1];
	string pp("11111");
	if (argc > 2)
		pp = argv[2];

	{
		pt::ptree tree;
		pt::read_ini(arg1, tree);
		typedef vector<string> split_vector_type;
		split_vector_type sns;

		try
		{
			using namespace boost;

			auto salt = tree.get<string>("General.salt");
			salt.erase(remove(salt.begin(), salt.end(), '"'), salt.end());

			split(sns, salt, is_any_of(","), token_compress_on);
			for(auto &a:sns)
			{
				trim_if(a, is_any_of(" \""));
				cout << a << endl;
			}
		}
		catch(const pt::ptree_error &e)
		{
			cout << e.what() << endl;
		}

		/*
		 * key 만들기
		 */
		auto saltv = tta::fromBase64(sns.at(0));
		tta::salt_t salt;
		memcpy(salt.salt, &saltv[0], sizeof salt.salt);

		auto stamp = sns.at(1);
		auto keyv = tta::getKey(pp.c_str(), salt);
		if (keyv.size() < tta::kni_len)
		{
			printf("keyv sz %d?", keyv.size());
			return 0;
		}

		auto key64 = tta::toHash64(&keyv[0], keyv.size());
		if (stamp == key64)
		{
			printf("암호 통과했다\n");
			cout << "keyv64: " << tta::toBase64(&keyv[0], keyv.size()) << endl;
			for(int i=0; i<keyv.size(); i++)
			{
				if (i == tta::key_len)
					printf("\n");
				printf("%02x", keyv[i]);
			}
			printf("\n\n");
		}
		else
		{
			printf("암호 틀리다\n");
			return 0;
		}

		tta::dvrkey_t key;
		memcpy(key.key, &keyv[0], sizeof key.key);
		printf("keyv sz %d, sizeof key.key %d\n", keyv.size(), sizeof key.key);
#if 1
		vector<const char*> passwords = {
				"General.user_ttapassword",
				"General.camera_ttapassword",
				"General.ddns_wns_password",
				"General.ddns_custom_pass",
				"General.xdsl_password",
				"General.event_email_userpass",
				"General.event_ftp_password",
		};
		for(auto var:passwords)
		{
			cout << var << ":\n";
			try
			{
				auto a = tree.get<string>(var);

				a.erase(remove(a.begin(), a.end(), '"'), a.end());
				cout << a << endl;
				cout << tta::fromAes64(a, key) << endl;
			}
			catch(const pt::ptree_error &e)
			{
				cout << e.what() << endl;
			}
			cout <<endl;
		}//for
#endif
		/*
		 * test
		 */
		const char* test1 = "12345,11111,22222,33333,44444,55555,66666,77777,88888,99999,00000";
		const char* test2 = "12345,12345,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,";

		cout << "test camera_ttapasswd:\n";
		cout << test2 << endl;
		auto camaes64 = tta::toAes64(test2, key);
		cout << camaes64 << endl;
	}

	return 0;
}
