﻿/*
* Copyright (c) 1995, 1996, 1997 Kungliga Tekniska Högskolan
* (Royal Institute of Technology, Stockholm, Sweden).
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions
* are met:
*
* 1. Redistributions of source code must retain the above copyright
*    notice, this list of conditions and the following disclaimer.
*
* 2. Redistributions in binary form must reproduce the above copyright
*    notice, this list of conditions and the following disclaimer in the
*    documentation and/or other materials provided with the distribution.
*
* 3. Neither the name of the Institute nor the names of its contributors
*    may be used to endorse or promote products derived from this software
*    without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE INSTITUTE AND CONTRIBUTORS ``AS IS'' AND
* ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
* ARE DISCLAIMED.  IN NO EVENT SHALL THE INSTITUTE OR CONTRIBUTORS BE LIABLE
* FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
* DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
* OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
* HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
* LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
* OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
* SUCH DAMAGE.
*/

#include <errno.h>
#include <cstring>
#include <Windows.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <io.h>
#include <atlbase.h>
#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif
#ifdef HAVE_FCNTL_H
#include <fcntl.h>
#endif

#ifndef HAVE_MKSTEMP

int mkstemp(char *tmp)
{
	int start, i;
	int val;
	val = getpid();
	start = strlen(tmp) - 1;
	while (tmp[start] == 'X') {
		tmp[start] = '0' + val % 10;
		val /= 10;
		start--;
	}

	do {
		int fd;
		CA2WEX<256> wtmp(tmp, CP_UTF8);
		fd = _wopen(wtmp, O_RDWR | O_CREAT | O_EXCL, 0600);
		if (fd >= 0 || errno != EEXIST)
			return fd;
		i = start + 1;
		do {
			if (tmp[i] == 0)
				return -1;
			tmp[i]++;
			if (tmp[i] == '9' + 1)
				tmp[i] = 'a';
			if (tmp[i] <= 'z')
				break;
			tmp[i] = 'a';
			i++;
		} while (1);
	} while (1);
}

#endif