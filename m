Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.217
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795570100;
	b=Um2lNnfiuh7ldCglkVBz6d9dvxsMLEFzbKnCDJe8xVn3EG99kBh6dZcLONX4rAh7Dgjt
	 qiC2dVqugRvW+DeasetoMf3+d/LHb0kjbmsbJ9TOB5KPn1YaahIOdjlwNCuxDKuDsHX/s
	 RTYZfR9N0sXiywhbjKEpvwPSDmDNzwFojjBu+tA2DQ+mUAVVkypQnNaSAqYg+RddSRcbV
	 ru9Lhn1Qyl69NxZpA7tM0udaSvB8FPDJyJnl0AzufWlo6O5W8OXkiWQPkWLSqVJeDzmhl
	 b3GFEbEz9cVANdAuKhvN9nnLmHZMzI4Xwll+q7I9VxJqtgI3g14GB6rjhZaMZVf1b9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795570100;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:CC:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
	bh=UaOi+lu8BF/lBpKWa6kqj9advTlQZvEf13deKbaVXbs=;
	b=b4KjFI5UHBUo7d4ZeSDfYNuW8Fkw9pfF6pb9eoIixPAUS8eruHSfi8Y9yreknzPuBqfU
	 gqHx+C6boumCiK6nChqQnAUcBORk9DDESr7IpNFDK/lddDZPse/dZLagDOHhtyEahmNIJ
	 1LsbHk6fQqXu33Ql5f8lyMsw7HwlJa+yIjGV2tXYZB/OOjzvh+6vogCjeo5JDPaVKao4D
	 +nco/pQN+wPAQ+aM+vGPg53ZArVlgHt2Vy4K6sSRSPygv8uO+oALvuqSYWM0q3mjLN+um
	 9yv67dNFOyJ5IOgbVLpRZPTl5OlT+wrpSUKqN5y0hGUlsU4DeZdyZb7ohjTF3DA5iXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=CiYCstWz;
	arc=none smtp.remote-ip=113.46.200.217
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF76606A31E
	for <linux-nilfs@vger.kernel.org>; Wed, 25 Nov 2026 01:28:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7AF76606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=CiYCstWz
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=UaOi+lu8BF/lBpKWa6kqj9advTlQZvEf13deKbaVXbs=;
	b=CiYCstWz6DcyvDe8TxrLcQmlQfkiXV27rTtiZjAsd2Yr9LkFyRAF28MARUUyxeecPV2MqvPyB
	5p/1wQolgmXEiP3BGZB/xETjWm8eD8OAaFoyG7m/NQjKPAnz7N9AsoVf6KxXsxZtTSMhUjRFT3t
	G0psQrn4GvHwi9LlpX/7UQg=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4jZ28f6qF6zcb44;
	Wed, 25 Nov 2026 09:26:58 +0800 (CST)
Received: from dggpemr100013.china.huawei.com (unknown [7.185.36.198])
	by mail.maildlp.com (Postfix) with ESMTPS id C365140575;
	Wed, 25 Nov 2026 09:28:03 +0800 (CST)
Received: from kwepemq500016.china.huawei.com (7.202.194.202) by
 dggpemr100013.china.huawei.com (7.185.36.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Wed, 25 Nov 2026 09:28:03 +0800
Received: from [10.108.234.194] (10.108.234.194) by
 kwepemq500016.china.huawei.com (7.202.194.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Wed, 25 Nov 2026 09:28:02 +0800
Message-ID: <ed215e42-eae7-46a6-afca-835e8f56298a@huawei.com>
Date: Wed, 25 Nov 2026 09:28:02 +0800
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
 <70c39f48-e9af-44a0-b9de-ebafe285fd10@huawei.com>
 <CAKFNMomnLBAwvZhua-BygyT_MGyWv6Ka1AggO7cwm-y-YMYmeg@mail.gmail.com>
Content-Language: en-US
From: "wangjianjian (C)" <wangjianjian3@huawei.com>
In-Reply-To: <CAKFNMomnLBAwvZhua-BygyT_MGyWv6Ka1AggO7cwm-y-YMYmeg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq500016.china.huawei.com (7.202.194.202)


On 11/23/2026 7:06 PM, Ryusuke Konishi wrote:
> On Mon, Nov 23, 2026 at 6:47 PM wangjianjian (C)  wrote:
>>
>> On 11/19/2026 7:32 PM, Ryusuke Konishi wrote:
>>> On Thu, Nov 19, 2026 at 5:41 PM Wang Jianjian wrote:
>>>> Zhengzheng reported below syz problems:
>>>>
>>>> NILFS (loop5): disposed unprocessed dirty file(s) when stopping log writer
>>>> VFS: Busy inodes after unmount of loop5 (nilfs2)
>>>>
>>>> The reproducer called ioctl clean_segments on a corrupted image. It's
>>>> first argument is { ino = 8, cno = 0xffffffffffffffff, vd_vblocknr = 34,
>>>> vd_period = [0x30000000000000, 0x10), vd_blocknr = 6, vd_offset =
>>>> 7,...}.
>>>>
>>>> nilfs_ioctl_clean_segments
>>>>     nilfs_ioctl_move_blocks // gc iget 8, get one inode reference
>>>>     nilfs_clean_segments
>>>>       nilfs->ns_gc_inodes move to sci->sc_gc_inodes
>>>>       nilfs_segctor_construct
>>>>         nilfs_segctor_do_construct
>>>>           nilfs_segctor_assign
>>>>             nilfs_segctor_update_payload_blocknr
>>>>               nilfs_bmap_assign
>>>>                 nilfs_btree_assign_gc
>>>>                   nilfs_dat_move
>>>>                     // since there is no dat entry for vblknr 34
>>>>                     // (entry->de_blocknr == 0), return -EINVAL
>>>>                     // fs will be remounted to readonly
>>>>      // clean segments loop will be break because readonly fs
>>>>      nilfs_remove_all_gcinodes
>>>>           // since nilfs->ns_gc_inodes empty, it
>>>>           // clean nothing
>>>>
>>>> ioctl_clean_segment will get one extra reference of inode 8 and when
>>>> segments construct do GC move vblock 34 and do bmap assign, it lookup
>>>> DAT table and get de_blocknr = 0, so it return -EINVAL. And since
>>>> nilfs->ns_gc_inodes is empty, nilfs_remove_all_gcinodes will do nothing
>>>> and the extra inode reference won't be released.
>>>>
>>>> To fix this, splice sci->sc_gc_inodes back to nilfs->ns_gc_inodes when
>>>> got error.
>>>>
>>>> Note that, when normal files add to nilfs dirty list by
>>>> nilfs_set_file_dirty, it will got one reference and when
>>>> nilfs_bmap_assign got error, nilfs_segctor_do_construct() also doesn't
>>>> put the inode, but as a last resort, nilfs_segctor_destroy will do
>>>> it(however, it doesn't clean sci->sc_gc_inodes).
>>>>
>>>> Fixes: 7942b919f7321 ("nilfs2: ioctl operations")
>>>> Signed-off-by: Wang Jianjian <wangjianjian3@huawei.com>
>>>> Reported-by: fengaojigui88@gmail.com
>>>> Closes: https://lore.kernel.org/linux-nilfs/CAO-4RZ2=4okHYZ-xCkpV-ekj-aSqKLnYGOsRM9A2dD8R4Ozzeg@mail.gmail.com/T/#u
>>>> ---
>>>>    fs/nilfs2/segment.c | 1 +
>>>>    1 file changed, 1 insertion(+)
>>>>
>>>> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
>>>> index af0c3560444f..ea56a26041e8 100644
>>>> --- a/fs/nilfs2/segment.c
>>>> +++ b/fs/nilfs2/segment.c
>>>> @@ -2588,6 +2588,7 @@ int nilfs_clean_segments(struct super_block *sb, struct nilfs_argv *argv,
>>>>     out_unlock:
>>>>           sci->sc_freesegs = NULL;
>>>>           sci->sc_nfreesegs = 0;
>>>> +       list_splice_tail_init(&sci->sc_gc_inodes, &nilfs->ns_gc_inodes);
>>>>           nilfs_mdt_clear_shadow_map(nilfs->ns_dat);
>>>>     bail_unlock:
>>>>           nilfs_transaction_unlock(sb);
>>>> --
>>>> 2.34.1
>>> Hi Wang Jianjian,
>>>
>>> Thank you for the patch.
>>>
>>> Previously, once GC entered the loop, it would retry until it
>>> succeeded, so the sc_gc_inodes list was always emptied by
>>> nilfs_remove_written_gcinodes().
>>>
>>> However, since commit ce5a5ad1a833 ("nilfs2: fix infinite loop in
>>> nilfs_clean_segments()"), an escape path was added for when filesystem
>>> corruption is detected, which broke that assumption.  This issue
>>> really should have been addressed back then.
>>>
>>> Ideally, the GC inodes on the sc_gc_inodes list should be discarded in
>>> this error path.  Also, since the cleanup handling on GC failure still
>> Hi Ryusuke,
>>
>> Which error path do you mean? The error handling in
>> nilfs_segctor_do_construct() ?
> Hi Wang Jianjian,
>
> I am currently focused on reviewing another patch and want to wrap
> that up first, so please bear with me for a little while.
>
> I will most likely take your patch as is.  However, to properly handle
> GC error cases -- including the additional GC-related bug reports that
> have come in -- multiple fixes will be needed, and I expect to adopt
> your patch as the first patch in that fix series. Please give me a
> little more time.
>
> When I mentioned revisiting the logic, I was referring to the entire
> error path where log writing -- including the series of operations in
> nilfs_segctor_do_construct() -- fails from that GC loop.  Originally,
> the GC ioctl loop had no escape path on error because log writing
> accompanied by GC is irreversible; while retrying is safe, aborting
> out of it breaks consistency.
>
> However, the current looping causes hangs reported separately and is
> not desirable in the first place.  I am therefore reviewing all
> operations performed by the log writer and their side effects,
> examining what issues arise and what approach can resolve them so that
> we can cleanly bail out when an error occurs during a GC log write.
>
> Specifically, the log writer is implemented to undo changes on error
> for certain metadata files such as the checkpoint file (cpfile) and
> the segment usage file (sufile).
> Also, the bmap/B-tree of regular inodes is designed and implemented so
> that buffer dirty flags are not lost on error and retry, causing no
> issues as long as they remain in memory.  However, the DAT metadata
> file, which manages the translation from virtual block addresses to
> physical block addresses, cannot be rolled back all at once once a log
> write has started (doing so would break overall consistency).
> Therefore, I am adding a new partial restore mechanism for GC to make
> error bail-out possible.
>
> I am working on this right now, and the direction of the fix is
> already settled.  I hope to send it together with your patch to
> Viacheslav within this week.
Got it.
>
>>> looks somewhat questionable, we may eventually want to split the error
>>> path clearly.  However, as this works as a workaround, I plan to
>>> accept it as is unless additional testing reveals any issues.
>>>
>>> I will run follow-up tests, revisit the GC error handling logic, and
>>> then forward it to Viacheslav.
>> And what kind of tests you you usually run ? other than normal fs
>> tests(such as fsstress, xfstests, ...), do you have any nilfs specific
>> tests?
> As for how I test patches, I run the following checks and tests in a
> local automated environment:
>
> Style and static analysis checks: scripts/checkpatch.pl and make C=2
> fs/nilfs2/nilfs2.ko
>
> Build tests: make allmodconfig, cross-compilation for other
> architectures (such as powerpc), builds with CC=clang, and
> builds/tests on a 32-bit kernel (686-pae)
>
> Functional and stress tests: basic I/O tests (read/write, O_DIRECT,
> sendfile, aio, etc.), iozone, fsstress, GC tests (nilfs-clean), and
> NILFS2-specific mount tests
> (https://github.com/konis/nilfs-test-tools.git)
>
> For individual bug reports, I run the reproducers manually.  When
> verifying specific features such as atime or Direct-IO, I also run the
> relevant test cases from xfstests. Occasionally, I temporarily modify
> the code to intentionally inject errors and test error paths.
>
> It would be great to integrate these custom tests into xfstests,
> though I haven't had the bandwidth to get around to it yet.  If you
> would like to help out with that, contributions are very welcome --
> consolidating them into xfstests is definitely the right way forward.
>
> Hope this helps.
Sure, this helps a lot. And I can look it later.
>
> Thanks,
> Ryusuke Konishi
>
>>> Thanks,
>>> Ryusuke Konishi
