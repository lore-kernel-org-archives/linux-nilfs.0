From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v3] nilfs2: implement calculation of free inodes count
Date: Sat, 18 May 2013 03:18:39 +0900 (JST)
Message-ID: <20130518.031839.52209374.konishi.ryusuke@lab.ntt.co.jp>
References: <1368687285.2248.6.camel@slavad-ubuntu>
	<20130517.014452.397311903.konishi.ryusuke@lab.ntt.co.jp>
	<1368774423.2970.5.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1368774423.2970.5.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Fri, 17 May 2013 11:07:03 +0400, Vyacheslav Dubeyko wrote:
> Hi Ryusuke,
> 
> On Fri, 2013-05-17 at 01:44 +0900, Ryusuke Konishi wrote:
>> On Thu, 16 May 2013 10:54:45 +0400, Vyacheslav Dubeyko wrote:
>> > Hi Ryusuke,
>> > 
>> > On Thu, 2013-05-16 at 07:59 +0900, Ryusuke Konishi wrote:
>> > 
>> > [snip]
>> >> > 
>> >> > This patch still has a potential overflow issue that I pointed out in
>> >> > the previous comment; the patch handles the number of descriptor
>> >> > blocks in 32-bit wide variables without checking its upper limit.
>> >> > 
>> >> > If you won't to add checks for the number of descriptor blocks, I
>> >> > propose you to change the definition of nilfs_palloc_groups_count() instead:
>> >> > 
>> >> >   static inline unsigned long
>> >> >   nilfs_palloc_groups_count(const struct inode *inode)
>> >> >   {
>> >> > - 	return 1UL << (BITS_PER_LONG - (inode->i_blkbits + 3 /* log2(8) */));
>> >> > + 	return nilfs_palloc_groups_per_desc_block(inode) << 32;
>> >> >   }
>> >> > 
>> > 
>> > I think the real reason of problem is in using constants (BITS_PER_LONG
>> > for the first case and 32 for the second one). But, anyway, it makes
>> > sense to operate by volume size in this calculation. Because namely
>> > volume size is the real limitation for calculation of maximum available
>> > groups count.
>> > 
>> > What do you think about using volume size in this calculation?
>> > 
>> > With the best regards,
>> > Vyacheslav Dubeyko.
>> 
>> I disagree with using volume size because it makes resize logic much
>> harder especially for shrink logic.  It requires reconstructing of
>> ifile and DAT meatadata file.
>> 
>> I just want to fix the calculation of the maximum number of groups so
>> that the number of descriptor blocks doesn't overflow both for 64-bit
>> and 32-bit architectures.
>> 
> 
> Ok. I see.
> 
> What about such implementation?
> 
> static inline unsigned long
> nilfs_palloc_groups_count(const struct inode *inode)
> {
> #define NILFS_DESC_BLOCKS_MAX UINT_MAX
> 	return nilfs_palloc_groups_per_desc_block(inode) *
> 			(unsigned long)NILFS_DESC_BLOCKS_MAX;
> #undef NILFS_DESC_BLOCKS_MAX
> }

No, the bit width of "unsigned int" and that of "unsigned long" are
the same on 32-bit architectures (i.e. 32 bits).  This function
overflows.

Regards,
Ryusuke Konishi

> With the best regards,
> Vyacheslav Dubeyko.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
