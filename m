From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] nilfs2: fix issue with potential infinite loop in
 nilfs_mdt_get_block()
Date: Mon, 30 Jun 2014 11:14:20 +0400
Message-ID: <1404112460.2580.16.camel@slavad-CELSIUS-H720>
References: <1404049010.4139.17.camel@slavad-CELSIUS-H720>
	 <20140630.033345.651115405791674896.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=baxlurzVugd+phmZweD1v40zDVC665s4M8SA5VQDzoM=;
	b=f8G6c9YGVL803vsi/HgxheB6qzXJ2MIB3DCf9k4lEocmzjvypuT4VVZx/Yc9tRu8hj6QGZbxUbNHmnrBa+LYilieM1Qr3T6/liorDe0vElPGVjs7S0ScELd9OQahL84V;
In-Reply-To: <20140630.033345.651115405791674896.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Mon, 2014-06-30 at 03:33 +0900, Ryusuke Konishi wrote:
> On Sun, 29 Jun 2014 17:36:50 +0400, Vyacheslav Dubeyko wrote:
> > From: Vyacheslav Dubeyko <Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org>
> > Subject: [PATCH] nilfs2: fix issue with potential infinite loop in nilfs_mdt_get_block()
> > 
> > Potentially, there are situations when nilfs_mdt_read_block() can
> > return -ENOENT and nilfs_mdt_create_block() can return -EEXIST.
> 
> Did you actually see this situation happened ?
> 

Yes, I've caught this issue during testing extended attributes support.
I think that initial reason of the issue is bug in my code. But, anyway,
it is possible to encounter such issue in the future because of some
modification of the code.

> nilfs_mdt_read_block() returns -ENOENT only if nilfs_grab_buffer()
> didn't find a buffer head on page cache and nilfs_bmap_lookup() hit
> a hole block.
> 
> nilfs_mdt_create_block() returns -EEXIST only if nilfs_grab_buffer()
> got a buffer head in uptodate state or nilfs_bmap_insert() failed due
> to an existing block.
> 
> So, these usually don't happen at the same time.  What situation
> do you suppose ?
> 

In brief, I have such situation:

First step - trying to create node.

/* .... */

err = nilfs_palloc_prepare_alloc_entry(xafile, req);

/* .... */

err = nilfs_palloc_get_entry_block(xafile, req->pr_entry_nr, 1,
                                           &req->pr_entry_bh);

/* failure in the code */

nilfs_palloc_abort_alloc_entry(xafile, req);

Second step - trying to create node again.

/* .... */

err = nilfs_palloc_prepare_alloc_entry(xafile, req);

/* .... */

err = nilfs_palloc_get_entry_block(xafile, req->pr_entry_nr, 1,
                                           &req->pr_entry_bh);

I have infinite loop here, in nilfs_palloc_get_entry_block(). Every next
trying to create node results in infinite loop even if I restart system.
So, I suppose that, maybe, there is some issue in
nilfs_palloc_abort_alloc_entry() on the first step. Or, maybe, I am
using nilfs_palloc_prepare_alloc_entry() and
nilfs_palloc_get_entry_block() by means of improper way.

> This function is so primitive to easily change even though the retry
> loop looks an interim implementation of an early date.  I would
> understand what is going on and whole impact of the change.
> 
> > Such situation results in infinite loop inside nilfs_mdt_get_block()
> > method. This patch fixes issue with potential infinite loop in
> > nilfs_mdt_get_block() by means of uncomment limitation of read-create
> > loop retries.
> 
> If this patch is applied, nilfs_mdt_get_block() can return -ENOENT
> even for the case of create == true.  This is unexpected for caller
> functions.  I think we should return proper error code which fits to
> the exceptional situation that causes an infinite repetition (if it
> actually happens).

Yes, maybe, this patch is improper. But, anyway, we need to have some
limitation for repetition. And, of course, it needs to remove this
commented line. So, what your final vision of proper fix for the issue?

Thanks,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
