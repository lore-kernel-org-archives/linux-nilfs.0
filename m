Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.223
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795427243;
	b=ZS+/RvQ39QymgHIbjF3ti76IPkqP/TTDcKFF9pOjihOYyrkWDZw3g2BZqQZPYxuvVF4M
	 naAGdmPl/fnrr47t6YGfTqW5eLGTibGKVAndnxag4TV3wo5h0lQUekKEwy6b1cIvh0ENL
	 ZT6tymyjdJC/IYRW7LCcSzbVvbyD0m6UiBlQ/7lbRUAmrx2hl8FinwIxuXvTPB5VvasIE
	 3o9FaJ1yrxttfbRYZBkJiWd0X5RG+OiGnQCcrwvPOQ1tIjP9qOR5IeDntpU04klvzgEcg
	 iPVaneCmWSLYu0JcTPd97autq484rIdLT075FM+1XND/IzSq5f3tOomvNpz40mgnDQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795427243;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:CC:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
	bh=4fxAfI0a2C6thUnVCcQb+kjUx5re7WxYNCaW1Ta8RVw=;
	b=kx/vKwx09TR+ARz+ebteFCJl37cdhYfTbScM4rgiV3yGNxHY8yi5BGrviLiL8VcM58eW
	 B0Ml4XuiRO3k8/fHNEA9yLkd/69nEiT82RKXBE64e31fGwRfUOLKaiKLGMMh10FnGuam2
	 8iK7tZnUqCBLCaNvOUuafE18kXEtH1IbcP4SjGBDp84VfL7YLebx5a0LvY1X5SLBOhvq9
	 Wq702xD7+CCnPyU8rmRt0b6doGAzYZkrWwrlOz3ZCdiTTUj/tLWvOqIK5FLkQKzPzbCJ3
	 vJGtOPT5wwhkMRSIm6nRCj6/lu52Rxz3WntrEB53MgnMEyB0NkiVXzd7Qu5V2erKxiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=5hipb5uI;
	arc=none smtp.remote-ip=113.46.200.223
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5597F606A31A
	for <linux-nilfs@vger.kernel.org>; Mon, 23 Nov 2026 09:47:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5597F606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=5hipb5uI
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=4fxAfI0a2C6thUnVCcQb+kjUx5re7WxYNCaW1Ta8RVw=;
	b=5hipb5uIjdlSD6RRyJZYcAmdU+EQ0MNnqPj3ltTSZ5XVO5Dy8Mq0JMi4DiNShwEG7S8x6yaKL
	xKv0pL1w66425I1X5/AohX0+ZbNaTMD3JQg6S6IeTkz+w6ENjcb93L1KdYrrI+rfxUkCzUvtliv
	hMgzNWahJ/OhejSZBHIiEY4=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4jY1LS0F1BzmV7s;
	Mon, 23 Nov 2026 17:46:56 +0800 (CST)
Received: from kwepemf200016.china.huawei.com (unknown [7.202.181.9])
	by mail.maildlp.com (Postfix) with ESMTPS id 9336340563;
	Mon, 23 Nov 2026 17:47:18 +0800 (CST)
Received: from [10.108.234.194] (10.108.234.194) by
 kwepemf200016.china.huawei.com (7.202.181.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 23 Nov 2026 17:47:18 +0800
Message-ID: <70c39f48-e9af-44a0-b9de-ebafe285fd10@huawei.com>
Date: Mon, 23 Nov 2026 17:47:17 +0800
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
Subject: Re: [PATCH] nilfs2: fix leak of gc inodes on error
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
CC: <slava@dubeyko.com>, <linux-nilfs@vger.kernel.org>,
	<fengaojigui88@gmail.com>
References: <20261119083809.3918948-1-wangjianjian3@huawei.com>
 <CAKFNMokeofZ8NU+nbn+FnYHNuQi5JJKhC_oS5+=bH-vhgrOUJg@mail.gmail.com>
Content-Language: en-US
From: "wangjianjian (C)" <wangjianjian3@huawei.com>
In-Reply-To: <CAKFNMokeofZ8NU+nbn+FnYHNuQi5JJKhC_oS5+=bH-vhgrOUJg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemf200016.china.huawei.com (7.202.181.9)


On 11/19/2026 7:32 PM, Ryusuke Konishi wrote:
> On Thu, Nov 19, 2026 at 5:41 PM Wang Jianjian wrote:
>> Zhengzheng reported below syz problems:
>>
>> NILFS (loop5): disposed unprocessed dirty file(s) when stopping log writer
>> VFS: Busy inodes after unmount of loop5 (nilfs2)
>>
>> The reproducer called ioctl clean_segments on a corrupted image. It's
>> first argument is { ino = 8, cno = 0xffffffffffffffff, vd_vblocknr = 34,
>> vd_period = [0x30000000000000, 0x10), vd_blocknr = 6, vd_offset =
>> 7,...}.
>>
>> nilfs_ioctl_clean_segments
>>    nilfs_ioctl_move_blocks // gc iget 8, get one inode reference
>>    nilfs_clean_segments
>>      nilfs->ns_gc_inodes move to sci->sc_gc_inodes
>>      nilfs_segctor_construct
>>        nilfs_segctor_do_construct
>>          nilfs_segctor_assign
>>            nilfs_segctor_update_payload_blocknr
>>              nilfs_bmap_assign
>>                nilfs_btree_assign_gc
>>                  nilfs_dat_move
>>                    // since there is no dat entry for vblknr 34
>>                    // (entry->de_blocknr == 0), return -EINVAL
>>                    // fs will be remounted to readonly
>>     // clean segments loop will be break because readonly fs
>>     nilfs_remove_all_gcinodes
>>          // since nilfs->ns_gc_inodes empty, it
>>          // clean nothing
>>
>> ioctl_clean_segment will get one extra reference of inode 8 and when
>> segments construct do GC move vblock 34 and do bmap assign, it lookup
>> DAT table and get de_blocknr = 0, so it return -EINVAL. And since
>> nilfs->ns_gc_inodes is empty, nilfs_remove_all_gcinodes will do nothing
>> and the extra inode reference won't be released.
>>
>> To fix this, splice sci->sc_gc_inodes back to nilfs->ns_gc_inodes when
>> got error.
>>
>> Note that, when normal files add to nilfs dirty list by
>> nilfs_set_file_dirty, it will got one reference and when
>> nilfs_bmap_assign got error, nilfs_segctor_do_construct() also doesn't
>> put the inode, but as a last resort, nilfs_segctor_destroy will do
>> it(however, it doesn't clean sci->sc_gc_inodes).
>>
>> Fixes: 7942b919f7321 ("nilfs2: ioctl operations")
>> Signed-off-by: Wang Jianjian <wangjianjian3@huawei.com>
>> Reported-by: fengaojigui88@gmail.com
>> Closes: https://lore.kernel.org/linux-nilfs/CAO-4RZ2=4okHYZ-xCkpV-ekj-aSqKLnYGOsRM9A2dD8R4Ozzeg@mail.gmail.com/T/#u
>> ---
>>   fs/nilfs2/segment.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
>> index af0c3560444f..ea56a26041e8 100644
>> --- a/fs/nilfs2/segment.c
>> +++ b/fs/nilfs2/segment.c
>> @@ -2588,6 +2588,7 @@ int nilfs_clean_segments(struct super_block *sb, struct nilfs_argv *argv,
>>    out_unlock:
>>          sci->sc_freesegs = NULL;
>>          sci->sc_nfreesegs = 0;
>> +       list_splice_tail_init(&sci->sc_gc_inodes, &nilfs->ns_gc_inodes);
>>          nilfs_mdt_clear_shadow_map(nilfs->ns_dat);
>>    bail_unlock:
>>          nilfs_transaction_unlock(sb);
>> --
>> 2.34.1
> Hi Wang Jianjian,
>
> Thank you for the patch.
>
> Previously, once GC entered the loop, it would retry until it
> succeeded, so the sc_gc_inodes list was always emptied by
> nilfs_remove_written_gcinodes().
>
> However, since commit ce5a5ad1a833 ("nilfs2: fix infinite loop in
> nilfs_clean_segments()"), an escape path was added for when filesystem
> corruption is detected, which broke that assumption.  This issue
> really should have been addressed back then.
>
> Ideally, the GC inodes on the sc_gc_inodes list should be discarded in
> this error path.  Also, since the cleanup handling on GC failure still

Hi Ryusuke,

Which error path do you mean? The error handling in 
nilfs_segctor_do_construct() ?

> looks somewhat questionable, we may eventually want to split the error
> path clearly.  However, as this works as a workaround, I plan to
> accept it as is unless additional testing reveals any issues.
>
> I will run follow-up tests, revisit the GC error handling logic, and
> then forward it to Viacheslav.
And what kind of tests you you usually run ? other than normal fs 
tests(such as fsstress, xfstests, ...), do you have any nilfs specific 
tests?
>
> Thanks,
> Ryusuke Konishi
