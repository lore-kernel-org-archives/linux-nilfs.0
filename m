From: "Michael L. Semon" <mlsemon35-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 0/5] nilfs-utils: skip inefficient gc operations
Date: Wed, 22 Jan 2014 18:46:43 -0500
Message-ID: <52E05863.90604@gmail.com>
References: <cover.1390310509.git.andreas.rohner@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        bh=KF4aapSzfsjAtuwTwe2ySjzfZ1ZmYDop2J2hZKIagRI=;
        b=qUkg4ilybzFZWMCsjwAEJcA8pDYNV9hGzrnB33H3lhGf65fF/OzTupuJ48qlx+Iw2c
         xrJnXNBMxTXT9VHl4NgEiZMqVlQkayE/K7l7I//lM7JZ5jRFsivHe3pPEeC6piDrleqP
         IYVMn7HGYj9LybaRNIKl/8v0HQHoGG7wmfHkf0zydLXE2EjC7ncvurld2UgGxJa/atkw
         NwHdXqJDQEfuPz8s5wS7DObKKSGrckl9AE6jvXqdKE4d0RhiXA0XlyjCSy6ZmYXqiU5F
         MLVPlnqDd8yzvcowsj8kps5RljYswK/8M/mAQXhNnrYyxq+pNUTTbX2fjM7vjxTr6z/l
         7dLw==
In-Reply-To: <cover.1390310509.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 01/21/2014 08:59 AM, Andreas Rohner wrote:
> Hi,
> 
> This is the second version of this patch set. It replaces the kind of 
> hacky use of v_flags with a proper implementation of 
> NILFS_IOCTL_SET_SUINFO ioctl.
> 
> v1->v2
> * Implementation of NILFS_IOCTL_SET_SUINFO
> * Added mc_min_free_blocks_threshold config option
>   (if clean segments < min_clean_segments)
> * Added new command line param for nilfs-clean
> * Update man- and config-files
> * Simpler benchmark
> 
> This patch set implements a small new feature and there shouldn't be
> any compatibility issues. It enables the GC to check how much free
> space can be gained from cleaning a segment and if it is less than a
> certain threshold it will abort the operation and try a different
> segment. Although no blocks need to be moved, the SUFILE entry of the
> corresponding segment needs to be updated to avoid an infinite loop.

As a user (not a NILFS2 developer), I'll have to live with this one for 
a while to see how well I like it.  On x86, xfstests went well for my 
debug DEBUG_PAGEALLOC CONFIG_AIO=n kernel 3.13.0+, no obvious 
before/after changes in speed, but no crashes, either.  I hit a glitch 
with Vyacheslav's xattr/ACL pages on 2k blocksize filesystems, so I'll 
have to test smaller block sizes at a later time.

So that's your warning: small block sizes and POSIX AIO were not tested 
by me.  If you don't have xfstests, get it.  It's useful for finding 
bugs and regressions in filesystems.

Not having your super-secret test suite or disk space to run it, I 
went the other direction, using the commonly available fs_mark utility 
to make many tiny writes with 16 threads.  My initial opinion is that 
your new GC code fixes some obvious lag when a filesystem is populated 
and nilfs_cleanerd starts to do its work.  However, for reasons of code 
or simple mathematics, the file system hits end-of-space a bit earlier 
than does the unpatched code.  I'll have to build some kernels, live 
with the system, and otherwise generate lots of checkpoints to know if 
this is a problem.  IOW, I need to find out for myself if I need to 
make a slightly larger filesystem to do the same things using a patched 
NILFS2.

Thanks!

Michael

[sample collection of data from fs_mark below]

File/sec Output from this fs_mark command (two different runs)...

fs_mark -d /mnt/xfstests-test/test -F -D 16 -t 16 -n 150 -s 28672 -w 4096

...generates the following numbers for comparison:

FILES   OLD     NEW
2400    219.4   222.3
4800    210.5   217.9
7200    216.7   212
9600    216     213
12000   216.1   213.1
14400   215.5   213.4
16800   213.5   215.4
19200   212.5   214.9
21600   214.2   209.6
24000   212     200
26400   191.6   194.4
28800   211.3   208.6
31200   193.8   190.6
33600   188.2   174.6
36000   139.7   192.2
38400    78.9   204.9
40800   110.6   188.8
43200    73.8   205.9
45600    75.7   205.7
48000    76     190.4
50400   115.4   187
52800   180.8   190.6
55200   192.4   202
57600   158.3   206.8
60000   201.7   189.1
62400   174.8   200.7
64800   170     189.2
67200   203.3   187.7
69600   174.8   175
72000   150.9   174.3
74400   141.7   175.6
76800   199.5   174.6
79200   180.2   174.9
81600    66.8    77.1
84000    40.8    76.6
86400    67.3    86.9
88800    59.3    77.1
91200   127.1
93600   113.5
96000   110.1
98400   112.6
100800   75.5
103200   58
105600   53.8
108000   45.2
110400   45.9
112800   48.2

The test partition is a 4-GB MD RAID-0 partition, 64k chunk size, 
on old, damaged spinning rust HDDs and old x86 hardware.  GC issues 
show up well when using small writes and small file sizes, at least 
on this hardware.  If this test moves more quickly on your hardware 
(it should), try to increase the threads before increasing other 
parameters.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
