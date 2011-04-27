From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Regarding ``problem with nilfs_cleanerd - part 2'' and
 ``Nilfs_cleanerd err=-17''
Date: Wed, 27 Apr 2011 15:40:07 +0900 (JST)
Message-ID: <20110427.154007.255390385.ryusuke@osrg.net>
References: <loom.20110425T072626-629@post.gmane.org>
	<20110425.163414.06954497.ryusuke@osrg.net>
	<loom.20110426T231606-740@post.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <loom.20110426T231606-740-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: itelichko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 26 Apr 2011 21:21:48 +0000 (UTC), Ivan Telichko wrote:
> It seems my reply was discarded, probably because it was too large. I
> will try to use pastebin for summaries then.
> 
> > According to the log, the same data block (i.e. blocks having the same
> > inode number, the same block offset, and the same checkpoint number)
> > appeared twice in a segment, and this causes a conflict of buffer on
> > GC page cache.
> 
> I tried to find blocks with same ino, cno and blkoff fields in one segment
> with perl script. In 200 segments around 1721, there are about 1600 of
> these, but none with ino=97606. Most of them (around 98%) have cno=0,
> ino = one of 3,4,5.
>
> Could you tell more about how bad blocks should look like? It is not
> clear if blocks without blkoff=X or with level=X count as duplicates.

The log says 4 segments were selected for GC at that time, so the
duplicated block would be present between segment 1718 and 1721 (if
exists).

Is there dumpseg data of the segment 1718 and 1719 ?

If the duplicated block exists, it will look like:

      finfo
        ino = 97606, cno = 281, nblocks = xx, ndatblk = xx
          ...
          vblocknr = xxxxxxx, blkoff = 14, blocknr = xxxxxxxx
          ...

B-tree node blocks, which appear without "blkoff = X" or with "level =
X", are irrelevant to this error.

Thanks,
Ryusuke Konishi
 
> > Could you take summaries of the segment 1721 and its adjacent segments ?
> > 
> > Summaries of a segment can be obtained as follows:
> > 
> >  # dumpseg /dev/sda6 1721
> >            ~~~~~~~~~
> >            your block device
> > 
> > where the segment 1721 contains the block 3526535 (a segment consists
> > of 2048 blocks by default).  It doesn't contain any user private data.
> 
> Here are summaries for blocks 1720,1721,1722:
> 
>   http://pastebin.com/vdC8WUWv
> 
> ---
> 
> Regards,
>   Ivan Telichko
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
