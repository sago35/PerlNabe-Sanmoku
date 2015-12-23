#include <stdio.h>
#include <stdlib.h>

int
main(int argc, char *argv[])
{
    int i;

    for (i = 0; i < 9; i++)
    {
        if (atoi(argv[i+1]) == 0)
        {
            printf("%d\n", i);
            return 0;
        }
    }

    return 1;
}
