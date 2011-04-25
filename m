From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Regarding ``problem with nilfs_cleanerd - part 2'' and
 ``Nilfs_cleanerd err=-17''
Date: Mon, 25 Apr 2011 16:34:14 +0900 (JST)
Message-ID: <20110425.163414.06954497.ryusuke@osrg.net>
References: <loom.20110422T201841-92@post.gmane.org>
	<20110425.103542.66626035.ryusuke@osrg.net>
	<loom.20110425T072626-629@post.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <loom.20110425T072626-629-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: itelichko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

On Mon, 25 Apr 2011 05:28:10 +0000 (UTC), Ivan Telichko wrote:
> > If you are still keeping the partition, could you test if the
> > following patch makes a difference ?
> 
> No observable difference, patched cleanerd still dies the same way.
>
> There are more messages in the log if I start nilfs_cleanerd by hand:
> 
>   Apr 26 02:54:21 nilfs_cleanerd[4734]: start
>   Apr 26 02:54:21 nilfs_cleanerd[4734]: pause (clean check)
>   Apr 26 02:54:21 nilfs_cleanerd[4734]: resume (clean check)
>   Apr 26 02:54:21 nilfs_cleanerd[4734]: ncleansegs = 244
>   Apr 26 02:54:21 nilfs_cleanerd[4734]: 4 segments selected to be cleaned
>   Apr 26 02:54:21 nilfs_cleanerd[4734]: protected checkpoints = [69325,69425]
>     (protection period >= 1303760661)
>   Apr 26 02:54:22 kernel: nilfs_ioctl_move_inode_block: conflicting data buffer:
>     ino=97606, cno=281, offset=14, blocknr=3526535, vblocknr=1555981
>   Apr 26 02:54:22 kernel: NILFS: GC failed during preparation: cannot read
>     source blocks: err=-17
>   Apr 26 02:54:23 nilfs_cleanerd[4734]: cannot clean segments: File exists
>   Apr 26 02:54:23 nilfs_cleanerd[4734]: shutdown

Thanks,

According to the log, the same data block (i.e. blocks having the same
inode number, the same block offset, and the same checkpoint number)
appeared twice in a segment, and this causes a conflict of buffer on
GC page cache.

Umm, we need more information to narrow down this.

Could you take summaries of the segment 1721 and its adjacent segments ?

Summaries of a segment can be obtained as follows:

 # dumpseg /dev/sda6 1721
           ~~~~~~~~~
           your block device

where the segment 1721 contains the block 3526535 (a segment consists
of 2048 blocks by default).  It doesn't contain any user private data.


Regards,
Ryusuke Konishi

> ---
> 
> Regards,
>   Ivan Telichko
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
