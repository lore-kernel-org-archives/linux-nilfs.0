From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: [PATCH 00/24] nilfs2: introduce debugging subsystem
 implementation
Date: Tue, 18 Jun 2013 02:02:35 +0900 (JST)
Message-ID: <20130618.020235.402928744.konishi.ryusuke@lab.ntt.co.jp>
References: <1371471701.2075.129.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1371471701.2075.129.camel@slavad-ubuntu>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs@vger.kernel.org, Linux FS Devel <linux-fsdevel@vger.kernel.org>

On Mon, 17 Jun 2013 16:21:41 +0400, Vyacheslav Dubeyko wrote:
> Hi,
> 
> This patch set implements debugging subsystem in NILFS2 driver.
> 
> The debugging subsystem includes:
> (1) debugging subsystem API;
> (2) subsystems and printing opportunity flags;
> (3) kernel configuration options.
> 
> The debugging subsystem API includes:
> (1) nilfs2_debug() method.
>     It is a basic debugging method. It expects a set of
>     flags, format string and variable arguments list.
> 
> (2) nilfs2_hexdump() method.
>     It is a method for writing in system log hexdumps
>     of internal structures. It expects a set of flags,
>     prefix string, pointer on memory and size of pointed data.
> 
> (3) NILFS_ERR_DBG() macros.
>     It is a macros that prints out file name, line number,
>     function name and error code.
> 
> Every module of NILFS2 driver has dedicated flag. These flags
> give opportunity to enable debugging output only from required
> modules of NILFS2 driver. There are several special output
> flags:
> (1) DBG_SHOW_ERR flag.
>     This flag requests writing in system log messages about
>     internal errors of NILFS2 driver.
> 
> (2) DBG_DUMP_STACK flag.
>     This flag requests output of dump stack.
> 
> (3) DBG_SPAM flag.
>     This flag requsts output from frequently called functions
>     or detailed debugging output from function's body.
> 
> (4) DBG_HEX_DUMP flag.
>     This flag requests writing in system log hexdumps of internal
>     structures.
> 
> The debugging subsystem of NILFS2 driver has DBG_MASK that defines
> set of flags for debugging output. Namely, this mask is used for
> comparing requested flag with set of flags that should be printed out.
> Such selection mechanism is used for the case of printk() calls.
> 
> Also, it is available opportunity of dynamic debugging by means of
> pr_debug() method using. In such case the behaviour of pr_debug() is
> controlled via writing to a control file in the 'debugfs' filesystem.
> 
> The debugging subsystem is configured by means of kernel
> configuration options:
> (1) NILFS2_USE_PR_DEBUG
>     This option enables using of pr_debug() instead of printk() and
>     print_hex_dump_bytes() instead of print_hex_dump().
> 
> (2) NILFS2_DEBUG_SHOW_ERRORS
>     This option enables writing in system log messages about internal
>     errors of NILFS2 driver.
> 
> (3) NILFS2_DEBUG_DUMP_STACK
>     This option enables output of dump stack. Usually, every
>     function in NILFS2 driver begins from debugging output of
>     function name, file, line and input arguments' value.
>     In the case of enabling this option debugging output
>     will include dump stack too.
> 
> (4) NILFS2_DEBUG_SHOW_SPAM
>     This option enables output from frequently called functions or
>     detailed debugging output from function's body.
> 
> (5) NILFS2_DEBUG_HEXDUMP
>     This option enables writing in system log hexdumps of internal
>     structures.
> 
> (6) NILFS2_DEBUG_BASE_OPERATIONS
>     This option enables base operations subsystem debugging output.
> 
> (7) NILFS2_DEBUG_MDT_FILES
>     This option enables metadata (MDT) files subsystem debugging output.
> 
> (8) NILFS2_DEBUG_SEGMENTS_SUBSYSTEM
>     This option enables segments subsystem debugging output.
> 
> (9) NILFS2_DEBUG_GC_SUBSYSTEM
>     This option enables GC subsystem debugging output.
> 
> (10) NILFS2_DEBUG_RECOVERY_SUBSYSTEM
>      This option enables recovery subsystem debugging output.
> 
> (11) NILFS2_DEBUG_BLOCK_MAPPING
>      This option enables block mapping subsystem debugging output.
> 
> (12) NILFS2_DEBUG_BUFFER_MANAGEMENT
>      This option enables buffer/page management subsystem debugging
>      output.
> 
> With the best regards,
> Vyacheslav Dubeyko.

Looks like you are trying to reinvent the wheel.

Please consider using trace events kernel API (See
Documentation/trace/events.txt and include/trace/events/xxxx.h etc),
and do not try to add own debug/tracing framework.  With the trace
events framekwork, you will be able to add flexible and switchable
debug functionalities without abusing NILFS2_DEBUG_XXXX kernel options
and printk variants.

As I usually comment to you, start small, with a simple but powerful
change, and try to keep your patchset as simple as you can.

Regards,
Ryusuke Konishi

> ---
>  Vyacheslav Dubeyko (1):
>     nilfs2: introduce debugging subsystem implementation
> 
>  fs/nilfs2/Kconfig     |  145 +++++++++++++
>  fs/nilfs2/alloc.c     |  140 +++++++++++--
>  fs/nilfs2/bmap.c      |  109 +++++++++-
>  fs/nilfs2/btnode.c    |   45 +++-
>  fs/nilfs2/btree.c     |  515 +++++++++++++++++++++++++++++++++++++++++-----
>  fs/nilfs2/cpfile.c    |  204 +++++++++++++++----
>  fs/nilfs2/dat.c       |  130 ++++++++++--
>  fs/nilfs2/debug.h     |  291 ++++++++++++++++++++++++++
>  fs/nilfs2/dir.c       |   71 ++++++-
>  fs/nilfs2/direct.c    |  117 +++++++++--
>  fs/nilfs2/file.c      |   29 ++-
>  fs/nilfs2/gcinode.c   |   23 ++-
>  fs/nilfs2/ifile.c     |   55 ++++-
>  fs/nilfs2/inode.c     |  271 +++++++++++++++++++++----
>  fs/nilfs2/ioctl.c     |  275 +++++++++++++++++++------
>  fs/nilfs2/mdt.c       |  128 +++++++++---
>  fs/nilfs2/namei.c     |  183 +++++++++++++----
>  fs/nilfs2/nilfs.h     |    1 +
>  fs/nilfs2/page.c      |   52 ++++-
>  fs/nilfs2/recovery.c  |  160 ++++++++++++---
>  fs/nilfs2/segbuf.c    |   90 +++++++-
>  fs/nilfs2/segment.c   |  541 +++++++++++++++++++++++++++++++++++++++++++------
>  fs/nilfs2/sufile.c    |  172 +++++++++++++---
>  fs/nilfs2/super.c     |  192 ++++++++++++++----
>  fs/nilfs2/the_nilfs.c |  130 +++++++++---
>  25 files changed, 3537 insertions(+), 532 deletions(-)
> --
> 1.7.9.5
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
