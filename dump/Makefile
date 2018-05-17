CC=gcc
CFLAGS=-Wall -Wextra -Wmissing-declarations

UNAME_S:=$(shell uname -s)
ifeq ($(UNAME_S),Linux)
	CFLAGS += -fPIC -shared
endif
ifeq ($(UNAME_S),Darwin)
	CFLAGS += -dynamiclib
endif

TARGET=dump.dylib
HEADERS=shn.h pcap.h
OBJECTS=dump.o shn.o pcap.o

$(TARGET): $(OBJECTS)
	$(CC) $(CFLAGS) -ldl -o $@ $^

%.o: %.c $(HEADERS) 
	$(CC) $(CFLAGS) -c -o $@ $<

.PHONY: clean

clean:
	rm -f $(TARGET) $(OBJECTS)
