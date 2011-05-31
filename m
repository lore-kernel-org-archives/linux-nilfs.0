From: Dima Tisnek <dimaqq-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: nilfs2 doesn't garbage collect checkpoints for me
Date: Tue, 31 May 2011 15:08:52 -0700
Message-ID: <BANLkTinnpFyrxeO2_DF5gXLgas2WLdqw4Q@mail.gmail.com>
References: <BANLkTim4BBKwFJUzbnsKw0_Ru2k8ZW3MYw@mail.gmail.com>
	<201105262032.54257.dexen.devries@gmail.com>
	<BANLkTimNm6QcNOmc1Gwp2K+SVKoRV8+8Cg@mail.gmail.com>
	<20110527.133803.215389018.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:mime-version:in-reply-to:references:date
         :message-id:subject:from:to:content-type:content-transfer-encoding;
        bh=T84fY3/ByEHLoTYn5vEUP7IAOnNPvO38rIHyiRxxT1M=;
        b=N8KsDEzolchwUpboz75VBu8VVbjDn0p3s+NB4ezerpb/qgvsVV/7c/oJkI+TxA2DX3
         JlZU34z6CFGGK+fYqAFO/O6ZIyDuie8FMBYk8rGUw2flvRUqZo99VIvlqQPjsMtwB+Jh
         oCIrlMdbA0AE48vx15pEnkJK6JMjeiocke0ks=
In-Reply-To: <20110527.133803.215389018.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Ryusuke,

you were right, cleanerd memory usage was the culprit - my accelerated
test runs under virtualbox with only 256M of ram, thus high segment
numbers eat up a large portion of that. I now have nsegments 5 and 10
(mc), and tests run to completion :)

while on the subject, does nilfs have to crash under low memory,
and will it always crash if system is oom?

now my next problem, nilfs interacts rather badly with nbd, I get 100%
system cpu utilization in nbd (as seen in top). I get high cpu usage
with other filesystems too actually, with nilfs it's just much much
worse. whole system becomes completely unresponsive and I can only get
4 small sqlite transactions per second. ext3/nbd gives me at least 10x
more tps.

Can I do anything to help track down this issue?

I tried loopback, that doesn't suit my testcase, as I can't get stats
out of loopback device.
nilfs/loop works fine most of the time, but becomes sluggish (still
usable) when cleanerd has to do some work.

d.

On 26 May 2011 21:38, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org> w=
rote:
> Hi,
> On Thu, 26 May 2011 13:24:22 -0700, Dima Tisnek wrote:
>> Hi Dexen,
>>
>> you were spot on, protection time was the culprit.
>>
>> while on the subject, I can see many cases where more is written to
>> the disk in 1h than there is free space (my problem was than entire
>> disk, but it's equivalent), are there any plans to collect earlier
>> rather than enfore protection time when running low on disk?
>>
>> now I set cleaner like this (for accelerated testing):
>>
>> protection_period =C2=A0 =C2=A0 =C2=A0 1
>> min_clean_segments =C2=A0 =C2=A0 =C2=A010%
>> max_clean_segments =C2=A0 =C2=A0 =C2=A090%
>> clean_check_interval =C2=A0 =C2=A01
>> selection_policy =C2=A0 =C2=A0 =C2=A0 =C2=A0timestamp =C2=A0 =C2=A0 =
=C2=A0 # timestamp in ascend order
>> nsegments_per_clean =C2=A0 =C2=A0 10
>> mc_nsegments_per_clean =C2=A0100
>> cleaning_interval =C2=A0 =C2=A0 =C2=A0 10
>> mc_cleaning_interval =C2=A0 =C2=A01
>> retry_interval =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A010
>> use_mmap
>> log_priority =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0info
>>
>> I know some settings are ridiculous, do tell me if I did something
>> completely insane :)
>
> The maximum value of nsegments_per_clean and mc_nsegments_per_clean i=
s
> is 32, and it is cut to the value if greater than that.
>
> Setting a large value for these parameters is actually not sane
> because cleaning one segment consumes 8MB kernel memory at maximum.
> Decreasing cleaning intervals is better way.
>
> But, unfortunately cleaner daemon does not handle subsecond value for
> these parameters.
>
>> same test (~150K disk traffic per transaction, 10 transactions a
>> second), eventually system begins to swap and then nilfs2 dies leavi=
ng
>> this in dmesg:
>>
>> [66598.373596] nilfs_cleanerd: page allocation failure. order:0, mod=
e:0x50
>> [66598.373596] Pid: 30708, comm: nilfs_cleanerd Tainted: G =C2=A0 =C2=
=A0 =C2=A0 =C2=A0W
>> 2.6.38-ARCH #1
>> [66598.373596] Call Trace:
>> [66598.373596] =C2=A0[<c10c563c>] ? __alloc_pages_nodemask+0x54c/0x7=
50
>> [66598.373596] =C2=A0[<c10ffab8>] ? mem_cgroup_charge_common+0x68/0x=
b0
>> [66598.373596] =C2=A0[<c10bf923>] ? find_or_create_page+0x43/0x90
>> [66598.373596] =C2=A0[<d2344733>] ? nilfs_grab_buffer+0x33/0xc0 [nil=
fs2]
>> [66598.381684] nbd4: Attempted send on closed socket
>> [66598.381684] end_request: I/O error, dev nbd4, sector 461512
>> [66598.394594] nbd4: Attempted send on closed socket
>> [66598.394594] end_request: I/O error, dev nbd4, sector 461760
>> [66598.394594] nbd4: Attempted send on closed socket
>> [66598.394594] end_request: I/O error, dev nbd4, sector 462008
>> [66598.404089] =C2=A0[<d2357bcc>] ?
>> nilfs_gccache_submit_read_data+0x2c/0x140 [nilfs2]
>> [66598.404089] =C2=A0[<d2358573>] ?
>> nilfs_ioctl_clean_segments.isra.8+0x2e3/0x7a0 [nilfs2]
>> [66598.404089] =C2=A0[<d2348d09>] ? nilfs_btree_do_lookup+0x1f9/0x29=
0 [nilfs2]
>> [66598.404089] =C2=A0[<d2358e36>] ? nilfs_ioctl+0x1f6/0x40c [nilfs2]
>> [66598.404089] =C2=A0[<c1033b14>] ? finish_task_switch+0x34/0xb0
>> [66598.404089] =C2=A0[<c13192cd>] ? schedule+0x28d/0x9e0
>> [66598.404089] =C2=A0[<d2358c40>] ? nilfs_ioctl+0x0/0x40c [nilfs2]
>> [66598.407101] nbd4: Attempted send on closed socket
>> [66598.407101] end_request: I/O error, dev nbd4, sector 462256
>> [66598.407101] nbd4: Attempted send on closed socket
>> [66598.407101] end_request: I/O error, dev nbd4, sector 462504
>> [66598.407101] nbd4: Attempted send on closed socket
>> [66598.407101] end_request: I/O error, dev nbd4, sector 462752
>> [66598.430221] =C2=A0[<c1113b99>] ? do_vfs_ioctl+0x79/0x570
>> [66598.430221] =C2=A0[<c11ac164>] ? copy_to_user+0x34/0x50
>> [66598.430221] =C2=A0[<c11140f7>] ? sys_ioctl+0x67/0x80
>> [66598.430221] =C2=A0[<c131c360>] ? syscall_call+0x7/0xb
>> [66598.430221] Mem-Info:
>> [66598.430221] DMA per-cpu:
>> [66598.430221] CPU =C2=A0 =C2=A00: hi: =C2=A0 =C2=A00, btch: =C2=A0 =
1 usd: =C2=A0 0
>> [66598.430221] Normal per-cpu:
>> [66598.430221] CPU =C2=A0 =C2=A00: hi: =C2=A0 90, btch: =C2=A015 usd=
: =C2=A011
>> [66598.430221] active_anon:0 inactive_anon:1 isolated_anon:0
>> [66598.430221] =C2=A0active_file:28328 inactive_file:28550 isolated_=
file:128
>> [66598.430221] =C2=A0unevictable:0 dirty:0 writeback:0 unstable:0
>> [66598.430221] =C2=A0free:0 slab_reclaimable:2787 slab_unreclaimable=
:1104
>> [66598.430221] =C2=A0mapped:1 shmem:0 pagetables:27 bounce:0
>> [66598.430221] DMA free:0kB min:120kB low:148kB high:180kB
>> active_anon:0kB inactive_anon:4kB active_file:5984kB
>> inactive_file:7032kB unevictable:0kB isolated(anon):0kB
>> isolated(file):0kB present:15804kB mlocked:0kB dirty:0kB writeback:0=
kB
>> mapped:0kB shmem:0kB slab_reclaimable:2876kB slab_unreclaimable:8kB
>> kernel_stack:8kB pagetables:0kB unstable:0kB bounce:0kB
>> writeback_tmp:0kB pages_scanned:18118 all_unreclaimable? yes
>> [66598.430221] lowmem_reserve[]: 0 238 238 238
>
> This log actually shows that the kernel memory shortage happened.
>
> You should decrease mc_nsegments_per_clean at least less than 32.
>
> Well, I'll consider changing the parser routine to allow subsecond
> values for the interval parameters.
>
> Thanks,
> Ryusuke Konishi
>
>
>> if you give me some hints and I will try again tomorrow :)
>>
>> Dima Tisnek
>>
>> On 26 May 2011 11:32, dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> > Hi,
>> >
>> >
>> > On Thursday 26 of May 2011 20:11:55 you wrote:
>> >> I'm testing nilfs2 and other fs's for use on cheap flash cards, t=
rying
>> >> to avoid writing same location all the time.
>> >
>> > I'm using nilfs2 on a small server with a cheap-o 16GB SSD extract=
ed from
>> > Eeepc for the same reason; works great.
>> >
>> >
>> >
>> >> My test program makes lots of small sqlite transactions which sql=
ite
>> >> syncs to disk.
>> >> In less than 2000 transaction 1GB nilfs2 volume ran out of disk s=
pace.
>> >> tried unmount, mount again, didn't help
>> >> block device is nbd, works with with other fs's
>> >>
>> >> lscp shows there are 7121 checkpoints and somehow old ones are no=
t
>> >> removed automatically.
>> >
>> > First off, the default configuration of nilfs_cleanerd is to keep =
all
>> > checkpoints for at least one hour (3600 seconds). See file
>> > /etc/nilfs_cleanerd.conf, option `protection_period'. For testing =
you may want
>> > to change the protection period to just a few seconds and see if t=
hat helps.
>> > Either via the config file (and issue a SIGHUP so it reloads the c=
onfig) or via
>> > the `-p SECONDS' argument (see manpage).
>> >
>> > To see what's going on, you may want to change (temporarily) the
>> > `log_priority' in config file to `debug'; in /var/log/debug you sh=
ould then see
>> > statements describing actions of the nilfs_cleanerd.
>> >
>> >
>> > Example:
>> >
>> > May 26 20:23:53 blitz nilfs_cleanerd[3198]: wake up
>> > May 26 20:23:53 blitz nilfs_cleanerd[3198]: ncleansegs =3D 1175
>> > May 26 20:23:53 blitz nilfs_cleanerd[3198]: 4 segments selected to=
 be cleaned
>> > May 26 20:23:53 blitz nilfs_cleanerd[3198]: protected checkpoints =
=3D
>> > [156725,157003] (protection period >=3D 1306430633)
>> > May 26 20:23:53 blitz nilfs_cleanerd[3198]: segment 1844 cleaned
>> > May 26 20:23:53 blitz nilfs_cleanerd[3198]: segment 1845 cleaned
>> > May 26 20:23:53 blitz nilfs_cleanerd[3198]: segment 1846 cleaned
>> > May 26 20:23:53 blitz nilfs_cleanerd[3198]: segment 1847 cleaned
>> > May 26 20:23:53 blitz nilfs_cleanerd[3198]: wait 0.488223000
>> >
>> >
>> > where the `ncleansegs' is the number of clean (free) segments you =
already
>> > have, and `protected checkpoints' indicates range of checkpoint nu=
mbers that
>> > are still under protection (due to the `protection_period' setting=
)
>> >
>> >
>> > In any case, my understanding is that in typical DB, each transact=
ion (which
>> > may be each command, if you don't begin/commit transaction explici=
tly) causes
>> > an fsync() which creates a new checkpoint. On a small drive that *=
may* cause
>> > creation of so many checkpoints in a short time they don't get GC'=
d before the
>> > drive fills up. Not sure yet how to work around that.
>> >
>> >
>> >
>> > Two more possible sources of the problem:
>> > 1) GC used to break in certain scenario: the FS could become inter=
nally
>> > inconsistent (no data loss, but it wouldn't perform GC anymore) if=
 two or more
>> > nilfs_cleanerds were processing it at the same time. It's probably=
 fixed with
>> > the most recent patches. To check if that's the case, see output o=
f `dmesg'
>> > command; it would indicate problems in NILFS.
>> >
>> > 2) new `nilfs_cleanerd' process may become stuck on semaphore if y=
ou kill the
>> > old one hard =C2=A0(for example, kill -9). That used to leave aux =
file in /dev/shm/,
>> > like /dev/shm/sem.nilfs-cleaner-2067. To check if that's the case,=
 run
>> > nilfs_cleanred through strace, like:
>> >
>> > # strace -f nilfs_cleanerd /dev/YOUR_FILESYSTEM
>> >
>> > if it hangs at one point on futex() call, that's it. A brute-force=
, but sure-
>> > fire way is to kill all instances of nilfs_cleanerd and remove fil=
es matching
>> > /dev/shm/sem.nilfs-cleaner-*
>> >
>> >
>> > Hope that helps somehow~
>> >
>> >
>> > --
>> > dexen deVries
>> >
>> > ``One can't proceed from the informal to the formal by formal mean=
s.''
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-ni=
lfs" in
>> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> > More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info=
=2Ehtml
>> >
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-nilf=
s" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
