From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: [PATCH v3] nilfs2: implement calculation of free inodes count
Date: Fri, 17 May 2013 01:44:52 +0900 (JST)
Message-ID: <20130517.014452.397311903.konishi.ryusuke@lab.ntt.co.jp>
References: <20130516.024602.67896918.konishi.ryusuke@lab.ntt.co.jp>
	<20130516.075913.157469255.konishi.ryusuke@lab.ntt.co.jp>
	<1368687285.2248.6.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1368687285.2248.6.camel@slavad-ubuntu>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Clemens Eisserer <linuxhippy@gmail.com>

On Thu, 16 May 2013 10:54:45 +0400, Vyacheslav Dubeyko wrote:
> Hi Ryusuke,
> 
> On Thu, 2013-05-16 at 07:59 +0900, Ryusuke Konishi wrote:
> 
> [snip]
>> > 
>> > This patch still has a potential overflow issue that I pointed out in
>> > the previous comment; the patch handles the number of descriptor
>> > blocks in 32-bit wide variables without checking its upper limit.
>> > 
>> > If you won't to add checks for the number of descriptor blocks, I
>> > propose you to change the definition of nilfs_palloc_groups_count() instead:
>> > 
>> >   static inline unsigned long
>> >   nilfs_palloc_groups_count(const struct inode *inode)
>> >   {
>> > - 	return 1UL << (BITS_PER_LONG - (inode->i_blkbits + 3 /* log2(8) */));
>> > + 	return nilfs_palloc_groups_per_desc_block(inode) << 32;
>> >   }
>> > 
> 
> I think the real reason of problem is in using constants (BITS_PER_LONG
> for the first case and 32 for the second one). But, anyway, it makes
> sense to operate by volume size in this calculation. Because namely
> volume size is the real limitation for calculation of maximum available
> groups count.
> 
> What do you think about using volume size in this calculation?
> 
> With the best regards,
> Vyacheslav Dubeyko.

I disagree with using volume size because it makes resize logic much
harder especially for shrink logic.  It requires reconstructing of
ifile and DAT meatadata file.

I just want to fix the calculation of the maximum number of groups so
that the number of descriptor blocks doesn't overflow both for 64-bit
and 32-bit architectures.

Regards,
Ryusuke Konishi


>> > This implies the maximum number of descriptor block is 1 ^ 32.
>> > 
>> > Because the above diff changes the maximum number of groups, I think
>> > it should be inserted as a separate patch.
>> 
>> Oops, sorry, this change can overflow in 32-bit architectures
>> because the type of return value is still unsigned long.
>> That calculation should be revised more carefully.
>> 
>> Ryusuke Konishi
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
