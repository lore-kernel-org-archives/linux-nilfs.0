From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH] nilfs2: add logic for the case of file growing (old
 size <= new size) in nilfs_truncate()
Date: Sat, 27 Apr 2013 02:19:40 +0900 (JST)
Message-ID: <20130427.021940.220060806.konishi.ryusuke@lab.ntt.co.jp>
References: <1366803866.2146.2.camel@slavad-ubuntu>
	<20130425.004815.356918234.konishi.ryusuke@lab.ntt.co.jp>
	<1366883899.3181.26.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1366883899.3181.26.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Thu, 25 Apr 2013 13:58:19 +0400, Vyacheslav Dubeyko wrote:
> On Thu, 2013-04-25 at 00:48 +0900, Ryusuke Konishi wrote:
>> Hi Vyacheslav,
>> On Wed, 24 Apr 2013 15:44:26 +0400, Vyacheslav Dubeyko wrote:
>> > From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
>> > Subject: [PATCH] nilfs2: add logic for the case of file growing (old size <= new size) in nilfs_truncate()
>> > 
>> > There are situations when nilfs_truncate() is called with new value of i_size that is greater than old one. This patch adds logic for such case.
>> > 
>> > Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
>> > CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
>> 
>> Did you confirm that nilfs_truncate has real problem in such situtation?
>> 
> 
> I haven't any reproducing path that can reveal real problem for such
> situation. But I think that, as minimum, it makes sense to return from
> nilfs_truncate() without any activity for the case of blkoff ==
> inode->i_blocks.

block_truncate_page() must be called even if blkoff == inode->i_blocks
because it handles marginal block.

>> I think hole blocks should be appended in that case.
>> 
>> Doesn't the current implementation work so?
>> 
> 
> As I understand, in current NILFS2 implementation nilfs_truncate()
> results in calling nilfs_get_block() with create flag equals by zero.
> The nilfs_get_block() simply returns without any activity for the case
> of file growing:
> 
> 135         } else if (ret == -ENOENT) {
> 136                 /* not found is not error (e.g. hole); must return without
> 137                    the mapped state flag. */
> 138                 ;
> 139         }
> 

That is the desired behavior.

> Suggested implementation calls nilfs_get_block() with create flag equals
> by 1, in result. So, it will allocate the block really. If the real
> allocation is not desirable then I am wrong with suggested
> implementation for the case of blkoff > inode->i_blocks.
> 
> Could you share your vision about it?

As I commented on the previous mail, we don't have to do the real
allocation for the case of blkoff > inode->i_blocks.

We just have to set up inode so that the extended part is regarded as
hole blocks.  Hole blocks are read as null bytes ('\0'), and this
complies with the spec of truncate/ftruncate.

Regards,
Ryusuke Konishi


> With the best regards,
> Vyacheslav Dubeyko.
> 
>> 
>> With regards,
>> Ryusuke Konishi
>> 
>> > ---
>> >  fs/nilfs2/inode.c |   30 ++++++++++++++++++++++++++++++
>> >  1 file changed, 30 insertions(+)
>> > 
>> > diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
>> > index 6b49f14..5ccaace 100644
>> > --- a/fs/nilfs2/inode.c
>> > +++ b/fs/nilfs2/inode.c
>> > @@ -698,6 +698,36 @@ void nilfs_truncate(struct inode *inode)
>> >  
>> >  	blocksize = sb->s_blocksize;
>> >  	blkoff = (inode->i_size + blocksize - 1) >> sb->s_blocksize_bits;
>> > +
>> > +	if (blkoff > inode->i_blocks) {
>> > +		int err;
>> > +		struct address_space *mapping = inode->i_mapping;
>> > +		struct page *page;
>> > +		void *fsdata;
>> > +		loff_t size = inode->i_size;
>> > +
>> > +		err = pagecache_write_begin(NULL, mapping, size, 0,
>> > +						AOP_FLAG_UNINTERRUPTIBLE,
>> > +						&page, &fsdata);
>> > +		if (err) {
>> > +			printk(KERN_ERR
>> > +			    "NILFS: pagecache_write_begin() failed: err %d",
>> > +			    err);
>> > +			return;
>> > +		}
>> > +		err = pagecache_write_end(NULL, mapping, size,
>> > +						0, 0, page, fsdata);
>> > +		if (err < 0) {
>> > +			printk(KERN_ERR
>> > +			    "NILFS: pagecache_write_end() failed: err %d",
>> > +			    err);
>> > +			return;
>> > +		}
>> > +		mark_inode_dirty(inode);
>> > +		return;
>> > +	} else if (blkoff == inode->i_blocks)
>> > +		return;
>> > +
>> >  	nilfs_transaction_begin(sb, &ti, 0); /* never fails */
>> >  
>> >  	block_truncate_page(inode->i_mapping, inode->i_size, nilfs_get_block);
>> > -- 
>> > 1.7.9.5
>> > 
>> > 
>> > 
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
>> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
