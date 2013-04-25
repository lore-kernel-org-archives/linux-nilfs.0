From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: Re: [PATCH] nilfs2: add logic for the case of file growing (old
 size <= new size) in nilfs_truncate()
Date: Thu, 25 Apr 2013 13:58:19 +0400
Message-ID: <1366883899.3181.26.camel@slavad-ubuntu>
References: <1366803866.2146.2.camel@slavad-ubuntu>
	 <20130425.004815.356918234.konishi.ryusuke@lab.ntt.co.jp>
Reply-To: slava@dubeyko.com
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=q9cDcV3DBZr6lO6Eu59MxykIIOoFCsfSJ0G10gLxuJs=;
	b=WnZVkBM/DjvNBw2IVoJv/qsmx7HqdeDk0jrksRQIwrbGH4nR6TBx4Um4JpBRmB2/F3jfmI5kGPDEsONkZ09ITsc4OJNRcxxH9du1Q7yWOMAqX7CUNOh1KdKzJRLlxqiA;
In-Reply-To: <20130425.004815.356918234.konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

On Thu, 2013-04-25 at 00:48 +0900, Ryusuke Konishi wrote:
> Hi Vyacheslav,
> On Wed, 24 Apr 2013 15:44:26 +0400, Vyacheslav Dubeyko wrote:
> > From: Vyacheslav Dubeyko <slava@dubeyko.com>
> > Subject: [PATCH] nilfs2: add logic for the case of file growing (old size <= new size) in nilfs_truncate()
> > 
> > There are situations when nilfs_truncate() is called with new value of i_size that is greater than old one. This patch adds logic for such case.
> > 
> > Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
> > CC: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
> 
> Did you confirm that nilfs_truncate has real problem in such situtation?
> 

I haven't any reproducing path that can reveal real problem for such
situation. But I think that, as minimum, it makes sense to return from
nilfs_truncate() without any activity for the case of blkoff ==
inode->i_blocks.

> I think hole blocks should be appended in that case.
> 
> Doesn't the current implementation work so?
> 

As I understand, in current NILFS2 implementation nilfs_truncate()
results in calling nilfs_get_block() with create flag equals by zero.
The nilfs_get_block() simply returns without any activity for the case
of file growing:


135         } else if (ret == -ENOENT) {
136                 /* not found is not error (e.g. hole); must return without
137                    the mapped state flag. */
138                 ;
139         }

Suggested implementation calls nilfs_get_block() with create flag equals
by 1, in result. So, it will allocate the block really. If the real
allocation is not desirable then I am wrong with suggested
implementation for the case of blkoff > inode->i_blocks.

Could you share your vision about it?

With the best regards,
Vyacheslav Dubeyko.

> 
> With regards,
> Ryusuke Konishi
> 
> > ---
> >  fs/nilfs2/inode.c |   30 ++++++++++++++++++++++++++++++
> >  1 file changed, 30 insertions(+)
> > 
> > diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
> > index 6b49f14..5ccaace 100644
> > --- a/fs/nilfs2/inode.c
> > +++ b/fs/nilfs2/inode.c
> > @@ -698,6 +698,36 @@ void nilfs_truncate(struct inode *inode)
> >  
> >  	blocksize = sb->s_blocksize;
> >  	blkoff = (inode->i_size + blocksize - 1) >> sb->s_blocksize_bits;
> > +
> > +	if (blkoff > inode->i_blocks) {
> > +		int err;
> > +		struct address_space *mapping = inode->i_mapping;
> > +		struct page *page;
> > +		void *fsdata;
> > +		loff_t size = inode->i_size;
> > +
> > +		err = pagecache_write_begin(NULL, mapping, size, 0,
> > +						AOP_FLAG_UNINTERRUPTIBLE,
> > +						&page, &fsdata);
> > +		if (err) {
> > +			printk(KERN_ERR
> > +			    "NILFS: pagecache_write_begin() failed: err %d",
> > +			    err);
> > +			return;
> > +		}
> > +		err = pagecache_write_end(NULL, mapping, size,
> > +						0, 0, page, fsdata);
> > +		if (err < 0) {
> > +			printk(KERN_ERR
> > +			    "NILFS: pagecache_write_end() failed: err %d",
> > +			    err);
> > +			return;
> > +		}
> > +		mark_inode_dirty(inode);
> > +		return;
> > +	} else if (blkoff == inode->i_blocks)
> > +		return;
> > +
> >  	nilfs_transaction_begin(sb, &ti, 0); /* never fails */
> >  
> >  	block_truncate_page(inode->i_mapping, inode->i_size, nilfs_get_block);
> > -- 
> > 1.7.9.5
> > 
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


