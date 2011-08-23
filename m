From: Zahid Chowdhury <zahid.chowdhury-VJizFkI/10gAspv4Qr0y0gC/G2K4zDHf@public.gmane.org>
Subject: RE: mount & fsck of nilfs partition fail.
Date: Tue, 23 Aug 2011 07:15:27 -0700
Message-ID: <053D39D3D76C474EB2D2A284AA6BA3181B060B8E1D@COLOSSEXCH01.starsolutions.com>
References: <053D39D3D76C474EB2D2A284AA6BA3181B05F38A67@COLOSSEXCH01.starsolutions.com>
	<053D39D3D76C474EB2D2A284AA6BA3181B05F390D2@COLOSSEXCH01.starsolutions.com>
	<053D39D3D76C474EB2D2A284AA6BA3181B06066B94@COLOSSEXCH01.starsolutions.com>
 <20110823.120347.178748126.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110823.120347.178748126.ryusuke-sG5X7nlA6pw@public.gmane.org>
Content-Language: en-US
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,
  We are using a Kingspec 16 Gb SSD drive with the SATA i/f from the industrial standard catalog. It is of the MLC variety internally. If you
want more details, it is this part, except ours is 16 Gb:
  http://www.kingspec.com/solid-state-disk-products/ssd-25industsata-imlcj.htm

I still have the failed nilfs & can dual mount it to poke around it, if you
want any further information. I have recently moved on in my development to
another drive and have specifically kept the failed drive for debug
information for the nilfs community. I can still hold on to it for a while more until the reaper of drives wants it back from me. Thanks for any help.

Zahid

-----Original Message-----
From: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Ryusuke Konishi
Sent: Monday, August 22, 2011 8:04 PM
To: Zahid Chowdhury
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: mount & fsck of nilfs partition fail.

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
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
