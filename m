From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v2] nilfs2: implement calculation of free inodes count
Date: Wed, 15 May 2013 11:56:18 +0900 (JST)
Message-ID: <20130515.115618.27792395.konishi.ryusuke@lab.ntt.co.jp>
References: <1368446091.2229.9.camel@slavad-ubuntu>
	<20130514.031840.27794271.konishi.ryusuke@lab.ntt.co.jp>
	<1368514254.2739.9.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1368514254.2739.9.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hi Vyacheslav,
On Tue, 14 May 2013 10:50:54 +0400, Vyacheslav Dubeyko wrote:
> Hi Ryusuke,
> 
> On Tue, 2013-05-14 at 03:18 +0900, Ryusuke Konishi wrote:
> 
> [snip]
>>  
>> >  /**
>> > + * nilfs_palloc_count_max_entries - count max number of entries that can be
>> > + *					described by @desc_blocks
>> > + * @inode: inode of metadata file using this allocator
>> > + * @desc_blocks: descriptor blocks count
>> > + */
>> > +u64 nilfs_palloc_count_max_entries(struct inode *inode,
>> > +				    unsigned int desc_blocks)
>> 
>> The logical upper limit of descriptor block count is 2 ^ 43 (in the
>> case of 64-bit architecture), so the desc_blocks argument should have
>> unsigned long type.
>> 
> 
> I think that in real world the int type will be enough for descriptor
> blocks count. Moreover, I use atomic_t type for storing knowledge about
> current known descriptor blocks count in nilfs_mdt_info structure. If
> you insist on using unsigned long type then atomic_t type is not good
> choice.

I pointed out that it looks to have a potential overflow issue which
may lead to security breakage.  (the atomic_t type counter sounds
another overflow issue).

> But do you really think that we have to use the unsigned long
> type for descriptor blocks count?

Well, 32-bit descriptor blocks count is enough.

Ok, let's define the maximum number of descriptor blocks (to 2 ^ 32 -
1) and set upper limit on the number of entries with the value.

One thing we should care is the persistent object allocater is also
used by DAT metadata file though it doesn't use this count up logic at
present.

The DAT file contains 128 entries of virtual blocks per disk block,
then each descriptor block handles up to

   128 * 4096 * 8 * 4096 / 4 = 2 ^ 32 virtual blocks

in the case of 4kB block.  So, 32-bit wide descriptor number seems
enough also for the DAT file. (2 ^ 64 virtual blocks can be maintained
in the DAT file).


Regards,
Ryusuke Konishi

> With the best regards,
> Vyacheslav Dubeyko.
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
