From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH] nilfs2: implement calculation of free inodes count
Date: Tue, 07 May 2013 23:38:50 +0900 (JST)
Message-ID: <20130507.233850.160073573.konishi.ryusuke@lab.ntt.co.jp>
References: <1367586746.5050.4.camel@slavad-ubuntu-12.04>
	<CAKFNMo=mnO=kTVWySGLYTC1o8A3uavEo6VhtthgT_kJhN+0Zfg@mail.gmail.com>
	<1367930977.2216.34.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1367930977.2216.34.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hi Vyacheslav,
On Tue, 07 May 2013 16:49:37 +0400, Vyacheslav Dubeyko wrote:
> Hi Ryusuke,
> 
> On Mon, 2013-05-06 at 23:07 +0900, Ryusuke Konishi wrote:
> 
> [snip]
>> I agree to use count of descriptor blocks of ifile to
>> calculate the approximate value of the total file nodes.
>> 
>> Here are my comments on the patch:
>> 
>> (1) Consider using nilfs_bmap_last_key()  instead of repeating read
>>      of descriptor blocks to decide new desc_blocks count.
>>      The current logic may incur many device read accesses
>>      even if it is updated in a stepwise fashion with
>>      NILFS_IFILE_I(ifile)->mi.mi_desc_blocks_count.
>> 
> 
> Maybe I misunderstand something but I think that nilfs_bmap_last_key()
> can be less efficient solution. As I understand, descriptor block with 4
> KB in size can describe 1024 groups. Every group can describe 32768
> inodes. As a result, we can describe 32768 * 1024 = 33554432 inodes by
> means of one descriptor block. So, the most frequent use-case will be
> calculation with 1 descriptor block, from my point of view. Yes, I agree
> that it is possible not read mi_desc_blocks_count in the beginning of
> nilfs_count_free_inodes() but to use simply 1 as constant value. But,
> anyway, even if we need to define a real count of descriptor blocks then
> it makes only once (if we exhaust descriptor block capacity or after
> mount in the case of presence of several descriptor blocks). This
> counted value is saved in mi_desc_blocks_count and is used in further
> calculations by means of reading mi_desc_blocks_count during exhausting
> of next 33554432 inodes count.

Ok, I agree that your calculation makes sense.  So, repeating the read
of descriptor blocks is not a problem in the real world.

Please go on with the current approach.

> Do you mean that nilfs_bmap_last_key() can initiate lesser read requests
> as my way of using nilfs_palloc_get_desc_block() call?

Yes, nilfs_bmap_last_key() does not involve read of leaf blocks of
nilfs btree (i.e. data blocks including descriptor block, etc) unlike
with nilfs_palloc_get_desc_block function, however it is negligible
anyway as you pointed out.
 
>> (2) Do not use __statfs_word type for local variables or arguments of
>>      functions.  I think an integer type such as u64 should be used
>>      instead.
>> 
> 
> Ok. I agree.
> 
>> (3) Consider moving the main part of nilfs_count_free_inodes()
>>      function to alloc.c, for example, as a function like:
>> 
>>      int nilfs_palloc_count_max_entries(struct inode *inode, u64 nentries,
>>                                                         u64 *nmaxentries);
>> 
>>      Then, nilfs_palloc_groups_per_desc_block() and
>>      nilfs_palloc_groups_count() do not need to be moved,
>>      and nilfs_root argument becomes eliminable from the routine
>>      added to ifile.c.
>> 
> 
> Ok. I'll do it.
> 
>> (4) Please consider the name convention of functions in ifile.c.
>>      The ifile.c includes routines related to ifile inode,
>>      and all its functions have the same name convention (i.e.
>>      nilfs_ifile_xxxx() ).
>> 
> 
> Ok. I agree.
> 
>> (5) nilfs_count_free_inodes() may return -ERANGE.
>>      (It's OK if inode_count is given as an argument of the function.)
>>      But, nilfs_statfs() should not return -ERANGE as-is.
>> 
>>      In that case, I think nilfs_statfs() should output a warning
>>      message and ignore the error code.
>> 
> 
> Currently, it is processed returned error of nilfs_count_free_blocks()
> in nilfs_statfs(). Yes, nilfs_count_free_blocks() doesn't return any
> error really. But, potentially, nilfs_statfs() can return error from
> this method. So, as I understand, you suggest simply to warn in
> nilfs_statfs() about errors in called methods and doesn't return these
> errors from it. Am I correct?

I mean that only -ERANGE should not be returned to user space as-is
because it looks an internal error code indicating that there is an
inconsistency in the file system metadata.  Other errors like -EIO or
-ENOMEM can be returned to user space.  These error codes are actually
specified in the man page of statfs.


With regards,
Ryusuke Konishi

> With the best regards,
> Vyacheslav Dubeyko.
> 
>> Regards,
>> Ryusuke Konishi
>> 
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
