From: Ivan Telichko <itelichko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Regarding =?utf-8?b?YGBwcm9ibGVt?= with =?utf-8?b?bmlsZnNfY2xlYW5lcmQ=?= - part 2'' and =?utf-8?b?YGBOaWxmc19jbGVhbmVyZA==?= err=-17''
Date: Tue, 26 Apr 2011 21:21:48 +0000 (UTC)
Message-ID: <loom.20110426T231606-740@post.gmane.org>
References: <loom.20110422T201841-92@post.gmane.org> <20110425.103542.66626035.ryusuke@osrg.net> <loom.20110425T072626-629@post.gmane.org> <20110425.163414.06954497.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

It seems my reply was discarded, probably because it was too large. I
will try to use pastebin for summaries then.

> According to the log, the same data block (i.e. blocks having the same
> inode number, the same block offset, and the same checkpoint number)
> appeared twice in a segment, and this causes a conflict of buffer on
> GC page cache.

I tried to find blocks with same ino, cno and blkoff fields in one segment
with perl script. In 200 segments around 1721, there are about 1600 of
these, but none with ino=97606. Most of them (around 98%) have cno=0,
ino = one of 3,4,5.

Could you tell more about how bad blocks should look like? It is not
clear if blocks without blkoff=X or with level=X count as duplicates.

> Could you take summaries of the segment 1721 and its adjacent segments ?
> 
> Summaries of a segment can be obtained as follows:
> 
>  # dumpseg /dev/sda6 1721
>            ~~~~~~~~~
>            your block device
> 
> where the segment 1721 contains the block 3526535 (a segment consists
> of 2048 blocks by default).  It doesn't contain any user private data.

Here are summaries for blocks 1720,1721,1722:

  http://pastebin.com/vdC8WUWv

---

Regards,
  Ivan Telichko

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
