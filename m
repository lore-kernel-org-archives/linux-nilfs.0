From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: Re: [PATCH v5 1/2] nilfs2: implement calculation of free inodes count
Date: Fri, 24 May 2013 22:15:18 +0400
Message-ID: <9760484B-DDAD-4FBA-B19F-49E6059136F5@dubeyko.com>
References: <1369402355.2235.22.camel@slavad-ubuntu> <20130525.024056.57452695.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=oLHh68YVo/S7LX8sRzMabohCpsZWC2OG4UVvNyNoWjw=;
	b=Zou6kS1ghlpF2TB3K3gwVfoc1LpTtiSHZGJwVJYsUU4EYpWyikdi12+YghGCrKa42xaq7HFa0i3ztRyrnIAR7nYL61tC7lwUPgXqiY+q6CSasXZH5+Ghm9KSfUEP9Llt;
In-Reply-To: <20130525.024056.57452695.konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Clemens Eisserer <linuxhippy@gmail.com>


On May 24, 2013, at 9:40 PM, Ryusuke Konishi wrote:

[snip]
>> 
>> +
>> +/**
>> + * nilfs_palloc_count_max_entries - count max number of entries that can be
>> + *					described by descriptor blocks count
>> + * @inode: inode of metadata file using this allocator
>> + * @nused: current number of used entries
>> + * @nmaxp: max number of entries [out]
>> + */
>> +int nilfs_palloc_count_max_entries(struct inode *inode, u64 nused, u64 *nmaxp)
>> +{
>> +	unsigned long desc_blocks = 0;
>> +	u64 entries_per_desc_block, nmax;
>> +	int err;
>> +
>> +	err = nilfs_palloc_count_desc_blocks(inode, &desc_blocks);
>> +	if (unlikely(err))
>> +			return err;
>> +
>> +	entries_per_desc_block = (u64)nilfs_palloc_entries_per_group(inode) *
>> +				nilfs_palloc_groups_per_desc_block(inode);
>> +	nmax = entries_per_desc_block * desc_blocks;
>> +
>> +	if (nused == nmax &&
>> +			nilfs_palloc_mdt_file_can_grow(inode, desc_blocks)) {
>> +		nmax += entries_per_desc_block;
> 
>> +		++desc_blocks;
> 
> This increment operation seems no longer needed.
> 
> There may be a check tool which catches this and warns it as a minor
> fault.
> 
> 
> By the way, indent location of your patch looks odd in spots.
> Doesn't your editor adjust indentation automatically?
> 
> For instance, the following return statement is indented with too many
> tabs.
> 

Ooops. Sorry. It simply my mistake during patch reworking. Of course, I'll correct it.

>> +	if (unlikely(err))
>> +			return err;
> 

Ditto. It needs to be corrected too.

> 
> In the following lines, the indent location of the second argument is
> not aligned to the first argument.
> 
>> +static inline bool nilfs_palloc_mdt_file_can_grow(struct inode *inode,
>> +						    unsigned long desc_blocks)
> 
> This patch has similar more examples:
> 
>> +	err = nilfs_ifile_count_free_inodes(root->ifile,
>> +						&nmaxinodes, &nfreeinodes);
> 
> I can let two latter cases pass, but please care also about indent
> positions if possible.
> 

I'll align it too.

Thank you for remarks. I'll prepare the new version of the patch with these minor corrections.

Thanks,
Vyacheslav Dubeyko.

