From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v2 6/9] nilfs2: add tracking of block deletions and
 updates
Date: Sun, 10 May 2015 12:17:29 +0900 (JST)
Message-ID: <20150510.121729.1918039848761403115.konishi.ryusuke@lab.ntt.co.jp>
References: <1430647522-14304-7-git-send-email-andreas.rohner@gmx.net>
	<20150509.160512.1087140271092828536.konishi.ryusuke@lab.ntt.co.jp>
	<554E67C0.1050309@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=ExiiLt8NAfHZat5G49xRWCN4QW3XGiwWLCsPO62RKQA=;
        b=xFof468xDnbPhjYgGSI/cmos0ZGLzoHaWkM+EOcRyVH0KcIC2LCliez2coN/MY4oW6
         ZTFTwbRIEtYng5bTBXRR85iGCc5f2u0SfX7H2P+chQZMxbCJFOu22/bOS6Boe8o/G4Tv
         p3WTlcKsjnMIeYYPcu9mvyoXGLABCq/Pxg6GQnSPQSU1h/IcCKvTTVOsUukrDsRFrG8j
         OEB5ZQgjn4HY0ZmjedFepB/YMQNoEHqAaOMoMQkPT7dwXB0/cY/O8Ku8zUnMGh3J31wG
         5z7JgkxNPetq52+bBMHNz2pIVsgOKwoqj0+BGILSbH/+n+f+kHutpQFfyaxsiQyCmuZz
         ovww==
In-Reply-To: <554E67C0.1050309-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, 09 May 2015 22:02:08 +0200, Andreas Rohner wrote:
> On 2015-05-09 09:05, Ryusuke Konishi wrote:
>> On Sun,  3 May 2015 12:05:19 +0200, Andreas Rohner wrote:
<snip>
>>> @@ -1889,9 +1890,35 @@ static int nilfs_btree_propagate_p(struct nilfs_bmap *btree,
>>>  				   int level,
>>>  				   struct buffer_head *bh)
>>>  {
>>> -	while ((++level < nilfs_btree_height(btree) - 1) &&
>>> -	       !buffer_dirty(path[level].bp_bh))
>>> -		mark_buffer_dirty(path[level].bp_bh);
>>> +	struct the_nilfs *nilfs = btree->b_inode->i_sb->s_fs_info;
>>> +	struct nilfs_btree_node *node;
>>> +	__u64 ptr, segnum;
>>> +	int ncmax, vol, counted;
>>> +
>>> +	vol = buffer_nilfs_volatile(bh);
>>> +	counted = buffer_nilfs_counted(bh);
>>> +	set_buffer_nilfs_counted(bh);
>>> +
>>> +	while (++level < nilfs_btree_height(btree)) {
>>> +		if (!vol && !counted && nilfs_feature_track_live_blks(nilfs)) {
>>> +			node = nilfs_btree_get_node(btree, path, level, &ncmax);
>>> +			ptr = nilfs_btree_node_get_ptr(node,
>>> +						       path[level].bp_index,
>>> +						       ncmax);
>>> +			segnum = nilfs_get_segnum_of_block(nilfs, ptr);
>>> +			nilfs_sufile_dec_nlive_blks(nilfs->ns_sufile, segnum);
>>> +		}
>>> +
>>> +		if (path[level].bp_bh) {
>>> +			if (buffer_dirty(path[level].bp_bh))
>>> +				break;
>>> +
>>> +			mark_buffer_dirty(path[level].bp_bh);
>>> +			vol = buffer_nilfs_volatile(path[level].bp_bh);
>>> +			counted = buffer_nilfs_counted(path[level].bp_bh);
>>> +			set_buffer_nilfs_counted(path[level].bp_bh);
>>> +		}
>>> +	}
>>>  
>>>  	return 0;
>>>  }
>> 
>> Consider the following comments:
>> 
>> - Please use volatile flag also for the duplication check instead of
>>   adding nilfs_counted flag.
> 
> I thought volatile already means something else. I wasn't sure if could
> use it. I will change it and remove the nilfs_counted flag.

Sorry for the confusing naming.

The volatile flag originally meant that the parent node of the buffer
stores a memory address of buffer_head struct of it instead of a disk
block address (virtual or real one).  This is needed for newly created
and never written buffers.

It later got used for the duplication check of pointer updating as
well.  For node buffers marked dirty through dirty flag propagation,
the dirty flag can be used for this purpose.  However, for node or
data buffers which trigger the propagation, another flag was needed
since it's already marked dirty.

For details, see what nilfs_btree_commit_propagate_v() and
nilfs_btree_commit_update_v() are doing.

Anyway, we can apply the same semantics for live block tracking of
DAT.

> 
>> - btree.c, direct.c, and dat.c shouldn't refer SUFILE directly.
>>   Please add a wrapper function like "nilfs_dec_nlive_blks(nilfs, blocknr)"
>>   to the implementation of the_nilfs.c, and use it instead.
>> - To clarify implementation separate function to update pointers
>>   like nilfs_btree_propagate_v() is doing.
> 
> Ok.
> 
>> - The return value of nilfs_sufile_dec_nlive_blks() looks to be ignored
>>   intentionally.  Please add a comment explaining why you do so.
> 
> I just thought, that the block tracking isn't important enough to cause
> a fatal error. I should at least use the WARN_ON() macro. Do you think I
> should return possible errors?

I think ignoring errors is ok.  Just I thought we should clarify the
reason for other kernel developers.  Outputting some warning sounds
good.  In that case, using nilfs_warning() seems better than WARN_ON()
since the former can deliver a meaningful message.

<snip>
>>> +	if (unlikely(!NILFS_BMAP_USE_VBN(bmap))) {
>>> +		if (!buffer_nilfs_volatile(bh) && !buffer_nilfs_counted(bh) &&
>>> +				nilfs_feature_track_live_blks(nilfs)) {
>>> +			set_buffer_nilfs_counted(bh);
>>> +			segnum = nilfs_get_segnum_of_block(nilfs, ptr);
>>> +
>>> +			nilfs_sufile_dec_nlive_blks(nilfs->ns_sufile, segnum);
>>> +		}
>>> +		return 0;
>>> +	}
>> 
>> Use the volatile flag also for duplication check, and do not use
>> unlikely() marcro when testing "!NILFS_BMAP_USE_VBN(bmap)".  It's
>> not exceptional as error:
>> 
>> 	if (!NILFS_BMAP_USE_VBN(bmap)) {
>> 		if (!buffer_nilfs_volatile(bh)) {
>> 			if (nilfs_feature_track_live_blks(nilfs))
>> 				nilfs_dec_nlive_blks(nilfs, ptr);
>> 			set_buffer_nilfs_volatile(bh);
>> 		}
>> 		return 0;
>> 	}
> 
> During my tests, this was only called once directly after the first
> bytes are written on a newly formatted volume. This can only be true for
> the DAT-File and the DAT-File is very unlikely to be small enough to use
> the direct bmap, except on a newly formatted volume. Do you mean, that
> unlikely() should only be used for errors?

Ok, it sounds reasonable.

In general, unlikely() should only be used for errors.  But this is
special; DAT-file soon becomes big and will be converted to b-tree,
therefore nilfs_direct_propagate() soon becomes a function for other
type of files.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
