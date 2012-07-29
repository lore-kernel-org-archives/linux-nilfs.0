From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH 2/2] nilfs-utils: add skeleton of fsck.nilfs2 is able to
 check signature magic in superblock only
Date: Sun, 29 Jul 2012 18:30:01 +0900
Message-ID: <CAKFNMokKF0WayYq0SuMJJxdCPUmhNVCLcsVaaGgGJc06US_K5A@mail.gmail.com>
References: <B924B05D-DB39-42F2-B8E3-9411C4A330C1@dubeyko.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        bh=CkltxYP6D0cCRNXnHFM9Dc+NNDHwhEudOJlJzGDhc+4=;
        b=FBaqGsJ5jz+LweV9PTQBRI+CWkqoYAWiiuMQtBi6IQSIibfX80Yx2RU/vQLiVbgTjA
         pXZiawAB1foC86l2o7YObMGgBQxyGSG93ct1smL+y+t/OV0mOMudl9BfK2V7vhVAX3Rm
         T0VXQQ9BprmJWat3PJ0UJbKVCXPcVPbumn5cTtAjX8qPDSAkvlod0G4FDWkfhePU+L0C
         15dRLS73aVdbqepiRu2mkrZENNal4Gyv3fjmUXEEHrO/zIkt5VNGazBxV66LIIKV7D8e
         GBBhfRq5842WeDCS4w2ft8HnoS6opbHRh7XjloKWgegKU9ka5hwp13Q72RjkaPsggJ3E
         4CgA==
In-Reply-To: <B924B05D-DB39-42F2-B8E3-9411C4A330C1-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi
2012/7/23 Vyacheslav Dubeyko wrote:
> Hi,
>
> This patch adds functionality of fsck.nilfs2 skeleton that is capable to check signature magic in superblock only.
>
> With the best regards,
> Vyacheslav Dubeyko.
> --
> From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> Subject: [PATCH 2/2] nilfs-utils: add skeleton of fsck.nilfs2 is able to check signature magic in superblock only
>
> This patch adds functionality of fsck.nilfs2 skeleton that is capable to check signature magic in superblock only.
>
> Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>

First, try to fix coding style issues with checkpatch.pl script.
Although this is not a kernel code, it's helpful for related developers
if the source code fit the common coding style rules in some degree.
 (See <linux>/Documentation/CodingStyle  for details)

You can check it easily as follows:

$ cd nilfs-utils/sbin/fsck/
$ <path-to-linux-kernel-source-code>/scripts/checkpatch.pl --file *.c *.h

Note that you don't have to adhere to eliminate its errors/warnings
(ignore unreasonable warnings in case-by-case basis).


Second, try to reuse common routines like nilfs_sb_read() in lib/sb.c
instead of writing new read super block routines.

If routines in lib/sb.c are not sufficient, consider adding extended routines
as a separate patch.

For instance, you can define new nilfs_sb_read_xxxx() which will also return the
reason why super block read was failed.

Sharing common read/write routines for superblocks, segments,
metadata, btrees, etc, is important.

Since nilfs is a complex file system, it will become unmaintainable in a future
if each tools has similar I/O routines separately.

I will add other comments in line.

> ---
>  sbin/fsck/Makefile.am        |   13 ++
>  sbin/fsck/fsck_messages.c    |  254 ++++++++++++++++++++++++
>  sbin/fsck/fsck_messages.def  |   62 ++++++
>  sbin/fsck/fsck_messages.h    |  110 +++++++++++
>  sbin/fsck/fsck_nilfs2.c      |  379 +++++++++++++++++++++++++++++++++++
>  sbin/fsck/fsck_nilfs2.h      |   37 ++++
>  sbin/fsck/fsck_raw_ops.c     |  413 +++++++++++++++++++++++++++++++++++++++
>  sbin/fsck/fsck_raw_ops.h     |   46 +++++
>  sbin/fsck/nilfs_superblock.c |  445 ++++++++++++++++++++++++++++++++++++++++++
>  sbin/fsck/nilfs_superblock.h |   48 +++++
>  10 files changed, 1807 insertions(+), 0 deletions(-)
>
> diff --git a/sbin/fsck/Makefile.am b/sbin/fsck/Makefile.am
> new file mode 100644
> index 0000000..ed7916c
> --- /dev/null
> +++ b/sbin/fsck/Makefile.am
> @@ -0,0 +1,13 @@
> +## Makefile.am
> +
> +AM_CFLAGS = -Wall
> +AM_CPPFLAGS = -I$(top_srcdir)/include
> +LDADD = $(top_builddir)/lib/libmountchk.la \
> +       $(top_builddir)/lib/libcrc32.la
> +
> +sbin_PROGRAMS = fsck.nilfs2
> +
> +fsck_nilfs2_SOURCES = fsck_messages.c fsck_messages.h fsck_messages.def \
> +                       fsck_nilfs2.c fsck_nilfs2.h \
> +                       fsck_raw_ops.c fsck_raw_ops.h \
> +                       nilfs_superblock.c nilfs_superblock.h
> diff --git a/sbin/fsck/fsck_messages.c b/sbin/fsck/fsck_messages.c
> new file mode 100644
> index 0000000..9e4accd
> --- /dev/null
> +++ b/sbin/fsck/fsck_messages.c
> @@ -0,0 +1,254 @@
> +/*
> + * fsck_messages.c - Print routines (fsck.nilfs2)
> + *
> + * Copyright (C) 2012 Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> + *
> + * This file is part of NILFS.
> + *
> + * NILFS is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * NILFS is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with NILFS; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> + *
> + * Written by Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> + */
> +
> +#include <stdio.h>
> +#include <stdarg.h>
> +
> +#include "fsck_messages.h"
> +
> +/*****************************************************************************
> + * GLOBAL VARIABLES
> + *****************************************************************************/
> +
> +/* Verbosity level of fsck */
> +extern int verbosity_level;
> +
> +/* NILFS fsck message array */
> +const char *fsck_message[MAX_MESSAGE_CODE] = {
> +
> +#define NILFS_FSCK_MESSAGE(ID, MESSAGE) MESSAGE,
> +#include "fsck_messages.def"
> +
> +}; /* const char *fsck_message[MAX_MESSAGE_CODE] */
> +
> +/*****************************************************************************
> + * IMPLEMENTATION SECTION
> + *****************************************************************************/
> +
> +/*****************************************************************************
> + * NAME: FSCK_PRINT_MESSAGE (fsck.nilfs2)
> + *
> + * MACRO: Print fsck message into stdout/stderr
> + *
> + * PARAMETERS:
> + * @granted_verbosity: Verbosity level gives right to print.
> + * @out_stream: Type of the standard output stream [stdout | stderr].
> + * @prefix: Prefix word begins a message.
> + * @fmt: Format of the message.
> + */
> +#define FSCK_PRINT_MESSAGE(granted_verbosity, out_stream, prefix, fmt) \
> +       do { \
> +               va_list args_list; \
> +               if (verbosity_level < granted_verbosity) \
> +                       return; \
> +               va_start(args_list, fmt); \
> +               fprintf(out_stream, prefix); \
> +               vfprintf(out_stream, fmt, args_list); \
> +               fprintf(out_stream, "\n"); \
> +               va_end(args_list); \
> +       } while (0)
> +/* FSCK_PRINT_MESSAGE */
> +
> +/*****************************************************************************
> + * NAME: ui_info (fsck.nilfs2)
> + *
> + * FUNCTION: Inform user about something
> + *
> + * PARAMETERS:
> + * @fmt: Format of the message.
> + */
> +void ui_info(const char *fmt, ...)
> +{
> +       FSCK_PRINT_MESSAGE(BE_VERBOSE, stdout, "[UI_INFO]: ", fmt);
> +} /* ui_info() */
> +
> +/*****************************************************************************
> + * NAME: ui_warning (fsck.nilfs2)
> + *
> + * FUNCTION: Warn user about some important but not critical situation
> + *
> + * PARAMETERS:
> + * @fmt: Format of the message.
> + */
> +void ui_warning(const char *fmt, ...)
> +{
> +       FSCK_PRINT_MESSAGE(BE_VERBOSE, stdout, "[UI_WARNING]: ", fmt);
> +} /* ui_warning() */
> +
> +/*****************************************************************************
> + * NAME: ui_error (fsck.nilfs2)
> + *
> + * FUNCTION: Report error in way of using the utility
> + *
> + * PARAMETERS:
> + * @fmt: Format of the message.
> + */
> +void ui_error(const char *fmt, ...)
> +{
> +       FSCK_PRINT_MESSAGE(BE_VERBOSE, stdout, "[UI_ERROR]: ", fmt);
> +} /* ui_error() */
> +
> +/*****************************************************************************
> + * NAME: fs_info (fsck.nilfs2)
> + *
> + * FUNCTION: Inform user about file system state
> + *
> + * PARAMETERS:
> + * @fmt: Format of the message.
> + */
> +void fs_info(const char *fmt, ...)
> +{
> +       FSCK_PRINT_MESSAGE(BE_VERBOSE, stdout, "[FS_INFO]: ", fmt);
> +} /* fs_info() */
> +
> +/*****************************************************************************
> + * NAME: fs_warning (fsck.nilfs2)
> + *
> + * FUNCTION: Warn user about some important thing in file system state
> + *
> + * PARAMETERS:
> + * @fmt: Format of the message.
> + */
> +void fs_warning(const char *fmt, ...)
> +{
> +       FSCK_PRINT_MESSAGE(BE_VERBOSE, stderr, "[FS_WARNING]: ", fmt);
> +} /* fs_warning() */
> +
> +/*****************************************************************************
> + * NAME: fs_fatal_error (fsck.nilfs2)
> + *
> + * FUNCTION: Report about detected unrecoverable error in file system's metadata
> + *
> + * PARAMETERS:
> + * @fmt: Format of the message.
> + */
> +void fs_fatal_error(const char *fmt, ...)
> +{
> +       FSCK_PRINT_MESSAGE(BE_VERBOSE, stderr, "[FS_FATAL_ERROR]: ", fmt);
> +} /* fs_fatal_error() */
> +
> +/*****************************************************************************
> + * NAME: fs_critical_error (fsck.nilfs2)
> + *
> + * FUNCTION: Report about detected critical file system's metadata error
> + *
> + * PARAMETERS:
> + * @fmt: Format of the message.
> + */
> +void fs_critical_error(const char *fmt, ...)
> +{
> +       FSCK_PRINT_MESSAGE(BE_VERBOSE, stderr, "[FS_CRITICAL_ERROR]: ", fmt);
> +} /* fs_critical_error() */
> +
> +/*****************************************************************************
> + * NAME: fs_minor_error (fsck.nilfs2)
> + *
> + * FUNCTION: Report about detected minor file system's metadata error
> + *
> + * PARAMETERS:
> + * @fmt: Format of the message.
> + */
> +void fs_minor_error(const char *fmt, ...)
> +{
> +       FSCK_PRINT_MESSAGE(BE_VERBOSE, stderr, "[FS_MINOR_ERROR]: ", fmt);
> +} /* fs_minor_error() */
> +
> +/*****************************************************************************
> + * NAME: fs_looks_like_error (fsck.nilfs2)
> + *
> + * FUNCTION: Report about detected suspicious metadata's state looks like error
> + *
> + * PARAMETERS:
> + * @fmt: Format of the message.
> + */
> +void fs_looks_like_error(const char *fmt, ...)
> +{
> +       FSCK_PRINT_MESSAGE(BE_VERBOSE, stderr, "[FS_LOOKS_LIKE_ERROR]: ", fmt);
> +} /* fs_looks_like_error() */
> +
> +/*****************************************************************************
> + * NAME: fsck_info (fsck.nilfs2)
> + *
> + * FUNCTION: Inform user about fsck common actions
> + *
> + * PARAMETERS:
> + * @fmt: Format of the message.
> + */
> +void fsck_info(const char *fmt, ...)
> +{
> +       FSCK_PRINT_MESSAGE(BE_VERBOSE, stdout, "[FSCK_INFO]: ", fmt);
> +} /* fsck_info() */
> +
> +/*****************************************************************************
> + * NAME: fsck_warning (fsck.nilfs2)
> + *
> + * FUNCTION: Warn user about some important situation in fsck states
> + *
> + * PARAMETERS:
> + * @fmt: Format of the message.
> + */
> +void fsck_warning(const char *fmt, ...)
> +{
> +       FSCK_PRINT_MESSAGE(BE_VERBOSE, stderr, "[FSCK_WARNING]: ", fmt);
> +} /* fsck_warning() */
> +
> +/*****************************************************************************
> + * NAME: fsck_error (fsck.nilfs2)
> + *
> + * FUNCTION: Report about internal fsck errors
> + *
> + * PARAMETERS:
> + * @fmt: Format of the message.
> + */
> +void fsck_error(const char *fmt, ...)
> +{
> +       FSCK_PRINT_MESSAGE(BE_VERBOSE, stderr, "[FSCK_ERROR]: ", fmt);
> +} /* fsck_error() */
> +
> +/*****************************************************************************
> + * NAME: fsck_perror (fsck.nilfs2)
> + *
> + * FUNCTION: Report about internal fsck errors + print system error message
> + *
> + * PARAMETERS:
> + * @fmt: Format of the message.
> + */
> +void fsck_perror(const char *fmt, ...)
> +{
> +       FSCK_PRINT_MESSAGE(BE_VERBOSE, stderr, "[FSCK_ERROR]: ", fmt);
> +       perror("[SYSTEM_ERROR]");
> +} /* fsck_perror() */
> +
> +/*****************************************************************************
> + * NAME: fsck_debug (fsck.nilfs2)
> + *
> + * FUNCTION: Debug messages of fsck
> + *
> + * PARAMETERS:
> + * @fmt: Format of the message.
> + */
> +void fsck_debug(const char *fmt, ...)
> +{
> +       FSCK_PRINT_MESSAGE(DEBUG_SPAM, stdout, "[FSCK_DEBUG]: ", fmt);
> +} /* fsck_debug() */
> diff --git a/sbin/fsck/fsck_messages.def b/sbin/fsck/fsck_messages.def
> new file mode 100644
> index 0000000..5eab7ea
> --- /dev/null
> +++ b/sbin/fsck/fsck_messages.def
> @@ -0,0 +1,62 @@
> +/*
> + * fsck_messages.def - List of codes and associated messages
> + *                     (fsck.nilfs2)
> + *
> + * Copyright (C) 2012 Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> + *
> + * This file is part of NILFS.
> + *
> + * NILFS is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * NILFS is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with NILFS; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> + *
> + * Written by Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> + */
> +
> +#ifndef NILFS_FSCK_MESSAGE
> +#define NILFS_FSCK_MESSAGE(ID, MESSAGE)
> +#endif
> +
> +NILFS_FSCK_MESSAGE(FSCK_OK, "")
> +NILFS_FSCK_MESSAGE(UNKNOWN_ERROR, "Unknown error has occured.")
> +NILFS_FSCK_MESSAGE(NOT_IMPLEMENTED, "Sorry. Functionality is not implemented yet.")
> +NILFS_FSCK_MESSAGE(SUCCESS_FAREWELL, "All is OK. Have a nice day.")
> +NILFS_FSCK_MESSAGE(BAD_DEVICE, "Cannot open device.")
> +NILFS_FSCK_MESSAGE(NOT_MOUNTED, "Device is not mounted.")
> +NILFS_FSCK_MESSAGE(RO_MOUNT, "Device is mounted in RO mode.")
> +NILFS_FSCK_MESSAGE(RW_MOUNT, "Device is mounted in RW mode.")
> +NILFS_FSCK_MESSAGE(DEVICE_NOT_OPENED, "Device is not opened.")
> +NILFS_FSCK_MESSAGE(FLUSH_FAILED, "Flush is failed.")
> +NILFS_FSCK_MESSAGE(CANNOT_CLOSE_DEVICE, "Cannot close device.")
> +NILFS_FSCK_MESSAGE(INVALID_BLOCK_SIZE, "Invalid block size.")
> +NILFS_FSCK_MESSAGE(DATA_PROCCESSED_PARTIALLY, "The requested data are proccessed partially.")
> +NILFS_FSCK_MESSAGE(OP_FAILED, "Requested operation has failed.")
> +NILFS_FSCK_MESSAGE(INVALID_PARAMETER, "Input parameters are invalid.")
> +NILFS_FSCK_MESSAGE(OUT_OF_VOLUME, "Trying to operate out of volume.")
> +NILFS_FSCK_MESSAGE(CANNOT_SET_DEV_POS, "Cannot set current position on device.")
> +NILFS_FSCK_MESSAGE(CANNOT_ALLOCATE, "Cannot allocate memory.")
> +NILFS_FSCK_MESSAGE(CANNOT_FREE, "Cannot free memory.")
> +NILFS_FSCK_MESSAGE(CANNOT_READ_SUPERBLOCK, "Cannot read superblock from disk.")
> +NILFS_FSCK_MESSAGE(INVALID_NILFS_SIGNATURE, "Superblock signature is invalid. This is *not* NILFS superblock")
> +NILFS_FSCK_MESSAGE(NILFS_NOT_FOUND, "NILFS superblocks are not detected.")
> +NILFS_FSCK_MESSAGE(ONLY_SB1_OK_FOUND, "Primary valid superblock was found but secondary *not*.")
> +NILFS_FSCK_MESSAGE(ONLY_SB1_CORRUPTED_FOUND, "Corrupted primary superblock was found but secondary *not*.")
> +NILFS_FSCK_MESSAGE(ONLY_SB2_OK_FOUND, "Secondary valid superblock was found but primary *not*..")
> +NILFS_FSCK_MESSAGE(ONLY_SB2_CORRUPTED_FOUND, "Corrupted secondary superblock was found but primary *not*.")
> +NILFS_FSCK_MESSAGE(SB1_SB2_CORRUPTED, "Primary and secondary superblocks were found but in corrupted state.")
> +NILFS_FSCK_MESSAGE(SB1_OK_SB2_CORRUPTED, "Primary superblock is valid but secondary is in corrupted state..")
> +NILFS_FSCK_MESSAGE(SB1_CORRUPTED_SB2_OK, "Secondary superblock is valid but primary is in corrupted state.")
> +NILFS_FSCK_MESSAGE(CANNOT_DETECT_SB_STATE, "Cannot detect state of a superblock because of internal error.")
> +NILFS_FSCK_MESSAGE(SB1_OK_SB2_OK, "NILFS has valid primary and secondary superblocks.")
> +
> +#undef NILFS_FSCK_MESSAGE
> diff --git a/sbin/fsck/fsck_messages.h b/sbin/fsck/fsck_messages.h
> new file mode 100644
> index 0000000..ddbe717
> --- /dev/null
> +++ b/sbin/fsck/fsck_messages.h
> @@ -0,0 +1,110 @@
> +/*
> + * fsck_messages.h - Declaration of fsck error, warning, info codes,
> + *                   associated messages and routines (fsck.nilfs2)
> + *
> + * Copyright (C) 2012 Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> + *
> + * This file is part of NILFS.
> + *
> + * NILFS is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * NILFS is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with NILFS; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> + *
> + * Written by Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> + */
> +
> +#ifndef FSCK_ERROR_H
> +#define FSCK_ERROR_H
> +
> +/* Available verbosity levels of fsck. */
> +enum fsck_verbosity_level {
> +       KEEP_SILENCE,
> +       BE_VERBOSE,
> +       DEBUG_SPAM
> +}; /* enum fsck_verbosity_level */
> +
> +/* NILFS error, warning, info codes and associated messages. */
> +enum fsck_message_codes {
> +
> +#define NILFS_FSCK_MESSAGE(ID, MESSAGE) ID,
> +#include "fsck_messages.def"
> +
> +       MAX_MESSAGE_CODE
> +}; /* enum fsck_message_codes */
> +
> +/* NILFS fsck exit codes. */
> +enum fsck_exit_codes {
> +       RETURN_FSCK_OK                 = 0,
> +       RETURN_FSCK_CORRECTED          = 1,
> +       RETURN_FSCK_REBOOT             = 2,
> +       RETURN_FSCK_ERRORS_UNCORRECTED = 4,
> +       RETURN_FSCK_OP_ERROR           = 8,
> +       RETURN_FSCK_USAGE_ERROR        = 16,
> +       EXIT_LIBRARY                   = 128
> +}; /* enum fsck_exit_codes */
> +
> +/*****************************************************************************
> + * User Interface (UI) messages
> + */
> +
> +/* Inform user about something */
> +void ui_info(const char *fmt, ...);
> +
> +/* Warn user about some important but not critical situation */
> +void ui_warning(const char *fmt, ...);
> +
> +/* Report error in way of using the utility */
> +void ui_error(const char *fmt, ...);
> +
> +/*****************************************************************************
> + * Messages inform about file system state
> + */
> +
> +/* Inform user about file system state */
> +void fs_info(const char *fmt, ...);
> +
> +/* Warn user about some important thing in file system state */
> +void fs_warning(const char *fmt, ...);
> +
> +/* Report about detected unrecoverable file system's error */
> +void fs_fatal_error(const char *fmt, ...);
> +
> +/* Report about detected critical file system's error */
> +void fs_critical_error(const char *fmt, ...);
> +
> +/* Report about detected minor file system's error */
> +void fs_minor_error(const char *fmt, ...);
> +
> +/* Report about detected suspicious state looks like error */
> +void fs_looks_like_error(const char *fmt, ...);
> +
> +/*****************************************************************************
> + * Fsck internal messages
> + */
> +
> +/* Inform user about fsck common actions */
> +void fsck_info(const char *fmt, ...);
> +
> +/* Warn user about some important situation in fsck states */
> +void fsck_warning(const char *fmt, ...);
> +
> +/* Report about internal fsck errors */
> +void fsck_error(const char *fmt, ...);
> +
> +/* Report about internal fsck errors + print system error message */
> +void fsck_perror(const char *fmt, ...);
> +
> +/* Debug messages of fsck */
> +void fsck_debug(const char *fmt, ...);
> +
> +#endif /* FSCK_ERROR_H */
> diff --git a/sbin/fsck/fsck_nilfs2.c b/sbin/fsck/fsck_nilfs2.c
> new file mode 100644
> index 0000000..15acc95
> --- /dev/null
> +++ b/sbin/fsck/fsck_nilfs2.c
> @@ -0,0 +1,379 @@
> +/*
> + * fsck_nilfs2.c - NILFS fsck functionality (fsck.nilfs2)
> + *
> + * Copyright (C) 2012 Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> + *
> + * This file is part of NILFS.
> + *
> + * NILFS is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * NILFS is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with NILFS; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> + *
> + * Written by Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> + */
> +
> +#ifdef HAVE_CONFIG_H
> +#include "config.h"
> +#endif /* HAVE_CONFIG_H */
> +
> +#include <stdio.h>
> +
> +#if HAVE_STDLIB_H
> +#include <stdlib.h>
> +#endif /* HAVE_STDLIB_H */
> +
> +#include <assert.h>
> +
> +#if HAVE_UNISTD_H
> +#include <unistd.h>
> +#endif /* HAVE_UNISTD_H */
> +
> +#if HAVE_STRINGS_H
> +#include <strings.h>
> +#endif /* HAVE_STRINGS_H */
> +
> +#include <string.h>
> +#include <stdarg.h>
> +
> +#include "fsck_nilfs2.h"
> +#include "fsck_raw_ops.h"
> +#include "nilfs_superblock.h"
> +
> +/*****************************************************************************
> + * GLOBAL VARIABLES
> + *****************************************************************************/
> +
> +/* Name of fsck utility */
> +const char *progname = "fsck.nilfs2";
> +
> +/* Verbosity level of fsck */
> +int verbosity_level = BE_VERBOSE;
> +
> +/* Current exit value */
> +int fsck_exit_value = RETURN_FSCK_OK;
> +
> +/* Name of raw device keeps volume for check */
> +char *device_name = NULL;
> +
> +/*****************************************************************************
> + * FUNCTIONS DECLARATION
> + *****************************************************************************/
> +
> +/* Print help message about correct using of utility and exit */
> +static void fsck_usage(void);
> +
> +/* Print message informs about current version of the utility */
> +static void show_fsck_version(void);
> +
> +/* Parse fsck's input parameters */
> +static void parse_params(int argc, char **argv);
> +
> +/* Check that device name requested by user is a real partition */
> +static int is_device_exist(const char *check_device_name);
> +
> +/* Check that device mounted or not */
> +static int is_device_mounted(const char *check_device_name);
> +
> +/*****************************************************************************
> + * IMPLEMENTATION SECTION
> + *****************************************************************************/
> +
> +/*****************************************************************************
> + * NAME: main (fsck.nilfs2)
> + *
> + * FUNCTION: Entry point for nilfs2 check/repair utility
> + *
> + * INTERFACE:
> + *            fsck.nilfs2 <device name>
> + *
> + *                         [ -n ]
> + *                         read only check
> + *                         report but do not repair problems
> + *
> + *                         [-v level]
> + *                         set verbosity level [silence | info | debug]
> + *
> + *                         [ -V ]
> + *                         version information
> + *                         print version information and exit
> + *
> + * RETURNS:
> + *      success:                   RETURN_FSCK_OK (0)
> + *      errors corrected:          RETURN_FSCK_CORRECTED (1)
> + *      errors uncorrected:        RETURN_FSCK_ERRORS_UNCORRECTED (4)
> + *      operational error:         RETURN_FSCK_OP_ERROR (8)
> + *      usage error:               RETURN_FSCK_USAGE_ERROR (16)
> + */
> +int main(int argc, char **argv)
> +{
> +       int err = FSCK_OK;
> +
> +       show_fsck_version();
> +       parse_params(argc, argv);
> +
> +       if (-BAD_DEVICE == is_device_exist(device_name)) {
> +               ui_error("%s Requested device: %s.", fsck_message[BAD_DEVICE], device_name);
> +               fsck_usage();
> +               return (fsck_exit_value);
> +       }
> +
> +       err = is_device_mounted(device_name);
> +       if (-RW_MOUNT == err) {
> +               fsck_error("%s Requested device: %s.", fsck_message[RW_MOUNT], device_name);
> +               fsck_exit_value = RETURN_FSCK_OP_ERROR;
> +               goto fsck_exit;
> +       }
> +       else if (-RO_MOUNT == err) {
> +               fsck_warning("%s Requested device: %s.", fsck_message[RO_MOUNT], device_name);
> +               ui_warning("FSCK currently doesn't work with mounted partitions.");
> +               fsck_exit_value = RETURN_FSCK_OP_ERROR;
> +               goto fsck_exit;
> +       }
> +
> +       err = open_volume(device_name);
> +       if (-BAD_DEVICE == err) {
> +               fsck_error("%s Requested device: %s.", fsck_message[BAD_DEVICE], device_name);
> +               fsck_exit_value = RETURN_FSCK_OP_ERROR;
> +               goto fsck_exit;
> +       }
> +
> +       err = get_nilfs_superblocks();
> +       if (FSCK_OK != err) {
> +               fsck_error("Cannot get superblocks from requested device: %s.", device_name);
> +               fsck_exit_value = RETURN_FSCK_OP_ERROR;
> +               goto fsck_close_volume;
> +       }
> +
> +       /* <TODO: process return values more properly.> */
> +       err = check_nilfs_superblocks();
> +       if (-SB1_OK_SB2_OK == err) {
> +               fsck_info("Device %s contains valid NILFS superblocks.", device_name);
> +       } else if (-NILFS_NOT_FOUND == err) {
> +               ui_warning("Requested device %s doesn't contain valid NILFS superblocks", device_name);
> +               ui_warning("!!!This is not NILFS volume or NILFS volume completely *UNRECOVERABLE*.!!!");
> +               goto fsck_free_resources;
> +       } else if (-CANNOT_DETECT_SB_STATE == err) {
> +               fsck_error("Cannot detect superblocks states on requested device: %s.", device_name);
> +               fsck_exit_value = RETURN_FSCK_OP_ERROR;
> +               goto fsck_free_resources;
> +       } else {
> +               /* <TODO: process return values more properly.> */
> +               ui_warning("Requested device %s contains NILFS volume with *CORRUPTED* superblocks.", device_name);
> +       }
> +
> +       ui_info("FSCK currently does nothing. %s", fsck_message[NOT_IMPLEMENTED]);
> +       ui_info(fsck_message[SUCCESS_FAREWELL]);
> +
> +fsck_free_resources:
> +       if (FSCK_OK != free_nilfs_superblocks()) {
> +               fsck_exit_value = RETURN_FSCK_OP_ERROR;
> +       }
> +
> +fsck_close_volume:
> +       if (FSCK_OK != close_volume()) {
> +               fsck_error("%s Requested device: %s.", fsck_message[CANNOT_CLOSE_DEVICE], device_name);
> +               fsck_exit_value = RETURN_FSCK_OP_ERROR;
> +       }
> +
> +fsck_exit:
> +       return (fsck_exit_value);
> +} /* main() */
> +
> +/*****************************************************************************
> + * NAME: show_fsck_version (fsck.nilfs2)
> + *
> + * FUNCTION: Print message informs about current version of the utility
> + */
> +static void show_fsck_version(void)
> +{
> +       fprintf(stdout, "%s (%s %s)\n", progname, PACKAGE, PACKAGE_VERSION);
> +} /* show_fsck_version() */
> +
> +/*****************************************************************************
> + * NAME: parse_params (fsck.nilfs2)
> + *
> + * FUNCTION:  Parse fsck's input parameters.  If any unrecognized
> + *            parameters are detected, or if any required parameter is
> + *            omitted, issue a message and exit.
> + *
> + * RETURNS:
> + * If there is an error in parse_params(), it calls fsck_usage()
> + * to remind the user of command format and proper options.
> + */
> +void parse_params(int argc, char **argv)
> +{
> +       int c;
> +       char *short_opts = "nv:V";
> +
> +       /* Names of verbosity levels that
> +          can be requested by user by input option */
> +       const char *verbosity_level_names[] = {
> +                       [KEEP_SILENCE] = "silence",
> +                       [BE_VERBOSE] = "info",
> +                       [DEBUG_SPAM] = "debug" };
> +
> +       while ((c = getopt(argc, argv, short_opts))
> +               != EOF) {
> +               switch (c) {
> +               case 'n':
> +               /*************************************
> +                * read only check                   *
> +                * report but do not repair problems *
> +                *************************************/
> +                       fprintf(stdout,
> +                               "Read-only check doesn't supported yet. %s\n",
> +                               fsck_message[NOT_IMPLEMENTED]);
> +                       fsck_exit_value = RETURN_FSCK_OP_ERROR;
> +                       exit(fsck_exit_value);
> +                       break;
> +
> +               case 'v':
> +               /**************************
> +                * Set verbosity level    *
> +                **************************/
> +                       for (int index = KEEP_SILENCE;
> +                                       index <= (DEBUG_SPAM + 1); index++) {
> +                               if (index == (DEBUG_SPAM + 1)) {
> +                                       fsck_usage();
> +                                       return;
> +                               }
> +                               if (0 ==
> +                                   strncmp(verbosity_level_names[index],
> +                                           optarg,
> +                                           strlen(verbosity_level_names[index]))) {
> +                                       verbosity_level = index;
> +                                       break;
> +                               }
> +                       }
> +                       break;
> +
> +               case 'V':
> +               /**********************
> +                * print version only *
> +                **********************/
> +                       exit(RETURN_FSCK_OK);
> +                       break;
> +
> +               default:
> +                       fsck_usage();
> +               }
> +       }
> +
> +       /* TODO: check params existence in together */
> +
> +       if (optind != argc - 1) {
> +               fprintf(stderr, "[UI_ERROR]: Device not specified.\n");
> +               fsck_usage();
> +       }
> +
> +       device_name = argv[optind];
> +
> +       return;
> +} /* parse_params() */
> +
> +/*****************************************************************************
> + * NAME: fsck_usage (fsck.nilfs2)
> + *
> + * FUNCTION: Print help message about correct using of utility and exit from
> + *           utility
> + */
> +static void fsck_usage(void)
> +{
> +       fprintf(stdout,
> +               "Usage: %s [-nV] [-v level] device\n",
> +               progname);
> +       fprintf(stdout,
> +              "\nEmergency help:\n"
> +              " -n                 Check read only, make no changes to the file system.\n"
> +              " -v level           Set verbosity level [silence | info | debug].\n"
> +              " -V                 Print version information only.\n");
> +       fsck_exit_value = RETURN_FSCK_USAGE_ERROR;
> +       exit(fsck_exit_value);
> +} /* fsck_usage() */
> +
> +/*****************************************************************************
> + * NAME:  is_device_exist (fsck.nilfs2)
> + *
> + * FUNCTION:  Check that device name requested by user is a real partition.
> + *
> + * PARAMETERS:
> + * @check_device_name: Name of the device for check
> + *
> + * RETURNS:
> + * FSCK_OK - requested device can be opened in RO mode.
> + * %-BAD_DEVICE - cannot open device.
> + */
> +static int is_device_exist(const char *check_device_name)
> +{
> +       FILE *file_ptr = NULL;
> +
> +       fsck_debug("<is_device_exist()>: check device name.");

Use __func__ macro to omit verbose function names in debug messages.

+       fsck_debug("<%s>: check device name.", __func__);

Or you can easily define new macro which hides the common prefix
"<function name>: " and use of __func__.
.

> +
> +       if (!check_device_name) {
> +               fsck_debug("<is_device_exist()>: NULL pointer on device name.");
> +               return -BAD_DEVICE;
> +       }
> +
> +       file_ptr = fopen(check_device_name, "r");
> +       if (file_ptr) {
> +               fclose(file_ptr);
> +       } else {
> +               fsck_debug("<is_device_exist()>: %s requested device name is not valid.",
> +                               check_device_name);
> +               return -BAD_DEVICE;
> +       }
> +
> +       fsck_debug("<is_device_exist()>: %s requested device is opened successfully.",
> +                               check_device_name);
> +       return FSCK_OK;
> +} /* is_device_exists() */
> +
> +/* libmountchk function */
> +extern int check_mount(const char *device);
> +
> +/*****************************************************************************
> + * NAME:  is_device_mounted (fsck.nilfs2)
> + *
> + * FUNCTION:  Check that device mounted or not.
> + *
> + * PARAMETERS:
> + * @check_device_name: Name of the device for check
> + *
> + * RETURNS:
> + * %-NOT_MOUNTED - Device is not mounted.
> + * %-RO_MOUNT - Device is mounted in RO mode.
> + * %-RW_MOUNT - Device is mounted in RW mode.
> + * %-BAD_DEVICE - Some error in function logic has occured.
> + */
> +static int is_device_mounted(const char *check_device_name)
> +{
> +       fsck_debug("<is_device_mounted()>: check mount state.");
> +
> +       if (!check_device_name) {
> +               fsck_debug("<is_device_mounted()>: NULL pointer on device name.");
> +               return -BAD_DEVICE;
> +       }
> +
> +       /* Currently, check_mount() returns -1 if device is mounted
> +          or error is occured. <TODO: reimplement with the purpose
> +          of detection RO mount> */
> +       if (-1 == check_mount(check_device_name)) {
> +               fsck_debug("<is_device_mounted()>: %s device is mounted.",
> +                                       check_device_name);
> +               return -RW_MOUNT;
> +       }
> +
> +       fsck_debug("<is_device_mounted()>: %s device is *not* mounted.",
> +                                       check_device_name);
> +       return -NOT_MOUNTED;
> +} /* is_device_mounted */
> diff --git a/sbin/fsck/fsck_nilfs2.h b/sbin/fsck/fsck_nilfs2.h
> new file mode 100644
> index 0000000..9d702b9
> --- /dev/null
> +++ b/sbin/fsck/fsck_nilfs2.h
> @@ -0,0 +1,37 @@
> +/*
> + * fsck_nilfs2.h - NILFS fsck declarations
> + *
> + * Copyright (C) 2012 Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> + *
> + * This file is part of NILFS.
> + *
> + * NILFS is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * NILFS is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with NILFS; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> + *
> + * Written by Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> + */
> +
> +#ifndef FSCK_NILFS2_H
> +#define FSCK_NILFS2_H
> +
> +#include "nilfs.h"
> +#include "fsck_messages.h"
> +
> +/* NILFS fsck message array */
> +extern const char* fsck_message[MAX_MESSAGE_CODE];
> +
> +/* Default sector size */
> +#define DEFAULT_SECTOR_SIZE 512
> +
> +#endif /* FSCK_NILFS2_H */
> diff --git a/sbin/fsck/fsck_raw_ops.c b/sbin/fsck/fsck_raw_ops.c
> new file mode 100644
> index 0000000..a159add
> --- /dev/null
> +++ b/sbin/fsck/fsck_raw_ops.c
> @@ -0,0 +1,413 @@
> +/*
> + * fsck_raw_ops.c - Raw operations with disk functionality
> + *
> + * Copyright (C) 2012 Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> + *
> + * This file is part of NILFS.
> + *
> + * NILFS is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * NILFS is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with NILFS; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> + *
> + * Written by Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> + */
> +
> +#include <stdio.h>
> +
> +#if HAVE_STDLIB_H
> +#include <stdlib.h>
> +#endif /* HAVE_STDLIB_H */
> +
> +#if HAVE_UNISTD_H
> +#include <unistd.h>
> +#endif /* HAVE_UNISTD_H */
> +
> +#include <string.h>
> +#include <linux/fs.h>
> +
> +#if HAVE_SYS_IOCTL_H
> +#include <sys/ioctl.h>
> +#endif /* HAVE_SYS_IOCTL_H */
> +
> +#include "fsck_nilfs2.h"
> +#include "fsck_raw_ops.h"
> +
> +/*****************************************************************************
> + * CONSTANTS
> + *****************************************************************************/
> +
> +#define DEVICE_RO_MODE "rb"
> +#define DEVICE_RW_MODE "r+b"
> +
> +/*****************************************************************************
> + * GLOBAL VARIABLES
> + *****************************************************************************/
> +
> +/* Pointer on opened device */
> +FILE *opened_device_ptr = NULL;
> +
> +/* Block device sector size (default value: 512 bytes) */
> +int device_sector_size = DEFAULT_SECTOR_SIZE;
> +
> +/* Size of the device in bytes */
> +u_int64_t device_size_in_bytes = 0;
> +
> +/*****************************************************************************
> + * IMPLEMENTATION SECTION
> + *****************************************************************************/
> +
> +/*****************************************************************************
> + * NAME:  open_device (fsck.nilfs2)
> + *
> + * FUNCTION:  Open device.
> + *
> + * PARAMETERS:
> + * @device_name: Name of the device for opening
> + * @mode: mode of opening [RO | RW]
> + *
> + * RETURNS:
> + * FSCK_OK - device has opened successfully.
> + * %-BAD_DEVICE - cannot open device.
> + */
> +static int open_device(const char *device_name, const char *mode)
> +{
> +       int file_descriptor = 0;
> +
> +       if (!device_name || !mode) {
> +               fsck_debug("<open_device()>: NULL pointer.");
> +               return -BAD_DEVICE;
> +       }
> +
> +       fsck_debug("<open_device()>: try to open device %s in %s mode.",
> +                       device_name, mode);
> +
> +       if (opened_device_ptr) {
> +               fsck_error("%s Device %s is opened yet.",
> +                               fsck_message[BAD_DEVICE], device_name);
> +               return -BAD_DEVICE;
> +       }
> +
> +       opened_device_ptr = fopen(device_name, mode);
> +       if (!opened_device_ptr) {
> +               fsck_perror("%s The mode %s is unavailable for %s device.",
> +                               fsck_message[BAD_DEVICE], device_name, mode);
> +               return -BAD_DEVICE;
> +       }
> +
> +       /* In the case of error fileno() returns -1 */
> +       file_descriptor = fileno(opened_device_ptr);
> +       if (-1 == file_descriptor) {
> +               fsck_debug("<open_device()>: fileno() cannot convert pointer into descriptor.");
> +               goto open_success;
> +       }
> +
> +       /* In the case of error ioctl() returns -1 */
> +       if (-1 == ioctl(file_descriptor, BLKSSZGET, &device_sector_size)) {
> +               fsck_debug("<open_device()>: cannot detect device sector size.");
> +       } else {
> +               fsck_debug("<open_device()>: sector size %d.", device_sector_size);
> +       }
> +
> +       /* In the case of error ioctl() returns -1 */
> +       if (-1 == ioctl(file_descriptor, BLKGETSIZE64, &device_size_in_bytes)) {
> +               fsck_debug("<open_device()>: cannot detect device size in bytes.");
> +       } else {
> +               fsck_debug("<open_device()>: device size in bytes %lld.", device_size_in_bytes);
> +       }
> +
> +open_success:
> +       fsck_debug("<open_device()>: device %s is opened in %s mode successfully.",
> +                       device_name, mode);
> +       return FSCK_OK;
> +} /* open_device() */
> +
> +/*****************************************************************************
> + * NAME:  open_device_ro (fsck.nilfs2)
> + *
> + * FUNCTION:  Open device in READ-ONLY mode.
> + *
> + * PARAMETERS:
> + * @device_name: Name of the device for opening
> + *
> + * RETURNS:
> + * FSCK_OK - device has opened successfully.
> + * %-BAD_DEVICE - cannot open device.
> + */
> +static int open_device_ro(const char *device_name)
> +{
> +       return open_device(device_name, DEVICE_RO_MODE);
> +} /* open_device_ro() */
> +
> +/*****************************************************************************
> + * NAME:  open_device_rw (fsck.nilfs2)
> + *
> + * FUNCTION:  Open device in READ-WRITE mode.
> + *
> + * PARAMETERS:
> + * @device_name: Name of the device for opening
> + *
> + * RETURNS:
> + * FSCK_OK - device has opened successfully.
> + * %-BAD_DEVICE - cannot open device.
> + */
> +static int open_device_rw(const char *device_name)
> +{
> +       /* <TODO: add support of RW mode> */
> +       ui_error("%s %s", fsck_message[BAD_DEVICE], fsck_message[NOT_IMPLEMENTED]);
> +       return -BAD_DEVICE;
> +} /* open_device_rw() */
> +
> +/*****************************************************************************
> + * NAME:  open_volume (fsck.nilfs2)
> + *
> + * FUNCTION:  Open volume for fsck operations.
> + *
> + * PARAMETERS:
> + * @device_name: Name of the device for opening
> + *
> + * RETURNS:
> + * FSCK_OK - device has opened successfully.
> + * %-BAD_DEVICE - cannot open device.
> + */
> +int open_volume(const char *device_name)
> +{
> +       /* <TODO: Currently it simply opens device in RO mode.
> +                 Function should analyze user options and open
> +                 device in proper mode.> */
> +       return open_device_ro(device_name);
> +} /* open_volume() */
> +
> +/*****************************************************************************
> + * NAME:  close_volume (fsck.nilfs2)
> + *
> + * FUNCTION:  Close volume after fsck operations.
> + *
> + * RETURNS:
> + * FSCK_OK - device has closed successfully.
> + * %-DEVICE_NOT_OPENED - device is not opened.
> + * %-FLUSH_FAILED - some error occurs during flushing.
> + * %-CANNOT_CLOSE_DEVICE - cannot close device.
> + */
> +int close_volume(void)
> +{
> +       int file_descriptor = 0;
> +
> +       fsck_debug("<close_volume()>: try to close device.");
> +
> +       if (!opened_device_ptr) {
> +               fsck_error("%s", fsck_message[DEVICE_NOT_OPENED]);
> +               return -DEVICE_NOT_OPENED;
> +       }
> +
> +       /* In the case of error fileno() returns -1 */
> +       file_descriptor = fileno(opened_device_ptr);
> +       if (-1 == file_descriptor) {
> +               fsck_debug("<close_device()>: fileno() cannot convert pointer into descriptor.");
> +               fsck_perror("%s", fsck_message[FLUSH_FAILED]);
> +               goto close_device;
> +       }
> +
> +       /* In the case of error fsync() returns -1 */
> +       if (-1 == fsync(file_descriptor)) {
> +               fsck_perror("%s", fsck_message[FLUSH_FAILED]);
> +       }
> +
> +close_device:
> +       if (fclose(opened_device_ptr)) {
> +               fsck_perror("%s", fsck_message[CANNOT_CLOSE_DEVICE]);
> +               return -CANNOT_CLOSE_DEVICE;
> +       }
> +
> +       fsck_debug("<close_device()>: device is closed successfully.");
> +       return FSCK_OK;
> +} /* close_volume() */
> +
> +/* Define type of operation with raw bytes */
> +enum {
> +       OP_READ,
> +       OP_WRITE
> +};
> +
> +/*****************************************************************************
> + * NAME:  raw_bytes (fsck.nilfs2)
> + *
> + * FUNCTION:  Read or write bytes on volume.
> + *
> + * PARAMETERS:
> + * @op_mode: Type of operation with volume.
> + * @device_offset: Offset from device beginning in bytes.
> + * @raw_data_buffer: Pointer on buffer with data.
> + * @requested_bytes_count: Requested count of bytes for operation.
> + * @actual_bytes_count: Actual count of proccessed bytes.
> + *
> + * RETURNS:
> + * FSCK_OK - All requested count of data are proccessed successfully.
> + * %-DEVICE_NOT_OPENED - Device is not opened.
> + * %-DATA_PROCCESSED_PARTIALLY - The requested data are proccessed partially.
> + * %-OP_FAILED - Requested operation has failed.
> + * %-INVALID_PARAMETER - Input parameters are invalid.
> + * %-CANNOT_SET_DEV_POS - Cannot set current position on device.
> + */
> +static int raw_bytes(int op_mode,
> +                       u_int64_t device_offset,
> +                       void *raw_data_buffer,
> +                       u_int32_t requested_bytes_count,
> +                       u_int32_t *actual_bytes_count)
> +{
> +       int err = FSCK_OK;
> +
> +       fsck_debug("<raw_bytes()>: try to proccess %d bytes on %lld offset.",
> +                               requested_bytes_count, device_offset);
> +
> +       if (NULL == raw_data_buffer || NULL == actual_bytes_count) {
> +               fsck_error("%s", fsck_message[INVALID_PARAMETER]);
> +               fsck_debug("<raw_bytes()>: raw_data_buffer is %#x.",
> +                               raw_data_buffer);
> +               fsck_debug("<raw_bytes()>: actual_bytes_count is %#x.",
> +                               actual_bytes_count);
> +               return -INVALID_PARAMETER;
> +       }
> +
> +       (*actual_bytes_count) = 0;
> +
> +       if (0 == requested_bytes_count) {
> +               fsck_debug("<raw_bytes()>: does nothing.");
> +               return FSCK_OK;
> +       }
> +
> +       if (!opened_device_ptr) {
> +               fsck_error("%s", fsck_message[DEVICE_NOT_OPENED]);
> +               return -DEVICE_NOT_OPENED;
> +       }
> +
> +       if (device_offset >= device_size_in_bytes) {
> +               fsck_error("%s", fsck_message[INVALID_PARAMETER]);
> +               fsck_debug("<raw_bytes()>: ATTENTION!!! Device size is %lld.",
> +                               device_size_in_bytes);
> +               return -INVALID_PARAMETER;
> +       }
> +
> +       if ((device_offset + requested_bytes_count) > device_size_in_bytes) {
> +               fsck_warning("%s", fsck_message[OUT_OF_VOLUME]);
> +       }
> +
> +       if (0 != fseeko(opened_device_ptr, device_offset, SEEK_SET)) {
> +               fsck_perror("%s", fsck_message[CANNOT_SET_DEV_POS]);
> +               err = -CANNOT_SET_DEV_POS;
> +               goto raw_bytes_op_failed;
> +       }
> +
> +       switch (op_mode) {
> +       case OP_READ:
> +               (*actual_bytes_count) =
> +                       fread(raw_data_buffer, 1, requested_bytes_count, opened_device_ptr);
> +               break;
> +       case OP_WRITE:
> +               (*actual_bytes_count) =
> +                       fwrite(raw_data_buffer, 1, requested_bytes_count, opened_device_ptr);
> +               break;
> +       default:
> +               fsck_error("%s", fsck_message[INVALID_PARAMETER]);
> +               fsck_debug("<raw_bytes()>: the requested value %d is invalid operation mode.",
> +                               op_mode);
> +               err = -INVALID_PARAMETER;
> +               goto raw_bytes_op_failed;
> +       }
> +
> +       if (-1 == (*actual_bytes_count)) {
> +               (*actual_bytes_count) = 0;
> +               fsck_perror("%s", fsck_message[OP_FAILED]);
> +               err = -OP_FAILED;
> +               goto raw_bytes_op_failed;
> +       } else if ((*actual_bytes_count) != requested_bytes_count) {
> +               fsck_warning("%s", fsck_message[DATA_PROCCESSED_PARTIALLY]);
> +               fsck_debug("<raw_bytes()>: Only %d bytes are proccessed from %d requested.",
> +                               (*actual_bytes_count), requested_bytes_count);
> +               err = -DATA_PROCCESSED_PARTIALLY;
> +               if (0 != feof(opened_device_ptr)) {
> +                       clearerr(opened_device_ptr);
> +                       goto raw_bytes_op_failed;
> +               } else {
> +                       goto raw_bytes_finished;
> +               }
> +       } else {
> +               fsck_debug("<raw_bytes()>: the requested %d bytes proccessed successfully.",
> +                               requested_bytes_count);
> +               goto raw_bytes_finished;
> +       }
> +
> +raw_bytes_op_failed:
> +       rewind(opened_device_ptr);
> +
> +raw_bytes_finished:
> +       return err;
> +} /* raw_bytes() */
> +
> +/*****************************************************************************
> + * NAME:  read_raw_bytes (fsck.nilfs2)
> + *
> + * FUNCTION:  Read bytes from volume.
> + *
> + * PARAMETERS:
> + * @device_offset: Offset from device beginning in bytes.
> + * @raw_data_buffer: Pointer on buffer with read data.
> + * @requested_bytes_count: Requested count of bytes for read.
> + * @read_bytes_count: Actual count of read bytes.
> + *
> + * RETURNS:
> + * FSCK_OK - All requested count of data are proccessed successfully.
> + * %-DEVICE_NOT_OPENED - Device is not opened.
> + * %-DATA_PROCCESSED_PARTIALLY - The requested data are proccessed partially.
> + * %-OP_FAILED - Requested operation has failed.
> + * %-INVALID_PARAMETER - Input parameters are invalid.
> + * %-CANNOT_SET_DEV_POS - Cannot set current position on device.
> + */
> +int read_raw_bytes(u_int64_t device_offset,
> +                       void *raw_data_buffer,
> +                       u_int32_t requested_bytes_count,
> +                       u_int32_t *read_bytes_count)
> +{
> +       return raw_bytes(OP_READ, device_offset, raw_data_buffer,
> +                               requested_bytes_count,
> +                               read_bytes_count);
> +} /* read_raw_bytes() */
> +
> +/*****************************************************************************
> + * NAME:  write_raw_bytes (fsck.nilfs2)
> + *
> + * FUNCTION:  Write bytes to volume.
> + *
> + * PARAMETERS:
> + * @device_offset: Offset from device beginning in bytes.
> + * @raw_data_buffer: Pointer on buffer with data for write.
> + * @requested_bytes_count: Requested count of bytes for write.
> + * @written_bytes_count: Actual count of written bytes.
> + *
> + * RETURNS:
> + * FSCK_OK - All requested count of data are proccessed successfully.
> + * %-DEVICE_NOT_OPENED - Device is not opened.
> + * %-DATA_PROCCESSED_PARTIALLY - The requested data are proccessed partially.
> + * %-OP_FAILED - Requested operation has failed.
> + * %-INVALID_PARAMETER - Input parameters are invalid.
> + * %-CANNOT_SET_DEV_POS - Cannot set current position on device.
> + */
> +int write_raw_bytes(u_int64_t device_offset,
> +                       void *raw_data_buffer,
> +                       u_int32_t requested_bytes_count,
> +                       u_int32_t *written_bytes_count)
> +{
> +       /* <TODO: maybe not write full portion of data is error. Need to think.> */
> +       return raw_bytes(OP_WRITE, device_offset, raw_data_buffer,
> +                               requested_bytes_count,
> +                               written_bytes_count);
> +} /* write_raw_bytes() */
> diff --git a/sbin/fsck/fsck_raw_ops.h b/sbin/fsck/fsck_raw_ops.h
> new file mode 100644
> index 0000000..3776489
> --- /dev/null
> +++ b/sbin/fsck/fsck_raw_ops.h
> @@ -0,0 +1,46 @@
> +/*
> + * fsck_raw_ops.h - Declarations for raw operations with disk
> + *
> + * Copyright (C) 2012 Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> + *
> + * This file is part of NILFS.
> + *
> + * NILFS is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * NILFS is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with NILFS; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> + *
> + * Written by Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> + */
> +
> +#ifndef FSCK_RAW_OPS_H
> +#define FSCK_RAW_OPS_H
> +
> +/* Open volume for fsck operations */
> +int open_volume(const char *device_name);
> +
> +/* Close volume after fsck operations */
> +int close_volume(void);
> +
> +/* Read bytes from volume */
> +int read_raw_bytes(u_int64_t device_offset,
> +                       void *raw_data_buffer,
> +                       u_int32_t requested_bytes_count,
> +                       u_int32_t *read_bytes_count);
> +
> +/* Write bytes to volume */
> +int write_raw_bytes(u_int64_t device_offset,
> +                       void *raw_data_buffer,
> +                       u_int32_t requested_bytes_count,
> +                       u_int32_t *written_bytes_count);
> +
> +#endif /* FSCK_RAW_OPS_H */
> diff --git a/sbin/fsck/nilfs_superblock.c b/sbin/fsck/nilfs_superblock.c
> new file mode 100644
> index 0000000..1a26bb6
> --- /dev/null
> +++ b/sbin/fsck/nilfs_superblock.c
> @@ -0,0 +1,445 @@
> +/*
> + * nilfs_superblock.c - NILFS superblocks checking, processing
> + *                      and recovering operations implementation
> + *
> + * Copyright (C) 2012 Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> + *
> + * This file is part of NILFS.
> + *
> + * NILFS is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * NILFS is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with NILFS; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> + *
> + * Written by Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> + */
> +
> +#include "fsck_nilfs2.h"
> +#include "fsck_raw_ops.h"
> +
> +#include "nilfs_superblock.h"
> +
> +/*****************************************************************************
> + * GLOBAL VARIABLES
> + *****************************************************************************/
> +
> +/* Block device sector size */
> +extern int device_sector_size;
> +
> +/* Size of the device in bytes */
> +extern u_int64_t device_size_in_bytes;
> +
> +/* Array of pointers on NILFS volume's superblocks */
> +struct nilfs_super_block *superblocks[SUPERBLOCK_TYPES_NUMBER] = {0};
> +
> +/*****************************************************************************
> + * FUNCTIONS DECLARATION
> + *****************************************************************************/
> +
> +/* Allocate memory for superblock */
> +static int allocate_superblock(int sb_type);
> +
> +/* Free memory allocated for superblock */
> +static int free_superblock(int sb_type);
> +
> +/* Read superblock from disk */
> +static int read_superblock(int sb_type);
> +
> +/* Check that superblock is valid */
> +/*static int is_nilfs_superblock_valid(const struct nilfs_super_block *sb_ptr);*/
> +
> +/* Compare two superblocks */
> +/*static int is_nilfs_superblocks_identical(
> +                               const struct nilfs_super_block *left_sb_ptr,
> +                               const struct nilfs_super_block *right_sb_ptr);*/
> +
> +/*****************************************************************************
> + * IMPLEMENTATION SECTION
> + *****************************************************************************/
> +
> +/*****************************************************************************
> + * NAME:  get_nilfs_superblocks (fsck.nilfs2)
> + *
> + * FUNCTION:  Allocate memory and read primary and secondary
> + *            superblocks from disk.
> + *
> + * RETURNS:
> + * FSCK_OK - primary and secondary superblocks are read successfully.
> + * %-CANNOT_ALLOCATE - cannot allocate memory for superblock.
> + * %-CANNOT_READ_SUPERBLOCK - cannot read superblock from disk.
> + */
> +int get_nilfs_superblocks(void)
> +{
> +       int err = FSCK_OK;
> +
> +       fsck_debug("<get_nilfs_superblocks()>: try to read superblocks from disk.");
> +
> +       err = allocate_superblock(PRIMARY_SUPERBLOCK);
> +       if (err) {
> +               err = CANNOT_ALLOCATE;
> +               goto get_nilfs_superblocks_failed;
> +       }
> +
> +       err = allocate_superblock(SECONDARY_SUPERBLOCK);
> +       if (err) {
> +               err = CANNOT_ALLOCATE;
> +               goto free_primary_superblock;
> +       }
> +
> +       err = read_superblock(PRIMARY_SUPERBLOCK);
> +       if (err) {
> +               err = CANNOT_READ_SUPERBLOCK;
> +               goto free_secondary_superblock;
> +       }
> +
> +       err = read_superblock(SECONDARY_SUPERBLOCK);
> +       if (err) {
> +               err = CANNOT_READ_SUPERBLOCK;
> +               goto free_secondary_superblock;
> +       }
> +
> +       fsck_debug("<get_nilfs_superblocks()>: nilfs superblocks are read successfully.");
> +       return FSCK_OK;
> +
> +free_secondary_superblock:
> +       free_superblock(SECONDARY_SUPERBLOCK);
> +
> +free_primary_superblock:
> +       free_superblock(PRIMARY_SUPERBLOCK);
> +
> +get_nilfs_superblocks_failed:
> +       return err;
> +} /* get_nilfs_superblocks() */
> +
> +/*****************************************************************************
> + * NAME:  check_nilfs_superblocks (fsck.nilfs2)
> + *
> + * FUNCTION:  Check primary and secondary NILFS superblocks.
> + *
> + * RETURNS:
> + * %-SB1_OK_SB2_OK - Primary and secondary superblocks are valid.
> + * %-NILFS_NOT_FOUND - NILFS superblocks are not detected.
> + * %-ONLY_SB1_OK_FOUND - Primary valid superblock was found but secondary *not*.
> + * %-ONLY_SB1_CORRUPTED_FOUND - Corrupted primary superblock was found but secondary *not*.
> + * %-ONLY_SB2_OK_FOUND - Secondary valid superblock was found but primary *not*.
> + * %-ONLY_SB2_CORRUPTED_FOUND - Corrupted secondary superblock was found but primary *not*.
> + * %-SB1_SB2_CORRUPTED - Primary and secondary superblocks were found but in corrupted state.
> + * %-SB1_OK_SB2_CORRUPTED - Primary superblock is valid but secondary is in corrupted state.
> + * %-SB1_CORRUPTED_SB2_OK - Secondary superblock is valid but primary is in corrupted state.
> + * %-CANNOT_DETECT_SB_STATE - Cannot detect state of a superblock because of internal error.
> + */
> +int check_nilfs_superblocks(void)
> +{
> +       /* <TODO: need to implement>
> +        * Currently, it checks only NILFS magic in superblocks.
> +        */
> +
> +       enum sb_detected_states {
> +               SB1_VALID              = 1 << 0,
> +               SB1_CORRUPTED          = 1 << 1,
> +               SB1_NOT_FOUND          = 1 << 2,
> +               SB2_VALID              = 1 << 3,
> +               SB2_CORRUPTED          = 1 << 4,
> +               SB2_NOT_FOUND          = 1 << 5,
> +               ALL_POSSIBLE_SB_STATES = 1 << 6
> +       }; /* enum sb_detected_states */
> +
> +       int err;
> +       int sb_states = 0;
> +
> +       int return_states[ALL_POSSIBLE_SB_STATES] = { -1 };
> +       return_states[SB1_VALID | SB2_VALID] = SB1_OK_SB2_OK;
> +       return_states[SB1_CORRUPTED | SB2_VALID] = SB1_CORRUPTED_SB2_OK;
> +       return_states[SB1_NOT_FOUND | SB2_VALID] = ONLY_SB2_OK_FOUND;
> +       return_states[SB1_VALID | SB2_CORRUPTED] = SB1_OK_SB2_CORRUPTED;
> +       return_states[SB1_CORRUPTED | SB2_CORRUPTED] = SB1_SB2_CORRUPTED;
> +       return_states[SB1_NOT_FOUND | SB2_CORRUPTED] = ONLY_SB2_CORRUPTED_FOUND;
> +       return_states[SB1_VALID | SB2_NOT_FOUND] = ONLY_SB1_OK_FOUND;
> +       return_states[SB1_CORRUPTED | SB2_NOT_FOUND] = ONLY_SB1_CORRUPTED_FOUND;
> +       return_states[SB1_NOT_FOUND | SB2_NOT_FOUND] = NILFS_NOT_FOUND;
> +
> +       fsck_debug("<check_nilfs_superblocks()>: try to check NILFS superblocks.");
> +
> +       err = is_nilfs_signature_ok(superblocks[PRIMARY_SUPERBLOCK]);
> +       if (FSCK_OK == err) {
> +               sb_states |= SB1_VALID;
> +               fsck_debug("<check_nilfs_superblocks()>: primary superblock has valid NILFS signature.");
> +               fsck_debug("<check_nilfs_superblocks()>: sb_states has %d value.", sb_states);
> +       } else if (-INVALID_NILFS_SIGNATURE == err) {
> +               sb_states |= SB1_NOT_FOUND;
> +               fsck_debug("<check_nilfs_superblocks()>: primary superblock is not found.");
> +               fsck_debug("<check_nilfs_superblocks()>: sb_states has %d value.", sb_states);
> +       } else {
> +               goto check_sb_internal_error;
> +       }

As you know, NILFS confirms validity of super blocks with check-sum as
well as the
MAGIC number.  See nilfs_sb_is_valid routine in lib/sb.c

> +
> +       err = is_nilfs_signature_ok(superblocks[SECONDARY_SUPERBLOCK]);
> +       if (FSCK_OK == err) {
> +               sb_states |= SB2_VALID;
> +               fsck_debug("<check_nilfs_superblocks()>: secondary superblock has valid NILFS signature.");
> +               fsck_debug("<check_nilfs_superblocks()>: sb_states has %d value.", sb_states);
> +       } else if (-INVALID_NILFS_SIGNATURE == err) {
> +               sb_states |= SB2_NOT_FOUND;
> +               fsck_debug("<check_nilfs_superblocks()>: secondary superblock is not found.");
> +               fsck_debug("<check_nilfs_superblocks()>: sb_states has %d value.", sb_states);
> +       } else {
> +               goto check_sb_internal_error;
> +       }
> +
> +       fsck_debug("<check_nilfs_superblocks()>: return_states has %d value.", return_states[sb_states]);
> +
> +       if (-1 == return_states[sb_states]) {
> +               goto check_sb_internal_error;
> +       } else if (NILFS_NOT_FOUND == return_states[sb_states]) {
> +               goto check_sb_fs_info;
> +       } else if ((sb_states & SB1_NOT_FOUND) || (sb_states & SB2_NOT_FOUND)) {
> +               goto check_sb_fs_fatal_error;
> +       } else if (SB1_OK_SB2_OK != return_states[sb_states]) {
> +               goto check_sb_fs_critical_error;
> +       }
> +
> +check_sb_fs_info:
> +       fs_info("%s", fsck_message[return_states[sb_states]]);
> +       return -return_states[sb_states];
> +
> +check_sb_fs_fatal_error:
> +       fs_fatal_error("%s", fsck_message[return_states[sb_states]]);
> +       return -return_states[sb_states];
> +
> +check_sb_fs_critical_error:
> +       fs_critical_error("%s", fsck_message[return_states[sb_states]]);
> +       return -return_states[sb_states];
> +
> +check_sb_internal_error:
> +       fsck_error("%s", fsck_message[CANNOT_DETECT_SB_STATE]);
> +       return -CANNOT_DETECT_SB_STATE;
> +} /* check_nilfs_superblocks() */
> +
> +/*****************************************************************************
> + * NAME:  free_nilfs_superblocks (fsck.nilfs2)
> + *
> + * FUNCTION:  Free memory allocated for superblocks.
> + *
> + * RETURNS:
> + * FSCK_OK - primary and secondary superblocks are freed successfully.
> + * %-CANNOT_FREE - cannot free memory for superblocks.
> + */
> +int free_nilfs_superblocks(void)
> +{
> +       int err_sb1 = FSCK_OK;
> +       int err_sb2 = FSCK_OK;
> +
> +       fsck_debug("<free_nilfs_superblocks()>: try to free memory of primary and secondary superblocks.");
> +
> +       err_sb1 = free_superblock(PRIMARY_SUPERBLOCK);
> +       err_sb2 = free_superblock(SECONDARY_SUPERBLOCK);
> +
> +       if (FSCK_OK != err_sb1 || FSCK_OK != err_sb2) {
> +               fsck_debug("<free_nilfs_superblocks()>: some error occurs during memory freeing.");
> +               return -CANNOT_FREE;
> +       }
> +
> +       fsck_debug("<free_nilfs_superblocks()>: superblocks memory has freed successfully.");
> +       return FSCK_OK;
> +
> +} /* free_nilfs_superblocks() */
> +
> +/*****************************************************************************
> + * NAME:  allocate_superblock (fsck.nilfs2)
> + *
> + * FUNCTION:  Allocate memory for superblock.
> + *
> + * PARAMETERS:
> + * @sb_type: Type of superblock.
> + *
> + * RETURNS:
> + * FSCK_OK - memory for superblock is allocated successfully.
> + * %-INVALID_PARAMETER - inavalid input parameter.
> + * %-CANNOT_ALLOCATE - cannot allocate memory for superblock.
> + */
> +static int allocate_superblock(int sb_type)
> +{
> +       struct nilfs_super_block *sb_ptr = NULL;
> +
> +       fsck_debug("<allocate_superblock()>: try to allocate memory for %d superblock type.",
> +                       sb_type);
> +
> +       if (sb_type >= SUPERBLOCK_TYPES_NUMBER) {
> +               fsck_error("%s", fsck_message[INVALID_PARAMETER]);
> +               return -INVALID_PARAMETER;
> +       }
> +
> +       if (superblocks[sb_type]) {
> +               fsck_error("%s", fsck_message[CANNOT_ALLOCATE]);
> +               fsck_debug("<allocate_superblock()>: superblock of %d type has allocated yet",
> +                               sb_type);
> +               return -CANNOT_ALLOCATE;
> +       }
> +
> +       sb_ptr = calloc(sizeof(struct nilfs_super_block), 1);
> +       if (NULL == sb_ptr) {
> +               fsck_perror("%s", fsck_message[CANNOT_ALLOCATE]);
> +               return -CANNOT_ALLOCATE;
> +       }
> +
> +       superblocks[sb_type] = sb_ptr;
> +
> +       fsck_debug("<allocate_superblock()>: memory for %d superblock type has allocated.",
> +                       sb_type);
> +
> +       return FSCK_OK;
> +} /* allocate_superblock() */
> +
> +/*****************************************************************************
> + * NAME:  free_superblock (fsck.nilfs2)
> + *
> + * FUNCTION:  Free memory allocated for superblock.
> + *
> + * PARAMETERS:
> + * @sb_type: Type of superblock.
> + *
> + * RETURNS:
> + * FSCK_OK - memory for superblock is freed successfully.
> + * %-INVALID_PARAMETER - inavalid input parameter.
> + * %-CANNOT_FREE - cannot free memory for superblock.
> + */
> +static int free_superblock(int sb_type)
> +{
> +       fsck_debug("<free_superblock()>: try to free memory for %d superblock type.",
> +                       sb_type);
> +
> +       if (sb_type >= SUPERBLOCK_TYPES_NUMBER) {
> +               fsck_error("%s", fsck_message[INVALID_PARAMETER]);
> +               return -INVALID_PARAMETER;
> +       }
> +
> +       if (NULL == superblocks[sb_type]) {
> +               fsck_warning("%s", fsck_message[CANNOT_FREE]);
> +               fsck_debug("<free_superblock()>: superblock of %d type *not* allocated yet",
> +                               sb_type);
> +               return -CANNOT_FREE;
> +       }
> +
> +       free(superblocks[sb_type]);
> +       superblocks[sb_type] = NULL;
> +
> +       fsck_debug("<free_superblock()>: superblock of %d type has freed",
> +                               sb_type);
> +
> +       return FSCK_OK;
> +} /* free_superblock() */
> +
> +/*****************************************************************************
> + * NAME:  read_superblock (fsck.nilfs2)
> + *
> + * FUNCTION:  Read superblock from disk.
> + *
> + * PARAMETERS:
> + * @sb_type: Type of superblock.
> + *
> + * RETURNS:
> + * FSCK_OK - superblock has read successfully.
> + * %-INVALID_PARAMETER - inavalid input parameter.
> + * %-CANNOT_READ_SUPERBLOCK - cannot read superblock from disk.
> + */
> +static int read_superblock(int sb_type)
> +{
> +       int err = FSCK_OK;
> +       u_int32_t read_bytes_count = 0;
> +       u_int64_t device_offset = 0;
> +
> +       fsck_debug("<read_superblock()>: try to read superblock of %d type.",
> +                       sb_type);
> +
> +       switch (sb_type) {
> +       case PRIMARY_SUPERBLOCK:
> +               device_offset = NILFS_SB_OFFSET_BYTES;
> +               break;
> +       case SECONDARY_SUPERBLOCK:
> +               if (sizeof(struct nilfs_super_block) >= device_size_in_bytes) {
> +                       fsck_debug("<read_superblock()>: Sector size: %d bytes. Device size: %lld bytes.",
> +                                       device_sector_size, device_size_in_bytes);
> +                       goto cannot_read_superblock;
> +               }
> +               /* Calculate device offset of secondary superblock */
> +               device_offset = NILFS_SB2_OFFSET_BYTES(device_size_in_bytes);
> +               /* Check device offset correctness */
> +               if (device_offset % DEFAULT_SECTOR_SIZE) {
> +                       fsck_debug("<read_superblock()>: Device offset has unaligned value %lld in bytes.",
> +                                       device_offset);
> +                       goto cannot_read_superblock;
> +               }

This check is meaningless.

NILFS_SB2_OFFESET_BYTES() always returns an aligned value to
4K bytes boundary.

Rather, You should check if the offset is not too small.

> +               break;
> +       default:
> +               fsck_error("%s", fsck_message[INVALID_PARAMETER]);
> +               return -INVALID_PARAMETER;
> +       }
> +
> +       if (NULL == superblocks[sb_type]) {
> +               fsck_debug("<read_superblock()>: superblock of %d type *not* allocated yet",
> +                               sb_type);
> +               goto cannot_read_superblock;
> +       }
> +
> +       err = read_raw_bytes(device_offset, superblocks[sb_type],
> +                               sizeof(struct nilfs_super_block),
> +                               &read_bytes_count);

You have to take care that the super block of NILFS is extensible.
The size of super block is stored in sbp->s_bytes.

If it's larger than 1KB, then it is broken.
If it's larger than sizeof(struct nilfs_super_block) but equal to or
smaller than 1KB,
then it was written by a certain future version of NILFS2 that the
fsck doesn't yet
know.  In this case,  fsck.nilfs2 should print warning message, but should not
regard it's broken.

Maybe, fsck should abort if it met unknown format and had to overwrite the
metadata.

The same thing applies to segment summary header, super root, and so forth.

> +
> +       if (DATA_PROCCESSED_PARTIALLY == err ||
> +                       read_bytes_count != sizeof(struct nilfs_super_block)) {
> +               fsck_debug("<read_superblock()>: actually read only %d bytes", read_bytes_count);
> +               goto cannot_read_superblock;
> +       }
> +
> +       if (FSCK_OK != err) {
> +               goto cannot_read_superblock;
> +       }
> +
> +       fsck_debug("<read_superblock()>: superblock is read successfully");
> +       return FSCK_OK;
> +
> +cannot_read_superblock:
> +       fsck_error("%s", fsck_message[CANNOT_READ_SUPERBLOCK]);
> +       return -CANNOT_READ_SUPERBLOCK;
> +} /* read_superblock() */
> +
> +/*****************************************************************************
> + * NAME:  is_nilfs_signature_ok (fsck.nilfs2)
> + *
> + * FUNCTION:  Check that superblock contains valid NILFS signature.
> + *
> + * PARAMETERS:
> + * @sb_ptr: Pointer on superblock.
> + *
> + * RETURNS:
> + * FSCK_OK - superblock contains valid NILFS signature.
> + * %-INVALID_PARAMETER - inavalid input parameter.
> + * %-INVALID_NILFS_SIGNATURE - superblock signature is invalid.
> + */
> +int is_nilfs_signature_ok(const struct nilfs_super_block *sb_ptr)
> +{
> +       fsck_debug("<is_nilfs_signature_ok()>: check signature of superblock.");
> +
> +       if (NULL == sb_ptr) {
> +               fsck_error("%s", fsck_message[INVALID_PARAMETER]);
> +               fsck_debug("<is_nilfs_signature_ok()>: pointer on superblock is NULL.");
> +               return -INVALID_PARAMETER;
> +       }
> +
> +       if (le16_to_cpu(sb_ptr->s_magic) != NILFS_SUPER_MAGIC) {
> +               fsck_error("%s", fsck_message[INVALID_NILFS_SIGNATURE]);
> +               return -INVALID_NILFS_SIGNATURE;
> +       }
> +
> +       fsck_debug("<is_nilfs_signature_ok()>: NILFS signature is ok.");
> +       return FSCK_OK;
> +} /* is_nilfs_signature_ok() */
> diff --git a/sbin/fsck/nilfs_superblock.h b/sbin/fsck/nilfs_superblock.h
> new file mode 100644
> index 0000000..e78301e
> --- /dev/null
> +++ b/sbin/fsck/nilfs_superblock.h
> @@ -0,0 +1,48 @@
> +/*
> + * nilfs_superblock.h - Declarations of operations for NILFS superblocks
> + *                      checking, processing and recovering
> + *
> + * Copyright (C) 2012 Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> + *
> + * This file is part of NILFS.
> + *
> + * NILFS is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * NILFS is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with NILFS; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> + *
> + * Written by Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> + */
> +
> +#ifndef NILFS_SUPERBLOCK_H
> +#define NILFS_SUPERBLOCK_H
> +
> +/* Type of NILFS superblocks */
> +enum superblock_type {
> +       PRIMARY_SUPERBLOCK,
> +       SECONDARY_SUPERBLOCK,
> +       SUPERBLOCK_TYPES_NUMBER
> +}; /* enum superblock_type */
> +
> +/* Allocate memory and read superblocks from disk */
> +int get_nilfs_superblocks(void);
> +
> +/* Check that superblock contains valid NILFS signature */
> +int is_nilfs_signature_ok(const struct nilfs_super_block *sb_ptr);
> +
> +/* Check primary and secondary NILFS superblocks */
> +int check_nilfs_superblocks(void);
> +
> +/* Free memory allocated for superblocks */
> +int free_nilfs_superblocks(void);
> +
> +#endif /* NILFS_SUPERBLOCK_H */
> --


With regards,
Ryusuke Konishi

> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
