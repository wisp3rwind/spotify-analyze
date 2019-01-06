#define _GNU_SOURCE
#include <stdio.h>
#include <dlfcn.h>

void curl_easy_perform(const struct CURL *curl) {
	static void (*real_perf)(const struct CURL *) = NULL;
    if (!real_perf)
        real_perf = dlsym(RTLD_NEXT, "curl_easy_perform");
        
    static void (*real_setopt)(const struct CURL *, const struct CURLoption *, ...) = NULL;
    if (!real_setopt)
        real_setopt = dlsym(RTLD_NEXT, "curl_easy_setopt");
        
    real_setopt(curl, 41L /* CURLOPT_VERBOSE */, 1L);
        
    return real_perf(curl);
}
