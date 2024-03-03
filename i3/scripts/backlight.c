#include <stdio.h>
#include <stdlib.h>

#include <assert.h>
#include <errno.h>
#include <math.h>
#include <string.h>

typedef unsigned char n8;
typedef signed long int s64;
typedef unsigned long int n64;

#define PATH_LEN 128

#undef stderr
#define stderr tty2
#define stddeb tty2

/* #define stddeb stdout */

FILE *tty2;

char default_path[PATH_LEN] = "/sys/class/backlight/intel_backlight";
char brightness_max_path[PATH_LEN];
char brightness_path[PATH_LEN];

void print_usage(FILE *stream, char *program)
{ /* clang-format off */
	fprintf(stream,
			"Backlight\n"
				"\tChange the brightness of a screen whose\n"
				"\tvalue is contained in `/sys/class/backlight/...`\n"
			"Usage:\n"
				"\t%s [options] command\n"
			"Options:\n"
				"\t-h <path>\tShow usage screen\n"
				"\t-p <path>\tProvide a screen path\n"
			"Commands:\n"
				"\t<br>\t\tPrint current brightness\n"
				"\tmax\t\tPrint max brightness\n"
				"\tset <0-max>\tSet brightness to value\n"
				"\tset max\tSet brightness to max brighness\n"
				"\tinc <0-max>\tIncrement brightness by value\n"
				"\tdec <0-max>\tDecement brightness by value\n", program);
} /* clang-format on */

n64 brightness_get(char *file_path)
{
	FILE *file;

#define BUFF_LEN 8
	char buffer[BUFF_LEN];

	n64 brightness = 0;
	n8 i = 0;
	int c;

	file = fopen(file_path, "r");
	if(file == NULL)
	{
		fprintf(stderr,
				"ERROR:%s:%d: Could not open file `%s` for reading\n%s\n",
				__FILE__,
				__LINE__,
				file_path,
				strerror(errno));
		exit(1);
	}

	while((c = getc(file)) != EOF && i < (BUFF_LEN - 1))
		buffer[i++] = c;

	brightness = strtoul(buffer, NULL, 10);
	if(errno)
	{
		fprintf(stderr,
				"ERROR:%s:%d: Could not convert content of file (`%s`) to "
				"n64\n%s\n",
				__FILE__,
				__LINE__,
				file_path,
				strerror(errno));
		exit(1);
	}

	fclose(file);
	return brightness;
}

void brightness_set(n64 value)
{
	FILE *brightness_file = fopen(brightness_path, "w");
	if(brightness_file == NULL)
	{
		fprintf(stderr,
				"ERROR:%s:%d: Could not open file `%s` for writing\n%s\n",
				__FILE__,
				__LINE__,
				brightness_path,
				strerror(errno));
		exit(1);
	}

	if(fprintf(brightness_file, "%lu", value) < 0)
	{
		fprintf(stderr,
				"ERROR:%s:%d: Could not write to file `%s`\n",
				__FILE__,
				__LINE__,
				brightness_path);
		exit(1);
	}

	fclose(brightness_file);
}
char *shift(int *argc, char ***argv)
{
	if((*argc)--) return *((*argv)++);
	return NULL;
}

n64 token_parse_n64(char *token)
{
	n64 value = 0;
	n8 token_len, i;

	token_len = strlen(token);
	for(i = 0; i < token_len; ++i)
	{
		if(token[i] < '0' || token[i] > '9')
		{
			fprintf(stderr,
					"ERROR:%s:%d: Error parsing token `%*s` to n64\n",
					__FILE__,
					__LINE__,
					token_len,
					token);
			exit(1);
		}

		value += (token[i] - '0') * pow(10, token_len - i - 1);
	}

	fprintf(stddeb,
			"DEBUG: Token (`%*s`) parsed to `%lu`\n",
			token_len,
			token,
			value);
	return value;
}

void flags_parse(char *program, char *token, int *argc, char ***argv)
{
	switch(token[1])
	{
		case 'h':
			print_usage(stdout, program);
			exit(0);
			break;

		case 'p':
			token = shift(argc, argv);
			if(token == NULL)
			{
				fprintf(stderr,
						"ERROR:%s:%d: Missing required argument for `p` flag\n",
						__FILE__,
						__LINE__);
				exit(1);
			}
			strncpy(default_path, token, PATH_LEN);
			break;

		default:
			fprintf(stderr,
					"ERROR:%s:%d: Unknown flag `%s` detected\n",
					__FILE__,
					__LINE__,
					token);
			exit(1);
			break;
	}
}

int main(int argc, char **argv)
{
	char *program = shift(&argc, &argv);
	tty2 = fopen("/dev/pts/2", "w");

	strncpy(brightness_path, default_path, PATH_LEN);
	strncat(brightness_path, "/brightness", PATH_LEN);

	strncpy(brightness_max_path, default_path, PATH_LEN);
	strncat(brightness_max_path, "/max_brightness", PATH_LEN);

	if(argc == 0)
	{
		n64 brightness = brightness_get(brightness_path);
		printf("%lu", brightness);
		exit(0);
	}
	while(argc > 0)
	{
		char *token = shift(&argc, &argv);

		/* Parse flags */
		if(token[0] == '-')
		{
			flags_parse(program, token, &argc, &argv);
			if(argc == 0)
			{
				n64 brightness = brightness_get(brightness_path);
				printf("%lu", brightness);
				exit(0);
			}
		}
		else if(strncmp(token, "max", PATH_LEN) == 0)
		{
			n64 max_brightness = brightness_get(brightness_max_path);
			printf("%lu", max_brightness);
			exit(0);
		}
		else if(strncmp(token, "set", PATH_LEN) == 0)
		{
			n64 max_brightness, value = 0;

			token = shift(&argc, &argv);
			if(token == NULL)
			{
				fprintf(stderr,
						"ERROR:%s:%d: Missing required argument for `set` "
						"command\n",
						__FILE__,
						__LINE__);
				exit(1);
			}

			max_brightness = brightness_get(brightness_max_path);
			fprintf(stddeb, "DEBUG: Max brightness is %lu\n", max_brightness);

			if(strncmp(token, "max", 3) == 0 && strlen(token) == 3)
				value = max_brightness;
			else
				value = token_parse_n64(token);

			if(value < 0 || value > max_brightness)
			{
				fprintf(stderr,
						"ERROR:%s:%d: Argument `%lu` out of bounds (0, %lu)\n",
						__FILE__,
						__LINE__,
						value,
						max_brightness);
				exit(1);
			}

			brightness_set(value);
			fprintf(stddeb, "DEBUG: Current brightness is %lu\n", value);
			exit(0);
		}
		else if(strncmp(token, "inc", PATH_LEN) == 0)
		{
			n64 max_brightness, brightness, value = 0;

			token = shift(&argc, &argv);
			if(token == NULL)
			{
				fprintf(stderr,
						"ERROR:%s:%d: Missing required argument for `set` "
						"command\n",
						__FILE__,
						__LINE__);
				exit(1);
			}
			value = token_parse_n64(token);

			max_brightness = brightness_get(brightness_max_path);
			brightness = brightness_get(brightness_path);
			fprintf(stddeb, "DEBUG: Max brightness is %lu\n", max_brightness);
			fprintf(stddeb, "DEBUG: Current brightness is %lu\n", brightness);

			if(value < 0 || value > max_brightness)
			{
				fprintf(stderr,
						"ERROR:%s:%d: Argument `%lu` out of bounds (0, %lu)\n",
						__FILE__,
						__LINE__,
						value,
						max_brightness);
				exit(1);
			}

			brightness += value;
			if(brightness > max_brightness) brightness = max_brightness;

			brightness_set(brightness);
			fprintf(stddeb, "DEBUG: Current brightness is %lu\n", brightness);
			exit(0);
		}
		else if(strncmp(token, "dec", PATH_LEN) == 0)
		{
			n64 max_brightness, brightness, value = 0;

			token = shift(&argc, &argv);
			if(token == NULL)
			{
				fprintf(stderr,
						"ERROR:%s:%d: Missing required argument for `set` "
						"command\n",
						__FILE__,
						__LINE__);
				exit(1);
			}
			value = token_parse_n64(token);

			max_brightness = brightness_get(brightness_max_path);
			brightness = brightness_get(brightness_path);
			fprintf(stddeb, "DEBUG: Max brightness is %lu\n", max_brightness);
			fprintf(stddeb, "DEBUG: Current brightness is %lu\n", brightness);

			if(value < 0 || value > max_brightness)
			{
				fprintf(stderr,
						"ERROR:%s:%d: Argument `%lu` out of bounds (0, %lu)\n",
						__FILE__,
						__LINE__,
						value,
						max_brightness);
				exit(1);
			}

			if(brightness < value)
				brightness = 0;
			else
				brightness -= value;

			brightness_set(brightness);
			fprintf(stddeb, "DEBUG: Current brightness is %ld\n", brightness);
			exit(0);
		}
		else
		{
			fprintf(stderr,
					"ERROR:%s:%d: Unknown command `%s`\n",
					__FILE__,
					__LINE__,
					token);
			exit(1);
		}
	}

	return 0;
}
