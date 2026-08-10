Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C253563E1
	for <linux-nilfs@vger.kernel.org>; Mon, 10 Aug 2026 06:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786343816; cv=none; b=WOGQcbYu6ixXtijsCpsqwRB/D0+MUpTWZxFHNRgU7Oc0DhIJyj0hkQODg5HAw4rknwoVxqDD3/Ya7coTLjCOzuEjdoauQ5pBrjtuerTRAwvOeGEwMK0nXdxkOOl4AigMBbF6UKlF96bfR/16s7DkFQALCMlFbChZRoekzFMZN6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786343816; c=relaxed/simple;
	bh=phVjSzlUczVfChH8uxe77vQI16iX5MpQtBIjvRkGtxg=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=DWKsJjWpLhdfgxeB/MZcx61TXNqwQl8fPPDfsWit3N0h178cgmZqCXHjkvXkIZEGoFHJFg/CTcfWZC20DZtaK5rHlLWTFJMra1FVGWfoINlo5y2tltdjbBjeZuuVDca9WJsyKR/reSaB1QJjK1rrpxmvcCSRHbFh2f57T8PrXbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=L08hUrB3; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="L08hUrB3"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=kAbywyY7aM83JSF2NqxS3gV1T8dyl/SScbsSCg6WFdg=;
	b=L08hUrB3PPPkYCC91vl1VMiplkc50L07MM/39ppGxfMVIXooaFehtBfve60NO5A0/9qN2X2lq
	VpoUCaE0ghJrfllQZq/Jrap287RiMv9Dau2Ngl4TqXa5AlyCBKh2P9SP6qW13BZXs+JAlrf0k5Q
	48ct95qYr5Ijejg6fUkbC/0=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4hJPsq01hTzcbMk;
	Mon, 10 Aug 2026 14:26:39 +0800 (CST)
Received: from kwepemf200016.china.huawei.com (unknown [7.202.181.9])
	by mail.maildlp.com (Postfix) with ESMTPS id 4E4BD40538;
	Mon, 10 Aug 2026 14:36:42 +0800 (CST)
Received: from [10.108.234.194] (10.108.234.194) by
 kwepemf200016.china.huawei.com (7.202.181.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 10 Aug 2026 14:36:41 +0800
Message-ID: <4282bea9-104a-42d3-abf0-6039232c5a04@huawei.com>
Date: Mon, 10 Aug 2026 14:36:41 +0800
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
 <000b9199-ef5c-4959-8a46-47d5fda76f15@huawei.com>
 <CAKFNMokpNB9jYvnU_GqmNvRdAfDNx5z1kMWrKkLU1xVH3fsqAw@mail.gmail.com>
From: "wangjianjian (C)" <wangjianjian3@huawei.com>
In-Reply-To: <CAKFNMokpNB9jYvnU_GqmNvRdAfDNx5z1kMWrKkLU1xVH3fsqAw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemf200016.china.huawei.com (7.202.181.9)

在 2026/8/10 14:07, Ryusuke Konishi 写道:
> On Sat, Aug 8, 2026 at 5:31 PM wangjianjian (C) wrote:
>>
>> 在 2026/7/30 21:31, Ryusuke Konishi 写道:
>>> On Thu, Jul 30, 2026 at 9:32 PM Wang Jianjian wrote:
>>>>
>>>> When rename, if new inode exists, then its nlink must not be zero.
>>>>
>>>> Signed-off-by: Wang Jianjian <wangjianjian3@huawei.com>
>>>> ---
>>>>    fs/nilfs2/namei.c | 5 +++++
>>>>    1 file changed, 5 insertions(+)
>>>>
>>>> diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
>>>> index e2fe95de3d71..db171789a316 100644
>>>> --- a/fs/nilfs2/namei.c
>>>> +++ b/fs/nilfs2/namei.c
>>>> @@ -397,6 +397,11 @@ static int nilfs_rename(struct mnt_idmap *idmap,
>>>>                   struct folio *new_folio;
>>>>                   struct nilfs_dir_entry *new_de;
>>>>
>>>> +               if (new_inode->i_nlink == 0) {
>>>> +                       err = -EFSCORRUPTED;
>>>> +                       goto out_dir;
>>>> +               }
>>>> +
>>>>                   err = -ENOTEMPTY;
>>>>                   if (old_is_dir && !nilfs_empty_dir(new_inode))
>>>>                           goto out_dir;
>>>> --
>>>> 2.34.1
>>>>
>>>
>>> Wang Jianjian, regarding this patch - much like the previous one - is
>>> this fix related to a Syzbot report?
>>>
>>> If so, could you please include the appropriate Reported-by and Closes tags?
>>>
>>> Also, please ensure that the filesystem name in the patch title is
>>> "nilfs2" rather than "nilfs" (kernel patch title prefixes generally
>>> follow the filesystem name, nilfs2).
>>>
>>> As for the patch itself: rather than using a stopgap measure to check
>>> i_nlink inside nilfs_rename, could you investigate the root cause of
>>> the inconsistency? If there is a flaw in the checks when reading the
>>> disk inode or a race condition involving link count handling, that is
>>> what should be resolved.
>>>
>>> Additionally, you are returning -EFSCORRUPTED for filesystem
>>> corruption, but nilfs2 does not yet utilize this return code.
>>> Following the established implementation pattern, when filesystem
>>> corruption is detected, you should report it via nilfs_error() (which
>>> logs an error message) and return -EIO (while I agree we should
>>> eventually switch to -EFSCORRUPTED across the board, doing so here in
>>> isolation would create inconsistency).
>>>
>>
>> Hi Ryusuke,
>> I have sent v2 patch and the root cause of the problem is in v2's commit
>> message. I don't think this check is a stopgap, other filesystems, such
>> like ext4, does this check too.
>>
>> nilfs_error will mark fs as readonly with default mount
>> option(NILFS_MOUNT_ERRORS_RO), I am not sure if this is overkilled since
>> this make the whole fs readonly(however, I add this in v2 patch).
>> Perhaps we should isolate this error and only mark this file is bad ?
>> For fs like ext4, we can mark one group to corrupted but nilfs seems not
>> have this disk layout isolation.
>>> Thanks,
>>> Ryusuke Konishi
>>
>> --
>> Regards
> 
> Hi Wang Jianjian,
> 
> Regarding this issue, as the analysis in your patch's commit message
> indicates, the fundamental problem is that when the inode or directory
> has sync write attributes set, nilfs_transaction_commit() calls
> nilfs_construct_segment(), which receives an interruption and fails
> with -ERESTARTSYS.
> 
> Consequently, the rename itself is retried even though it has already
> modified metadata beyond the point of no return.
> 
> We need to consider proper countermeasures, such as prohibiting
> interruptions during log write commits or making the transaction
> properly rollback-capable.
> Adding the i_nlink == 0 check is still merely a stopgap measure, and
> since interruptions can occur during normal operations, we should not
> trigger a filesystem error (or mark it read-only) because of them.
> 
> Handling this issue requires careful consideration.
> Since we are late in the release cycle, I do not want to rush this
> into the upstream tree right now.
> Could we please split off the b-tree key sorting inconsistency check
> patch to be processed first, and keep this rename issue under further
> investigation?
Thanks. will drop this.>
> Thanks,
> Ryusuke Konishi

-- 
Regards
