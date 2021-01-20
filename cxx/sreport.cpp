//============================================================================
// Name        : screport.cpp
// Author      : 박택순
// Version     :
// Copyright   : Your copyright notice
// Description : Hello World in C, Ansi-style
//============================================================================

#include <stdio.h>
#include <stdlib.h>
#include <iostream>

using namespace std;
int main(int argc, char *argv[]) {

	if (argc >1)
	{
		printf("src change report v1.0\n");
		printf("usage: svn diff [-c M | -r N[:M]] [TARGET[@REV]...] | sreport\n");
		printf(
			"\tDisplay the changes made to TARGETs as they are seen in REV between"
		  	 "two revisions.  TARGETs may be all working copy paths or all URLs."
		     "If TARGETs are working copy paths, N defaults to BASE and M to the"
		     "working copy; if URLs, N must be specified and M defaults to HEAD.\n"
		     "\tThe '-c M' option is equivalent to '-r N:M' where N = M-1."
		     "Using '-c -M' does the reverse: '-r M:N' where N = M-1.\n"
			 "\tA revision argument can be one of:\n"
                "\t NUMBER       revision number\n"
				"\t '{' DATE '}' revision at start of the date\n"
				"\t 'HEAD'       latest in repository\n"
				"\t 'BASE'       base rev of item's working copy\n"
				"\t 'COMMITTED'  last commit at or before BASE\n"
				"\t 'PREV'       revision just before COMMITTED\n"
				);
		return EXIT_SUCCESS;
	}

	string l;
	char fn[1024], line[10240];
	while (!cin.getline(line,sizeof(line)-1).eof()) {
		int left, right;

//		printf("머지? %s\n", l.c_str());

		if (sscanf(line, "+++ %s", fn) >0)
			cout<<fn;
		else if(sscanf(line, "@@ %d,%*d %d,%*d @@", &left, &right) >0) {
			left *= -1;
			if (left <= 1 || right <= 1)
				printf("경고: 이건 직접 봐라.\n");
			left +=3;
			right +=3;
			if (left == right)
				printf("\t%d\n", left);
			else
				printf("\t%d -> %d\n",left,right);
		}
	}

	return EXIT_SUCCESS;
}
