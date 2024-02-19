# Copyright (c) 2006-2024, Intel Corporation
# All rights reserved.

# -*- mode: Makefile; -*-

#
# tboot-specific build settings
#
RELEASEVER  := "0.00.1"
RELEASETIME := "2024-03-01 16:30 +0100"
ROOTDIR ?= $(CURDIR)/..

# tboot needs too many customized compiler settings to use system CFLAGS,
# so if environment wants to set any compiler flags, it must use TBOOT_CFLAGS
CFLAGS		:= $(TBOOT_CFLAGS)

include $(ROOTDIR)/Config.mk

# tboot target arch is 64b
CFLAGS		+= -march=x86-64
CFLAGS		+= -nostdinc
CFLAGS		+= -fno-builtin -fno-common -fno-strict-aliasing
CFLAGS		+= -fomit-frame-pointer
CFLAGS		+= -pipe
CFLAGS		+= -iwithprefix include
CFLAGS		+= -I$(CURDIR)/include -I$(ROOTDIR)/include
# ensure no floating-point variables
CFLAGS		+= -msoft-float
# Disable PIE/SSP if GCC supports them. They can break us.
CFLAGS		+= $(call cc-option,$(CC),-nopie,)
CFLAGS		+= $(call cc-option,$(CC),-fno-stack-protector,)
CFLAGS		+= $(call cc-option,$(CC),-fno-stack-protector-all,)
CFLAGS		+= $(call cc-option,$(CC),-fno-stack-check,)

# changeset variable for banner
CFLAGS		+= -DTBOOT_CHANGESET=\""$(shell (hg parents --template "{latesttag} {date|isodate} {rev}:{node|short}" || echo "$(RELEASETIME) $(RELEASEVER)") 2>/dev/null)"\"

# flags for OpenSSL
CFLAGS		+= -DPOLY1305_ASM -DOPENSSL_IA32_SSE2

AFLAGS		+= -D__ASSEMBLY__

# Most CFLAGS are safe for assembly files:
#  -std=gnu{89,99} gets confused by #-prefixed end-of-line comments
AFLAGS		+= $(patsubst -std=gnu%,,$(CFLAGS))


# LDFLAGS are only passed directly to $(LD)
LDFLAGS		= -melf_i386
