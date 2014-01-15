From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Does nilfs2 do any in-place writes?
Date: Thu, 16 Jan 2014 00:23:53 +0900 (JST)
Message-ID: <20140116.002353.94325733.konishi.ryusuke@lab.ntt.co.jp>
References: <1389783139.3913.23.camel@slavad-ubuntu>
	<CAFvQSYTG6HBVc9iodYyvCejwf889jiwOPsVb1Hi8cDrR9pOGeg@mail.gmail.com>
	<1389787304.3913.28.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1389787304.3913.28.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Vyacheslav,
On Wed, 15 Jan 2014 16:01:44 +0400, Vyacheslav Dubeyko wrote:
> Hi Clemens,
> 
> On Wed, 2014-01-15 at 12:44 +0100, Clemens Eisserer wrote:
>> Hi Vyacheslav,
>> 
>> > The main approach of NILFS2 is COW (copy-on-write) policy. It means that
>> > all data and metadata are written in log manner. Only superblocks are
>> > placed in fixed positions and updated there. First superblock is located
>> > in the volume begin, second one in the volume end.
>> 
>> Can you give me an estime how often the superblock is updated / written to?
>> 
> 
> NILFS2 has special method nilfs_sb_need_update() [1] and special
> constant NILFS_SB_FREQ [2] that it is used usually for definition
> frequency of superblocks updating. So, as far as I can judge, default
> value of such frequency under high I/O load is 10 seconds (Minimum
> interval of periodical update of superblocks (in seconds)).
> 
> With the best regards,
> Vyacheslav Dubeyko.
> 
> [1] http://lxr.free-electrons.com/source/fs/nilfs2/the_nilfs.h#L254
> [2] http://lxr.free-electrons.com/source/fs/nilfs2/the_nilfs.h#L252

By the way, do you have any nice idea to stop periodical update of
superblocks?

Most information on the superblock is static (layout information
or so).

sbp->s_state has an ERROR state bit and a VALID state bit, but
these bits are mostly static.

sbp->s_free_blocks_count keeps free block count at the time, but I
think this information is not important because it can be calculated
from the number of clean segments.

We need to the periodical in-place superblock write only for updating
a pointer to the most latest log.  And, this will be eliminable if we
can invent the fast way to determine the latest log.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
