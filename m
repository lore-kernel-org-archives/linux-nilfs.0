Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC84288B1
	for <linux-nilfs@vger.kernel.org>; Wed, 28 Aug 2024 01:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724808255; cv=none; b=fOZvfT049PtuKjZs/O9lslnUrK/axtAi2uMvILOiRxXHLmfOUBsit4whRCAWpYNzAFWerR9YaBGevxxNqkA/X4re/yFoKErxoMcdQBx9gYkl056A14VW6uKau550g5vT0Qsroyh11irMG/iqh4DuwwiBv7Xp/FL+ij92wHXvId0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724808255; c=relaxed/simple;
	bh=9YRUTIUsZ0jvUPJ/r0u5GaV6JZY2+CisCIWxamsK/Kg=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=ZTqKYwgXMnL4cLfGfhbj1trkm8ei8pGN6qJPixoSKkjJGxcEWH9WlTkserWnM3/Sw5c1ZBtZENkxxjaPdnU6C7YuN5WcDC/QO2tAdwJRrMWj3qcb31lpcPn/B9tfIc7wJ9wbGNJvigY0YV9ZAhGCRy+TDkZ2l0kIDB64lDfx7Bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Wtmq74Tcfz1xw0f
	for <linux-nilfs@vger.kernel.org>; Wed, 28 Aug 2024 09:22:11 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 1F1C91402CF
	for <linux-nilfs@vger.kernel.org>; Wed, 28 Aug 2024 09:24:09 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 28 Aug 2024 09:24:08 +0800
Message-ID: <1350545b-1cf1-4525-9bc7-20e1b170cb30@huawei.com>
Date: Wed, 28 Aug 2024 09:24:08 +0800
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] nilfs2: support ->tmpfile()
Content-Language: en-US
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
CC: <linux-nilfs@vger.kernel.org>
References: <20240719091725.1877001-1-lihongbo22@huawei.com>
 <CAKFNMome8sJQ6z391GVYCAG0rgbnnwyVAUJVdCnNWmRjtgakxw@mail.gmail.com>
 <11f2a7dc-bf2e-4018-ae1f-55a065433d33@huawei.com>
 <CAKFNMomN96gJ0EGK_qJMXxqc+ibyOOsiiBzUoV-Qir1rd43HWA@mail.gmail.com>
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <CAKFNMomN96gJ0EGK_qJMXxqc+ibyOOsiiBzUoV-Qir1rd43HWA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/8/28 3:27, Ryusuke Konishi wrote:
> On Tue, Aug 27, 2024 at 10:29 PM Hongbo Li wrote:
>>
>>
>>
>> On 2024/7/20 1:36, Ryusuke Konishi wrote:
>>> On Fri, Jul 19, 2024 at 6:12 PM Hongbo Li wrote:
>>>>
>>>> Add function nilfs2_tmpfile to support O_TMPFILE file creation.
>>>>
>>>> tmpfile testcases(generic/(004,389,509,530,531) except
>>>> generic/389,530 (need acl and shutdown supported) now run/pass.
>>>>
>>>> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
>>>> ---
>>>>    fs/nilfs2/namei.c | 31 +++++++++++++++++++++++++++++++
>>>>    1 file changed, 31 insertions(+)
>>>>
>>>> diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
>>>> index c950139db6ef..a36667d7a5e8 100644
>>>> --- a/fs/nilfs2/namei.c
>>>> +++ b/fs/nilfs2/namei.c
>>>> @@ -125,6 +125,36 @@ nilfs_mknod(struct mnt_idmap *idmap, struct inode *dir,
>>>>           return err;
>>>>    }
>>>>
>>>> +static int nilfs_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
>>>> +                       struct file *file, umode_t mode)
>>>> +{
>>>> +       struct inode *inode;
>>>> +       struct nilfs_transaction_info ti;
>>>> +       int err;
>>>> +
>>>> +       err = nilfs_transaction_begin(dir->i_sb, &ti, 1);
>>>> +       if (err)
>>>> +               return err;
>>>> +
>>>> +       inode = nilfs_new_inode(dir, mode);
>>>> +       err = PTR_ERR(inode);
>>>> +       if (!IS_ERR(inode)) {
>>>> +               inode->i_op = &nilfs_file_inode_operations;
>>>> +               inode->i_fop = &nilfs_file_operations;
>>>> +               inode->i_mapping->a_ops = &nilfs_aops;
>>>> +               nilfs_mark_inode_dirty(inode);
>>>> +               d_tmpfile(file, inode);
>>>> +               unlock_new_inode(inode);
>>>> +               err = 0;
>>>> +       }
>>>> +       if (!err)
>>>> +               err = nilfs_transaction_commit(dir->i_sb);
>>>> +       else
>>>> +               nilfs_transaction_abort(dir->i_sb);
>>>> +
>>>> +       return finish_open_simple(file, err);
>>>> +}
>>>> +
>>>>    static int nilfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
>>>>                            struct dentry *dentry, const char *symname)
>>>>    {
>>>> @@ -544,6 +574,7 @@ const struct inode_operations nilfs_dir_inode_operations = {
>>>>           .mkdir          = nilfs_mkdir,
>>>>           .rmdir          = nilfs_rmdir,
>>>>           .mknod          = nilfs_mknod,
>>>> +       .tmpfile        = nilfs_tmpfile,
>>>>           .rename         = nilfs_rename,
>>>>           .setattr        = nilfs_setattr,
>>>>           .permission     = nilfs_permission,
>>>> --
>>>> 2.34.1
>>>>
>>>
>>> Hi Hongbo,
>>>
>>> Thank you for the patch suggestion.
>>>
>>> As for the O_TMPFILE support, with this implementation, when the file
>>> system crashes in an unclean way, the inodes generated in the ifile
>>> metadata file by nilfs_new_inode() are not released and remain
>>> orphaned.
>>
>> Doesn't the nilfs transaction ensure this kind of consistency?
>>
> 
> The nilfs transaction is to gurantee the consistency of metadata
> state, but unfortunately it does not guarantee that an inode with link
> count 0 will continue to exist.  A different mechanism is needed.
> 
> For normal files, when the link count falls to 0 and iput() is
> executed, nilfs_evict_inode(), which evicts the inode, simultaneously
> releases the inode on the bitmap and the data and b-tree blocks.
> 
> A mechanism is needed to allow files with link count == 0 to survive
> across checkpoints.
> 
> Strictly speaking, there is a problem with the current NILFS2
> implementation; if a checkpoint is created between the time the inode
> is removed from the namespace and the time the final iput() is called,
> and the machine uncleanly goes down at that time,the inode becomes an
> orphan inode and its blocks are not released.
> 
> Therefore, I think that an additional mechanism to maintain orphan
> inodes is needed in any way.  If that can be done, the rest of your
> tmpfile implementation seems to be usable almost as is, so how about
> holding off until then?
> 
ok, no problem.

> I thought that it would be better for me to implement this mechanism
> myself, because it would be difficult to implement correctly without a
> thorough understanding of the lifecycle management and coherency of
> NILFS2 metadata.

yeah, may be it would be difficult to implement without deep digging. 
I'll try to see if I can dig up some other minor features to keep up 
with other file systems, But it might not be that fast. Anyway, thank 
you very much for your careful review.

Thanks,
Hongbo

> 
> More importantly, since NILFS2 has not kept up with the implementation
> of the wide range of functions available in today's file systems, I
> would appreciate your help in implementing those additional functions
> (for example, functions related to attributes such as encryption and
> compression, or other minor features).
> 
>>>
>>> I think that this problem needs to be solved first.
>>>
>>> If you could propose a mechanism to repair orphaned inodes at mount
>>> time, I would like to apply it.
>>> Is that possible?
>>>
>>> For example,
>>>
>>> A method of constructing an on-disk chain list of inodes that starts
>>> from the latest checkpoint of cpfile, or a reserved inode (inode
>>> number 0, etc.) of ifile, registering them there, and releasing them
>>> during recovery at mount time.
>>>
>>> Alternatively, a less efficient method would be to perform a full scan
>>> of ifile metadata when recovery occurs at mount time,
>>> and release those whose link count does not match the inode bitmap.
>>
> 
>> Thanks for your detailed explanation. If we scan the orphaned inodes at
>> mount time, this may increase the time for mounting (unless scanning in
>> background).
> 
> A scan only needs to be performed if the file system was not unmounted
> cleanly, so it is not necessary to do it every time, but considering
> scalability, I now think it would be better to be able to properly
> manage orphan inodes, as mentioned above.
> 
> Thanks,
> Ryusuke Konishi
> 
>>
>> Thanks,
>> Hongbo
>>
>>>
>>> If we actually implement it, I think we need to discuss the method to
>>> be determined.
>>>
>>> This issue takes priority, but I would like to make another comment
>>> about the implementation of your proposal:
>>
>> Thanks for your
>>>
>>> The call to nilfs_mark_inode_dirty() involves copying the on-memory
>>> inode data to the ifile, so it must be done after the on-memory inode
>>> update is complete.  Therefore, move it after the call to d_tmpfile().
>>> (we need to check if this swap actually works without side effects).
>>>
>>> Also, the function name in the changelog is a type for "nilfs_tmpfile".
>>>
>>> That's all for now.
>>>
>>> Thanks,
>>> Ryusuke Konishi
> 
> 
> Ryusuke Konishi
