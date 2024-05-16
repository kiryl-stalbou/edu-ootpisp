#include <stdio.h>

extern "C"
{
    void write(const char *string)
    {
        FILE *file = fopen("lib/ffi_out.txt", "w+");

        fprintf(file, "%s\n", string);

        fclose(file);
    }
}