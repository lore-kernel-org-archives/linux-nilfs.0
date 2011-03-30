From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH] nilfs2: fix oops due to a bad aops initialization
Date: Wed, 30 Mar 2011 20:22:15 +0900 (JST)
Message-ID: <20110330.202215.163256481.ryusuke@osrg.net>
References: <20110330.132555.158630340.ryusuke@osrg.net>
	<4D930F02.4070409@fusionio.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D930F02.4070409-5c4llco8/ftWk0Htik3J/w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: jaxboe-5c4llco8/ftWk0Htik3J/w@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 30 Mar 2011 13:07:46 +0200, Jens Axboe <jaxboe-5c4llco8/ftWk0Htik3J/w@public.gmane.org> wrote:
> On 2011-03-30 06:25, Ryusuke Konishi wrote:
> > diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
> > index 4d2a1ee..9d2dc6b 100644
> > --- a/fs/nilfs2/page.c
> > +++ b/fs/nilfs2/page.c
> > @@ -495,12 +495,14 @@ unsigned nilfs_page_count_clean_buffers(struct page *page,
> >  void nilfs_mapping_init(struct address_space *mapping,
> >  			struct backing_dev_info *bdi)
> >  {
> > +	static const struct address_space_operations empty_aops;
> > +
> >  	mapping->host = NULL;
> >  	mapping->flags = 0;
> >  	mapping_set_gfp_mask(mapping, GFP_NOFS);
> >  	mapping->assoc_mapping = NULL;
> >  	mapping->backing_dev_info = bdi;
> > -	mapping->a_ops = NULL;
> > +	mapping->a_ops = &empty_aops;
> >  }
> 
> Hmm wait, inode init should set the mapping aops to an empty type
> already. Does the OOPS go away if you just remove the mapping->a_ops =
> NULL assignment?
> 
> -- 
> Jens Axboe

Nilfs has two mappings in each inode, one for data pages and another
for btree nodes.  The aops initialization is neede for the latter one.

Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
