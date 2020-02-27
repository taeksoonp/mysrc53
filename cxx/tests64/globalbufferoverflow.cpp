#include <stdlib.h>
#include <stdio.h>
#include <string.h>

char buffer[16];

int main(int argc, char **argv) {
    if(argc < 2) {
        printf("no parameters specified\n");
        exit(-1);
    }

    // global buffer overflow may occur here
    // if argv[1] has more than 16 symbols
    strcpy(buffer, argv[1]);
}
