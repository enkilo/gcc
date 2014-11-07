/*  DO NOT EDIT THIS FILE.

    It has been auto-edited by fixincludes from:

	"fixinc/tests/inc/stdio.h"

    This had to be done to correct non-standard usages in the
    original, manufacturer supplied header file.  */

#ifndef FIXINC_WRAP_STDIO_H_STDIO_STDARG_H
#define FIXINC_WRAP_STDIO_H_STDIO_STDARG_H 1

#define __need___va_list
#include <stdarg.h>


#if defined( ALPHA_GETOPT_CHECK )
extern int getopt(int, char *const[], const char *);
#endif  /* ALPHA_GETOPT_CHECK */


#if defined( BSD_STDIO_ATTRS_CONFLICT_CHECK )
#define _BSD_STRING(_BSD_X) _BSD_STRINGX(_BSD_X)
#define _BSD_STRINGX(_BSD_X) #_BSD_X
int vfscanf(FILE *, const char *, __builtin_va_list) __asm__ (_BSD_STRING(__USER_LABEL_PREFIX__) "__svfscanf");
#endif  /* BSD_STDIO_ATTRS_CONFLICT_CHECK */


#if defined( READ_RET_TYPE_CHECK )
extern unsigned int fread(), fwrite();
extern int	fclose(), fflush(), foo();
#endif  /* READ_RET_TYPE_CHECK */



#if defined( STDIO_STDARG_H_CHECK )

#endif  /* STDIO_STDARG_H_CHECK */


#if defined( STDIO_DUMMY_VA_LIST_CHECK )
extern void mumble( __gnuc_va_list);
#endif  /* STDIO_DUMMY_VA_LIST_CHECK */

#endif  /* FIXINC_WRAP_STDIO_H_STDIO_STDARG_H */
