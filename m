From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: mount & fsck of nilfs partition fail.
Date: Tue, 23 Aug 2011 12:03:47 +0900 (JST)
Message-ID: <20110823.120347.178748126.ryusuke@osrg.net>
References: <053D39D3D76C474EB2D2A284AA6BA3181B05F38A67@COLOSSEXCH01.starsolutions.com>
	<053D39D3D76C474EB2D2A284AA6BA3181B05F390D2@COLOSSEXCH01.starsolutions.com>
	<053D39D3D76C474EB2D2A284AA6BA3181B06066B94@COLOSSEXCH01.starsolutions.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <053D39D3D76C474EB2D2A284AA6BA3181B06066B94-ZjuI7xOJlFPnaE3xbIMyWkCiaQ3SRT3KFkJ40O1dFu8@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: zahid.chowdhury-VJizFkI/10gAspv4Qr0y0gC/G2K4zDHf@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 8 Aug 2011 14:33:55 -0700, Zahid Chowdhury wrote:
> Hello Ryusuke/nilfs kernel developers,
>   Can you please let me know if I should keep the corrupted nilfs
>   filesystem described below for nilfs bug fixes, or if no solution
>   exists for this corruption. If it is the latter then, I will
>   backup, repartition the filesystem, and then finally restore the
>   filesystem and continue my work. Thanks.
> 
> Zahid

Sorry for my late reply and the repetitive trouble of yours.

The error log says btree of DAT file broke.  I reviewed the btree
code, but haven't yet found any related issues so far.

It's hard to track the root cause from this kind of situation.
So, please reformat the filesystem and continue your work.

By the way, what kind of device are you using?  Is it a flash device
or a pendrive ?   Please tell me the product name If you don't mind.


Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
