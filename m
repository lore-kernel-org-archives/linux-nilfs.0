Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E757B3B1ED7
	for <linux-nilfs@vger.kernel.org>; Sat,  8 Aug 2026 08:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786177877; cv=none; b=XPuS7G4gqfLDXJoYpQn3Zn/QIRB/BiaLtUNjTtoivPRheUZ5OUXTkZ50oI05GeQj8xZVIXoU86l20ck0LmSNYuMt5E7pgVVQiGdr2RB+D0AxxP/XXyhB5n3lMjQPh2+qribYQDHE5T0scAuXJQfOqrmmcVEJbITLoEYAcVNUCe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786177877; c=relaxed/simple;
	bh=73bEWl/XM/YiMZND1Fr5Kk3XERt4kCagPwkfM6ywMSE=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=qhTWCS+kmDrGX0pzXQ4Ym2E+4615LJZAmQDsz6JNSfeBTITSf79kvn1qRjxiiwLbF24hyVfItbM4mLQJIH+q3Q/o7jaduvTZxVkmBHQgqHIyzARgJi2kms+zUIfa6DpICIg6SQDGTq9R5UZ0eWV2opuSN58ryYvhcNKMzw0bgwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=hz8O0E6V; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="hz8O0E6V"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=SUVAzmUOR8WbOqn5GkZfRTVolxtjHu6j+I6jXb/u+4k=;
	b=hz8O0E6VB+QK7y4SGZDskUS6hTDQvSwefOVHrSniumvc9HbY6DlwmdwqmzNvB1j9d4wgadBDW
	jRu9d7Wa2CSDi2DJCC5vu9R3KUWLB88U1YNs5uAQh3pTZBlHxG1NpWkosX9iBrWDqt522NTDNj9
	6GXy3Ut3esyho2aThkGHfbk=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4hHDV31xc7zpSvB;
	Sat,  8 Aug 2026 16:20:27 +0800 (CST)
Received: from kwepemf200016.china.huawei.com (unknown [7.202.181.9])
	by mail.maildlp.com (Postfix) with ESMTPS id B805C202E6;
	Sat,  8 Aug 2026 16:31:03 +0800 (CST)
Received: from [10.108.234.194] (10.108.234.194) by
 kwepemf200016.china.huawei.com (7.202.181.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 8 Aug 2026 16:31:03 +0800
Message-ID: <000b9199-ef5c-4959-8a46-47d5fda76f15@huawei.com>
Date: Sat, 8 Aug 2026 16:31:02 +0800
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] nilfs: check new inode's nlink when rename
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
CC: <slava@dubeyko.com>, <linux-nilfs@vger.kernel.org>
References: <20260730120105.2746192-1-wangjianjian3@huawei.com>
 <20260730120105.2746192-2-wangjianjian3@huawei.com>
 <CAKFNMo=_QiAVYgqCggCqVBBwC4F+g4cOWgS=Nt=AAghda48gAQ@mail.gmail.com>
From: "wangjianjian (C)" <wangjianjian3@huawei.com>
In-Reply-To: <CAKFNMo=_QiAVYgqCggCqVBBwC4F+g4cOWgS=Nt=AAghda48gAQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemf200016.china.huawei.com (7.202.181.9)

在 2026/7/30 21:31, Ryusuke Konishi 写道:
> On Thu, Jul 30, 2026 at 9:32 PM Wang Jianjian wrote:
>>
>> When rename, if new inode exists, then its nlink must not be zero.
>>
>> Signed-off-by: Wang Jianjian <wangjianjian3@huawei.com>
>> ---
>>   fs/nilfs2/namei.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
>> index e2fe95de3d71..db171789a316 100644
>> --- a/fs/nilfs2/namei.c
>> +++ b/fs/nilfs2/namei.c
>> @@ -397,6 +397,11 @@ static int nilfs_rename(struct mnt_idmap *idmap,
>>                  struct folio *new_folio;
>>                  struct nilfs_dir_entry *new_de;
>>
>> +               if (new_inode->i_nlink == 0) {
>> +                       err = -EFSCORRUPTED;
>> +                       goto out_dir;
>> +               }
>> +
>>                  err = -ENOTEMPTY;
>>                  if (old_is_dir && !nilfs_empty_dir(new_inode))
>>                          goto out_dir;
>> --
>> 2.34.1
>>
> 
> Wang Jianjian, regarding this patch - much like the previous one - is
> this fix related to a Syzbot report?
> 
> If so, could you please include the appropriate Reported-by and Closes tags?
> 
> Also, please ensure that the filesystem name in the patch title is
> "nilfs2" rather than "nilfs" (kernel patch title prefixes generally
> follow the filesystem name, nilfs2).
> 
> As for the patch itself: rather than using a stopgap measure to check
> i_nlink inside nilfs_rename, could you investigate the root cause of
> the inconsistency? If there is a flaw in the checks when reading the
> disk inode or a race condition involving link count handling, that is
> what should be resolved.
> 
> Additionally, you are returning -EFSCORRUPTED for filesystem
> corruption, but nilfs2 does not yet utilize this return code.
> Following the established implementation pattern, when filesystem
> corruption is detected, you should report it via nilfs_error() (which
> logs an error message) and return -EIO (while I agree we should
> eventually switch to -EFSCORRUPTED across the board, doing so here in
> isolation would create inconsistency).
> 

Hi Ryusuke,
I have sent v2 patch and the root cause of the problem is in v2's commit 
message. I don't think this check is a stopgap, other filesystems, such 
like ext4, does this check too.

nilfs_error will mark fs as readonly with default mount 
option(NILFS_MOUNT_ERRORS_RO), I am not sure if this is overkilled since 
this make the whole fs readonly(however, I add this in v2 patch). 
Perhaps we should isolate this error and only mark this file is bad ? 
For fs like ext4, we can mark one group to corrupted but nilfs seems not 
have this disk layout isolation.
> Thanks,
> Ryusuke Konishi

-- 
Regards
