Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.224
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794801859;
	b=zysk9Bjh5CUlqUIjqnIQl7Ess3TSzbOS1LY6fihCtUCTdQg4U/ANMY5BUplOwxoTft+D
	 Cj6CEADQySdJR8BmsZKP2HkM7aI6Ki9PxD69oAajf0eVcqyiSSDM52lzr42/AaY8OQRqj
	 jTJDAsIAsTYOHpk5XrZYaE7wzZqJYbzv3NdgLoxyPrsSZUr1NnEzjLuHWz8CY3tvdChG9
	 pG6fw6yxnWPRq/65ZaAJIz1ivk/Q01o6mmfZwLkhzodpTi9Z283crZex6VEHWS5eThsZl
	 mKSWZPPKXkGqNcmzWQ1gtQWvn14AVo4BZFkM/tIvLSzqWIn/FuJPgis2K5SCCUWyLVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794801859;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=jQp1Dwh3s3aJtnBbrOyeLLHK1t3EFAU6RCgMfRuRJhI=;
	b=bjFzJxVGHA3sDV+sJjS0aaA9B1oVLr0pO1KK2vyJV5gU7YlDOiC3zMlM52ENbX3p/FHa
	 TkjR6hf6XIlNDth7C7LUOWKZiIlaNcll9hNnkF2rOrE2KxR7rO+MEs6nCWXDKVEoDLjer
	 fSn1J4f3JOuFoJGUUV49Xi//DisCF/o6YWPqYkBqIhbNVCYCRW+YfJ273owHFcNAaMVgv
	 YTrPk0kBQUWnPtxVB5QAWAxYWVFN+AxYyV68SbO9deACX3IScTk/De82n9rHoRqUZkIG/
	 UmE5y/F7Gk9JkPKXpIXVA6V+E2ITqs6yy1e7vt97GFw1/jOTGIGa9SyOzyty/n7r9nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=xEq3AwMl;
	arc=none smtp.remote-ip=113.46.200.224
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFA7606A31C
	for <linux-nilfs@vger.kernel.org>; Mon, 16 Nov 2026 04:04:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CAFA7606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=xEq3AwMl
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=jQp1Dwh3s3aJtnBbrOyeLLHK1t3EFAU6RCgMfRuRJhI=;
	b=xEq3AwMlTVozPagqgZ2JyRZvb7fpNMEhfHgnGcOOdQQB/XDOzeJ+VMbkLSI/xNAxySiYRAd/P
	wvfmdzE9pdjtB0riwxfkQS+uzKbd2p+2QhN8bA6BK42xYwhAnMR1fUDz8j7lgaEIS+m2OZ2hqX/
	QtkvPFkRC+HihXVZuNlf3h4=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4jSZ3t66MXz1d05l;
	Mon, 16 Nov 2026 12:03:54 +0800 (CST)
Received: from kwepemf200016.china.huawei.com (unknown [7.202.181.9])
	by mail.maildlp.com (Postfix) with ESMTPS id 4F6EC40563;
	Mon, 16 Nov 2026 12:04:13 +0800 (CST)
Received: from [10.108.234.194] (10.108.234.194) by
 kwepemf200016.china.huawei.com (7.202.181.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 16 Nov 2026 12:04:02 +0800
Message-ID: <89a13930-ab51-45b9-a7ba-1924e2f1bc3c@huawei.com>
Date: Mon, 16 Nov 2026 12:03:59 +0800
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Post: <mailto:linux-nilfs@vger.kernel.org>
List-Help: <mailto:linux-nilfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-nilfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] nilfs2: introduce atime support
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>, Wang Jianjian
	<wangjianjian0@foxmail.com>
CC: <slava@dubeyko.com>, <linux-nilfs@vger.kernel.org>
References: <20261115013328.123821-1-wangjianjian0@foxmail.com>
 <tencent_F3CAF2061A8AE294D88513588FD3DE1F4806@qq.com>
 <CAKFNMo=YrOGtBLSaE=7YRcf97KCGGYkSEcy9P1W7mwT0rxq2Dg@mail.gmail.com>
From: "wangjianjian (C)" <wangjianjian3@huawei.com>
In-Reply-To: <CAKFNMo=YrOGtBLSaE=7YRcf97KCGGYkSEcy9P1W7mwT0rxq2Dg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemf200016.china.huawei.com (7.202.181.9)

在 2026/11/16 2:27, Ryusuke Konishi 写道:
> On Sun, Nov 15, 2026 at 10:33 AM Wang Jianjian wrote:
>>
>> From: Viacheslav Dubeyko <slava@dubeyko.com>
>>
>> Currently, NILFS2 doesn't support atime. And it is possible
>> to see the evidence of it by running generic/003 test-case of
>> xfstests suite:
>>
>> sudo ./check generic/003
>> FSTYP -- nilfs2
>> PLATFORM -- Linux/x86_64 hfsplus-testing-0001 6.18.0-rc1+ #10 SMP PREEMPT_DYNAMIC Fri Nov 28 20:48:25 PST 2025
>> MKFS_OPTIONS -- /dev/loop51
>> MOUNT_OPTIONS -- /dev/loop51 /mnt/scratch
>>
>> generic/003 35s ... - output mismatch (see xfstests-dev/results//generic/003.out.bad)
>>
>> This patch exchanges i_xattr on i_atime and i_pad
>> on i_atime_nsec fields of struct nilfs_inode in
>> the on-disk layout, removes all declarations that
>> disabled atime support. Also, it modifies
>> nilfs_read_inode_common(), nilfs_write_inode_common(),
>> and nilfs_setattr() with the goal of proper atime
>> support.
>>
>> sudo ./check generic/003
>> FSTYP         -- nilfs2
>> PLATFORM      -- Linux/x86_64 nilfs2-testing 6.19.0-rc1+ #8 SMP PREEMPT_DYNAMIC Tue Feb 17 16:21:59 PST 2026
>> MKFS_OPTIONS  -- /dev/loop51
>> MOUNT_OPTIONS -- /dev/loop51 /mnt/scratch
>>
>> generic/003  30s ...  34s
>> Ran: generic/003
>> Passed all 1 tests
>>
>> [1] https://github.com/nilfs-dev/nilfs2/issues/7
>>
>> Co-developed-by: Viacheslav Dubeyko <slava@dubeyko.com>
>> Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
>> Signed-off-by: Wang Jianjian <wangjianjian0@foxmail.com>
> 
> Hi Wang Jianjian,
> 
> Thank you for the v2 patches.  The overall implementation looks good to me.
> 
> I applied the series to my local tree with minor fixes, including
> adding the missing kernel-doc comments for the new members in
> "struct the_nilfs" and adjusting the patch 1 subject.
> 
> Sorry for the confusion in my previous email -- since Viacheslav is
> credited as the original patch Author, I will also update the
> authorship tags on my end to attribute "Co-developed-by" to you
> instead (per Documentation/process/submitting-patches.rst).
> 
> Once v7.4-rc3 is released, I will run tests on it and forward the
> patches to Viacheslav.
> 
> As a follow-up cleanup, we can also update the remaining places to
> reference the cached feature flags in the nilfs object directly
> instead of reading from the superblock buffer.
> However, since it would conflict with the ongoing VFS changes in the
> next cycle, I will defer that cleanup until after the next merge
> window closes.
> 
> Regarding nilfs-utils, I will refine the confirmation prompt messages
> slightly on my end, and merge the series into master promptly once the
> kernel patches are queued.
Hi Ryusuke,

Got it. Thanks!>
> Thanks,
> Ryusuke Konishi
> 
>> ---
>>   fs/nilfs2/Kconfig                  |  2 +-
>>   fs/nilfs2/inode.c                  | 11 +++++++++--
>>   fs/nilfs2/nilfs.h                  |  4 ----
>>   fs/nilfs2/segment.c                |  2 --
>>   fs/nilfs2/super.c                  |  8 +++-----
>>   include/uapi/linux/nilfs2_ondisk.h |  8 ++++----
>>   6 files changed, 17 insertions(+), 18 deletions(-)
>>
>> diff --git a/fs/nilfs2/Kconfig b/fs/nilfs2/Kconfig
>> index 0a5ace60e6ab..79b99c33af06 100644
>> --- a/fs/nilfs2/Kconfig
>> +++ b/fs/nilfs2/Kconfig
>> @@ -20,7 +20,7 @@ config NILFS2_FS
>>            snapshot is mountable as a read-only file system concurrently with
>>            its writable mount, and this feature is convenient for online backup.
>>
>> -         Some features including atime, extended attributes, and POSIX ACLs,
>> +         Some features including extended attributes, and POSIX ACLs,
>>            are not supported yet.
>>
>>            To compile this file system support as a module, choose M here: the
>> diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
>> index a99a69e9f91b..d91620f55629 100644
>> --- a/fs/nilfs2/inode.c
>> +++ b/fs/nilfs2/inode.c
>> @@ -386,6 +386,7 @@ void nilfs_set_inode_flags(struct inode *inode)
>>   int nilfs_read_inode_common(struct inode *inode,
>>                              struct nilfs_inode *raw_inode)
>>   {
>> +       struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
>>          struct nilfs_inode_info *ii = NILFS_I(inode);
>>          int err;
>>
>> @@ -394,8 +395,12 @@ int nilfs_read_inode_common(struct inode *inode,
>>          i_gid_write(inode, le32_to_cpu(raw_inode->i_gid));
>>          set_nlink(inode, le16_to_cpu(raw_inode->i_links_count));
>>          inode->i_size = le64_to_cpu(raw_inode->i_size);
>> -       inode_set_atime(inode, le64_to_cpu(raw_inode->i_mtime),
>> -                       le32_to_cpu(raw_inode->i_mtime_nsec));
>> +       if (nilfs->ns_feature_compat_ro & NILFS_FEATURE_COMPAT_RO_ATIME)
>> +               inode_set_atime(inode, le64_to_cpu(raw_inode->i_atime),
>> +                               le32_to_cpu(raw_inode->i_atime_nsec));
>> +       else
>> +               inode_set_atime(inode, le64_to_cpu(raw_inode->i_mtime),
>> +                               le32_to_cpu(raw_inode->i_mtime_nsec));
>>          inode_set_ctime(inode, le64_to_cpu(raw_inode->i_ctime),
>>                          le32_to_cpu(raw_inode->i_ctime_nsec));
>>          inode_set_mtime(inode, le64_to_cpu(raw_inode->i_mtime),
>> @@ -701,8 +706,10 @@ void nilfs_write_inode_common(struct inode *inode,
>>          raw_inode->i_gid = cpu_to_le32(i_gid_read(inode));
>>          raw_inode->i_links_count = cpu_to_le16(inode->i_nlink);
>>          raw_inode->i_size = cpu_to_le64(inode->i_size);
>> +       raw_inode->i_atime = cpu_to_le64(inode_get_atime_sec(inode));
>>          raw_inode->i_ctime = cpu_to_le64(inode_get_ctime_sec(inode));
>>          raw_inode->i_mtime = cpu_to_le64(inode_get_mtime_sec(inode));
>> +       raw_inode->i_atime_nsec = cpu_to_le32(inode_get_atime_nsec(inode));
>>          raw_inode->i_ctime_nsec = cpu_to_le32(inode_get_ctime_nsec(inode));
>>          raw_inode->i_mtime_nsec = cpu_to_le32(inode_get_mtime_nsec(inode));
>>          raw_inode->i_blocks = cpu_to_le64(inode->i_blocks);
>> diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
>> index 28d35b2fa7f7..81cc6552365e 100644
>> --- a/fs/nilfs2/nilfs.h
>> +++ b/fs/nilfs2/nilfs.h
>> @@ -27,7 +27,6 @@
>>    * @i_state: dynamic state flags
>>    * @i_bmap: pointer on i_bmap_data
>>    * @i_bmap_data: raw block mapping
>> - * @i_xattr: <TODO>
>>    * @i_dir_start_lookup: page index of last successful search
>>    * @i_cno: checkpoint number for GC inode
>>    * @i_assoc_inode: associated inode (B-tree node cache holder or back pointer)
>> @@ -43,7 +42,6 @@ struct nilfs_inode_info {
>>          unsigned long  i_state;         /* Dynamic state flags */
>>          struct nilfs_bmap *i_bmap;
>>          struct nilfs_bmap i_bmap_data;
>> -       __u64 i_xattr;  /* sector_t ??? */
>>          __u32 i_dir_start_lookup;
>>          __u64 i_cno;            /* check point number for GC inode */
>>          struct inode *i_assoc_inode;
>> @@ -234,8 +232,6 @@ static inline int nilfs_init_acl(struct inode *inode, struct inode *dir)
>>   }
>>   #endif
>>
>> -#define NILFS_ATIME_DISABLE
>> -
>>   /* Flags that should be inherited by new inodes from their parent. */
>>   #define NILFS_FL_INHERITED                                             \
>>          (FS_SECRM_FL | FS_UNRM_FL | FS_COMPR_FL | FS_SYNC_FL |          \
>> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
>> index af0c3560444f..68b640a7aa5b 100644
>> --- a/fs/nilfs2/segment.c
>> +++ b/fs/nilfs2/segment.c
>> @@ -930,8 +930,6 @@ static void nilfs_write_root_mdt_inode(struct inode *inode,
>>          nilfs_write_inode_common(inode, raw_inode);
>>
>>          /* zero-fill unused portion of raw_inode */
>> -       raw_inode->i_xattr = 0;
>> -       raw_inode->i_pad = 0;
>>          memset((void *)raw_inode + sizeof(*raw_inode), 0,
>>                 nilfs->ns_inode_size - sizeof(*raw_inode));
>>
>> diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
>> index f92bcf1a9544..ddad1e4f55ce 100644
>> --- a/fs/nilfs2/super.c
>> +++ b/fs/nilfs2/super.c
>> @@ -863,11 +863,6 @@ int nilfs_store_magic(struct super_block *sb,
>>
>>          sb->s_magic = le16_to_cpu(sbp->s_magic);
>>
>> -       /* FS independent flags */
>> -#ifdef NILFS_ATIME_DISABLE
>> -       sb->s_flags |= SB_NOATIME;
>> -#endif
>> -
>>          nilfs->ns_resuid = le16_to_cpu(sbp->s_def_resuid);
>>          nilfs->ns_resgid = le16_to_cpu(sbp->s_def_resgid);
>>          nilfs->ns_interval = le32_to_cpu(sbp->s_c_interval);
>> @@ -876,6 +871,9 @@ int nilfs_store_magic(struct super_block *sb,
>>          nilfs->ns_feature_compat_ro = le64_to_cpu(sbp->s_feature_compat_ro);
>>          nilfs->ns_feature_incompat = le64_to_cpu(sbp->s_feature_incompat);
>>
>> +       if (!(nilfs->ns_feature_compat_ro & NILFS_FEATURE_COMPAT_RO_ATIME))
>> +               sb->s_flags |= SB_NOATIME;
>> +
>>          return 0;
>>   }
>>
>> diff --git a/include/uapi/linux/nilfs2_ondisk.h b/include/uapi/linux/nilfs2_ondisk.h
>> index 19587700c92c..e94593137adb 100644
>> --- a/include/uapi/linux/nilfs2_ondisk.h
>> +++ b/include/uapi/linux/nilfs2_ondisk.h
>> @@ -47,9 +47,9 @@
>>    * @i_links_count: links count
>>    * @i_flags: file flags
>>    * @i_bmap: block mapping
>> - * @i_xattr: extended attributes
>> + * @i_atime: access time (seconds)
>>    * @i_generation: file generation (for NFS)
>> - * @i_pad: padding
>> + * @i_atime_nsec: access time (nano seconds)
>>    */
>>   struct nilfs_inode {
>>          __le64  i_blocks;
>> @@ -65,9 +65,9 @@ struct nilfs_inode {
>>          __le32  i_flags;
>>          __le64  i_bmap[NILFS_INODE_BMAP_SIZE];
>>   #define i_device_code  i_bmap[0]
>> -       __le64  i_xattr;
>> +       __le64  i_atime;
>>          __le32  i_generation;
>> -       __le32  i_pad;
>> +       __le32  i_atime_nsec;
>>   };
>>
>>   #define NILFS_MIN_INODE_SIZE           128
>> --
>> 2.47.3
>>

-- 
Regards
