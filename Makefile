RELEASE_CFLAGS ?= -O2 -march=native
DEBUG_CFLAGS ?= -Og -g
SHARED_CFLAGS := -Wall -Wextra `pkg-config imlib2 --cflags` -fPIC
LDFLAGS += `pkg-config imlib2 --libs`

.PHONY: clean distclean debug install-debug release install-release install

release: pss.so
debug: pss-dbg.so

pss.so: imlib2-pss.o
	$(CC) -shared -o$@ $^ $(LDFLAGS)

imlib2-pss.o: imlib2-pss.c
	$(CC) -c $(SHARED_CFLAGS) $(RELEASE_CFLAGS) -o$@ $<

install-release: install
install: pss.so
	install -m 644 $< `pkg-config imlib2 --variable=libdir`/imlib2/loaders/

clean:
	$(RM) imlib2-pss.o imlib2-pss-dbg.o

distclean: clean
	$(RM) pss.so pss-dbg.so


pss-dbg.so: imlib2-pss-dbg.o
	$(CC) -shared -o$@ $^ $(LDFLAGS)

imlib2-pss-dbg.o: imlib2-pss.c
	$(CC) -c -DIMLIB2_PSS_DEBUG $(SHARED_CFLAGS) $(DEBUG_CFLAGS) -o$@ $<

install-debug: pss-dbg.so
	install -m 644 $< `pkg-config imlib2 --variable=libdir`/imlib2/loaders/
