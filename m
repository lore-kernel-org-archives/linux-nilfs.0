From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH v2 3/9] nilfs2: introduce new feature flag for tracking
 live blocks
Date: Sat, 09 May 2015 20:53:33 +0200
Message-ID: <554E57AD.4040908@gmx.net>
References: <1430647522-14304-1-git-send-email-andreas.rohner@gmx.net>	<1430647522-14304-4-git-send-email-andreas.rohner@gmx.net> <20150509.112814.2026089040966346261.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150509.112814.2026089040966346261.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2015-05-09 04:28, Ryusuke Konishi wrote:
> On Sun,  3 May 2015 12:05:16 +0200, Andreas Rohner wrote:
>> This patch introduces a new file system feature flag
>> NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS. If it is enabled, the file system
>> will keep track of the number of live blocks per segment. This
>> information can be used by the GC to select segments for cleaning more
>> efficiently.
> 
> Please describe the reason why you separated
> NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS and
> NILFS_FEATURE_COMPAT_SUFILE_LIVE_BLKS_EXT that you mentioned before
> in the commit log.

Yes sure.

Regards,
Andreas Rohner

>>
>> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
>> ---
>>  fs/nilfs2/the_nilfs.h     | 8 ++++++++
>>  include/linux/nilfs2_fs.h | 4 +++-
>>  2 files changed, 11 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
>> index 12cd91d..d755b6b 100644
>> --- a/fs/nilfs2/the_nilfs.h
>> +++ b/fs/nilfs2/the_nilfs.h
>> @@ -401,4 +401,12 @@ static inline int nilfs_flush_device(struct the_nilfs *nilfs)
>>  	return err;
>>  }
>>  
>> +static inline int nilfs_feature_track_live_blks(struct the_nilfs *nilfs)
>> +{
>> +	const __u64 required_bits = NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS |
>> +				    NILFS_FEATURE_COMPAT_SUFILE_LIVE_BLKS_EXT;
>> +
>> +	return ((nilfs->ns_feature_compat & required_bits) == required_bits);
>> +}
>> +
>>  #endif /* _THE_NILFS_H */
>> diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
>> index 4800daa..5f05bbf 100644
>> --- a/include/linux/nilfs2_fs.h
>> +++ b/include/linux/nilfs2_fs.h
>> @@ -221,11 +221,13 @@ struct nilfs_super_block {
>>   * doesn't know about, it should refuse to mount the filesystem.
>>   */
>>  #define NILFS_FEATURE_COMPAT_SUFILE_LIVE_BLKS_EXT	BIT(0)
>> +#define NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS		BIT(1)
> 
> Ditto.  Avoid using BIT macro in nilfs2_fs.h for now.
> 
> Regards,
> Ryusuke Konishi
> 
>>  #define NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT		BIT(0)
>>  
>>  #define NILFS_FEATURE_COMPAT_SUPP					\
>> -			(NILFS_FEATURE_COMPAT_SUFILE_LIVE_BLKS_EXT)
>> +			(NILFS_FEATURE_COMPAT_SUFILE_LIVE_BLKS_EXT |	\
>> +			 NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS)
>>  #define NILFS_FEATURE_COMPAT_RO_SUPP	NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT
>>  #define NILFS_FEATURE_INCOMPAT_SUPP	0ULL
>>  
>> -- 
>> 2.3.7
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
