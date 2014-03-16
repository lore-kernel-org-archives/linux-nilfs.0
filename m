From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH 2/6] nilfs2: add new timestamp to seg usage and function
 to change su_nblocks
Date: Sun, 16 Mar 2014 17:19:42 +0100
Message-ID: <5325CF1E.2040709@gmx.net>
References: <2FD47FE0-3468-4EF4-AAAE-4A636C640C44@dubeyko.com>	<53259801.5080409@gmx.net>	<ED41900C-6380-44C1-AC7E-EB8DF74EBFBD@dubeyko.com> <20140316.223111.52181167.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140316.223111.52181167.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2014-03-16 14:31, Ryusuke Konishi wrote:
> On Sun, 16 Mar 2014 17:06:10 +0300, Vyacheslav Dubeyko wrote:
>>
>> On Mar 16, 2014, at 3:24 PM, Andreas Rohner wrote:
>>
>>>>>
>>>>> diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
>>>>> index ff3fea3..ca269ad 100644
>>>>> --- a/include/linux/nilfs2_fs.h
>>>>> +++ b/include/linux/nilfs2_fs.h
>>>>> @@ -614,11 +614,13 @@ struct nilfs_cpfile_header {
>>>>> * @su_lastmod: last modified timestamp
>>>>> * @su_nblocks: number of blocks in segment
>>>>> * @su_flags: flags
>>>>> + * @su_lastdec: last decrement of su_nblocks timestamp
>>>>> */
>>>>> struct nilfs_segment_usage {
>>>>> 	__le64 su_lastmod;
>>>>> 	__le32 su_nblocks;
>>>>> 	__le32 su_flags;
>>>>> +	__le64 su_lastdec;
>>>>
>>>> So, this change makes on-disk layout incompatible with previous one.
>>>> Am I correct? At first it needs to be fully confident that we really need in
>>>> changing in this place. Secondly, it needs to add incompatible flag for
>>>> s_feature_incompat field of superblock and maybe mount option.
>>>
>>> No it IS compatible. NILFS uses the entry sizes stored in the super
>>> block. Notice, that the code does not depend on sizeof(struct
>>> nilfs_suinfo) or sizeof(struct nilfs_segment_usage). So an old kernel
>>> can read a file system with su_lastdec and a new kernel can read an old
>>> file system without su_lastdec.
>>
>> But, anyway, I think that you add some new feature by this and previous
>> patches. I suppose that it makes sense to add specially dedicated flag or
>> flags in s_feature_xxx field of superblock. If feature is compatible with
>> previous state of driver then flag can be added for s_feature_compat
>> field.
>>
>> Thanks,
>> Vyacheslav Dubeyko.
> 
> This is important thing.  Please evaluate backward compatibility and
> forward compatibility of modifications, and properly add one of
> incompat, compat_ro, or compat flags as Vyacheslav mentioned.  It will
> be a focal point of early stage review.

Ok, I have to look into these flags.

I reuse su_nblocks to represent the number of live blocks, which gets
incremented and decremented as files are deleted and snapshots
created/removed. That is definitely incompatible. Is it better to set a
incompat flag or should I define a new field like su_nliveblocks? With a
new field it could be compatible with older drivers, but it would add
another 8 bytes to the structure.

But if I understood you correctly I need to add a new feature flag in
any case.

Regards,
Andreas Rohner

> Regards,
> Ryusuke Konishi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
