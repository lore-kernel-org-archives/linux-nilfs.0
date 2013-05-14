From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2] nilfs2: implement calculation of free inodes count
Date: Tue, 14 May 2013 10:50:54 +0400
Message-ID: <1368514254.2739.9.camel@slavad-ubuntu>
References: <1368446091.2229.9.camel@slavad-ubuntu>
	 <20130514.031840.27794271.konishi.ryusuke@lab.ntt.co.jp>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=hK3qAIFTh78bLJyjQGT4+3J5QFuSeCILGFWg7mNJ1l4=;
	b=OBe+hG6s/dQ3Ks7GzSGKdxNF+7HMWuiZb4miBbx3DzYlavJkyLxOIPEO/Z3WIi3Mxvb1LbQduaK706WFB3vA4ZOatyc4Q8bGrIAZkQ0/qWfGrFbyCwVDd2qok/eb65kw;
In-Reply-To: <20130514.031840.27794271.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hi Ryusuke,

On Tue, 2013-05-14 at 03:18 +0900, Ryusuke Konishi wrote:

[snip]
>  
> >  /**
> > + * nilfs_palloc_count_max_entries - count max number of entries that can be
> > + *					described by @desc_blocks
> > + * @inode: inode of metadata file using this allocator
> > + * @desc_blocks: descriptor blocks count
> > + */
> > +u64 nilfs_palloc_count_max_entries(struct inode *inode,
> > +				    unsigned int desc_blocks)
> 
> The logical upper limit of descriptor block count is 2 ^ 43 (in the
> case of 64-bit architecture), so the desc_blocks argument should have
> unsigned long type.
> 

I think that in real world the int type will be enough for descriptor
blocks count. Moreover, I use atomic_t type for storing knowledge about
current known descriptor blocks count in nilfs_mdt_info structure. If
you insist on using unsigned long type then atomic_t type is not good
choice. But do you really think that we have to use the unsigned long
type for descriptor blocks count?

With the best regards,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
