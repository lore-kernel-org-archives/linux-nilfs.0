From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v3] nilfs2: implement calculation of free inodes count
Date: Thu, 16 May 2013 07:59:13 +0900 (JST)
Message-ID: <20130516.075913.157469255.konishi.ryusuke@lab.ntt.co.jp>
References: <1368624730.2187.8.camel@slavad-ubuntu>
	<20130516.024602.67896918.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130516.024602.67896918.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Thu, 16 May 2013 02:46:02 +0900 (JST), Ryusuke Konishi wrote:
> On Wed, 15 May 2013 17:32:10 +0400, Vyacheslav Dubeyko wrote:
>> Hi Ryusuke,
>> 
>> This is third version of the patch.
>> 
>> v2->v3
>>  * Trivial BUG_ON checks were removed.
>>  * Whole calculation algorithm was moved into
>>    nilfs_palloc_count_max_entries() method.
>>  * Improve error processing in the code.
>>  * The nilfs_palloc_mdt_file_can_grow() method was simplified.
>>  * The nilfs_ifile_count_free_inodes() method was simplified.
>> 
>> v1->v2
>>  * Change __statfs_word on u64 type.
>>  * Rename nilfs_count_free_inodes() into nilfs_ifile_count_free_inodes()
>>    method.
>>  * Introduce auxiliary functions: nilfs_palloc_count_max_entries(),
>>    nilfs_palloc_count_desc_blocks(), nilfs_palloc_mdt_file_can_grow().
>>  * Rework processing of returned error from nilfs_ifile_count_free_inodes()
>>    in nilfs_statfs().
>> 
>> With the best regards,
>> Vyacheslav Dubeyko.
>> ---
>> From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
>> Subject: [PATCH v3] nilfs2: implement calculation of free inodes count
>> 
>> Currently, NILFS2 returns 0 as free inodes count (f_ffree) and
>> current used inodes count as total file nodes in file system
>> (f_files):
>> 
>> df -i
>> Filesystem      Inodes  IUsed   IFree IUse% Mounted on
>> /dev/loop0           2      2       0  100% /mnt/nilfs2
>> 
>> This patch implements real calculation of free inodes count.
>> First of all, it is calculated total file nodes in file system
>> as (desc_blocks_count * groups_per_desc_block * entries_per_group).
>> Then, it is calculated free inodes count as difference the total
>> file nodes and used inodes count. As a result, we have such output
>> for NILFS2:
>> 
>> df -i
>> Filesystem       Inodes   IUsed    IFree IUse% Mounted on
>> /dev/loop0      4194304 2114701  2079603   51% /mnt/nilfs2
>> 
>> Reported-by: Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
>> CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
>> Tested-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> 
> This patch still has a potential overflow issue that I pointed out in
> the previous comment; the patch handles the number of descriptor
> blocks in 32-bit wide variables without checking its upper limit.
> 
> If you won't to add checks for the number of descriptor blocks, I
> propose you to change the definition of nilfs_palloc_groups_count() instead:
> 
>   static inline unsigned long
>   nilfs_palloc_groups_count(const struct inode *inode)
>   {
> - 	return 1UL << (BITS_PER_LONG - (inode->i_blkbits + 3 /* log2(8) */));
> + 	return nilfs_palloc_groups_per_desc_block(inode) << 32;
>   }
> 
> This implies the maximum number of descriptor block is 1 ^ 32.
> 
> Because the above diff changes the maximum number of groups, I think
> it should be inserted as a separate patch.

Oops, sorry, this change can overflow in 32-bit architectures
because the type of return value is still unsigned long.
That calculation should be revised more carefully.

Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
