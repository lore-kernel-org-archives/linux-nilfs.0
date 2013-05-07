From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH] nilfs2: implement calculation of free inodes count
Date: Wed, 08 May 2013 00:17:03 +0900 (JST)
Message-ID: <20130508.001703.27791709.konishi.ryusuke@lab.ntt.co.jp>
References: <CAKFNMo=mnO=kTVWySGLYTC1o8A3uavEo6VhtthgT_kJhN+0Zfg@mail.gmail.com>
	<1367930977.2216.34.camel@slavad-ubuntu>
	<20130507.233850.160073573.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130507.233850.160073573.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Tue, 07 May 2013 23:38:50 +0900 (JST), Ryusuke Konishi wrote:
> Hi Vyacheslav,
> On Tue, 07 May 2013 16:49:37 +0400, Vyacheslav Dubeyko wrote:
>> Hi Ryusuke,
>> 
>> On Mon, 2013-05-06 at 23:07 +0900, Ryusuke Konishi wrote:
>> 
>> [snip]
>>> I agree to use count of descriptor blocks of ifile to
>>> calculate the approximate value of the total file nodes.
>>> 
>>> Here are my comments on the patch:
>>> 
>>> (1) Consider using nilfs_bmap_last_key()  instead of repeating read
>>>      of descriptor blocks to decide new desc_blocks count.
>>>      The current logic may incur many device read accesses
>>>      even if it is updated in a stepwise fashion with
>>>      NILFS_IFILE_I(ifile)->mi.mi_desc_blocks_count.
>>> 
[snip]
>> Do you mean that nilfs_bmap_last_key() can initiate lesser read requests
>> as my way of using nilfs_palloc_get_desc_block() call?
> 
> Yes, nilfs_bmap_last_key() does not involve read of leaf blocks of
> nilfs btree (i.e. data blocks including descriptor block, etc) unlike
> with nilfs_palloc_get_desc_block function, however it is negligible
> anyway as you pointed out.

Oops, I have missed the point.  Most important difference in these two
functions is that you do not need to repeat calling the function in
the case of nilfs_bmap_last_key().  nilfs_bmap_last_key() returns the
maximum index of allocated data blocks with one call.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
