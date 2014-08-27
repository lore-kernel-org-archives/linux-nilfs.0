From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH 0/1] add missing blkdev_issue_flush() to nilfs_sync_fs()
Date: Wed, 27 Aug 2014 12:14:33 +0200
Message-ID: <53FDAF89.8050609@gmx.net>
References: <1408959018-10570-1-git-send-email-andreas.rohner@gmx.net> <20140827.092959.1305564732068171399.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140827.092959.1305564732068171399.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Ryusuke,

On 2014-08-27 02:29, Ryusuke Konishi wrote:
>> Looking over the code I noticed, that nilfs_sync_file() gets called by 
>> the fsync() syscall and it basically constructs a new partial segment 
>> and calls blkdev_issue_flush().
>>
>> nilfs_ioctl_sync(), which is used by the cleaner, also essentially works 
>> the same way. It writes all the dirty files to disk and calls 
>> blkdev_issue_flush().
>>
>> nilfs_sync_fs() also writes out all the dirty files, but there is no 
>> blkdev_issue_flush() at the end. At first I thought, that 
>> nilfs_commit_super() may flush the block device anyway and therefore no 
>> additional flush is necessary, but nilfs_sb_dirty(nilfs) is only set to 
>> true if a new segment is started. So in the following scenario data 
>> could be lost despite a call to sync():
>>
>> 1. Write out less data than a full segment
>> 2. Call sync()
>> 3. nilfs_sb_dirty() is false and nilfs_commit_super() is NOT called
>> 4. Cut power to the device
>> 5. Data loss
>>
>> As I stated above, I am not sure if this is really necessary. Maybe I 
>> have overlooked something obvious.
> 
> Your indication is right, we have a data integration issue for the
> "nilfs_sb_dirty() is false" case in nilfs_sync_fs().
> 
> But, I rather would mitigate the cache flush overhead keeping data
> integerity instead of simply adding the third blkdev_issue_flush()
> call.
> 
> We don't have to call blkdev_issue_flush() if the last log was
> written synchronously with a cache flush operation.
> (this logic looks to be feasible by adding a flag.)
>
> Also, the cache flush is not needed after writing super block; a disk
> cache flush is needed BEFORE writing a super block to ensure that the
> super block is pointing to a valid log, but a succeeding flush
> operation is not needed because the pointer information is recoverable
> with mount time recovery.

Yes that's true.

> nilfs_sync_super() uses both FLUSH/FUA options for writing the primary
> super block and the FUA option may be superfluous in that sense.
> (we need to understand the precise semantics)

I have looked into that. According to
"Documentation/block/writeback_cache_control.txt" the FLUSH option makes
sure, that all previous write requests are in non-volatile storage and
the FUA option makes sure, that the current request only returns
successful if it was written to non-volatile storage. Since it doesn't
matter if the write to the super block is lost, because it can be
recovered, the FUA option is not necessary. But the name of the function
nilfs_sync_super() kind of suggests, that it guarantees, that the super
block is written to non-volatile storage so I don't know if we should
remove the FUA flag.

This also means, that if nilfs_sync_super() was called no additional
blkdev_issue_flush() is necessary. So if the super block was written
during segment construction there is also no need for an additional
blkdev_issue_flush().

> Can you improve the patch considering these view points ?

Yes I will work on it.

br,
Andreas Rohner
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
