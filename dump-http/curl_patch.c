#define _GNU_SOURCE
#include <stdio.h>
#include <dlfcn.h>

/* the kind of data that is passed to information_callback*/
typedef enum {
  CURLINFO_TEXT = 0,
  CURLINFO_HEADER_IN,    /* 1 */
  CURLINFO_HEADER_OUT,   /* 2 */
  CURLINFO_DATA_IN,      /* 3 */
  CURLINFO_DATA_OUT,     /* 4 */
  CURLINFO_SSL_DATA_IN,  /* 5 */
  CURLINFO_SSL_DATA_OUT, /* 6 */
  CURLINFO_END
} curl_infotype;
        
static int custom_curl_debug(const struct CURL *handle, curl_infotype type, char *data, size_t size, void *userp) {
	// TODO: Print to pcap
	return 0;
}

void curl_easy_perform(const struct CURL *curl) {
	static void (*real_perf)(const struct CURL *) = NULL;
    if (!real_perf)
        real_perf = dlsym(RTLD_NEXT, "curl_easy_perform");
        
    static void (*real_setopt)(const struct CURL *, const struct CURLoption *, ...) = NULL;
    if (!real_setopt)
        real_setopt = dlsym(RTLD_NEXT, "curl_easy_setopt");
        
    real_setopt(curl, 41L /* CURLOPT_VERBOSE */, 1L);
    real_setopt(curl, 94L /* CURLOPT_DEBUGFUNCTION */, custom_curl_debug);
        
    return real_perf(curl);
}