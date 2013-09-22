From: "Michael L. Semon" <mlsemon35-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Best way to shut down NILFS2? (umount hang issue)...
Date: Sat, 21 Sep 2013 23:20:35 -0400
Message-ID: <523E6203.2090509@gmail.com>
References: <5238DAD8.3070804@gmail.com>   <1379485106.2365.11.camel@slavad-ubuntu>   <CAJzLF9nbfM6aY8u57Lgkm4r_mpBtd96J=HaqSnF=+oLvhYpmUw@mail.gmail.com>  <1379571773.2310.5.camel@slavad-ubuntu> <523B866D.9060406@gmail.com> <1379664873.2280.11.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=eycDBMDnv5oa0YZDBE8s7Gu2ZQbrRoR90O1NycKFvsE=;
        b=bI5wGNyufmD9sqKU0OsFAFemcHWUlazl0lCh0L03tylq2fFM3sesn4COTPDKdsbdqI
         qFcpZ64pb16G2TZeFHkD56Lw33bJWPU+5s2hGNzX9iDGTbVvEOuqVsf2lsIbiQzfmZvM
         m2yJdQB8YsrQgGzASHPEncYMzvH/d6Hbcu+ckVpfzaxYL1H+LQSh/tFFzEqVEfFt01um
         WsB+1qcl2fgXo1hyWjdk8QcXtkZHv0RNohI0UQHQWpdBXjfwnT+fD4EHnz13O4mQUcC8
         q4hIPdIXfOmijaehqWXsUXH/rI7Z7dv3N38TCnbSJDCI2GBPokOsrQQFTiVE5EzPeQpH
         XLpg==
In-Reply-To: <1379664873.2280.11.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 09/20/2013 04:14 AM, Vyacheslav Dubeyko wrote:
> Hi Michael,
> 
> On Thu, 2013-09-19 at 19:19 -0400, Michael L. Semon wrote:
> 
> [snip]
>>
>> The issue still happens.  One patch was already in the kernel, and
>> the second patch you mentioned did not make much of a difference.
>> The second patch is still installed, though.
>>
> 
> Ok. Thank you for report. I'll try to reproduce the issue, firstly.
> 
>> The problem I mentioned above is the one that is easy to explain.
>> The crash doesn't even have to stress the computer:  A simple
>> SysRq-induced crash should be enough to get the problem started, 
>> though the PC might need to be crashed more than once.
>>
>> I've changed / to mount as errors=panic, but there has been no 
>> panic yet.
>>
>> # ================
>>
>> Here is where the overall problem becomes hard to explain.  Consider this 
>> scenario:
>>
>> / is NILFS2 (rw,order=strict)
>> /boot is JFS
>> /tmp is JFS
>> /usr/src is JFS
>>
>> Because I don't want the hung NILFS2 umount to give problems to /tmp and 
>> /usr/src, I adapted the end of the standard Slackware shutdown script to 
>> look something like this:
>>
>> /bin/umount -v -a -t noproc,nosysfs,nonilfs2
>>
>> # This line can be here to show a sync problem, or removed 
>> # to show a umount problem....
>> sync
>>
>> /bin/umount -v -a -t nilfs2
>>
>> echo "Remounting root filesystem read-only."
>> /bin/mount -v -n -o remount,ro /dev/sdb12 /
>>
>> [I can get you the exact script next time.]
>>
> 
> Ok. Please, share all additional details (or script) that it will be
> helpful for the issue reproducing from your point of view.

This is for the "simple" case.  The only extra program used was LTP's 
fsstress.  No kernels were built to stress memory.  None of the 
additional JFS partitions were used:  This is just NILFS2 /, swap, and 
virtual filesystems.

> So, I need in such details:
> (1) Could you share the output of "nilfs-tune -l"?

[These results came from a session with the drive write caches shut 
off.]

nilfs-tune 2.1.5
Filesystem volume name:	  nBoot
Filesystem UUID:	  fbc3d532-ef4b-4d0a-a064-6dad94b71224
Filesystem magic number:  0x3434
Filesystem revision #:	  2.0
Filesystem features:      (none)
Filesystem state:	  invalid or mounted
Filesystem OS type:	  Linux
Block size:		  4096
Filesystem created:	  Thu Sep 19 00:37:12 2013
Last mount time:	  Sat Sep 21 15:16:44 2013
Last write time:	  Sat Sep 21 15:16:44 2013
Mount count:		  271
Maximum mount count:	  50
Reserve blocks uid:	  0 (user root)
Reserve blocks gid:	  0 (group root)
First inode:		  11
Inode size:		  128
DAT entry size:		  32
Checkpoint size:	  192
Segment usage size:	  16
Number of segments:	  639
Device size:		  5368709120
First data block:	  1
# of blocks per segment:  2048
Reserved segments %:	  5
Last checkpoint #:	  7681
Last block address:	  229931
Last sequence #:	  751
Free blocks count:	  436224
Commit interval:	  0
# of blks to create seg:  0
CRC seed:		  0x4fc978f4
CRC check sum:		  0xc37ab2f6
CRC check data size:	  0x00000118

> (2) Could you share /etc/fstab content and "mount" output for the
> reproduced issue case?

# ======================= /etc/fstab =======================

/dev/sdb2   swap              swap      defaults                      0  0
/dev/sdb12  /                 nilfs2    rw,order=strict,errors=panic  0  0
devpts      /dev/pts          devpts    gid=5,mode=620                0  0
proc        /proc             proc      defaults                      0  0
debugfs     /sys/kernel/debug debugfs   defaults                      0  0


# ====================== output of `mount`=======================

proc on /proc type proc (rw)
sysfs on /sys type sysfs (rw)
/dev/sdb12 on / type nilfs2 (rw,order=strict,errors=panic,gcpid=96)
devpts on /dev/pts type devpts (rw,gid=5,mode=620)
debugfs on /sys/kernel/debug type debugfs (rw)

# ===============================================================

> (3) Could you share "fdisk -l" or "parted -l" output?

OK, and I annotated it a bit as well...

Model: ATA ST3120814A (scsi) # not really, it's IDE
Disk /dev/sda: 120GB
Sector size (logical/physical): 512B/512B
Partition Table: msdos
Disk Flags: 

Number  Start   End     Size    Type      File system  Flags
 1      1049kB  102MB   101MB   primary   jfs # /boot (not mounted in test)
 2      102MB   120GB   120GB   extended
 5      103MB   170MB   67.1MB  logical   # journal for /dev/sdb10
 6      171MB   305MB   134MB   logical   # $TEST_LOGDEV for xfstests
 7      306MB   440MB   134MB   logical   # $SCRATCH_LOGDEV for xfstests
 8      441MB   1073MB  631MB   logical   ext2 # dump capture (not used)
 9      1074MB  12.6GB  11.5GB  logical   xfs  # production / (not used)
10      12.6GB  120GB   107GB   logical   # dm-crypt (xfs)


Model: ATA WDC WD600BB-75CA (scsi) # not really, it's IDE
Disk /dev/sdb: 60.0GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags: 

Number  Start   End     Size    File system     Name         Flags
 1      1049kB  3490MB  3489MB  jfs             gEmergency  # alt / (not used)
 2      3490MB  4295MB  805MB   linux-swap(v1)  gAltSwap    # swap
 3      4295MB  25.8GB  21.5GB  jfs             gStorage    # backup (not used)
12      25.8GB  31.1GB  5369MB  nilfs2          gN2Boot     # / for test
13      31.1GB  32.2GB  1074MB  jfs             gTmpForN2   # /tmp (not used)
 4      32.2GB  34.3GB  2080MB  nilfs2          gTestDev    # $TEST_DEV
 5      34.3GB  46.1GB  11.8GB  xfs             gScratchDev # $SCRATCH_DEV
 6      46.1GB  46.9GB  805MB                   gBadLower   # bad blocks
 7      46.9GB  47.4GB  537MB                   gTstRTDev   # $TEST_RTDEV
 8      47.4GB  48.0GB  537MB                   gScrRTDev   # $SCRATCH_RTDEV
 9      48.0GB  49.1GB  1074MB                  gBadUpper   # bad blocks
10      49.1GB  60.0GB  11.0GB  jfs             gUsrSrc   # /usr/src (not used)

> (4) Could you share /etc/nilfs_cleanerd.conf content?

# =================== /etc/nilfs_cleanerd.conf ==================

# nilfs_cleanerd.conf - configuration file of NILFS cleaner daemon.
#
# This file contains GC parameters that are loaded when cleaner gets
# started.  You can force them to be reloaded by sending a HUP signal
# to the cleaner process.
#
# Each parameter is declared with a keyword-value pair or a directive
# with no argument.  Lines beginning with "#" are ignored.  For
# details, see the man page of nilfs_cleanerd.conf(5).

# Protection period in second.
protection_period	3600

# Minimum number of clean segments
#   0 = continuous cleaning
# > 0 = pause cleaning until less segments are available
min_clean_segments	10%

# Maximum number of clean segments
max_clean_segments	20%

# The argument of min_clean_segments and max_clean_segments can be
# followed by a percent sign (%) or one of the following
# multiplicative suffixes: K 1024, MB 1000*1000, M 1024*1024, GB
# 1000*1000*1000, G 1024*1024*1024, and so on for T, P, E.
#
# If the argument is followed by "%", it represents a disk capacity
# ratio.

# Clean segment check interval in seconds
clean_check_interval	10

# Segment selection policy.
# In NILFS version 2.0.0, only the timestamp policy is supported.
selection_policy	timestamp	# timestamp in ascend order

# The maximum number of segments to be cleaned at a time.
nsegments_per_clean	2

# The maximum number of segments to be cleaned at a time
# if clean segments < min_clean_segments
mc_nsegments_per_clean	4

# Cleaning interval in seconds.
cleaning_interval	5

# Cleaning interval in seconds
# if clean segments < min_clean_segments
mc_cleaning_interval	1

# Retry interval in seconds.
retry_interval		60

# Use mmap when reading segments if supported.
use_mmap

# Log priority.
# Supported priorities are emerg, alert, crit, err, warning, notice, info, and
# debug.
log_priority		info

# ===============================================================

My test case started to succeed, and the next 20-30 reboots were successful.  
[Again, the problem can fix itself over time.]  So I inserted this into my 
/etc/rc.d/rc.local script:

# ======================= SCRIPT FRAGMENT =======================

echo 'Issuing `nilfs-tune -l /dev/sdb12`...'
/sbin/nilfs-tune -l /dev/sdb12
echo "Querying mounts using the mount command..."
/bin/mount
echo 'Issuing `nilfs-clean --status /dev/sdb12`'
/sbin/nilfs-clean --status /dev/sdb12
echo "Running fsstress..."
/opt/ltp/testcases/bin/fsstress -p 16 -n 100 -d /tmp/test
echo "Invoking shutdown..."
/sbin/shutdown -r now

# ===============================================================

Note that it uses the fsstress from the latest LTP (September 2013) 
from ltp.sourceforge.net.  The fsstress from xfstests does not cause 
any problems.

>> I choose to build a kernel, which fills memory, exercises a JFS
>> filesystem and probably writes temp files to /tmp on JFS.  `make 
>> install` installs the kernel to /boot on JFS.  [BTW, `make install` 
>> can stall when /boot is within a NILFS2 / partition, but that has 
>> not been tested since I started using a separate /boot partition.] 
>>
>> There is a much higher chance that shutdown will hang before the
>> NILFS2 partitions are umounted.  A simple `mount` placed before the
>> `sync` shows that umount is honoring the "nonilfs2" flag, and the
>> NILFS2 partitions are still mounted.  So why would the sync *before*
>> the umount of NILFS2 partitions get hung between segctord and sync,
>> when mount supposedly has not umounted the NILFS2 partitions yet?
>> This is why I mentioned the sync issue and the umount issue at the
>> same time.
>>
>> Could it be that `umount ... nonilfs2` causes /etc/mtab to be
>> modified, which is updated by NILFS2 on /, but it is not done in 
>> time to make sync (or the next `umount ... nilfs2`) happy?  I'm 
>> only speculating on this idea.
>>
> 
> I hope that I have enough details for successful reproducing of the
> issue. But if I encounter some troubles then I'll ask you about
> additional details. I'll share results of my attempt, anyway.
> 
> So, I think that it needs to reproduce the issue and to investigate it
> before answering on your questions. :)

Thanks.  There is some more data after my question, just in case there 
is something obviously misconfigured.

Also, I did get half of the problem to show by running xfstests 
generic/069, using `./check -g auto` without specifying "-o pp=0".  
However, your latest patch was not installed in that kernel, and 
so generic/069 might have shown the problem that you patched.

Good luck!

Michael

# ======= KDB stack trace of test in /etc/rc.d/rc.local =========

Running fsstress...
seed = 1379318781
Invoking shutdown...
[  867.598103] SysRq : DEBUG

Entering kdb (current=0xc16cf620, pid 0) due to Keyboard Entry
kdb> ps
42 sleeping system daemon (state M) processes suppressed,
use 'ps A' to see all.
Task Addr       Pid   Parent [*] cpu State Thread     Command
0xc16cf620        0        0  1    0   R  0xc16cf8d8 *swapper

0xdf450000        1        0  0    0   S  0xdf4502b8  init
0xde129960       72        2  0    0   D  0xde129c18  segctord
0xde128cb0       96        1  0    0   S  0xde128f68  nilfs_cleanerd
0xde128000      115        1  0    0   S  0xde1282b8  rc.M
0xde12b2c0      124        1  0    0   S  0xde12b578  syslogd
0xde12d8d0      129        1  0    0   S  0xde12db88  klogd
0xde12e580      235        1  0    0   S  0xde12e838  sshd
0xde12a610      241        1  0    0   S  0xde12a8c8  ntpd
0xde12f230      246        1  0    0   S  0xde12f4e8  acpid
0xde12bf70      248        1  0    0   S  0xde12c228  gpm
0xde9f6580      250        1  0    0   S  0xde9f6838  crond
0xde9f58d0      252        1  0    0   S  0xde9f5b88  atd
0xdd718000      278      115  0    0   D  0xdd7182b8  shutdown
kdb> btp 278
Stack traceback for pid 278
0xdd718000      278      115  0    0   D  0xdd7182b8  shutdown
 dd78de3c 00000096 f48c74cc 00000010 00000000 dd718000 1a99a6cf 00000005 
 dd78c000 dd718000 00000005 00215ed3 00000000 1a9aa249 00000005 00000000 
 c106c8db 00000000 dd78de28 c1051df4 007d4405 00000086 dd718470 dd78de28 
Call Trace:
 [<c106c8db>] ? trace_hardirqs_off_caller+0x1a/0x115
 [<c1051df4>] ? sched_clock_cpu+0x8f/0xe2
 [<c14f414e>] schedule+0x22/0x4c
 [<c14f1548>] schedule_timeout+0xf8/0x16c
 [<c14f5925>] ? _raw_spin_unlock_irq+0x27/0x36
 [<c106c8bf>] ? trace_hardirqs_on+0xb/0xd
 [<c14f44e8>] wait_for_completion+0x9e/0xce
 [<c104fcb6>] ? try_to_wake_up+0x138/0x138
 [<c11057e2>] sync_inodes_sb+0xc3/0x1f2
 [<c106cae9>] ? trace_hardirqs_off+0xb/0xd
 [<c14f4475>] ? wait_for_completion+0x2b/0xce
 [<c11087a5>] sync_inodes_one_sb+0x15/0x17
 [<c10e45d9>] iterate_supers+0xc5/0xc7
 [<c1108790>] ? SyS_tee+0x2c5/0x2c5
 [<c1108922>] sys_sync+0x31/0x78
 [<c14f6d3b>] sysenter_do_call+0x12/0x32

kdb> btp 72
Stack traceback for pid 72
0xde129960       72        2  0    0   D  0xde129c18  segctord
 de1addb8 00000092 de1add70 c106a213 00000000 de129960 4efb093e 00000006 
 de1ac000 de129960 00000001 c14f58d7 de129960 00000002 de1add98 00000002 
 dfaef060 00000282 de129da8 00000046 00000282 dfaef060 de1adda0 c106c8bf 
Call Trace:
 [<c106a213>] ? lock_release_holdtime.part.22+0xba/0xed
 [<c14f58d7>] ? _raw_spin_unlock_irqrestore+0x2f/0x56
 [<c106c8bf>] ? trace_hardirqs_on+0xb/0xd
 [<c10f6e51>] ? inode_lru_list_del+0x27/0x27
 [<c14f414e>] schedule+0x22/0x4c
 [<c10f6e5e>] inode_wait+0xd/0x11
 [<c14f165e>] __wait_on_bit+0x4e/0x6b
 [<c10f6e51>] ? inode_lru_list_del+0x27/0x27
 [<c1103158>] __inode_wait_for_writeback+0x80/0x98
 [<c1046b4d>] ? autoremove_wake_function+0x3d/0x3d
 [<c1104e62>] inode_wait_for_writeback+0x1d/0x28
 [<c10f79b3>] evict+0x83/0x15d
 [<c10f84b1>] iput+0xc3/0x137
 [<c127afc2>] nilfs_dispose_list+0xfc/0x14b
 [<c127b387>] nilfs_transaction_unlock+0x55/0x5e
 [<c127db60>] nilfs_segctor_thread+0xd5/0x2ad
 [<c127da8b>] ? nilfs_segctor_construct+0x229/0x229
 [<c10460c4>] kthread+0xa7/0xa9
 [<c14f6cb7>] ret_from_kernel_thread+0x1b/0x28
 [<c104601d>] ? __kthread_parkme+0x5b/0x5b

kdb> btp 96
Stack traceback for pid 96
0xde128cb0       96        1  0    0   S  0xde128f68  nilfs_cleanerd
 de26becc 00000096 00000001 c14f58d7 de128cb0 de128cb0 830bd70d 000000c9 
 de26a000 de128cb0 de1290f8 00000046 00000286 c16e6c20 de26be94 c106c8bf 
 de26bea4 00000286 13260165 de26bef4 de26bed4 c1049262 de26beb4 ab91e650 
Call Trace:
 [<c14f58d7>] ? _raw_spin_unlock_irqrestore+0x2f/0x56
 [<c106c8bf>] ? trace_hardirqs_on+0xb/0xd
 [<c1049262>] ? __hrtimer_start_range_ns+0x96/0x2a7
 [<c14f414e>] schedule+0x22/0x4c
 [<c14f3741>] schedule_hrtimeout_range_clock+0xb5/0x140
 [<c1048a10>] ? atomic_dec_and_mutex_lock+0x6b/0x6b
 [<c128ca92>] wq_sleep.constprop.12+0xb3/0x13a
 [<c128d72f>] SyS_mq_timedreceive+0x162/0x3da
 [<c10ce78d>] ? might_fault+0x93/0xa6
 [<c14f6478>] syscall_call+0x7/0xb

# ======================= /etc/rc.d/rc.S ========================

#!/bin/sh
#
# /etc/rc.d/rc.S:  System initialization script.
#
# Adapted from the standard Slackware rc.S in slackware-current.
#

# Turn off write cache for sake of /dev/sdb10's journal on /dev/sda5.
# /sbin/hdparm -W0 /dev/sda
# Turn off write cache for all drives.
/sbin/hdparm -W0 /dev/sda /dev/sdb

PATH=/sbin:/usr/sbin:/bin:/usr/bin

# /bin/dmesg -l 0,1,2,3,4,5,6,7 --console-on debug

# Try to mount /proc:
/sbin/mount -n -v proc /proc -n -t proc 2> /dev/null

# Try to mount /sys:
/sbin/mount -n -v sysfs /sys -n -t sysfs

/sbin/mount -n -t nilfs2 -o remount,rw,order=strict,errors=panic /dev/sdb12 /

# Try not to remove mtab (doesn't make a difference)

if [ -e /etc/mtab~* ]; then
  /bin/rm /etc/mtab~*
fi
if [ -e /etc/mtab.* ]; then
  /bin/rm /etc/mtab.*
fi
if [ -e /etc/mtab ]; then
  /bin/truncate --size=0 /etc/mtab
fi
# /bin/ln -s /proc/mounts /etc/mtab
/bin/touch /etc/mtab

# Record entries in mtab
/sbin/mount -f -v proc /proc -t proc 2> /dev/null
/sbin/mount -f -v sysfs /sys -t sysfs
/sbin/mount -f -t nilfs2 -o remount,rw,order=strict,errors=panic /dev/sdb12 /

/sbin/fsck -aAR
# if [ -e /dev/sdb13 ]; then
# 	echo "Making fresh JFS /tmp on /dev/sdb13..."
# 	/sbin/jfs_mkfs -q -L jTmpForN2 /dev/sdb13
# fi

# MLS - Get the devs going, one way or another...

if [ -x /etc/rc.d/rc.udev ]; then
  /etc/rc.d/rc.udev start
else
  if [ -d /dev/ ]; then
    if [ ! -e /dev/pts ]; then
      mkdir /dev/pts
    fi
    if [ ! -e /dev/shm ]; then
      mkdir /dev/shm
    fi
    if [ ! -e /dev/md ]; then
        mkdir /dev/md
    fi
    if [ ! -e /dev/fd ]; then
      ln -sf /proc/self/fd /dev/fd
      ln -sf fd/0 /dev/stdin
      ln -sf fd/1 /dev/stdout
      ln -sf fd/2 /dev/stderr
    fi
    if [ ! -e /dev/X0R ]; then
      ln -sf null /dev/X0R
    fi
    if [ ! -e /dev/root ]; then
      ln -s /dev/sdb12 /dev/root
    fi
    if [ ! -e /dev/mouse ]; then
      ln -s /dev/input/mice /dev/mouse
    fi
    if [ ! -e /dev/cdrom ]; then
      ln -sf sr0 /dev/cdrom
    fi
    if [ -e /dev/ram0 ]; then
      ln -sf ram0 /dev/ramdisk
    fi
  fi
fi

# # MLS - either way, link ttyS0 to gps0
# if [ -e /dev/ttyS0 ]; then
#   chmod 0640 /dev/ttyS0
#   chown root:gps /dev/ttyS0
#   ln -sf ttyS0 /dev/gps0
# fi

# # If /run exists, mount a tmpfs on it (unless the
# # initrd has already done so):
# if [ -d /run ]; then
#   if ! grep -wq "tmpfs /run tmpfs" /proc/mounts ; then
#     /sbin/mount -v -n -t tmpfs tmpfs /run -o mode=0755
#   fi
# fi

# Enable swapping:
/sbin/swapon -a 2> /dev/null

# remount / rw went here.
/sbin/mount -t nilfs2 -o remount,rw,order=strict,errors=panic /dev/sdb12 /
# /sbin/mount -o remount,rw /

/sbin/hwclock --hctosys --utc --directisa

# /sbin/mdadm --auto-detect

# # Configure runtime kernel parameters:
if [ -x /sbin/sysctl -a -r /etc/sysctl.conf ]; then
  /sbin/sysctl -e -p /etc/sysctl.conf
fi

# Turn on some debugging for JBD2
# if [ -e /sys/module/jbd2/parameters/jbd2_debug ]; then
#   echo 1 > /sys/module/jbd2/parameters/jbd2_debug
# fi

# Mount non-root file systems in fstab, but not NFS or SMB 
# because TCP/IP is not yet configured, and not proc or sysfs
# because those have already been mounted.  Also check that
# devpts is not already mounted before attempting to mount
# it.  With a 2.6.x or newer kernel udev mounts devpts.
# We also need to wait a little bit to let USB and other
# hotplugged devices settle (sorry to slow down the boot):
echo "Mounting non-root local filesystems:"
if /bin/grep -wq devpts /proc/mounts ; then
  /sbin/mount -a -v -t nonfs,nosmbfs,nocifs,noproc,nosysfs,nodevpts
else
  /sbin/mount -a -v -t nonfs,nosmbfs,nocifs,noproc,nosysfs
fi

/bin/chmod 1777 /tmp

# # Clean up some temporary files:
# rm -f /var/run/* /var/run/*/* /var/run/*/*/* /etc/nologin \
#   /etc/dhcpc/*.pid /etc/forcefsck /etc/fastboot \
#   /var/state/saslauthd/saslauthd.pid \
#   /tmp/.Xauth* 1> /dev/null 2> /dev/null
#   ( cd /var/log/setup/tmp && rm -rf * )
#   ( cd /tmp && rm -rf kde-[a-zA-Z]* ksocket-[a-zA-Z]* hsperfdata_[a-zA-Z]* plugtmp* )

# # Clean up some temporary files:
rm -f /var/run/* /var/run/*/* /var/run/*/*/* /etc/nologin \
  /etc/forcefsck /etc/fastboot 1> /dev/null 2> /dev/null
  ( cd /var/log/setup/tmp && rm -rf * )

# Create a fresh utmp file:
touch /var/run/utmp
chown root:utmp /var/run/utmp
chmod 664 /var/run/utmp

# Update the current kernel level in the /etc/motd (Message Of The Day) file,
# if the first line of that file begins with the word 'Linux'.
# You are free to modify the rest of the file as you see fit.
if [ -x /bin/sed ]; then
  /bin/sed -i "{1s/^Linux.*/$(/bin/uname -sr)\./}" /etc/motd
fi

# If there are SystemV init scripts for this runlevel, run them.
if [ -x /etc/rc.d/rc.sysvinit ]; then
  . /etc/rc.d/rc.sysvinit
fi

# Run serial port setup script:
# CAREFUL!  This can make some systems hang if the rc.serial script isn't
# set up correctly.  If this happens, you may have to edit the file from a
# boot disk, and/or set it as non-executable:
# if [ -x /etc/rc.d/rc.serial ]; then
#   sh /etc/rc.d/rc.serial start
# fi

# Carry an entropy pool between reboots to improve randomness.
if [ -f /etc/random-seed ]; then
  echo "Using /etc/random-seed to initialize /dev/urandom."
  cat /etc/random-seed > /dev/urandom
fi
# Use the pool size from /proc, or 512 bytes:
if [ -r /proc/sys/kernel/random/poolsize ]; then
  dd if=/dev/urandom of=/etc/random-seed count=1 bs=$(cat /proc/sys/kernel/random/poolsize) 2> /dev/null
else
  dd if=/dev/urandom of=/etc/random-seed count=1 bs=512 2> /dev/null
fi
chmod 600 /etc/random-seed

# ======================= /etc/rc.d/rc.6 ========================

#! /bin/sh
#
# /etc/rc.d/rc.6 for test

# Set the path.
PATH=/sbin:/etc:/bin:/usr/bin

echo "Mount at beginning of shutdown..."
/bin/mount

# If there are SystemV init scripts for this runlevel, run them.
if [ -x /etc/rc.d/rc.sysvinit ]; then
  . /etc/rc.d/rc.sysvinit
fi

# Set linefeed mode to avoid staircase effect.
/bin/stty onlcr

echo "Running shutdown script $0:"

# Find out how we were called.
case "$0" in
	*0)
		command="halt"
		;;
	*6)
		command=reboot
		;;
	*)
		echo "$0: call me as \"rc.0\" or \"rc.6\" please!"
		exit 1
		;;
esac

# Run any local shutdown scripts:
if [ -x /etc/rc.d/rc.local_shutdown ]; then
  /etc/rc.d/rc.local_shutdown stop
fi

# Stop the Apache web server:
if [ -x /etc/rc.d/rc.httpd ]; then
  /etc/rc.d/rc.httpd stop
fi

# Stop the MySQL database:
if [ -r /var/run/mysql/mysql.pid ]; then
  . /etc/rc.d/rc.mysqld stop
fi

# Stop the Samba server:
if [ -x /etc/rc.d/rc.samba ]; then
  . /etc/rc.d/rc.samba stop
fi

# Shut down the NFS server:
if [ -x /etc/rc.d/rc.nfsd ]; then
  /etc/rc.d/rc.nfsd stop
fi

# Shut down the SSH server:
if [ -x /etc/rc.d/rc.sshd ]; then
  /etc/rc.d/rc.sshd stop
fi

# Shut down the SASL authentication daemon:
if [ -x /etc/rc.d/rc.saslauthd ]; then
  /etc/rc.d/rc.saslauthd stop
fi

# Shut down OpenLDAP:
if [ -x /etc/rc.d/rc.openldap ]; then
  /etc/rc.d/rc.openldap stop
fi

# Stop D-Bus:
if [ -x /etc/rc.d/rc.messagebus ]; then
  sh /etc/rc.d/rc.messagebus stop
fi

# Kill any processes (typically gam) that would otherwise prevent
# unmounting NFS volumes:
unset FUSER_DELAY
for dir in $(/bin/mount | grep 'type nfs' | cut -d ' ' -f 3 ) ; do
  echo "Killing processes holding NFS mount $dir open..."
  # Background this to prevent fuser from also blocking shutdown:
  /usr/bin/fuser -k -m $dir &
  FUSER_DELAY=5
done
# If fuser was run, let it have some delay:
if [ ! -z "$FUSER_DELAY" ]; then
  sleep $FUSER_DELAY
fi

# Unmount any NFS, SMB, or CIFS filesystems:
echo "Unmounting remote filesystems."
/bin/umount -v -a -l -f -r -t nfs,smbfs,cifs

# Try to shut down pppd:
PS="$(ps ax)"
if echo "$PS" | /bin/grep -q -w pppd ; then
  if [ -x /usr/sbin/ppp-off ]; then
    /usr/sbin/ppp-off
  fi
fi

# Shut down YP services:
if [ -x /etc/rc.d/rc.yp ]; then
  if grep -wq stop /etc/rc.d/rc.yp ; then
    /etc/rc.d/rc.yp stop
  fi
fi

# Bring down the networking system, but first make sure that this
# isn't a diskless client with the / partition mounted via NFS:
if ! /bin/mount | /bin/grep -q 'on / type nfs' ; then
  if [ -x /etc/rc.d/rc.inet1 ]; then
    . /etc/rc.d/rc.inet1 stop
  fi
fi

# In case dhcpcd might have been manually started on the command line,
# look for the .pid file, and shut dhcpcd down if it's found:
if /bin/ls /etc/dhcpc/*.pid 1> /dev/null 2> /dev/null ; then
  /sbin/dhcpcd -k 1> /dev/null 2> /dev/null
  # A little time for /etc/resolv.conf and/or other files to
  # restore themselves.
  sleep 2
fi

# Shut down PCMCIA devices:
if [ -x /etc/rc.d/rc.pcmcia ]; then
  . /etc/rc.d/rc.pcmcia stop
  # The cards might need a little extra time here to deactivate:
  /bin/sleep 5
fi

# Turn off process accounting:
if [ -x /sbin/accton -a -r /var/log/pacct ]; then
  /sbin/accton off
fi

# Terminate acpid before syslog:
if [ -x /etc/rc.d/rc.acpid -a -r /var/run/acpid.pid ]; then # quit
  . /etc/rc.d/rc.acpid stop
fi

# Stop udev:
if [ -x /etc/rc.d/rc.udev ]; then
  sh /etc/rc.d/rc.udev force-stop
fi

/sbin/hwclock --systohc --utc --directisa

# I had problems when killall5 seemed to kill nilfs_cleanerd. 
# Therefore, exclude the gcpids reported by mount from killall5 
# and trust that they are still running.
pidskip=$(mount | sed -ne 's/^.*gcpid=\([0-9][0-9]*\).*$/\1/p' \
  | tr "\n" "," | sed -e 's/,$//')

echo NILFS2 before killall5, using pidskip $pidskip ...
ps ax | grep nilfs | grep -v grep
sleep 1

# Kill all remaining processes.
if [ ! "$1" = "fast" ]; then
  echo "Sending all processes the SIGTERM signal."
  if [ -z $pidskip ]; then
    /sbin/killall5 -15
  else
    /sbin/killall5 -15 -o $pidskip
  fi
  /bin/sleep 5
  echo "Sending all processes the SIGKILL signal."
  if [ -z $pidskip ]; then
    /sbin/killall5 -9
  else
    /sbin/killall5 -9 -o $pidskip
  fi
fi

echo NILFS2 after killall5...
ps ax | grep nilfs | grep -v grep
sleep 1

# Try to turn off quota.
if /bin/grep -q quota /etc/fstab ; then
  if [ -x /sbin/quotaoff ]; then
    echo "Turning off filesystem quotas."
    /sbin/quotaoff -a
  fi
fi

# Carry a random seed between reboots.
echo "Saving random seed from /dev/urandom in /etc/random-seed."
# Use the pool size from /proc, or 512 bytes:
if [ -r /proc/sys/kernel/random/poolsize ]; then
  /bin/dd if=/dev/urandom of=/etc/random-seed count=1 bs=$(cat /proc/sys/kernel/random/poolsize) 2> /dev/null
else
  /bin/dd if=/dev/urandom of=/etc/random-seed count=1 bs=512 2> /dev/null
fi
/bin/chmod 600 /etc/random-seed

# Before unmounting file systems write a reboot or halt record to wtmp.
$command -w

# Clear /var/lock/subsys.
if [ -d /var/lock/subsys ]; then
  rm -f /var/lock/subsys/*
fi

# Turn off swap:
echo "Turning off swap."
/sbin/swapoff -a
/bin/sync

# echo "Issuing nilfs-clean -b for / ."
# /sbin/nilfs-clean -b /dev/sdb12

echo "Unmounting local file systems, except for NILFS2 file systems."
/bin/umount -v -a -t noproc,nosysfs,nonilfs2

echo "Checking mounts before umounting NILFS2 file systems:"
/bin/mount

# Comment out the next two lines to test umount hangs instead of sync hangs.
echo "Issuing sync"
/bin/sync

echo "Unmounting NILFS2 file systems."
/bin/umount -v -a -r -t nilfs2,noproc,nosysfs
# /sbin/hdparm -F /dev/sda /dev/sdb

echo "Remounting root filesystem read-only."
/bin/mount -t nilfs2 -n -o remount,ro /dev/sdb12 /

# This never hurts:
# /bin/sync

# Close any volumes opened by cryptsetup:
if [ -f /etc/crypttab -a -x /sbin/cryptsetup ]; then
  cat /etc/crypttab | grep -v "^#" | grep -v "^$" | while read line; do
    # NOTE: we only support LUKS formatted volumes (except for swap)!
    LUKS=$(echo $line | tr '\t' ' ' | tr -s ' ' | cut -f1 -d' ')
    DEV=$(echo $line | tr '\t' ' ' | tr -s ' ' | cut -f2 -d' ')
    OPTS=$(echo $line | tr '\t' ' ' | tr -s ' ' | cut -f4 -d' ')
    if /sbin/cryptsetup isLuks $DEV 2>/dev/null ; then
      echo "Locking LUKS crypt volume '${LUKS}':"
      /sbin/cryptsetup luksClose ${LUKS}
    elif echo $OPTS | grep -wq swap ; then
      # If any of the volumes was used as encrypted swap,
      # then run mkswap on the underlying device -
      # in case other Linux installations on this computer should use it:
      echo "Erasing encrypted swap '${LUKS}' and restoring normal swap on ${DEV}:"
      /sbin/cryptsetup remove ${LUKS}
      mkswap $DEV
    fi
  done
fi

# Deactivate LVM volume groups:
if [ -r /etc/lvmtab -o -d /etc/lvm/backup ]; then
  echo "Deactivating LVM volume groups:"
  /sbin/vgchange -an --ignorelockingfailure
fi

# This never hurts again (especially since root-on-LVM always fails
# to deactivate the / logical volume...  but at least it was
# remounted as read-only first)
# /sbin/hdparm -F /dev/sda /dev/sdb
/bin/sync

# sleep 3 fixes problems with some hard drives that don't
# otherwise finish syncing before reboot or poweroff
/bin/sleep 3

# This is to ensure all processes have completed on SMP machines:
wait

if [ -x /sbin/genpowerd ]; then
  # See if this is a powerfail situation:
  if /bin/egrep -q "FAIL|SCRAM" /etc/upsstatus 2> /dev/null ; then
    # Signal UPS to shut off the inverter:
    /sbin/genpowerd -k
    if [ ! $? = 0 ]; then
      echo
      echo "There was an error signaling the UPS."
      echo "Perhaps you need to edit /etc/genpowerd.conf to configure"
      echo "the serial line and UPS type."
      # Wasting 15 seconds of precious power:
      /bin/sleep 15
    fi
  fi
fi

# Now halt (poweroff with APM or ACPI enabled kernels) or reboot.
if [ "$command" = "reboot" ]; then
  echo "Rebooting."
  /sbin/reboot
else
  /sbin/poweroff
fi


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
