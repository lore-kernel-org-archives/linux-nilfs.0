From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH 1/2] nilfs2: add nilfs_sufile_trim_fs to trim clean segs
Date: Thu, 20 Feb 2014 17:12:36 +0900 (JST)
Message-ID: <20140220.171236.372026179.konishi.ryusuke@lab.ntt.co.jp>
References: <0ba40f9a0504b2a228e0714032f82556e03b927e.1392676472.git.andreas.rohner@gmx.net>
	<20140219.033733.321498615.konishi.ryusuke@lab.ntt.co.jp>
	<5304510A.8080006@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5304510A.8080006-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 19 Feb 2014 07:36:58 +0100, Andreas Rohner wrote:
> On 2014-02-18 19:37, Ryusuke Konishi wrote:
>> On Mon, 17 Feb 2014 23:39:51 +0100, Andreas Rohner wrote:
>> 
>> Please try to compile this patch both for 32-bit kernel and 64-bit
>> kernel to test if the patch is architecture independent.
> 
> Ok.
> 
> With all the proper division macros it gets very complicated. I think it
> would simplify things if we just truncate to block size instead of
> sector size. Then we could use simple bit shifts. It would look
> something like this:
> 
> 	if (range->len < nilfs->ns_blocksize ||
> 			range->start >= max_byte)
> 		return -EINVAL;
> 	/* sector_t could be 32 bit */
> 	if (range->len > max_byte)
> 		range->len = max_byte;
> 
> 	sects_per_block = (1 << nilfs->ns_blocksize_bits) /
> 			bdev_logical_block_size(nilfs->ns_bdev);
> 
> 	start_block = (range->start + nilfs->ns_blocksize - 1) >>
> 			nilfs->ns_blocksize_bits;
> 	end_block = start_block + (range->len >>
> 				nilfs->ns_blocksize_bits);
> 
> 	segnum = nilfs_get_segnum_of_block(nilfs, start_block);
> 	end = nilfs_get_segnum_of_block(nilfs, end_block +
> 			nilfs->ns_blocks_per_segment - 1);
> 
> 	minlen = range->minlen >> nilfs->ns_blocksize_bits;
> 
> 
> What do you think?

Yes, sector-based calculations looks a bit complicated.  Your idea,
adjusting positions to fs-block alignment, is reasonable.  I agree
with the approach.

>> So, these will be as follows:
>> 
>> 	u64 len = range->len;
>> 
>> 	...
>> 
>> 	do_div(len, sect_size);
>> 	if (!len)
>> 		goto out;
>> 
>> 	...
>> 	start_sect = DIV_ROUND_UP_ULL(range->start, sect_size);
>> 	end_sect = start_sect + len - 1;  /* this end_sect is inclusive */
> 
> I don't get why this has to be inclusive. To me this seems to be a
> matter of taste. I think it is much easier to reason about this stuff
> and more "natural", if start_sect is inclusive and end_sect is
> exclusive. Then segnum is inclusive and end is exclusive. It is just
> like with pointer arithmetic.

Yes, it is implementation matter (taste).  The above comment just
notice that the result of the calculation is inclusive which differs
from the original meaning.  What I hope there, is that usage of
variables (e.g. the edge is inclusive or exclusive) is taken care to
avoid confusion.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
