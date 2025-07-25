# st - simple terminal
# See LICENSE file for copyright and license details.
.POSIX:

include config.mk

SRC = src/st.c src/x.c
OBJ = obj/st.o obj/x.o
HEADERS = src/config.h src/st.h src/win.h

all: st

config.h:
	cp src/config.def.h src/config.h

obj/%.o: src/%.c
	$(CC) $(STCFLAGS) -o $@ -c $<

obj/st.o: $(HEADERS)
obj/x.o: src/arg.h $(HEADERS)

$(OBJ): src/config.h config.mk

st: $(OBJ)
	$(CC) -o $@ $(OBJ) $(STLDFLAGS)

clean:
	rm -f st $(OBJ) st-$(VERSION).tar.gz

dist: clean
	mkdir -p st-$(VERSION)
	cp -R FAQ LEGACY TODO LICENSE Makefile README config.mk\
		config.def.h st.info st.1 arg.h st.h win.h $(SRC)\
		st-$(VERSION)
	tar -cf - st-$(VERSION) | gzip > st-$(VERSION).tar.gz
	rm -rf st-$(VERSION)

install: st
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f st $(DESTDIR)$(PREFIX)/bin
	chmod 755 $(DESTDIR)$(PREFIX)/bin/st
	mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	sed "s/VERSION/$(VERSION)/g" < st.1 > $(DESTDIR)$(MANPREFIX)/man1/st.1
	chmod 644 $(DESTDIR)$(MANPREFIX)/man1/st.1
	tic -sx st.info
	@echo Please see the README file regarding the terminfo entry of st.

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/st
	rm -f $(DESTDIR)$(MANPREFIX)/man1/st.1

.PHONY: all clean dist install uninstall
