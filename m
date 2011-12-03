From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: nilfs_cleanerd from nilfs-utils shutdown on version 2.0 and 2.1 does not fail but says nothing and does not clean the old checkpoints nor newer (actually older) ones.
Date: Sat, 3 Dec 2011 13:34:29 +0100
Message-ID: <201112031334.30221.dexen.devries@gmail.com>
References: <053D39D3D76C474EB2D2A284AA6BA3181F26A4F05D@COLOSSEXCH01.starsolutions.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:references:in-reply-to:x-face:cc
         :mime-version:content-type:content-transfer-encoding:message-id;
        bh=GUHSzxQICriPKBQDvsvJQfmBCWyxcKVHYL0ZpKwLHaY=;
        b=vnJ1ay4lCPIKZ+921Xmempc2K+uTyuWd77nDiO1pAnSng7Z9wOvgv46W0FdDaWGlzL
         hEANv7oBdi7Six5Cvz8lzeoIbAtEsp2YXQZ38hKZGAHdvubYPSKzYUG5Bsnu/TK2CymS
         kAxXYFfpH/fTZS4dNUzfUX17o34yS3TgfT7VQ=
In-Reply-To: <053D39D3D76C474EB2D2A284AA6BA3181F26A4F05D-ZjuI7xOJlFPnaE3xbIMyWkCiaQ3SRT3KFkJ40O1dFu8@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="windows-1252"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Zahid Chowdhury <zahid.chowdhury-VJizFkI/10gAspv4Qr0y0gC/G2K4zDHf@public.gmane.org>

Hi Zahid,


On Saturday 03 December 2011 01:33:09 you wrote:
> (...)
> I cannot ever start up the daemon. If I move to a 2.1 daemon, then it=
 logs
> no errors, but it cleans no old or newer (really older) checkpoints -=
 it
> just sits in a do-nothing mode (strace(1) shows he is hung on a
> mq_timedreceive syscall).
> (...)

nilfs_cleanerd creates sort of a lock file in /dev/shm, named `sem.nilf=
s-
cleanerd-$PID'. nilfs_cleanerd version 2.1 refuses to process a filesys=
tem if=20
it has an associated /dev/shm/sem.nilfs-cleanerd-$PID file -- to protec=
t from=20
corruption occuring when multiple cleanerds accessed same filesystem. T=
his=20
looks in strace as being stuck at mq_timedreceive syscall.

All files in /dev/shm/ disappear after reboot (it's a temporary filesys=
tem) so=20
you don't usually see this behavior. However, when you start a new=20
nilfs_cleanerd (v2.1) process without reboot, you need to clean relevan=
t file=20
by hand. Do ensure the old cleanerd process is dead before deleting the=
 file.=20
Otherwise corruption will happen when multiple cleanerd access same=20
filesystem.


On Saturday 03 December 2011 01:33:09 you wrote:
>   If I move the system date forward, have some checkpoints created an=
d then
> move the date backward a 2.0 cleanerd daemon fails on this error: Nov=
 30
> 14:39:37 nilfs_cleanerd[5789]: start
>     Nov 30 14:39:38 kernel: nilfs_ioctl_move_inode_block: conflicting=
 data
>         buffer: ino=3D4, cno=3D0, offset=3D0, blocknr=3D665655, vbloc=
knr=3D566462
>     Nov 30 14:39:38 kernel: NILFS: GC failed during preparation: cann=
ot
> read source blocks: err=3D-17
>     Nov 30 14:39:38 nilfs_cleanerd[5789]: cannot clean segments: File
> exists Nov 30 14:39:38 nilfs_cleanerd[5789]: shutdown
> (...)

I got similar (or same) error with older kernel. Removing all checkpoin=
ts with=20
rmcp helped -- but that doesn't seem like a 100% reliable solution to m=
e.=20
Right now I'm using kernels v3.1 and 3.2-rc3; seem rock-solid.


Regards,
--=20
dexen deVries

> Gresham=E2=80=99s Law for Computing:
>   The Fast drives out the Slow even if the Fast is Wrong.

William Kahan in
http://www.cs.berkeley.edu/~wkahan/Stnfrd50.pdf
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
