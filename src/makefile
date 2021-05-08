CPPS:=$(wildcard *.cpp)
OBJS:=$(patsubst %.cpp, %.o, ${CPPS})
HS:=$(wildcard *.h)
FCGILIBS:=-lfastcgipp
CXXFLAGS=-g -O0 -std=c++20 -DDEBUG
EC:=$(shell pkg-config --libs libsecp256k1)
LIBCRYPTO:=$(shell pkg-config --libs libcrypto++)
#NC:=`pkg-config --libs ncurses`
INC:=-I../..
USGOV:=usgov
LIBUSGOV:=libusgov
USWALLET:=uswallet
LIBUSWALLET:=libuswallet
LIBS:=-L../gov -L../wallet -l${USGOV} -l${USWALLET}
ARCH:=$(shell uname -m)
ifeq ($(ARCH),armv7l)
LIBS+=-latomic
endif

USHWALLET:=us-wallet

.PHONY: all
all: ${USHWALLET}

${USHWALLET}: ${OBJS}
#ifeq ($(WASM),1)
#	em++ ${CXXFLAGS} ${OBJS} -L../gov -L../wallet ${LIBS} ${EC} ${NC} ${LIBCRYPTO} -I../.. -pthread -lstdc++fs -o ${USHWALLET}_wasm
#else
#	g++ ${CXXFLAGS} ${OBJS} -L../gov -L../wallet ${LIBS} ${EC} ${NC} ${LIBCRYPTO} -Wl,-rpath,../wallet -Wl,-rpath,../gov -I../.. -pthread -lstdc++fs -o ${USHWALLET}
	g++ ${CXXFLAGS} ${OBJS} ${LIBS} ${EC} ${LIBCRYPTO} -Wl,-rpath,../wallet -Wl,-rpath,../gov -I../.. -pthread -lstdc++fs -o ${USHWALLET}
#endif

%.o: %.cpp
	g++ -fPIC -c ${CXXFLAGS} ${INC} $^ -o $@

clean:
	rm -f ${USHWALLET}
	rm -f *.o
