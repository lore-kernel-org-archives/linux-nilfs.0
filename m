From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: [PATCH v3] nilfs2: implement calculation of free inodes count
Date: Sat, 18 May 2013 20:33:55 +0900 (JST)
Message-ID: <20130518.203355.212404241.konishi.ryusuke@lab.ntt.co.jp>
References: <20130517.014452.397311903.konishi.ryusuke@lab.ntt.co.jp>
	<1368774423.2970.5.camel@slavad-ubuntu>
	<20130518.031839.52209374.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20130518.031839.52209374.konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Clemens Eisserer <linuxhippy@gmail.com>

Hi Vyacheslav,

I reconsidered upper limit number of each parameter in the persistent
object allocator, and reached a conclusion that the current
implementation of nilfs_palloc_groups_count function below and other
routines are consistent and reasonable.

 static inline unsigned long
 nilfs_palloc_groups_count(const struct inode *inode)
 {
 	return 1UL << (BITS_PER_LONG - (inode->i_blkbits + 3 /* log2(8) */));
 }

The basic idea of the following nilfs_palloc_groups_count() routine is
to represent serial number of objects (e.g. inode number, virtual
block number) with an unsigned long type.

The entry number is addressed with a group number, which is the upper
part of "unsigned long", and per-group offset number at the lower
part.

For instance, the entry number consists of 17 bits group number and 15
bit per-group offset number in the case of 32 bit OS and 4kB block
format:


  MSB                                    LSB
  31                  15 14               0
  +---------------------+------------------+
  |  Group number       | Per-group offset |
  |                     | number of entry  |
  +---------------------+------------------|
  |  Entry number (e.g. inode number,      |
  |        virtual block number,...)       |
  +----------------------------------------+

Then, number of entries per group, maximum number of groups,
and maximum number of descriptor blocks become as follows:

--------------+-----------------+-----------------+----------------
Architecture  |      32-bit     |      64-bit     | Calculation
--------------+-----------------+-----------------+----------------
Block size    |  1kB   |  4KB   |  1kB   |  4kB   |
--------------+--------+--------+--------+--------+----------------
Number of     |        |        |        |        | Number of
entries per   | 2 ^ 13 | 2 ^ 15 | 2 ^ 13 | 2 ^ 15 | bits per
group (N1)    |        |        |        |        | block
--------------+--------+--------+--------+--------+----------------
Maximum number|        |        |        |        | (Number of ids
of groups (N2)| 2 ^ 19 | 2 ^ 17 | 2 ^ 51 | 2 ^ 49 | with unsigned
              |        |        |        |        | long type) / N1
--------------+--------+--------+--------+--------+----------------
Number of     |        |        |        |        | Number of 
groups per    | 2 ^ 8  | 2 ^ 10 | 2 ^ 8  | 2 ^ 10 | 32-bit counters
descriptor    |        |        |        |        | per block
block (N3)    |        |        |        |        |
--------------+--------+--------+--------+--------+----------------
Maximum number|        |        |        |        |
of descriptor | 2 ^ 11 | 2 ^ 7  | 2 ^ 43 | 2 ^ 39 | N2 / N3
blocks        |        |        |        |        |
--------------+--------+--------+--------+--------+----------------

where the maximum number of descriptor blocks requires "unsigned long"
type for 64-bit OS.

So, please use unsigned long type for counters or ids of descriptor
blocks in your third patch even if it seems too large to you.  It
looks simpler than other way of changes.

To avoid using an "unsinged int" type atomic counter for desciptor
block calculation, I propose you to replace
nilfs_palloc_count_desc_blocks function with the following
implementation:

/**
 * nilfs_palloc_count_desc_blocks - count descriptor blocks number
 * @inode: inode of metadata file using this allocator
 * @desc_blocks: descriptor blocks number [out]
 */
static int nilfs_palloc_count_desc_blocks(struct inode *inode,
					  unsigned long *desc_blocks)
{
	unsigned long blknum;
	int ret;

	ret = nilfs_bmap_last_key(NILFS_I(inode)->i_bmap, &blknum);
	if (likely(!ret))
		*desc_blocks = DIV_ROUND_UP(
			blknum, NILFS_MDT(inode)->mi_blocks_per_desc_block);
	return ret;
}

I believe this will help to simplify your patch.


With regards,
Ryusuke Konishi


On Sat, 18 May 2013 03:18:39 +0900 (JST), Ryusuke Konishi wrote:
> On Fri, 17 May 2013 11:07:03 +0400, Vyacheslav Dubeyko wrote:
>> Hi Ryusuke,
>> 
>> On Fri, 2013-05-17 at 01:44 +0900, Ryusuke Konishi wrote:
>>> On Thu, 16 May 2013 10:54:45 +0400, Vyacheslav Dubeyko wrote:
>>> > Hi Ryusuke,
>>> > 
>>> > On Thu, 2013-05-16 at 07:59 +0900, Ryusuke Konishi wrote:
>>> > 
>>> > [snip]
>>> >> > 
>>> >> > This patch still has a potential overflow issue that I pointed out in
>>> >> > the previous comment; the patch handles the number of descriptor
>>> >> > blocks in 32-bit wide variables without checking its upper limit.
>>> >> > 
>>> >> > If you won't to add checks for the number of descriptor blocks, I
>>> >> > propose you to change the definition of nilfs_palloc_groups_count() instead:
>>> >> > 
>>> >> >   static inline unsigned long
>>> >> >   nilfs_palloc_groups_count(const struct inode *inode)
>>> >> >   {
>>> >> > - 	return 1UL << (BITS_PER_LONG - (inode->i_blkbits + 3 /* log2(8) */));
>>> >> > + 	return nilfs_palloc_groups_per_desc_block(inode) << 32;
>>> >> >   }
>>> >> > 
>>> > 
>>> > I think the real reason of problem is in using constants (BITS_PER_LONG
>>> > for the first case and 32 for the second one). But, anyway, it makes
>>> > sense to operate by volume size in this calculation. Because namely
>>> > volume size is the real limitation for calculation of maximum available
>>> > groups count.
>>> > 
>>> > What do you think about using volume size in this calculation?
>>> > 
>>> > With the best regards,
>>> > Vyacheslav Dubeyko.
>>> 
>>> I disagree with using volume size because it makes resize logic much
>>> harder especially for shrink logic.  It requires reconstructing of
>>> ifile and DAT meatadata file.
>>> 
>>> I just want to fix the calculation of the maximum number of groups so
>>> that the number of descriptor blocks doesn't overflow both for 64-bit
>>> and 32-bit architectures.
>>> 
>> 
>> Ok. I see.
>> 
>> What about such implementation?
>> 
>> static inline unsigned long
>> nilfs_palloc_groups_count(const struct inode *inode)
>> {
>> #define NILFS_DESC_BLOCKS_MAX UINT_MAX
>> 	return nilfs_palloc_groups_per_desc_block(inode) *
>> 			(unsigned long)NILFS_DESC_BLOCKS_MAX;
>> #undef NILFS_DESC_BLOCKS_MAX
>> }
> 
> No, the bit width of "unsigned int" and that of "unsigned long" are
> the same on 32-bit architectures (i.e. 32 bits).  This function
> overflows.
> 
> Regards,
> Ryusuke Konishi
> 
>> With the best regards,
>> Vyacheslav Dubeyko.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
