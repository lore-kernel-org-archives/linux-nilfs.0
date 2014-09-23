From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH] nilfs2: improve the performance of fdatasync()
Date: Tue, 23 Sep 2014 08:36:38 +0200
Message-ID: <542114F6.5080208@gmx.net>
References: <1411402827-22754-1-git-send-email-andreas.rohner@gmx.net> <20140923.140955.1260378150440043320.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140923.140955.1260378150440043320.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2014-09-23 07:09, Ryusuke Konishi wrote:
> Hi Andreas,
> On Mon, 22 Sep 2014 18:20:27 +0200, Andreas Rohner wrote:
>> Support for fdatasync() has been implemented in NILFS2 for a long time,
>> but whenever the corresponding inode is dirty the implementation falls
>> back to a full-flegded sync(). Since every write operation has to update
>> the modification time of the file, the inode will almost always be dirty
>> and fdatasync() will fall back to sync() most of the time. But this
>> fallback is only necessary for a change of the file size and not for
>> a change of the various timestamps.
>>
>> This patch adds a new flag NILFS_I_INODE_SYNC to differentiate between
>> those two situations.
>>
>>  * If it is set the file size was changed and a full sync is necessary.
>>  * If it is not set then only the timestamps were updated and
>>    fdatasync() can go ahead.
>>
>> There is already a similar flag I_DIRTY_DATASYNC on the VFS layer with
>> the exact same semantics. Unfortunately it cannot be used directly,
>> because NILFS2 doesn't implement write_inode() and doesn't clear the VFS
>> flags when inodes are written out. So the VFS writeback thread can
>> clear I_DIRTY_DATASYNC at any time without notifying NILFS2. So
>> I_DIRTY_DATASYNC has to be mapped onto NILFS_I_INODE_SYNC in
>> nilfs_update_inode().
>>
>> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
> 
> I looked into the patch. 
> 
> Very nice. This is what we should have done several years ago.
> 
> When this patch is applied, NILFS_I_INODE_DIRTY flag will be no longer
> required.  Can you remove it at the same time?

Ah yes of course. I just assumed that NILFS_I_INODE_DIRTY is needed for
something else and never actually checked it. In that case don't you
think that NILFS_I_INODE_DIRTY is a better name for the flag than
NILFS_I_INODE_SYNC?

The SYNC can be a bit confusing, especially because I used it in the
helper functions, where it means exactly the opposite:

static inline int nilfs_mark_inode_dirty(struct inode *inode)
static inline int nilfs_mark_inode_dirty_sync(struct inode *inode)

I did that to match the corresponding names of the VFS functions:

static inline void mark_inode_dirty(struct inode *inode)
static inline void mark_inode_dirty_sync(struct inode *inode)

So there is a bit of a conflict in names. What do you think?

br,
Andreas Rohner

> Thanks,
> Ryusuke Konishi
> 
>> ---
>>  fs/nilfs2/inode.c   | 12 +++++++-----
>>  fs/nilfs2/nilfs.h   | 13 +++++++++++--
>>  fs/nilfs2/segment.c |  3 ++-
>>  3 files changed, 20 insertions(+), 8 deletions(-)
>>
>> diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
>> index 6252b17..2f67153 100644
>> --- a/fs/nilfs2/inode.c
>> +++ b/fs/nilfs2/inode.c
>> @@ -125,7 +125,7 @@ int nilfs_get_block(struct inode *inode, sector_t blkoff,
>>  			nilfs_transaction_abort(inode->i_sb);
>>  			goto out;
>>  		}
>> -		nilfs_mark_inode_dirty(inode);
>> +		nilfs_mark_inode_dirty_sync(inode);
>>  		nilfs_transaction_commit(inode->i_sb); /* never fails */
>>  		/* Error handling should be detailed */
>>  		set_buffer_new(bh_result);
>> @@ -667,7 +667,7 @@ void nilfs_write_inode_common(struct inode *inode,
>>  	   for substitutions of appended fields */
>>  }
>>  
>> -void nilfs_update_inode(struct inode *inode, struct buffer_head *ibh)
>> +void nilfs_update_inode(struct inode *inode, struct buffer_head *ibh, int flags)
>>  {
>>  	ino_t ino = inode->i_ino;
>>  	struct nilfs_inode_info *ii = NILFS_I(inode);
>> @@ -679,6 +679,8 @@ void nilfs_update_inode(struct inode *inode, struct buffer_head *ibh)
>>  	if (test_and_clear_bit(NILFS_I_NEW, &ii->i_state))
>>  		memset(raw_inode, 0, NILFS_MDT(ifile)->mi_entry_size);
>>  	set_bit(NILFS_I_INODE_DIRTY, &ii->i_state);
>> +	if (flags & I_DIRTY_DATASYNC)
>> +		set_bit(NILFS_I_INODE_SYNC, &ii->i_state);
>>  
>>  	nilfs_write_inode_common(inode, raw_inode, 0);
>>  		/* XXX: call with has_bmap = 0 is a workaround to avoid
>> @@ -934,7 +936,7 @@ int nilfs_set_file_dirty(struct inode *inode, unsigned nr_dirty)
>>  	return 0;
>>  }
>>  
>> -int nilfs_mark_inode_dirty(struct inode *inode)
>> +int __nilfs_mark_inode_dirty(struct inode *inode, int flags)
>>  {
>>  	struct buffer_head *ibh;
>>  	int err;
>> @@ -945,7 +947,7 @@ int nilfs_mark_inode_dirty(struct inode *inode)
>>  			      "failed to reget inode block.\n");
>>  		return err;
>>  	}
>> -	nilfs_update_inode(inode, ibh);
>> +	nilfs_update_inode(inode, ibh, flags);
>>  	mark_buffer_dirty(ibh);
>>  	nilfs_mdt_mark_dirty(NILFS_I(inode)->i_root->ifile);
>>  	brelse(ibh);
>> @@ -978,7 +980,7 @@ void nilfs_dirty_inode(struct inode *inode, int flags)
>>  		return;
>>  	}
>>  	nilfs_transaction_begin(inode->i_sb, &ti, 0);
>> -	nilfs_mark_inode_dirty(inode);
>> +	__nilfs_mark_inode_dirty(inode, flags);
>>  	nilfs_transaction_commit(inode->i_sb); /* never fails */
>>  }
>>  
>> diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
>> index 0696161..30573d7 100644
>> --- a/fs/nilfs2/nilfs.h
>> +++ b/fs/nilfs2/nilfs.h
>> @@ -107,6 +107,7 @@ enum {
>>  	NILFS_I_INODE_DIRTY,		/* write_inode is requested */
>>  	NILFS_I_BMAP,			/* has bmap and btnode_cache */
>>  	NILFS_I_GCINODE,		/* inode for GC, on memory only */
>> +	NILFS_I_INODE_SYNC,		/* dsync is not allowed for inode */
>>  };
>>  
>>  /*
>> @@ -273,7 +274,7 @@ struct inode *nilfs_iget(struct super_block *sb, struct nilfs_root *root,
>>  			 unsigned long ino);
>>  extern struct inode *nilfs_iget_for_gc(struct super_block *sb,
>>  				       unsigned long ino, __u64 cno);
>> -extern void nilfs_update_inode(struct inode *, struct buffer_head *);
>> +extern void nilfs_update_inode(struct inode *, struct buffer_head *, int);
>>  extern void nilfs_truncate(struct inode *);
>>  extern void nilfs_evict_inode(struct inode *);
>>  extern int nilfs_setattr(struct dentry *, struct iattr *);
>> @@ -282,10 +283,18 @@ int nilfs_permission(struct inode *inode, int mask);
>>  int nilfs_load_inode_block(struct inode *inode, struct buffer_head **pbh);
>>  extern int nilfs_inode_dirty(struct inode *);
>>  int nilfs_set_file_dirty(struct inode *inode, unsigned nr_dirty);
>> -extern int nilfs_mark_inode_dirty(struct inode *);
>> +extern int __nilfs_mark_inode_dirty(struct inode *, int);
>>  extern void nilfs_dirty_inode(struct inode *, int flags);
>>  int nilfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>>  		 __u64 start, __u64 len);
>> +static inline int nilfs_mark_inode_dirty(struct inode *inode)
>> +{
>> +	return __nilfs_mark_inode_dirty(inode, I_DIRTY);
>> +}
>> +static inline int nilfs_mark_inode_dirty_sync(struct inode *inode)
>> +{
>> +	return __nilfs_mark_inode_dirty(inode, I_DIRTY_SYNC);
>> +}
>>  
>>  /* super.c */
>>  extern struct inode *nilfs_alloc_inode(struct super_block *);
>> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
>> index a1a1916..6102f3e 100644
>> --- a/fs/nilfs2/segment.c
>> +++ b/fs/nilfs2/segment.c
>> @@ -931,6 +931,7 @@ static void nilfs_drop_collected_inodes(struct list_head *head)
>>  			continue;
>>  
>>  		clear_bit(NILFS_I_INODE_DIRTY, &ii->i_state);
>> +		clear_bit(NILFS_I_INODE_SYNC, &ii->i_state);
>>  		set_bit(NILFS_I_UPDATED, &ii->i_state);
>>  	}
>>  }
>> @@ -2194,7 +2195,7 @@ int nilfs_construct_dsync_segment(struct super_block *sb, struct inode *inode,
>>  	nilfs_transaction_lock(sb, &ti, 0);
>>  
>>  	ii = NILFS_I(inode);
>> -	if (test_bit(NILFS_I_INODE_DIRTY, &ii->i_state) ||
>> +	if (test_bit(NILFS_I_INODE_SYNC, &ii->i_state) ||
>>  	    nilfs_test_opt(nilfs, STRICT_ORDER) ||
>>  	    test_bit(NILFS_SC_UNCLOSED, &sci->sc_flags) ||
>>  	    nilfs_discontinued(nilfs)) {
>> -- 
>> 2.1.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
