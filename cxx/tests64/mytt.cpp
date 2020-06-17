#include <stdio.h>
#include <vector>

#define RptOne0(X)
#define RptOne1(X) X
#define RptOne2(X) X, X+1
#define RptOne3(X) X, X+1, X+2
#define RptOne4(X) X, X+1, X+2, X+3
#define RptOne5(X) X, X+1, X+2, X+3, X+4
#define RptOne6(X) X, X+1, X+2, X+3, X+4, X+5
#define RptOne7(X) X, X+1, X+2, X+3, X+4, X+5, X+6
#define RptOne8(X) X, X+1, X+2, X+3, X+4, X+5, X+6, X+7
#define RptOne9(X) X, X+1, X+2, X+3, X+4, X+5, X+6, X+7, X+8
#define RptOne10(X) X, X+1, X+2, X+3, X+4, X+5, X+6, X+7, X+8, X+9

#define RptTen0(X)
#define RptTen1(X) RptOne10(X)
#define RptTen2(X) RptOne10(X), RptOne10(X+10)
#define RptTen3(X) RptOne10(X), RptOne10(X+10), RptOne10(X+20)

#define Rpt(TENS,ONES,X) RptTen##TENS(X), RptOne##ONES(X+TENS##0)
#define Rpt0(ONES,X) RptOne##ONES(X)

using namespace std;
vector<int> chlist = {
		Rpt(2,6,1)
};

union DigitalParam {
	unsigned char val;
	struct digital_st {
		char resolution:	4;
		char format:		2;
		char type:			2;
	} bt;
};

int main(void)
{
	int i = 0;
	for(auto a:chlist)
		printf("%d, ", a); printf("\n");

	DigitalParam p = {16};
	printf("res %d, format %d, type %d\n", p.bt.resolution, p.bt.format, p.bt.type);

	return 0;
}
