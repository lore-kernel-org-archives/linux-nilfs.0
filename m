From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Does nilfs2 do any in-place writes?
Date: Thu, 16 Jan 2014 14:08:32 +0400
Message-ID: <1389866912.2565.44.camel@slavad-ubuntu>
References: <1389783139.3913.23.camel@slavad-ubuntu>
	 <CAFvQSYTG6HBVc9iodYyvCejwf889jiwOPsVb1Hi8cDrR9pOGeg@mail.gmail.com>
	 <1389787304.3913.28.camel@slavad-ubuntu>
	 <20140116.002353.94325733.konishi.ryusuke@lab.ntt.co.jp>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=N6lELg8c47UyAbEB5lo6ij07QYETVMlKutakLh8LU0g=;
	b=Vwfyj5ThKJ+AJ8S+UuHNM1A5dqZZEuV10IxdZPpQu9dyDGtp/J6Eiql5zEYBws9WSGw+Pb09vOfZ3IV5prEuqKJCCb2CWUO5kqYZj45EdxcCdmabVohFHPFSId4j0JvO;
In-Reply-To: <20140116.002353.94325733.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Ryusuke,

On Thu, 2014-01-16 at 00:23 +0900, Ryusuke Konishi wrote:

> 
> By the way, do you have any nice idea to stop periodical update of
> superblocks?
> 

Yes, I think too that such suggestion is valuable for NILFS2. But I
suppose that the problem is more complex. I mean a situation with
write-able snapshots. If we will have write-able snapshots then it means
necessity to have independent version of some superblock's  fields
(s_last_cno, s_last_pseg, s_last_seq, s_mtime, s_wtime, s_mnt_count,
s_state, s_c_interval, s_feature_compat_ro, s_feature_incompat). For
example, snapshot can be made before xafile creation on a volume and
write-able snapshot should continue to live without possibility to xattr
creation, and so on.

> Most information on the superblock is static (layout information
> or so).
> 
> sbp->s_state has an ERROR state bit and a VALID state bit, but
> these bits are mostly static.
> 
> sbp->s_free_blocks_count keeps free block count at the time, but I
> think this information is not important because it can be calculated
> from the number of clean segments.
> 
> We need to the periodical in-place superblock write only for updating
> a pointer to the most latest log.  And, this will be eliminable if we
> can invent the fast way to determine the latest log.
> 

As far as I can see, we have more changeable fields in superblock. But,
of course, it is possible to leave in superblock only static
information. I assume that it makes sense to move changeable fields of
superblock into super root metadata structure. We can provide
independent sets of above-mentioned changeable superblock's field for
every snapshot/checkpoint in such way.

I suppose that another problem is to have unchangeable superblock (4 KB)
and changeable segment area near after it. I think that it can be not
FTL friendly situation for the case of flash using. Maybe it makes sense
to have specially reserved areas (with size is equal by segment size) in
the begin and in the end of NILFS2 volume. These areas can be used for
special metadata structures are modified with COW principle inside
reserved areas. Anyway, we need some metadata structure on volume (tree
or something else) that can give information about most latest log by
snapshot number.

So, currently, I haven't clear vision of possible good approach for
efficient search of latest log. But it needs to take into account and
possible GC policy change. Because more efficient way of garbage
collection can be a way to leave untouched "cold" segments (such full
segment can contain valid and actual data). As a result, chain of linked
partial segments on the volume can be more sophisticated and not chain
of sibling segments. Thereby, search of latest log can be not so simple
and fast operation in the environment of current search algorithm, I
think.

I think that [snapshot number | latest log] tree can be restricted by
one file system block (4 KB). So, one of the possible way is to save
changing in such tree by journal-like circular log which keeps chain of
modified blocks, for example. Maybe, it makes sense to keep pair of
values [current last log; upper bound of last log]. The upper bound can
be prediction value that it means where last log will be after some
time. Thereby, such tree and superblock(s) can live in reserved area at
the volume begin and end.

As you can see, currently, I don't suggest something concrete. I need to
think over it more deeply.

With the best regards,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
