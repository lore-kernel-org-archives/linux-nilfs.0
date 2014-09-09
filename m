From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH 1/1] nilfs2: add missing blkdev_issue_flush() to nilfs_sync_fs()
Date: Tue, 09 Sep 2014 21:58:27 +0200
Message-ID: <540F5BE3.7030604@gmx.net>
References: <1410280540-14916-1-git-send-email-andreas.rohner@gmx.net>	<1410280540-14916-2-git-send-email-andreas.rohner@gmx.net> <20140910.041840.1587577331345481426.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140910.041840.1587577331345481426.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2014-09-09 21:18, Ryusuke Konishi wrote:
> On Tue,  9 Sep 2014 18:35:40 +0200, Andreas Rohner wrote:
>> Under normal circumstances nilfs_sync_fs() writes out the super block,
>> which causes a flush of the underlying block device. But this depends on
>> the THE_NILFS_SB_DIRTY flag, which is only set if the pointer to the
>> last segment crosses a segment boundary. So if only a small amount of
>> data is written before the call to nilfs_sync_fs(), no flush of the
>> block device occurs.
>>
>> In the above case an additional call to blkdev_issue_flush() is needed.
>> To prevent unnecessary overhead, the new flag nilfs->ns_flushed_device
>> is introduced, which is cleared whenever new logs are written and set
>> whenever the block device is flushed.
>>
>> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
>> ---
>>  fs/nilfs2/file.c      |  6 +++++-
>>  fs/nilfs2/ioctl.c     |  6 +++++-
>>  fs/nilfs2/segment.c   |  4 ++++
>>  fs/nilfs2/super.c     | 12 ++++++++++++
>>  fs/nilfs2/the_nilfs.c |  1 +
>>  fs/nilfs2/the_nilfs.h |  2 ++
>>  6 files changed, 29 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
>> index 2497815..8a3e702 100644
>> --- a/fs/nilfs2/file.c
>> +++ b/fs/nilfs2/file.c
>> @@ -56,7 +56,11 @@ int nilfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
>>  	mutex_unlock(&inode->i_mutex);
>>  
>>  	nilfs = inode->i_sb->s_fs_info;
>> -	if (!err && nilfs_test_opt(nilfs, BARRIER)) {
>> +	if (!err && nilfs_test_opt(nilfs, BARRIER) &&
>> +	    !atomic_read(&nilfs->ns_flushed_device)) {
>> +		atomic_set(&nilfs->ns_flushed_device, 1);
>> +		smp_mb__after_atomic();
>> +
>>  		err = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
>>  		if (err != -EIO)
>>  			err = 0;
>> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
>> index 422fb54..47fe7cf 100644
>> --- a/fs/nilfs2/ioctl.c
>> +++ b/fs/nilfs2/ioctl.c
>> @@ -1022,7 +1022,11 @@ static int nilfs_ioctl_sync(struct inode *inode, struct file *filp,
>>  		return ret;
>>  
>>  	nilfs = inode->i_sb->s_fs_info;
>> -	if (nilfs_test_opt(nilfs, BARRIER)) {
>> +	if (nilfs_test_opt(nilfs, BARRIER) &&
>> +	    !atomic_read(&nilfs->ns_flushed_device)) {
>> +		atomic_set(&nilfs->ns_flushed_device, 1);
>> +		smp_mb__after_atomic();
>> +
>>  		ret = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
>>  		if (ret == -EIO)
>>  			return ret;
>> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
>> index a1a1916..3119b64 100644
>> --- a/fs/nilfs2/segment.c
>> +++ b/fs/nilfs2/segment.c
>> @@ -1997,6 +1997,10 @@ static int nilfs_segctor_do_construct(struct nilfs_sc_info *sci, int mode)
>>  			err = nilfs_segctor_wait(sci);
>>  			if (err)
>>  				goto failed_to_write;
>> +
>> +			if (test_bit(NILFS_SC_SUPER_ROOT, &sci->sc_flags) ||
>> +			    mode == SC_LSEG_DSYNC)
>> +				atomic_set(&nilfs->ns_flushed_device, 0);
>>  		}
>>  	} while (sci->sc_stage.scnt != NILFS_ST_DONE);
>>  
>> diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
>> index 228f5bd..74a9930 100644
>> --- a/fs/nilfs2/super.c
>> +++ b/fs/nilfs2/super.c
>> @@ -310,6 +310,8 @@ int nilfs_commit_super(struct super_block *sb, int flag)
>>  					    nilfs->ns_sbsize));
>>  	}
>>  	clear_nilfs_sb_dirty(nilfs);
>> +	atomic_set(&nilfs->ns_flushed_device, 1);
>> +	smp_mb__after_atomic();
>>  	return nilfs_sync_super(sb, flag);
>>  }
>>  
>> @@ -514,6 +516,16 @@ static int nilfs_sync_fs(struct super_block *sb, int wait)
>>  	}
>>  	up_write(&nilfs->ns_sem);
>>  
>> +	if (wait && !err && nilfs_test_opt(nilfs, BARRIER) &&
>> +	    !atomic_read(&nilfs->ns_flushed_device)) {
>> +		atomic_set(&nilfs->ns_flushed_device, 1);
>> +		smp_mb__after_atomic();
>> +
>> +		err = blkdev_issue_flush(sb->s_bdev, GFP_KERNEL, NULL);
>> +		if (err != -EIO)
>> +			err = 0;
>> +	}
>> +
>>  	return err;
>>  }
>>  
>> diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
>> index 9da25fe..d37c50b 100644
>> --- a/fs/nilfs2/the_nilfs.c
>> +++ b/fs/nilfs2/the_nilfs.c
>> @@ -74,6 +74,7 @@ struct the_nilfs *alloc_nilfs(struct block_device *bdev)
>>  		return NULL;
>>  
>>  	nilfs->ns_bdev = bdev;
>> +	atomic_set(&nilfs->ns_flushed_device, 0);
>>  	atomic_set(&nilfs->ns_ndirtyblks, 0);
>>  	init_rwsem(&nilfs->ns_sem);
>>  	mutex_init(&nilfs->ns_snapshot_mount_mutex);
>> diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
>> index d01ead1..ec53958 100644
>> --- a/fs/nilfs2/the_nilfs.h
>> +++ b/fs/nilfs2/the_nilfs.h
>> @@ -45,6 +45,7 @@ enum {
>>  
>>  /**
>>   * struct the_nilfs - struct to supervise multiple nilfs mount points
>> + * @ns_flushed_device: flag indicating if all volatile data was flushed
>>   * @ns_flags: flags
>>   * @ns_bdev: block device
>>   * @ns_sem: semaphore for shared states
>> @@ -103,6 +104,7 @@ enum {
>>   */
>>  struct the_nilfs {
>>  	unsigned long		ns_flags;
>> +	atomic_t		ns_flushed_device;
> 
> Andreas, can you implement this with just an integer variable like below ?
> 
>         int			ns_flushed_device
> 
> I want to limit the use of atomic_t type just for counters such as
> ref-counts, statistics information, and so forth.

Yes sure. I thought it is a good idea to use atomic_t, because
atomic_read() and atomic_set() are implemented with simple inline functions:

	static inline int atomic_read(const atomic_t *v)
	{
		return (*(volatile int *)&(v)->counter);
	}

	static inline void atomic_set(atomic_t *v, int i)
	{
		v->counter = i;
	}

So the performance would be essentially the same as with int. No extra
locks or memory barriers at least on architectures where an int is
always stored atomically. I thought it is good practice to use the
inline functions in this case.

> The load/store operations for this value is done atomically because
> the_nilfs structure is natually aligned without "packed" attribute
> though it may need that smp barriers are inserted properly.
> 
>>  	struct block_device    *ns_bdev;
>>  	struct rw_semaphore	ns_sem;
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
