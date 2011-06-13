From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: mount & fsck of nilfs partition fail.
Date: Mon, 13 Jun 2011 21:33:16 +0900 (JST)
Message-ID: <20110613.213316.221578492.ryusuke@osrg.net>
References: <053D39D3D76C474EB2D2A284AA6BA3181B05E4E02D@COLOSSEXCH01.starsolutions.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <053D39D3D76C474EB2D2A284AA6BA3181B05E4E02D-ZjuI7xOJlFPnaE3xbIMyWkCiaQ3SRT3KFkJ40O1dFu8@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: zahid.chowdhury-VJizFkI/10gAspv4Qr0y0gC/G2K4zDHf@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

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
