Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.217
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792998266;
	b=gXNleMNuPERILluh5THVkAoTB+wRJhdWvdja8n4oDbVHp1Yyvuva41aOYu26CF3p1x97
	 mcz+5TdIw9KIKNM8n71kI4ajTgsUcQGxeOY2Oxu282WlOAd9+FTXl4Gp1G3eZvQZZwhiI
	 vLHy19bNG4/epwwNKFUZmjU4MZjp42pgrlJ+WsI7x2td4est8cjaoYZ63lT5PkTkmqU29
	 AoiRCaEWFfpkVvWA1UO/L+7BdLrqr0RIJgp2qCjYw1UMNKw1sxS58b9snwiWqoziyO91a
	 yL/iPDraC+EMo8AuksI06TgG53yZd++lFRwIt9Tyi2p3++p+jVlumMtWkO2e2ApooVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792998266;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=X/eFdkXUNQx4x8K4Cnqa8YIilnDL/3Z4ZGL73Ff3qgk=;
	b=wR2BnyXFXliDAx530EZSM3AMTmmonwLVaZXERJp2vkjWK9LnDMJnISopSW8d5zIs9LS6
	 FhJ+skwss1uMU7Mn2ES2qVtsmh/u4Y1xZPDwEvbUQE9Ad5CN4UdIE5MvRnaXTvh3jeqhw
	 zU+/fin4JtQDSI4i9xTUXLNZ8Nzjj9y7tl9maV8xm7cE8pvbBvQMTOi73shSOy0VM7Cl+
	 4ROdTtHEp8vbWz2sDixleTNecQoF9VTJSKHk6yLRxYyzF60fmQSR7jT/3Gj7QBfuFZ/CB
	 h/aQjopNd7VDgBsnDSI2vhAAFgnDuAdjqYAGQlNXxOBJ5vbY1sZDz5lpUVHZEgw5UDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=aFFIW48E;
	arc=none smtp.remote-ip=113.46.200.217
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B24606A31A
	for <linux-nilfs@vger.kernel.org>; Mon, 26 Oct 2026 07:04:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 17B24606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=aFFIW48E
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=X/eFdkXUNQx4x8K4Cnqa8YIilnDL/3Z4ZGL73Ff3qgk=;
	b=aFFIW48EHH4LzlNsRrkhcpBhC9/XOH9ZT47XNtkUhcyKJOqJAO/cionSf+oAJMkT/PLQAZIWP
	WL2vDuNY5+GeNIEnzDlSC+tETfaTpFxQTh0twNKyi6vKgHkKleiqdT8DEJ7GlhFz29v0QEBl64E
	g0wiOnlGSiHffbhgkUq9qkE=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4jCl3X4x1JzcbTF;
	Mon, 26 Oct 2026 15:04:08 +0800 (CST)
Received: from kwepemf200016.china.huawei.com (unknown [7.202.181.9])
	by mail.maildlp.com (Postfix) with ESMTPS id A048F202E6;
	Mon, 26 Oct 2026 15:04:18 +0800 (CST)
Received: from [10.108.234.194] (10.108.234.194) by
 kwepemf200016.china.huawei.com (7.202.181.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 26 Oct 2026 15:04:18 +0800
Message-ID: <eefa16b7-506e-47e1-8ab9-b4f5738733ea@huawei.com>
Date: Mon, 26 Oct 2026 15:04:13 +0800
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
Subject: Re: [PATCH] nilfs2: add atime support
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>, <wangjianjian0@foxmail.com>,
	<slava@dubeyko.com>
CC: <linux-nilfs@vger.kernel.org>
References: <tencent_A1BD1C90A8E503B41B451E310527DC9E9F07@qq.com>
 <CAKFNMokNhGtWE-uAmXBAXneuqwFZ9bP++jRexS+p3Xdbq8G+Zw@mail.gmail.com>
From: "wangjianjian (C)" <wangjianjian3@huawei.com>
In-Reply-To: <CAKFNMokNhGtWE-uAmXBAXneuqwFZ9bP++jRexS+p3Xdbq8G+Zw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemf200016.china.huawei.com (7.202.181.9)

在 2026/10/25 13:09, Ryusuke Konishi 写道:
> On Sun, Oct 25, 2026 at 1:04 PM wrote:
>>
>> From: Wang Jianjian <wangjianjian0@foxmail.com>
>>
>> This RFC patch added atime support for nilfs2. To keep disk inode
>> layout, reuse {i_xattr, i_pad} as {i_atime, i_atime_nosec}. And remove
>> SB_NOATIME from sb_flags.
>>
>> For now, the default behavior is relatime and other time mount
>> options(such as noatime, lazytime,...) are not considered.
>>
>> Signed-off-by: Wang Jianjian <wangjianjian0@foxmail.com>
>> ---
>>   fs/nilfs2/inode.c                  | 6 ++++--
>>   fs/nilfs2/nilfs.h                  | 2 --
>>   fs/nilfs2/segment.c                | 3 ---
>>   fs/nilfs2/super.c                  | 5 -----
>>   include/uapi/linux/nilfs2_ondisk.h | 4 ++--
>>   5 files changed, 6 insertions(+), 14 deletions(-)
> 
> Hi Wang Jianjian, (and Viacheslav)
> 
> A similar proposal was made in the following RFC patch [1].
> 
> [1] https://lore.kernel.org/all/20260219204343.70117-1-slava@dubeyko.com/
> 
> Since that patch is more comprehensive, I would prefer to proceed
> based on Viacheslav's proposal.
> Regarding atime support, we previously agreed to utilize the reserved
> extended attribute field.
> As I recall, the remaining tasks were determining the design for the
> COMPAT flag in the superblock to ensure both forward and backward
> compatibility, and addressing the necessary updates for nilfs-utils.

Sure. And sorry I didn't notice Viacheslav's patch.>
> This has been on hold for more than half a year due to personal
> circumstances on both Viacheslav's side and mine, but depending on his
> availability, it might be time to start moving this forward soon.
> 
> However, since I am currently focused on analyzing a few issues and
> preparing patches to fix them, and will be traveling over the next two
> weeks due to family matters (which have required frequent travel this
> year), I would appreciate it if we could resume detailed discussions
> after 7.4-rc2 is released.
> 
> Thanks,
> Ryusuke Konishi
> 
>>
>> diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
>> index 34e6096069ad..c04f6aea5dee 100644
>> --- a/fs/nilfs2/inode.c
>> +++ b/fs/nilfs2/inode.c
>> @@ -409,8 +409,8 @@ int nilfs_read_inode_common(struct inode *inode,
>>          i_gid_write(inode, le32_to_cpu(raw_inode->i_gid));
>>          set_nlink(inode, le16_to_cpu(raw_inode->i_links_count));
>>          inode->i_size = le64_to_cpu(raw_inode->i_size);
>> -       inode_set_atime(inode, le64_to_cpu(raw_inode->i_mtime),
>> -                       le32_to_cpu(raw_inode->i_mtime_nsec));
>> +       inode_set_atime(inode, le64_to_cpu(raw_inode->i_atime),
>> +                       le32_to_cpu(raw_inode->i_atime_nsec));
>>          inode_set_ctime(inode, le64_to_cpu(raw_inode->i_ctime),
>>                          le32_to_cpu(raw_inode->i_ctime_nsec));
>>          inode_set_mtime(inode, le64_to_cpu(raw_inode->i_mtime),
>> @@ -721,8 +721,10 @@ void nilfs_write_inode_common(struct inode *inode,
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
>> index 4fc42d3787a4..23e2624f13ac 100644
>> --- a/fs/nilfs2/nilfs.h
>> +++ b/fs/nilfs2/nilfs.h
>> @@ -234,8 +234,6 @@ static inline int nilfs_init_acl(struct inode *inode, struct inode *dir)
>>   }
>>   #endif
>>
>> -#define NILFS_ATIME_DISABLE
>> -
>>   /* Flags that should be inherited by new inodes from their parent. */
>>   #define NILFS_FL_INHERITED                                             \
>>          (FS_SECRM_FL | FS_UNRM_FL | FS_COMPR_FL | FS_SYNC_FL |          \
>> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
>> index 829573cb6131..3a9a66cc22e0 100644
>> --- a/fs/nilfs2/segment.c
>> +++ b/fs/nilfs2/segment.c
>> @@ -929,9 +929,6 @@ static void nilfs_write_root_mdt_inode(struct inode *inode,
>>
>>          nilfs_write_inode_common(inode, raw_inode);
>>
>> -       /* zero-fill unused portion of raw_inode */
>> -       raw_inode->i_xattr = 0;
>> -       raw_inode->i_pad = 0;
>>          memset((void *)raw_inode + sizeof(*raw_inode), 0,
>>                 nilfs->ns_inode_size - sizeof(*raw_inode));
>>
>> diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
>> index 893a504cb80c..75c068359b7c 100644
>> --- a/fs/nilfs2/super.c
>> +++ b/fs/nilfs2/super.c
>> @@ -867,11 +867,6 @@ int nilfs_store_magic(struct super_block *sb,
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
>> diff --git a/include/uapi/linux/nilfs2_ondisk.h b/include/uapi/linux/nilfs2_ondisk.h
>> index b3442b16ff6a..ed365ba4565f 100644
>> --- a/include/uapi/linux/nilfs2_ondisk.h
>> +++ b/include/uapi/linux/nilfs2_ondisk.h
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
>>
>> base-commit: a4ff2be345d0abc943da8dd8da98151843b750dc
>> --
>> 2.34.1
>>

-- 
Regards
