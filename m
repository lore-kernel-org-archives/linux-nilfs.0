From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH v2 1/9] nilfs2: copy file system feature flags to the
 nilfs object
Date: Sat, 09 May 2015 20:41:18 +0200
Message-ID: <554E54CE.2020303@gmx.net>
References: <1430647522-14304-1-git-send-email-andreas.rohner@gmx.net>	<1430647522-14304-2-git-send-email-andreas.rohner@gmx.net> <20150509.105445.1816655707671265145.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150509.105445.1816655707671265145.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2015-05-09 03:54, Ryusuke Konishi wrote:
> On Sun,  3 May 2015 12:05:14 +0200, Andreas Rohner wrote:
>> This patch adds three new attributes to the nilfs object, which contain
>> a copy of the feature flags from the super block. This can be used, to
>> efficiently test whether file system feature flags are set or not.
>>
>> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
>> ---
>>  fs/nilfs2/the_nilfs.c | 4 ++++
>>  fs/nilfs2/the_nilfs.h | 8 ++++++++
>>  2 files changed, 12 insertions(+)
>>
>> diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
>> index 69bd801..606fdfc 100644
>> --- a/fs/nilfs2/the_nilfs.c
>> +++ b/fs/nilfs2/the_nilfs.c
>> @@ -630,6 +630,10 @@ int init_nilfs(struct the_nilfs *nilfs, struct super_block *sb, char *data)
>>  	get_random_bytes(&nilfs->ns_next_generation,
>>  			 sizeof(nilfs->ns_next_generation));
>>  
>> +	nilfs->ns_feature_compat = le64_to_cpu(sbp->s_feature_compat);
>> +	nilfs->ns_feature_compat_ro = le64_to_cpu(sbp->s_feature_compat_ro);
>> +	nilfs->ns_feature_incompat = le64_to_cpu(sbp->s_feature_incompat);
> 
> Consider moving these initialization to just before calling
> nilfs_check_feature_compatibility().

Yes no problem.

Regards,
Andreas Rohner

> It uses compat flags, and I'd like to unfold the function using these
> internal variables sometime.
> 
>> +
>>  	err = nilfs_store_disk_layout(nilfs, sbp);
>>  	if (err)
>>  		goto failed_sbh;
>> diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
>> index 23778d3..12cd91d 100644
>> --- a/fs/nilfs2/the_nilfs.h
>> +++ b/fs/nilfs2/the_nilfs.h
>> @@ -101,6 +101,9 @@ enum {
>>   * @ns_dev_kobj: /sys/fs/<nilfs>/<device>
>>   * @ns_dev_kobj_unregister: completion state
>>   * @ns_dev_subgroups: <device> subgroups pointer
>> + * @ns_feature_compat: Compatible feature set
>> + * @ns_feature_compat_ro: Read-only compatible feature set
>> + * @ns_feature_incompat: Incompatible feature set
>>   */
>>  struct the_nilfs {
>>  	unsigned long		ns_flags;
>> @@ -201,6 +204,11 @@ struct the_nilfs {
>>  	struct kobject ns_dev_kobj;
>>  	struct completion ns_dev_kobj_unregister;
>>  	struct nilfs_sysfs_dev_subgroups *ns_dev_subgroups;
>> +
>> +	/* Features */
>> +	__u64                   ns_feature_compat;
>> +	__u64                   ns_feature_compat_ro;
>> +	__u64                   ns_feature_incompat;
>>  };
>>  
>>  #define THE_NILFS_FNS(bit, name)					\
>> -- 
>> 2.3.7
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
