From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH] nilfs2: fix issue with potential infinite loop in
 nilfs_mdt_get_block()
Date: Wed, 02 Jul 2014 03:07:44 +0900 (JST)
Message-ID: <20140702.030744.810086020250066062.konishi.ryusuke@lab.ntt.co.jp>
References: <1404049010.4139.17.camel@slavad-CELSIUS-H720>
	<20140630.033345.651115405791674896.konishi.ryusuke@lab.ntt.co.jp>
	<1404112460.2580.16.camel@slavad-CELSIUS-H720>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=cqchbgS33VDSOAXhqNen3/DC7yNAMAXEV63If2L/rFY=;
        b=WUVonL5ctFsdVsFwyfCPVI9sguvb4pO3BIYtlO2Lf5frsRnefsW9oaUKTrsJYbGXGH
         B2TtmDVGczL7YW1hxMlsfZbgQ1yFbzkq9Z/J34hcdkIrg/eKxe1a8vXvF1AHcoqF83CW
         CG+Se/AvXjxLQWIU+2T+BryX15ESmEYMc8u4FabzAQngRBhTtL8FZMxmlVcgii9V3Jrz
         ywaZasR8CT4TJCKaKJCZmMAP8+DB24En1Xo9wn2vA71lNoXJVHyfJn6cK5N7YHDXEyYA
         1rjTmDirqhehPdA8Kl/WlvZ4H29e1uhqe4Nu2DncQAdLUEjdj8Zz0SngydpNxGUhwbrc
         D4Pg==
In-Reply-To: <1404112460.2580.16.camel@slavad-CELSIUS-H720>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Mon, 30 Jun 2014 11:14:20 +0400, Vyacheslav Dubeyko wrote:
> On Mon, 2014-06-30 at 03:33 +0900, Ryusuke Konishi wrote:
>> On Sun, 29 Jun 2014 17:36:50 +0400, Vyacheslav Dubeyko wrote:
>> nilfs_mdt_read_block() returns -ENOENT only if nilfs_grab_buffer()
>> didn't find a buffer head on page cache and nilfs_bmap_lookup() hit
>> a hole block.
>> 
>> nilfs_mdt_create_block() returns -EEXIST only if nilfs_grab_buffer()
>> got a buffer head in uptodate state or nilfs_bmap_insert() failed due
>> to an existing block.
>> 
>> So, these usually don't happen at the same time.  What situation
>> do you suppose ?
> 
> In brief, I have such situation:
> 
> First step - trying to create node.
> 
> /* .... */
> 
> err = nilfs_palloc_prepare_alloc_entry(xafile, req);
> 
> /* .... */
> 
> err = nilfs_palloc_get_entry_block(xafile, req->pr_entry_nr, 1,
>                                            &req->pr_entry_bh);
> 
> /* failure in the code */
> 
> nilfs_palloc_abort_alloc_entry(xafile, req);
> 
> Second step - trying to create node again.
> 
> /* .... */
> 
> err = nilfs_palloc_prepare_alloc_entry(xafile, req);
> 
> /* .... */
> 
> err = nilfs_palloc_get_entry_block(xafile, req->pr_entry_nr, 1,
>                                            &req->pr_entry_bh);
> 
> I have infinite loop here, in nilfs_palloc_get_entry_block(). Every next
> trying to create node results in infinite loop even if I restart system.
> So, I suppose that, maybe, there is some issue in
> nilfs_palloc_abort_alloc_entry() on the first step. Or, maybe, I am
> using nilfs_palloc_prepare_alloc_entry() and
> nilfs_palloc_get_entry_block() by means of improper way.

Thanks for explaning the situation.  At first glance, your steps
themselves look ok to me.

Let's narrow down the issue first.

The infinite loop is caused by the combination of the following two
behaviors:

 1) nilfs_mdt_read_block() returned -ENOENT that nilfs_bmap_lookup()
    returned.

 2) nilfs_mdt_create_block() returned -EEXIST.
    This function can return -EEXIST in the following two cases.

  2-1) nilfs_bmap_insert() returned -EEXIST.

  2-2) The buffer head gained through nilfs_grab_buffer() was
       up-to-date.

Could you confirm which is happening between 2-1 and 2-2 by inserting
debug code in nilfs_mdt_create_block() ?


> Yes, maybe, this patch is improper. But, anyway, we need to have some
> limitation for repetition. And, of course, it needs to remove this
> commented line. So, what your final vision of proper fix for the issue?

We need to find the root cause of the issue to know proper fix.

Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
