Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01B937D118
	for <linux-nilfs@vger.kernel.org>; Mon, 10 Aug 2026 06:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786345072; cv=none; b=fIuWpPJntydLZDwUYsHqUiCBm4hkoIUbJifV3/SCJc32StPuQXCSOQGpbfZXAtoeKdTxdMDlI/gNahNo0RknawIfdUNjuQLs6em9JwKdCqnJX5STYElkOA5rdeFeBkz9VUctBBHTZF/Yq9vicXToSEvw4dOopjxUU2RhPSMI3jQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786345072; c=relaxed/simple;
	bh=x8EOhCl65Tj7E3/ZXi92Sq5FmRiGUWuxJjiyJR7rAh4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=NzGs+9KgyAi2uTvBZKgQ/hQa3zBjXh5iPCafFd59mqM48ELgIh4GrMf9lxL9GKiwCLQUJW+l8Mm1VLsOVv/mvIu/KcPNb1VDC0Aq0bCdh2Xqtd2Mf4S93oC1K1Mw97Qc0BTQF197s2DX/jjYvbxz5TGFWbv/RVSlobM6AQo+wh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=aL5uIN2d; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="aL5uIN2d"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=n7CtCAbH+NjPY7Zo3LQC85UHHH40NaqmFaiUgeJzMfw=;
	b=aL5uIN2dxVKvbPhzbb6edecwNJHpMCikuQbT6A167NIiKwR/wOcetn6YCD784yBOgbjlNa8Sr
	gSzRyq90/lPBkA4Kh7AVXITotnUBranO7B7kWIRTISu+1PI4xIg6GqBvr2xZGjf6w4BrFUKQnOP
	TY10YGUngnlN2k0mYYuRVWE=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4hJQKB0M3LzpSvB;
	Mon, 10 Aug 2026 14:46:54 +0800 (CST)
Received: from kwepemf200016.china.huawei.com (unknown [7.202.181.9])
	by mail.maildlp.com (Postfix) with ESMTPS id E6EC72025F;
	Mon, 10 Aug 2026 14:57:33 +0800 (CST)
Received: from [10.108.234.194] (10.108.234.194) by
 kwepemf200016.china.huawei.com (7.202.181.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 10 Aug 2026 14:57:33 +0800
Message-ID: <c65950dd-591f-43f8-8954-b5753a17bd83@huawei.com>
Date: Mon, 10 Aug 2026 14:57:31 +0800
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] nilfs2: enhance btree node keys check
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
CC: <slava@dubeyko.com>, <linux-nilfs@vger.kernel.org>,
	<syzbot+158be45e4d99232e1900@syzkaller.appspotmail.com>
References: <20260810061059.1854426-1-wangjianjian3@huawei.com>
 <CAKFNMo=ypauSr1O7YqrYaD0JkoSJAHcDW-DFfFhLgqgh2o0G-w@mail.gmail.com>
From: "wangjianjian (C)" <wangjianjian3@huawei.com>
In-Reply-To: <CAKFNMo=ypauSr1O7YqrYaD0JkoSJAHcDW-DFfFhLgqgh2o0G-w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemf200016.china.huawei.com (7.202.181.9)

在 2026/8/10 14:49, Ryusuke Konishi 写道:
> On Mon, Aug 10, 2026 at 3:43 PM Wang Jianjian wrote:
>>
>> syzbot reported a warning on nilfs_btree_assign:
>> WARNING: fs/nilfs2/btree.c:2302 at nilfs_btree_assign+0x983/0xbe0 fs/nilfs2/btree.c:2302,
>>
>> Analysis found that a corrupted file has the following btree layout:
>> Level2(key/ptr): [ 256/15 ]
>> Level1(key/ptr): [ 0/8, 1/9, 0/10, 3/11, 4/12, 5/13, 6/14, 139637976727559/16, 0/17 ]
>>
>> The test truncated the file to 2 bytes, which partially zeroes the first block and
>> adds the file to the dirty list. When the segment constructor writes it and assigns
>> a new blocknr for the index block, it searches the btree with key=0 and min level=2,
>> and apparently returns ENOENT.
>>
>> Therefore, we should perform more checks on the btree nodes and return early.
>>
>> Reported-by: syzbot+158be45e4d99232e1900@syzkaller.appspotmail.com
>> Closes: https://syzkaller.appspot.com/bug?extid=158be45e4d99232e1900
>> Signed-off-by: Wang Jianjian <wangjianjian3@huawei.com>
>> ---
>>   fs/nilfs2/btree.c | 17 ++++++++++++++---
>>   1 file changed, 14 insertions(+), 3 deletions(-)
> Hi Wang Jianjian,
> 
> Thank you for the patch.
> 
> I would like to send this upstream.
> However, since there are a few minor things I would like to tweak, I
> will make the adjustments myself, run a thorough test, and then send
> it upstream.
> 
> Specifically, after actually testing it, I found the message a bit
> confusing. (While the commit message refers to keys and pointers as
> "key/ptr", referring to them as "index/key" in the actual log message
> is confusing.)Therefore, please note this slight change to the error
> message output:
> 
>          nilfs_crit(inode->i_sb,
>                    "bad btree node (ino=%llu, blocknr=%llu): unsorted
> keys at index %d (%llu) and %d (%llu)",
>                    inode->i_ino, (unsigned long long)blocknr,
>                    i - 1, prev_key, i, key);
> 
> Also, starting next time when you submit patches, please run
> checkpatch.pl (located in the scripts folder) on the patch output
> generated by git format-patch beforehand to check if it complies with
> the coding style guidelines.
> 
> So, unless you have any concerns, please leave this to me and sit tight.
Thanks, I will take care of it next time.>
> Thanks,
> Ryusuke Konishi
> 
>>
>> diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
>> index 64d5f7c5ab44..adf087c896ba 100644
>> --- a/fs/nilfs2/btree.c
>> +++ b/fs/nilfs2/btree.c
>> @@ -341,7 +341,8 @@ static int nilfs_btree_node_broken(const struct nilfs_btree_node *node,
>>                                     sector_t blocknr)
>>   {
>>          int level, flags, nchildren;
>> -       int ret = 0;
>> +       __u64 key, prev_key;
>> +       int i;
>>
>>          level = nilfs_btree_node_get_level(node);
>>          flags = nilfs_btree_node_get_flags(node);
>> @@ -356,9 +357,19 @@ static int nilfs_btree_node_broken(const struct nilfs_btree_node *node,
>>                             "bad btree node (ino=%llu, blocknr=%llu): level = %d, flags = 0x%x, nchildren = %d",
>>                             inode->i_ino, (unsigned long long)blocknr, level,
>>                             flags, nchildren);
>> -               ret = 1;
>> +               return 1;
>>          }
>> -       return ret;
>> +
>> +       for (i = 1, prev_key = nilfs_btree_node_get_key(node, 0); i < nchildren; i++, prev_key = key) {
>> +               key = nilfs_btree_node_get_key(node, i);
>> +               if (unlikely(key <= prev_key)) {
>> +                       nilfs_crit(inode->i_sb,
>> +                               "bad btree node(ino=%llu, blocknr=%llu), key not sorted: %d/%llu <= %d/%llu",
>> +                               inode->i_ino, (unsigned long long)blocknr, i, key, i - 1, prev_key);
>> +                       return 1;
>> +               }
>> +       }
>> +       return 0;
>>   }
>>
>>   /**
>> --
>> 2.34.1
>>

-- 
Regards
