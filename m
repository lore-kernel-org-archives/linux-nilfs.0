Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A3A3115B8
	for <linux-nilfs@vger.kernel.org>; Sat,  8 Aug 2026 08:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786177173; cv=none; b=VmfbAypMjX/ztwmBQJxaqf3LKN3Q/5zzIExVfUm6/QJUP7MBdeoTKpOtSU3AZhv/8dd7W01OOcAtfdrwseD7jthW0dUM0czXBupy1LhwKmkqx48KLI/zXbNM8cpoLYeH2ZhcvmKweONatQHj9iQFHEuiqtSrC+7JoYiVfSMA1oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786177173; c=relaxed/simple;
	bh=OacpM/FnEpeHd2o63mzLJ2KEPpnpwjJxLIviwe6ILNs=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=m4YZsFYm/NBhm7FRDld8ZzXN5k7l82F6Sg7dL6jLVAVp4r6sP8BwOBb9aR5aSvmCynnl773vP2NlnnKRGG6+uIO4vvg4gdtkw3NA1pVtScWzHyUUuCamZRu/fG0w9YliOMIxKbTGtEXKZqmhLerHwd9UuJGncAiJXCNt1l6GXhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=PHWsxjtv; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="PHWsxjtv"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=8rD7i24q5oVqCNjmDpNAFmyra+l3iU+XNPdfYd068w0=;
	b=PHWsxjtvBIGm2o0Bnvwkp5MaoGoueKZ6Hc4Bfj4xpVyriSVImbvgJcXObTluEH3kYqqTDxERI
	ADlLy6JQLQnHs7jB6on74HlrfvIrHSuzXL0POIyD6rFjMKlXzn51vqyGfnIjBVE3rKOwlcdlTO2
	OOoYZIkQN5nYKu5g4giJclE=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4hHDFj1x0lz1prN4;
	Sat,  8 Aug 2026 16:09:45 +0800 (CST)
Received: from kwepemf200016.china.huawei.com (unknown [7.202.181.9])
	by mail.maildlp.com (Postfix) with ESMTPS id 4AC634056D;
	Sat,  8 Aug 2026 16:19:20 +0800 (CST)
Received: from [10.108.234.194] (10.108.234.194) by
 kwepemf200016.china.huawei.com (7.202.181.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 8 Aug 2026 16:19:19 +0800
Message-ID: <446a3833-b834-4caa-b80e-dfc3675a478d@huawei.com>
Date: Sat, 8 Aug 2026 16:19:19 +0800
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] nilfs: enhance btree node keys check
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
CC: <slava@dubeyko.com>, <linux-nilfs@vger.kernel.org>
References: <20260730120105.2746192-1-wangjianjian3@huawei.com>
 <CAKFNMomBf5+K1NC=UXCy2Jktcb6Nq-EVCfxv73Okrg7ZjHdnCw@mail.gmail.com>
From: "wangjianjian (C)" <wangjianjian3@huawei.com>
In-Reply-To: <CAKFNMomBf5+K1NC=UXCy2Jktcb6Nq-EVCfxv73Okrg7ZjHdnCw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemf200016.china.huawei.com (7.202.181.9)

在 2026/7/30 20:42, Ryusuke Konishi 写道:
> On Thu, Jul 30, 2026 at 9:32 PM Wang Jianjian wrote:
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
>> Signed-off-by: Wang Jianjian <wangjianjian3@huawei.com>
>> ---
>>   fs/nilfs2/btree.c | 40 +++++++++++++++++++++++++++++++++++-----
>>   1 file changed, 35 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
>> index 64d5f7c5ab44..8b164e13663f 100644
>> --- a/fs/nilfs2/btree.c
>> +++ b/fs/nilfs2/btree.c
>> @@ -448,16 +448,46 @@ nilfs_btree_get_node(const struct nilfs_bmap *btree,
>>   }
>>
>>   static int nilfs_btree_bad_node(const struct nilfs_bmap *btree,
>> +                               const struct nilfs_btree_path *path,
>>                                  struct nilfs_btree_node *node, int level)
>>   {
>> +       struct inode *inode = btree->b_inode;
>> +       __u64 key1, key2;
>> +       int i, ncmax;
>> +
>>          if (unlikely(nilfs_btree_node_get_level(node) != level)) {
>>                  dump_stack();
>> -               nilfs_crit(btree->b_inode->i_sb,
>> +               nilfs_crit(inode->i_sb,
>>                             "btree level mismatch (ino=%llu): %d != %d",
>> -                          btree->b_inode->i_ino,
>> -                          nilfs_btree_node_get_level(node), level);
>> +                          inode->i_ino, nilfs_btree_node_get_level(node), level);
>>                  return 1;
>>          }
>> +
>> +       for (i = 1; i < nilfs_btree_node_get_nchildren(node); i++) {
>> +               key1 = nilfs_btree_node_get_key(node, i);
>> +               key2 = nilfs_btree_node_get_key(node, i - 1);
>> +
>> +               if (key1 <= key2) {
>> +                       nilfs_crit(inode->i_sb,
>> +                                  "btree node(ino=%llu) level=%d key not sorted: %d/%llu <= %d/%llu",
>> +                                       inode->i_ino, level, i, key1, i - 1, key2);
>> +                       return 1;
>> +               }
>> +       }
>> +
>> +       if (level < nilfs_btree_height(btree) - 1) {
>> +               struct nilfs_btree_node *parent = nilfs_btree_get_node(btree, path, level + 1, &ncmax);
>> +
>> +               key1 = nilfs_btree_node_get_key(parent, path[level + 1].bp_index);
>> +               key2 = nilfs_btree_node_get_key(node, 0);
>> +               if (key1 != key2) {
>> +                       nilfs_crit(inode->i_sb,
>> +                                  "btree node(ino=%llu) level=%d key=%llu not equal to parent's key=%llu",
>> +                                  inode->i_ino, level, key2, key1);
>> +                       return 1;
>> +               }
>> +       }
>> +
>>          return 0;
>>   }
>>
>> @@ -582,7 +612,7 @@ static int nilfs_btree_do_lookup(const struct nilfs_bmap *btree,
>>                          return ret;
>>
>>                  node = nilfs_btree_get_nonroot_node(path, level);
>> -               if (nilfs_btree_bad_node(btree, node, level))
>> +               if (nilfs_btree_bad_node(btree, path, node, level))
>>                          return -EINVAL;
>>                  if (!found)
>>                          found = nilfs_btree_node_lookup(node, key, &index);
>> @@ -630,7 +660,7 @@ static int nilfs_btree_do_lookup_last(const struct nilfs_bmap *btree,
>>                  if (ret < 0)
>>                          return ret;
>>                  node = nilfs_btree_get_nonroot_node(path, level);
>> -               if (nilfs_btree_bad_node(btree, node, level))
>> +               if (nilfs_btree_bad_node(btree, path, node, level))
>>                          return -EINVAL;
>>                  index = nilfs_btree_node_get_nchildren(node) - 1;
>>                  ptr = nilfs_btree_node_get_ptr(node, index, ncmax);
>> --
>> 2.34.1
> 
> Hi, Wang Jianjian.
> 
> Thank you for proposing the patch.
> 
> Your patch checks for key consistency within B-tree nodes; however,
> since this check is performed inside nilfs_btree_bad_node() - which is
> called during every B-tree search - it imposes unnecessary overhead.
> 
> Could you please move the check to nilfs_btree_broken_node_block() instead?
> That function performs the check only once when the B-tree node block is loaded.
> 
> By leveraging the BH_nilfs_checked flag on the buffer head, once the
> check is performed, it prevents redundant checks as long as the buffer
> remains in the cache.
> 
> If a node becomes corrupted after being loaded into memory, that
> indicates a bug in the B-tree implementation itself; therefore,
> checking it on every lookup is unnecessary.
> 
> Note that nilfs_btree_get_block() does not currently take a path
> argument, but how about passing the parent node's key to it for
> checking purposes?
> 
> Also, regarding the check for whether keys in the B-tree node are
> sorted: instead of calling nilfs_btree_node_get_key() for both keys in
> each iteration, could you reuse the value of the previous key?
> 
> While the compiler might optimize this, failing to reuse a variable
> that has already been accessed feels a bit counterintuitive.
> 
> One more minor point: since the conditions like "if (key1 <= key2)" is
> an exceptional error case, please wrap it with the unlikely() macro.
> 
> Could you please revise your implementation based on these comments?
> 
Hi Ryusuke,
I have send v2 patch and I drop the check of if parent's key equal to 
child's since current check can fix the problem and there are many 
callers of nilfs_btree_get_block and pass parent node's key down is a 
little ugly.

> Thank you.
> Ryusuke Konishi

-- 
Regards
