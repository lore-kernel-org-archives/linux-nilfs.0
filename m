From: "Yongkun Wang" <yongkun-b/Nwfc8pyCekRP3n4FtbsiGn5s73+xxf@public.gmane.org>
Subject: RE: Writes doubled by NILFS2
Date: Wed, 21 Apr 2010 23:41:13 +0900
Message-ID: <00df01cae160$b1195d60$134c1820$@iis.u-tokyo.ac.jp>
References: <j2kf2d3ba1f1004141746n9f914465q3e24d48bec7f990e@mail.gmail.com>	<20100416.213151.77349735.ryusuke@osrg.net>	<00c901cae064$f42b4bb0$dc81e310$@iis.u-tokyo.ac.jp> <20100420.204523.76757028.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100420.204523.76757028.ryusuke-sG5X7nlA6pw@public.gmane.org>
Content-Language: en-us
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: 'Ryusuke Konishi' <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

hi, Ryusuke,

Thank you for the reply.

It's O_SYNC.

The dumpseg and lssu are useful tools. The description of the structure in
the slides is very clear. 
Thank you for the hint of checking the meta data.

The information by dumpseg:

# dumpseg 698 | grep ino
      ino = 12, cno = 9, nblocks = 1356, ndatblk = 1343
      ino = 6, cno = 9, nblocks = 1, ndatblk = 1
      ino = 4, cno = 0, nblocks = 1, ndatblk = 1
      ino = 5, cno = 0, nblocks = 2, ndatblk = 2
      ino = 3, cno = 0, nblocks = 681, ndatblk = 681

File with inode 12 (ino=12) is the data file. "nblocks" is the number of
occupied blocks, right?

In this segment, the number of data file blocks is 1356, and the number of
the rest of the blocks is 685 (1+1+2+681).
Total 685 "overhead" blocks in this segment?

This may explain the additional writes in our trace.

Best Regards,
Yongkun

-----Original Message-----
From: Ryusuke Konishi [mailto:ryusuke-sG5X7nlA6pw@public.gmane.org] 
Sent: Tuesday, April 20, 2010 8:45 PM
To: yongkun-b/Nwfc8pyCekRP3n4FtbsiGn5s73+xxf@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: Writes doubled by NILFS2

Hi,
On Tue, 20 Apr 2010 17:39:13 +0900, "Yongkun Wang"
<yongkun-b/Nwfc8pyCekRP3n4FtbsiGn5s73+xxf@public.gmane.org> wrote:
> Hey, guys,
> 
> We have a database system, the data is stored on the disk formatted with
> NILFS2 (nilfs-2.0.15, kmod-nilfs-2.0.5-1.2.6.18_92.1.22.el5.x86_64).
> 
> I have run a trace at the system call level and the block IO level, that
is,
> tracing the requests before processed by NILFS2 and after processed by
> NILFS2.
> 
> We use synchronous IO. So the amount of writes at the two trace points
> should be equal. 
> It is true when we use EXT2 file system.
> 
> However, for NILFS2, we found that the writes have been doubled, that is,
> the amount of writes is doubled after processed by NILFS2. The amount of
> writes at the system call level is equal between EXT2 and NILFS2. 

Interesting results.  What kind of synchronous write did you use in
the measurement ?  fsync? or O_SYNC writes ?
 
> Since all the address are log-structured, it is hard to know what are the
> additional writes.
>
> Can you provide some hints on the additional writes? Is it caused by some
> special functions such as snapshot?

You can look into the logs with dumpseg(8) command:

 # dumpseg <segment number>

This shows summary of blocks written in the specified segment. lssu(1)
command would be of help for finding a log head.


In the dump log, files with inode number 3,4,5,6 are metadata.  The
log format is depicted in the page 10 of the following slides:

  http://www.nilfs.org/papers/jls2009-nilfs.pdf


In general, copy-on-write filesystems including lfs are said to incur
overheads by metadata writes especially for synchronous writes.

I guess small-sized fsyncs or O_SYNC writes are causing the overhead.

Thanks,
Ryusuke

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
