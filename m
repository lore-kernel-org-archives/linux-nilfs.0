Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C1C4A15
	for <linux-nilfs@vger.kernel.org>; Thu, 15 Aug 2024 01:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723684654; cv=none; b=oV+pwXcr637Th6DisVgEi+LCrUMEjWSGtZ56mbIUHZpu2Pq6zRntZpHXTHMksemE1LjPkoHqyIz9bmLS5SWIRBBXTU73h3kSRU7LEIIcnb0o26raowNC7ElpcmrUj/VE3DXj/0h1OdCrclDY2mDpHXS3AAihZYNX4UJXNukVKv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723684654; c=relaxed/simple;
	bh=DQ2Xxi4W673OmzvjHvFDpD+Sy5QbSiVGL/kg6AA2Sp4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=HtlN47hog3MAWnLo+lWC1v9Ec/08pXSNdeRXc2KWCI0BDRE+1Is/XtaIkBr5TujVCSZxTAvzw+9FOePsv12RsTV1N1Tp18bKyXbMXzj1PORJb0SB+DKmD1lWq29HHI3bupWj+82l+P9etCwMpfk91GBGYS8u/syXgheNpYXROJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4WknCx5sZRz1j6P9
	for <linux-nilfs@vger.kernel.org>; Thu, 15 Aug 2024 09:12:29 +0800 (CST)
Received: from dggpemm500021.china.huawei.com (unknown [7.185.36.109])
	by mail.maildlp.com (Postfix) with ESMTPS id 6C2EA1A0188
	for <linux-nilfs@vger.kernel.org>; Thu, 15 Aug 2024 09:17:22 +0800 (CST)
Received: from [10.67.109.234] (10.67.109.234) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 15 Aug 2024 09:17:22 +0800
Message-ID: <2892e7e1-6714-734e-6b23-4e7976ac9a52@huawei.com>
Date: Thu, 15 Aug 2024 09:17:21 +0800
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next] nilfs2: use common implementation of file type
Content-Language: en-GB
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
CC: <yuehaibing@huawei.com>, <linux-nilfs@vger.kernel.org>
References: <20240814123801.1196678-1-huangxiaojia2@huawei.com>
 <CAKFNMonzv8Xpx2bucrPwtmq=vYcFbVz1KC5G_Y89v9N=vQRnww@mail.gmail.com>
From: Huang Xiaojia <huangxiaojia2@huawei.com>
In-Reply-To: <CAKFNMonzv8Xpx2bucrPwtmq=vYcFbVz1KC5G_Y89v9N=vQRnww@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggpeml500012.china.huawei.com (7.185.36.15) To
 dggpemm500021.china.huawei.com (7.185.36.109)


On 2024/8/14 21:57, Ryusuke Konishi wrote:
> On Wed, Aug 14, 2024 at 9:31 PM Huang Xiaojia  wrote:
>> Deduplicate the nilfs2 file type conversion implementation and
>> remove NILFS_FT_* definitions since it's the same as defined
>> by POSIX.
>>
>> Signed-off-by: Huang Xiaojia <huangxiaojia2@huawei.com>
>> ---
>>   fs/nilfs2/dir.c                    | 44 ++++--------------------------
>>   include/uapi/linux/nilfs2_ondisk.h | 16 -----------
>>   2 files changed, 5 insertions(+), 55 deletions(-)
>>
>> diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
>> index 4a29b0138d75..ba6bc6efcf11 100644
>> --- a/fs/nilfs2/dir.c
>> +++ b/fs/nilfs2/dir.c
>> @@ -231,37 +231,6 @@ static struct nilfs_dir_entry *nilfs_next_entry(struct nilfs_dir_entry *p)
>>                                            nilfs_rec_len_from_disk(p->rec_len));
>>   }
>>
>> -static unsigned char
>> -nilfs_filetype_table[NILFS_FT_MAX] = {
>> -       [NILFS_FT_UNKNOWN]      = DT_UNKNOWN,
>> -       [NILFS_FT_REG_FILE]     = DT_REG,
>> -       [NILFS_FT_DIR]          = DT_DIR,
>> -       [NILFS_FT_CHRDEV]       = DT_CHR,
>> -       [NILFS_FT_BLKDEV]       = DT_BLK,
>> -       [NILFS_FT_FIFO]         = DT_FIFO,
>> -       [NILFS_FT_SOCK]         = DT_SOCK,
>> -       [NILFS_FT_SYMLINK]      = DT_LNK,
>> -};
>> -
>> -#define S_SHIFT 12
>> -static unsigned char
>> -nilfs_type_by_mode[(S_IFMT >> S_SHIFT) + 1] = {
>> -       [S_IFREG >> S_SHIFT]    = NILFS_FT_REG_FILE,
>> -       [S_IFDIR >> S_SHIFT]    = NILFS_FT_DIR,
>> -       [S_IFCHR >> S_SHIFT]    = NILFS_FT_CHRDEV,
>> -       [S_IFBLK >> S_SHIFT]    = NILFS_FT_BLKDEV,
>> -       [S_IFIFO >> S_SHIFT]    = NILFS_FT_FIFO,
>> -       [S_IFSOCK >> S_SHIFT]   = NILFS_FT_SOCK,
>> -       [S_IFLNK >> S_SHIFT]    = NILFS_FT_SYMLINK,
>> -};
>> -
>> -static void nilfs_set_de_type(struct nilfs_dir_entry *de, struct inode *inode)
>> -{
>> -       umode_t mode = inode->i_mode;
>> -
>> -       de->file_type = nilfs_type_by_mode[(mode & S_IFMT)>>S_SHIFT];
>> -}
>> -
>>   static int nilfs_readdir(struct file *file, struct dir_context *ctx)
>>   {
>>          loff_t pos = ctx->pos;
>> @@ -297,10 +266,7 @@ static int nilfs_readdir(struct file *file, struct dir_context *ctx)
>>                          if (de->inode) {
>>                                  unsigned char t;
>>
>> -                               if (de->file_type < NILFS_FT_MAX)
>> -                                       t = nilfs_filetype_table[de->file_type];
>> -                               else
>> -                                       t = DT_UNKNOWN;
>> +                               t = fs_ftype_to_dtype(de->file_type);
>>
>>                                  if (!dir_emit(ctx, de->name, de->name_len,
>>                                                  le64_to_cpu(de->inode), t)) {
>> @@ -444,7 +410,7 @@ void nilfs_set_link(struct inode *dir, struct nilfs_dir_entry *de,
>>          err = nilfs_prepare_chunk(folio, from, to);
>>          BUG_ON(err);
>>          de->inode = cpu_to_le64(inode->i_ino);
>> -       nilfs_set_de_type(de, inode);
>> +       de->file_type = fs_umode_to_ftype(inode->i_mode);
>>          nilfs_commit_chunk(folio, mapping, from, to);
>>          inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
>>   }
>> @@ -531,7 +497,7 @@ int nilfs_add_link(struct dentry *dentry, struct inode *inode)
>>          de->name_len = namelen;
>>          memcpy(de->name, name, namelen);
>>          de->inode = cpu_to_le64(inode->i_ino);
>> -       nilfs_set_de_type(de, inode);
>> +       de->file_type = fs_umode_to_ftype(inode->i_mode);
>>          nilfs_commit_chunk(folio, folio->mapping, from, to);
>>          inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
>>          nilfs_mark_inode_dirty(dir);
>> @@ -612,14 +578,14 @@ int nilfs_make_empty(struct inode *inode, struct inode *parent)
>>          de->rec_len = nilfs_rec_len_to_disk(NILFS_DIR_REC_LEN(1));
>>          memcpy(de->name, ".\0\0", 4);
>>          de->inode = cpu_to_le64(inode->i_ino);
>> -       nilfs_set_de_type(de, inode);
>> +       de->file_type = fs_umode_to_ftype(inode->i_mode);
>>
>>          de = (struct nilfs_dir_entry *)(kaddr + NILFS_DIR_REC_LEN(1));
>>          de->name_len = 2;
>>          de->rec_len = nilfs_rec_len_to_disk(chunk_size - NILFS_DIR_REC_LEN(1));
>>          de->inode = cpu_to_le64(parent->i_ino);
>>          memcpy(de->name, "..\0", 4);
>> -       nilfs_set_de_type(de, inode);
>> +       de->file_type = fs_umode_to_ftype(inode->i_mode);
>>          kunmap_local(kaddr);
>>          nilfs_commit_chunk(folio, mapping, 0, chunk_size);
>>   fail:
>> diff --git a/include/uapi/linux/nilfs2_ondisk.h b/include/uapi/linux/nilfs2_ondisk.h
>> index c23f91ae5fe8..f52c338103a5 100644
>> --- a/include/uapi/linux/nilfs2_ondisk.h
>> +++ b/include/uapi/linux/nilfs2_ondisk.h
>> @@ -306,22 +306,6 @@ struct nilfs_dir_entry {
>>          char    pad;
>>   };
>>
>> -/*
>> - * NILFS directory file types.  Only the low 3 bits are used.  The
>> - * other bits are reserved for now.
>> - */
>> -enum {
>> -       NILFS_FT_UNKNOWN,
>> -       NILFS_FT_REG_FILE,
>> -       NILFS_FT_DIR,
>> -       NILFS_FT_CHRDEV,
>> -       NILFS_FT_BLKDEV,
>> -       NILFS_FT_FIFO,
>> -       NILFS_FT_SOCK,
>> -       NILFS_FT_SYMLINK,
>> -       NILFS_FT_MAX
>> -};
>> -
>>   /*
>>    * NILFS_DIR_PAD defines the directory entries boundaries
>>    *
>> --
>> 2.34.1
>>
> Hi Huang Xiaojia,
>
> I understand the intention of using common code for conversion between
> ftype and dtype. I haven't fully reviewed this yet, including its
> compatibility, but I agree with the direction.
>
> However, please do not remove the definitions of NILFS_FT_* in
> nilfs2_ondisk.h (even if there is no longer a reference from the
> kernel implementation).
>
> These are identifiers exposed to user space tools as a part of the
> disk format definition in the uapi header, and removing them means
> changing the user interface.
>
> In the future, if FT_* is exposed to userspace, I think we will
> redefine them as aliases to them. For now, leave them as they are.
> Even if they should be unified to FT_*, they should be considered to
> be phased out rather than suddenly removed.
>
> Thanks,
> Ryusuke Konishi

Hi Ryusuke Konishi,

Thanks for your reply. Sorry for my negelect over user space tools.
I will keep NILFS_FT_* in the following patch.

Best Regards,
Huang Xiaojia

