
#include <stdint.h>

#if defined(__BYTE_ORDER__) && defined(__ORDER_LITTLE_ENDIAN__) && \
	__BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
#  define _le64toh(x) ((uint64_t)(x))
#elif defined(_WIN32)
/* Windows is always little endian, unless you're on xbox360
   http://msdn.microsoft.com/en-us/library/b0084kay(v=vs.80).aspx */
#  define _le64toh(x) ((uint64_t)(x))
#elif defined(__APPLE__)
#  include <libkern/OSByteOrder.h>
#  define _le64toh(x) OSSwapLittleToHostInt64(x)
#else

/* See: http://sourceforge.net/p/predef/wiki/Endianness/ */
#  if defined(__FreeBSD__) || defined(__NetBSD__) || defined(__OpenBSD__)
#    include <sys/endian.h>
#  else
#    include <endian.h>
#  endif
#  if defined(__BYTE_ORDER) && defined(__LITTLE_ENDIAN) && \
	__BYTE_ORDER == __LITTLE_ENDIAN
#    define _le64toh(x) ((uint64_t)(x))
#  else
#    define _le64toh(x) le64toh(x)
#  endif

#endif

#define ROTATE(x, b) (uint64_t)( ((x) << (b)) | ( (x) >> (64 - (b))) )

#define HALF_ROUND(a,b,c,d,s,t)			\
	a += b; c += d;				\
	b = ROTATE(b, s) ^ a;			\
	d = ROTATE(d, t) ^ c;			\
	a = ROTATE(a, 32);

#define DOUBLE_ROUND(v0,v1,v2,v3)		\
	HALF_ROUND(v0,v1,v2,v3,13,16);		\
	HALF_ROUND(v2,v1,v0,v3,17,21);		\
	HALF_ROUND(v0,v1,v2,v3,13,16);		\
	HALF_ROUND(v2,v1,v0,v3,17,21);

#define _SIPCONST1 0x736f6d6570736575ULL
#define _SIPCONST2 0x646f72616e646f6dULL
#define _SIPCONST3 0x6c7967656e657261ULL
#define _SIPCONST4 0x7465646279746573ULL

