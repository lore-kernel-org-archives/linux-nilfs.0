From: Zahid Chowdhury <zahid.chowdhury-VJizFkI/10gAspv4Qr0y0gC/G2K4zDHf@public.gmane.org>
Subject: RE: nilfs_cleanerd from nilfs-utils shutdown on version 2.0 and 2.1
 does not fail but says nothing and does not clean the old checkpoints nor
 newer (actually older) ones.
Date: Mon, 5 Dec 2011 11:05:48 -0800
Message-ID: <053D39D3D76C474EB2D2A284AA6BA3181F26A4F19B@COLOSSEXCH01.starsolutions.com>
References: <201112031334.30221.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201112031334.30221.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Dexen,
  I did have old cleanerd lock files from the crashed 2.0.23 in /dev/shm. The upgrade to 2.1 was hung on the lock files as you surmised on lock file removal 2.1 cleaned all the checkpoints. My box is using kernel 3.0.4, but I do have quite a few boxes still running kernel 2.6.18 from Centos 5.5 with the nilfs2 kernel mod back-ported to it (i.e. a builtin), so I will need to check if those boxes come out of the wedge of rewinded dates. Thanks a lot.

Zahid

-----Original Message-----
From: dexen deVries [mailto:dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org] 
Sent: Saturday, December 03, 2011 4:34 AM
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Zahid Chowdhury
Subject: Re: nilfs_cleanerd from nilfs-utils shutdown on version 2.0 and 2.1 does not fail but says nothing and does not clean the old checkpoints nor newer (actually older) ones.

Hi Zahid,


On Saturday 03 December 2011 01:33:09 you wrote:
> (...)
> I cannot ever start up the daemon. If I move to a 2.1 daemon, then it logs
> no errors, but it cleans no old or newer (really older) checkpoints - it
> just sits in a do-nothing mode (strace(1) shows he is hung on a
> mq_timedreceive syscall).
> (...)

nilfs_cleanerd creates sort of a lock file in /dev/shm, named `sem.nilfs-
cleanerd-$PID'. nilfs_cleanerd version 2.1 refuses to process a filesystem if 
it has an associated /dev/shm/sem.nilfs-cleanerd-$PID file -- to protect from 
corruption occuring when multiple cleanerds accessed same filesystem. This 
looks in strace as being stuck at mq_timedreceive syscall.

All files in /dev/shm/ disappear after reboot (it's a temporary filesystem) so 
you don't usually see this behavior. However, when you start a new 
nilfs_cleanerd (v2.1) process without reboot, you need to clean relevant file 
by hand. Do ensure the old cleanerd process is dead before deleting the file. 
Otherwise corruption will happen when multiple cleanerd access same 
filesystem.


On Saturday 03 December 2011 01:33:09 you wrote:
>   If I move the system date forward, have some checkpoints created and then
> move the date backward a 2.0 cleanerd daemon fails on this error: Nov 30
> 14:39:37 nilfs_cleanerd[5789]: start
>     Nov 30 14:39:38 kernel: nilfs_ioctl_move_inode_block: conflicting data
>         buffer: ino=4, cno=0, offset=0, blocknr=665655, vblocknr=566462
>     Nov 30 14:39:38 kernel: NILFS: GC failed during preparation: cannot
> read source blocks: err=-17
>     Nov 30 14:39:38 nilfs_cleanerd[5789]: cannot clean segments: File
> exists Nov 30 14:39:38 nilfs_cleanerd[5789]: shutdown
> (...)

I got similar (or same) error with older kernel. Removing all checkpoints with 
rmcp helped -- but that doesn't seem like a 100% reliable solution to me. 
Right now I'm using kernels v3.1 and 3.2-rc3; seem rock-solid.


Regards,
-- 
dexen deVries

> Gresham's Law for Computing:
>   The Fast drives out the Slow even if the Fast is Wrong.

William Kahan in
http://www.cs.berkeley.edu/~wkahan/Stnfrd50.pdf
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
