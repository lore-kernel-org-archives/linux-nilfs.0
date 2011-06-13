From: Zahid Chowdhury <zahid.chowdhury-VJizFkI/10gAspv4Qr0y0gC/G2K4zDHf@public.gmane.org>
Subject: RE: mount & fsck of nilfs partition fail.
Date: Mon, 13 Jun 2011 14:12:00 -0700
Message-ID: <053D39D3D76C474EB2D2A284AA6BA3181B05E4E167@COLOSSEXCH01.starsolutions.com>
References: <053D39D3D76C474EB2D2A284AA6BA3181B05E4E02D@COLOSSEXCH01.starsolutions.com>
 <20110613.213316.221578492.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110613.213316.221578492.ryusuke-sG5X7nlA6pw@public.gmane.org>
Content-Language: en-US
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello Ryusuke (or anybody else),
  I am no git expert, just looked at the cheatsheet, but I was unable to find your commit which add's a reason to the message below. I tried:
	git pull http://git.nilfs.org/nilfs2-utils-devel.git fsck0:fsck0
	Already up-to-date.
I also tried a re-fetch from scratch. All with no changes showing up in
fsck0.nilfs2.c. If anybody else knows a way for me to pickup Ryusuke's commit, please let me know. Thanks.

Zahid

-----Original Message-----
From: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Ryusuke Konishi
Sent: Monday, June 13, 2011 5:33 AM
To: Zahid Chowdhury
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: mount & fsck of nilfs partition fail.

On Mon, 13 Jun 2011 00:13:17 -0700, Zahid Chowdhury wrote:
> Hello,
>   We had another crash with nilfs2 under load and then on reboot mount failed as usual on
>     "Checksum error in segment payload"
> Leter when we tried an "fsck0.nilfs2 -v -f" on the partition we got:
> .
> .
> .
> Unclean FS.
> The latest log is lost. Trying rollback recovery..
> .
> Searching the latest checkpoint.
> fsck0.nilfs2: cannot read block (blocknr = 2696911)
> 
> and fsck0.nilfs2 gave up. Is there any other way of recovering this partition? If so, how?

Seems an I/O error or some sort of critical error happened.

I pushed a commit to append error reason in the above message.
Could you try it ?  (it's available on the fsck0 branch of the devel tree).

> Is this problem common? Is there any way to stop this scenario from occurring? Thanks.
> 
> Zahid

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
