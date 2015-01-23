//============================================================================
// Name        : eemacs.cpp
// Author      : Taeksoon Park
// Version     : 1.0
// Copyright   : Taeksoon Park ts.p@webgateinc.com all rights reserved.
// Description : 내pc로 emacsclient가 접속하게 해주는 거임.
//
// emacs option에 File Coding System Alist에 svn-commit\. ~> utf-8 추가해라.
//============================================================================

#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <string.h>

using namespace std;
const char *dftserver = "~/etc/server/server";
const char *home = "/home/ts.p";

int main(int argc, char** argv) {
	if (argc<2)
	{
		cout << "emacsclient for pts v1.0\n";
		cout << "default server file path is '" << dftserver << "'.\n";
		cout << "Usage: " << argv[0] << " <filename>\n";

		return 0;
	}

	char *arg1 = argv[1];
	char *a[argc];
	a[0] = argv[0];
	a[2] = 0;
	if (arg1 == strstr(arg1, "~/" ))
	{
		string a1 = arg1;
		a1.replace(0, strlen("~/"), "n:/");
		a[1] = strdup(a1.c_str());
	}

	else if (arg1 == strstr(arg1, home))
	{
		string a1 = arg1;
		a1.replace(0, strlen(home), "n:/");
		a[1] = strdup(a1.c_str());
	}

	else if (arg1[0] == '/')
	{
		if ( execvp("emacs",argv) <0)
			perror("eemacs failure:");
		exit(0);
	}

	else	//relative path.
	{
		string a1 = getenv("PWD");
		a1 += string("/") + arg1;

		a1.replace(0, strlen(home), "n:/");
		a[1] = strdup(a1.c_str());
	}

	if (execvp("emacsclient",a)<0)
		perror("eemacs failure:");

	return EXIT_SUCCESS;
}
