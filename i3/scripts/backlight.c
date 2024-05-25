#include <stdio.h>
#include <stdlib.h>
/* /sys/class/backlight/intel_backlight/ */
/* /sys/class/backlight/intel_backlight/max_brightness */
/* /sys/class/backlight/intel_backlight/brightness */

/* Usage */
void print_usage(FILE *stream, char *program)
{
	/* backlight -p <path>    Provide screen path            */
	/*           <br>  	      Print current brightness       */
	/*           set <0-100>  Set brightness to value        */
	/*           inc <0-20>   Increment brightness by value  */
	/*           dec <0-20>   Decement brightness by value   */
	/* clang-format off */
	fprintf(stream,
			"Usage:\n"
				"\t%s [flags] command\n"
			"Flags:\n"
				"\t-p <path>\tProvide a screen path\n"
			"Commands:\n"
				"\t<br>\t\tPrint default screen current brightness\n"
				"\tset <0-100>\tSet brightness to value\n"
				"\tinc <0-20>\tIncrement brightness by value\n"
				"\tdec <0-20>\tDecement brightness by value\n"
			"\n", program);
	/* clang-format on */
}

/* char* shift(int argc, char* argv[]) { */

/* } */

typedef unsigned char n8;

int main(int argc, char *argv[])
{
	/* char* program = argv[0]; */
	n8 i;
	FILE *tty1 = fopen("/dev/pts/1", "w");

	/* Read number of arguments */
	/* if 1 --> print default screen value */
	if(argc == 1)
	{
	}
	else if((argc - 1) % 2 == 0)
	{
	}
	else
	{
		print_usage(stdout, argv[0]);
		exit(1);
	}
	/* if > 3 --> read command and parse flags */

	/* DEBUG */
	printf("Hello, World!\n");

	fprintf(tty1, "\n");
	for(i = 0; i < argc; ++i)
	{
		fprintf(tty1, "%s\n", argv[i]);
	}
	fclose(tty1);

	return 0;
}
