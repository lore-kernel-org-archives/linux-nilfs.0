From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 2/6] nilfs2: add new timestamp to seg usage and function to change su_nblocks
Date: Sun, 16 Mar 2014 17:06:10 +0300
Message-ID: <ED41900C-6380-44C1-AC7E-EB8DF74EBFBD@dubeyko.com>
References: <cover.1394966728.git.andreas.rohner@gmx.net> <12561ce5e2cf8ae07fdda05e16c357f37d17c62f.1394966729.git.andreas.rohner@gmx.net> <2FD47FE0-3468-4EF4-AAAE-4A636C640C44@dubeyko.com> <53259801.5080409@gmx.net>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=0por8uWWJTmE3imAlgnNAt59Hz+1lFTnErJc3F1vZQY=;
	b=m2ko4MkKqBMtQZAJEF7VSnBHr9IWY4kNkiDc/Dch/Z6304CZWbeIAwulSrFr9Bb+8VdzfHECNyY64+3H+Z1G4gbGPPnLGnXl9h/Z4m/gVsLp9fbsTbzgvV+bctMoOQcb;
In-Reply-To: <53259801.5080409-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


On Mar 16, 2014, at 3:24 PM, Andreas Rohner wrote:

>>> 
>>> diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
>>> index ff3fea3..ca269ad 100644
>>> --- a/include/linux/nilfs2_fs.h
>>> +++ b/include/linux/nilfs2_fs.h
>>> @@ -614,11 +614,13 @@ struct nilfs_cpfile_header {
>>> * @su_lastmod: last modified timestamp
>>> * @su_nblocks: number of blocks in segment
>>> * @su_flags: flags
>>> + * @su_lastdec: last decrement of su_nblocks timestamp
>>> */
>>> struct nilfs_segment_usage {
>>> 	__le64 su_lastmod;
>>> 	__le32 su_nblocks;
>>> 	__le32 su_flags;
>>> +	__le64 su_lastdec;
>> 
>> So, this change makes on-disk layout incompatible with previous one.
>> Am I correct? At first it needs to be fully confident that we really need in
>> changing in this place. Secondly, it needs to add incompatible flag for
>> s_feature_incompat field of superblock and maybe mount option.
> 
> No it IS compatible. NILFS uses the entry sizes stored in the super
> block. Notice, that the code does not depend on sizeof(struct
> nilfs_suinfo) or sizeof(struct nilfs_segment_usage). So an old kernel
> can read a file system with su_lastdec and a new kernel can read an old
> file system without su_lastdec.

But, anyway, I think that you add some new feature by this and previous
patches. I suppose that it makes sense to add specially dedicated flag or
flags in s_feature_xxx field of superblock. If feature is compatible with
previous state of driver then flag can be added for s_feature_compat
field.

Thanks,
Vyacheslav Dubeyko.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
