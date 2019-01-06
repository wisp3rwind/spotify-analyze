CC=gcc
CFLAGS=-Wall -Wextra -Wmissing-declarations

UNAME_S:=$(shell uname -s)
ifeq ($(UNAME_S),Linux)
	CFLAGS += -fPIC -shared
endif
ifeq ($(UNAME_S),Darwin)
	CFLAGS += -dynamiclib
endif

DYLIB=curl_patch.dylib
INPUT=curl_patch.c

curl_patch: curl_patch.c
	$(CC) $(CFLAGS) -o $(DYLIB) $(INPUT)

.PHONY: clean

clean:
	rm -f $(DYLIB)
