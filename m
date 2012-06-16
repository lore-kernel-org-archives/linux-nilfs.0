From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: off-line resizing?
Date: Sat, 16 Jun 2012 10:15:23 +0900 (JST)
Message-ID: <20120616.101523.24077441.konishi.ryusuke@lab.ntt.co.jp>
References: <86fw9zw601.fsf@gray.siamics.net>
	<20120614.110607.87804359.konishi.ryusuke@lab.ntt.co.jp>
	<86lijqv7ye.fsf@gray.siamics.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <86lijqv7ye.fsf-Sxm0eyAyORm7AG94EA9mQA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-2022-jp"
To: oneingray-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, 14 Jun 2012 11:22:17 +0700, Ivan Shmakov wrote:
> >>>>> Ryusuke Konishi writes:
> >>>>> On Wed, 13 Jun 2012 23:06:54 +0700, Ivan Shmakov wrote:
>  >> Thus, I'm curious, are there any plans to implement “off-line” NILFS
>  >> resizing?
> 
>  > Implementing Off-line resizing is a bit tough task because it
>  > requires a user space library to read internal meta data of the nilfs
>  > file system and append updated blocks to it.  This is almost
>  > equivalent to implementing kernel functions of nilfs in user land.
> 
>  > So, we have no concrete schedule now.
> 
> 	ACK, thanks.
> 
> 	I wonder, how complicated this task would be?  In particular, do
> 	I need to alter all the segments to resize filesystem, or only
> 	specific ones?  Also, are these internal metadata records just
> 	“a bunch of C structs”, or something more complex?

This needs at least the following tasks:

1) Update two super blocks to increase/decrease the number of total
   segments and the device size. (easy)

2) Update segment usage information to adjust free segment count of
   nilfs_sufile_header struct (sh_ncleansegs) which is written in
   the segment usage file. (Sadly not easy)

3) If truncating in-use segments, relocating blocks and updating
   disk address translation information are also needed. (very hard)


For reference, a discussion on this topic is found in the archives of
the list:

  http://marc.info/?t=128419843600003&r=1&w=2


Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
