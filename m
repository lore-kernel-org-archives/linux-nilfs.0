Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772D731E858
	for <linux-nilfs@vger.kernel.org>; Fri, 31 Jul 2026 02:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785466358; cv=none; b=ojKlfSHkEGpdWvonPyv9huqIOBxNJziIoo4JKJCvY6XjWO8VtgtVTtdiuR74YqNH/1tSdAlMPHJyp6UuTUAL65lVsgkiUcuzdMnDM6n8D1epPeYDqCJp0mxrWqotQiOmIfCBLOh+0LLdjvuKGovyuMiJoD/Cxw7f3nYFQj+zjBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785466358; c=relaxed/simple;
	bh=eEcxnPGYJdiY5bnh8zyDjUoVXYC6RqndE89K/usluvA=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=lYXG/Y9JuzSoEsB45wVXyv8Z4zd8OKYSXcGPxoXbkEQ67shma03OEXcFTyH7NGuK+Xixr5fuMrfRf6DFlzCpg20O9bRKmSkVe64c7T4S2w9MH0Qv4XcCXkfejalQ4i5zulVTIX3ABLNtWTmxFl5NVWXO3AkVANDmAU3mvf30V54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=BbOgagET; arc=none smtp.client-ip=113.46.200.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="BbOgagET"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=aPA0EM3qutcldP8KUyZtnlZFPSEd6nXnUNruMgkl868=;
	b=BbOgagET7ZfBwvAuHisJWTFG7FAOubg+DgB7oMfXNTV+5gLEH8EkY8s5Qpc/EgXaO57lrkK86
	w+jw132MoDUy3MhpNL9HSKvz2X035vLZkOtbM5cp6WyugW0VazmXIIwvfCVt1EeKFHVo7Z1Z4UK
	OIJArWdRlyK13kU/6x1EBnQ=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hB9NP1cZ2zKm9N;
	Fri, 31 Jul 2026 10:43:01 +0800 (CST)
Received: from kwepemf200016.china.huawei.com (unknown [7.202.181.9])
	by mail.maildlp.com (Postfix) with ESMTPS id C683140578;
	Fri, 31 Jul 2026 10:52:31 +0800 (CST)
Received: from [10.108.234.194] (10.108.234.194) by
 kwepemf200016.china.huawei.com (7.202.181.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 31 Jul 2026 10:52:31 +0800
Message-ID: <a8c9ac4e-52b3-46ac-9af9-2bdc4af68fb8@huawei.com>
Date: Fri, 31 Jul 2026 10:52:28 +0800
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
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
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

Thanks for your detailed review, for the 2 patches, I will send v2 based 
your review.

  > Thank you.
> Ryusuke Konishi

-- 
Regards
