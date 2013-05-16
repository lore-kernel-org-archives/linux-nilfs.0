From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v3] nilfs2: implement calculation of free inodes count
Date: Thu, 16 May 2013 10:54:45 +0400
Message-ID: <1368687285.2248.6.camel@slavad-ubuntu>
References: <1368624730.2187.8.camel@slavad-ubuntu>
	 <20130516.024602.67896918.konishi.ryusuke@lab.ntt.co.jp>
	 <20130516.075913.157469255.konishi.ryusuke@lab.ntt.co.jp>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=J6gcGz3YjC0PjFi++pcZB9v7TrcNOMfbTOCv9phvSZs=;
	b=hUn8ptU15Yv0NBL61bM/DlJ5Hyz1AR2R4hGsO0QPFkwu1vVbLtfHfTrn+kUw87hmeyVguUkZ3kTe3j9dkVqh6ww/9EH8iBZiD1xGuibD6+wAlh1GMtCj81IccLEXmTOT;
In-Reply-To: <20130516.075913.157469255.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hi Ryusuke,

On Thu, 2013-05-16 at 07:59 +0900, Ryusuke Konishi wrote:

[snip]
> > 
> > This patch still has a potential overflow issue that I pointed out in
> > the previous comment; the patch handles the number of descriptor
> > blocks in 32-bit wide variables without checking its upper limit.
> > 
> > If you won't to add checks for the number of descriptor blocks, I
> > propose you to change the definition of nilfs_palloc_groups_count() instead:
> > 
> >   static inline unsigned long
> >   nilfs_palloc_groups_count(const struct inode *inode)
> >   {
> > - 	return 1UL << (BITS_PER_LONG - (inode->i_blkbits + 3 /* log2(8) */));
> > + 	return nilfs_palloc_groups_per_desc_block(inode) << 32;
> >   }
> > 

I think the real reason of problem is in using constants (BITS_PER_LONG
for the first case and 32 for the second one). But, anyway, it makes
sense to operate by volume size in this calculation. Because namely
volume size is the real limitation for calculation of maximum available
groups count.

What do you think about using volume size in this calculation?

With the best regards,
Vyacheslav Dubeyko.

> > This implies the maximum number of descriptor block is 1 ^ 32.
> > 
> > Because the above diff changes the maximum number of groups, I think
> > it should be inserted as a separate patch.
> 
> Oops, sorry, this change can overflow in 32-bit architectures
> because the type of return value is still unsigned long.
> That calculation should be revised more carefully.
> 
> Ryusuke Konishi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
