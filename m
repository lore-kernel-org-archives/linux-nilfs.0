From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Does nilfs2 do any in-place writes?
Date: Sat, 18 Jan 2014 09:00:08 +0900 (JST)
Message-ID: <20140118.090008.194171715.konishi.ryusuke@lab.ntt.co.jp>
References: <1389787304.3913.28.camel@slavad-ubuntu>
	<20140116.002353.94325733.konishi.ryusuke@lab.ntt.co.jp>
	<1389866912.2565.44.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1389866912.2565.44.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, 16 Jan 2014 14:08:32 +0400, Vyacheslav Dubeyko wrote:
>> Most information on the superblock is static (layout information
>> or so).
>> 
>> sbp->s_state has an ERROR state bit and a VALID state bit, but
>> these bits are mostly static.
>> 
>> sbp->s_free_blocks_count keeps free block count at the time, but I
>> think this information is not important because it can be calculated
>> from the number of clean segments.
>> 
>> We need to the periodical in-place superblock write only for updating
>> a pointer to the most latest log.  And, this will be eliminable if we
>> can invent the fast way to determine the latest log.
>> 
> 
> As far as I can see, we have more changeable fields in superblock. But,
> of course, it is possible to leave in superblock only static
> information. I assume that it makes sense to move changeable fields of
> superblock into super root metadata structure. We can provide
> independent sets of above-mentioned changeable superblock's field for
> every snapshot/checkpoint in such way.

I think only fields that constantly change should be put on the super
root block.  If we can find the way to look up the most latest log, we
don't need to update s_last_cno, s_last_pseg, s_last_seq so frequently
too. (cno, pseg, and seq number can be obtainable from the latest log)

Ideally, I think, we only should update the super blocks only at
mount/umount time or when changing file system state bits or feature
bits, etc.

> I suppose that another problem is to have unchangeable superblock (4 KB)
> and changeable segment area near after it. I think that it can be not
> FTL friendly situation for the case of flash using. Maybe it makes sense
> to have specially reserved areas (with size is equal by segment size) in
> the begin and in the end of NILFS2 volume.
> These areas can be used for
> special metadata structures are modified with COW principle inside
> reserved areas. Anyway, we need some metadata structure on volume (tree
> or something else) that can give information about most latest log by
> snapshot number.

Ok, I agree it is a reasonable approach to keep the pointer
information.  We should avoid frequent erase (overwrite) there, too.
And, it may become acceptable by applying COW policy.

Or, we may be able to reduce the number of seeks/disk-scans without
such additional information by combining binary search on the device
and a restriction on segment allocator.  For instance, we may be able
to reduce the number of block scans for the latest log lookup by
itroducing groups of segments in which we ensure that segments are
sequntially allocated in each group.  Then we can devide the disk-scan
steps into two phases, one is searching the latest segment group and
another is seaching the latest segment (log) in the group.  This idea
of grouping may be able to be nested.

> So, currently, I haven't clear vision of possible good approach for
> efficient search of latest log. But it needs to take into account and
> possible GC policy change. Because more efficient way of garbage
> collection can be a way to leave untouched "cold" segments (such full
> segment can contain valid and actual data). As a result, chain of linked
> partial segments on the volume can be more sophisticated and not chain
> of sibling segments. Thereby, search of latest log can be not so simple
> and fast operation in the environment of current search algorithm, I
> think.

Yes, GC policy is affected.  I think it is an acceptable change for
this purpose.

> I think that [snapshot number | latest log] tree can be restricted by
> one file system block (4 KB). So, one of the possible way is to save
> changing in such tree by journal-like circular log which keeps chain of
> modified blocks, for example. Maybe, it makes sense to keep pair of
> values [current last log; upper bound of last log]. The upper bound can
> be prediction value that it means where last log will be after some
> time. Thereby, such tree and superblock(s) can live in reserved area at
> the volume begin and end.

How about considering the latest log scan first, and then extending
the idea for writable snapshots/branches later, or the two ideas would be
separable if we think keeping them with one super root block.

Regards,
Ryusuke Konishi

> As you can see, currently, I don't suggest something concrete. I need to
> think over it more deeply.
> 
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
