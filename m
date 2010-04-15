From: "Ed F." <third07-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Response to a Write Error
Date: Wed, 14 Apr 2010 20:46:46 -0400
Message-ID: <j2kf2d3ba1f1004141746n9f914465q3e24d48bec7f990e@mail.gmail.com>
References: <t2kf2d3ba1f1004131638nb61e68cek1ecb43a86c316d35@mail.gmail.com>
	 <20100415.015106.58888665.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:mime-version:received:in-reply-to:references
         :date:received:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        bh=5RaAvB2/4AwbBFzKAHVkyh6gCQRtDIb/dPPJy+eqHXE=;
        b=Ejoau4qcw95cUGwuKULvgtiZqiWYZ48Yj6PBaBPWFUJqTwk5daOsZRbaQ/Zr5kmhCh
         IlePhpQ7o8se0lR85IO7HR1FBFj1gRoXipA7QyrMkedIjiE8Gph03VqdmdA0W0ZBINtc
         l+jY6Ho3bgGju1eq5AEcOASXYyIYSqkU6CInw=
In-Reply-To: <20100415.015106.58888665.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Apr 14, 2010 at 12:51 PM, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wr=
ote:

> I have no idea why the corruption occured since the 2.6.31-20 Ubuntu
> kernel is almost the same with the 2.6.31.y stable kernel.

I believe that the error was caused by accumulated defects on the
DVD-RAM disk, not by NILFS2.  I interpret the error messages to mean
that the DVD drive detected a hardware error when it tried to read
sector 8778160 and then had a write error at sector 8781280 that could
not be correct by the drive because there were no more spare
defect-correction sectors on that particular DVD-RAM disk.

> I'd appreciate it if you could help to test whether the same problem
> arises with nilfs in 2.6.32.y or 2.6.33.y.

The problem does not seem to be repeatable, even on 2.6.31.  I
detected no errors when I previously ran the same general test many
times using both that DVD-RAM and a loop-back file system on a hard
drive.

I will try again when I upgrade to 2.6.32 with Ubuntu 10.04.

> The following are the steps to make&install a newer nilfs in the
> 2.6.31 kernel.
>
> =A0$ sudo apt-get install linux-headers-`uname -r`
> =A0$ cd /usr/src
> =A0$ wget http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.32.11=
=2Etar.bz2
> =A0$ tar jxf linux-2.6.32.11.tar.bz2
> =A0$ cd linux-2.6.32.11/fs/nilfs2
> =A0$ make -C /lib/modules/`uname -r`/build SUBDIRS=3D$PWD BUILD_DIR=3D=
$PWD modules
> =A0$ su
> =A0# rmmod nilfs2
> =A0# mv /lib/modules/`uname -r`/kernel/fs/nilfs2/nilfs2.ko{,.bak}
> =A0# install -m 644 -c nilfs2.ko /lib/modules/`uname -r`/kernel/fs/ni=
lfs2/
> =A0# /sbin/depmod -A
> =A0# mount -t nilfs2 <device> <mount-dir>

Thank you for clarifying that process.  It will be very useful in
keeping the kernel module up-to-date.

> As for the write errors, the following two patches may work:
>
> "nilfs2: use GFP_NOIO for bio_alloc instead of GFP_NOWAIT" (merged to=
 v2.6.32)
> "nilfs2: do not return io error for bio allocation failure" (merged t=
o v2.6.33)
>
> It's hard to track the cause from the raw block data, so you don't
> have to keep the DVD-RAM data. =A0(dumpseg log for in-use segments is
> enough to me)

I will send a segment dump off-list.

If my analysis is correct, I have a DVD-RAM disk that has no more
sectors with which my DVD drive can correct defects.  Would you like
for me to save that disk for future error handling experiments?

Ed
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
