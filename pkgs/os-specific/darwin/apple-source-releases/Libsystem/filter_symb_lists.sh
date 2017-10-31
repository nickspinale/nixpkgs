#!/bin/sh

tmp=$(mktemp)

go() {
	grep -xF "$(nm -jgU -arch $1 $2)" $3 > $tmp
	mv $tmp $3
}

go x86_64 /usr/lib/system/libsystem_c.dylib system_c_symbols_x86_64
go i386 /usr/lib/system/libsystem_c.dylib system_c_symbols_i386
go x86_64 /usr/lib/system/libsystem_kernel.dylib system_kernel_symbols_x86_64
go i386 /usr/lib/system/libsystem_kernel.dylib system_kernel_symbols_i386
