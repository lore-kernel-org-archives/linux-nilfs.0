From: dE <de.techno-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] nilfs2: suggest to use dump_stack() in nilfs_error()
 and nilfs_warning()
Date: Tue, 01 Jul 2014 14:21:13 +0530
Message-ID: <53B27681.7060602@gmail.com>
References: <1404050621.4139.19.camel@slavad-CELSIUS-H720>	 <20140630.040159.120185966358440318.konishi.ryusuke@lab.ntt.co.jp> <1404116683.2580.32.camel@slavad-CELSIUS-H720>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        bh=L2z5L3HPKZFfMPfOQGYpZ8xdm6cLFVczd2SCXKvrnBs=;
        b=gbyfFV2UwjAl6v0biwGYCPqjySLK+hqn1sradJXtfW6jmCa60cUykKwLTTMwxF9Iht
         m08N7/IG44oZ45zruKFnX3A3yh9/htAInm9d6pY5UQ3WbvmXBlzzVJXILCfAs6WD8oGq
         UviY8lWaBoTDYXsoN7SXqAU0sexZ9xUMp4KbdFw5yDalJiOwdX6+QjqQqMYEDJJUJ4Kj
         Sotm3yvLhgY50RnHDcWHDQmcQAesvupxOH0kvaMGVi76u6+Sa9GHwgRgTJN92crWxJEp
         9gDzOZYlp3T87G5Mm5E8BDyRjDwVT9pPPFgMzc4yhWlTeHNhLUCbQjwJwEHhk+kPhKp6
         o4EA==
In-Reply-To: <1404116683.2580.32.camel@slavad-CELSIUS-H720>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 06/30/14 13:54, Vyacheslav Dubeyko wrote:
> On Mon, 2014-06-30 at 04:01 +0900, Ryusuke Konishi wrote:
>> On Sun, 29 Jun 2014 18:03:41 +0400, Vyacheslav Dubeyko wrote:
>>> From: Vyacheslav Dubeyko <Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org>
>>> Subject: [PATCH] nilfs2: suggest to use dump_stack() in nilfs_error() and nilfs_warning()
>>>
>>> This patch suggests to use dump_stack() call in nilfs_error() and
>>> nilfs_warning() for more clear understanding of different type of
>>> issues. As a result, end-users can report more informative
>>> descriptions of issues.
>>>
>>> Signed-off-by: Vyacheslav Dubeyko <Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org>
>>> CC: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
>>> CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
>> NAK.
>>
>> This patch makes error/warning routine of nilfs so verbose.
>>
>> dump_stack() should be used for some critical situations or internal
>> inconsisent situtations, or for cases in which the identifying call
>> path of trouble is not easy.
>>
>> I think it's not used for regular errors or warnings because they are
>> mostly identifiable.
>>
>> In addition, "errors=panic" mount option is available for nilfs_error
>> to force stack dump.
>>
> I worry about end-user side. Yes, if developer investigates the issue
> then he has many opportunities for the investigation. But we have very
> frequently end-users' reports with not very informative details. And it
> is not so easy to identify the reason of an issue very frequently. We've
> spent about a year on trying to identify the reason of the issue with
> race condition of competition between segments for dirty blocks. And the
> reason of such situation was impossibility to reproduce the issue easily
> and to understand situation on end-users' side. So, from my point of
> view, it makes sense to show dump_stack() for the case of remount in RO
> mode or any warnings.
>
> I think that NILFS2 driver contains many places without necessary output
> about errors. For example:
>
> [160281.690959] nilfs_btree_propagate: key = 10, level == 0
> [160281.690967] NILFS warning (device dm-0): nilfs_clean_segments:
> segment construction failed. (err=-2)
>
> Yes, it is possible to understand that we have some error situation on
> segctor side. And somewhere inside of segctor thread took place
> situation with -ENOENT error. But it is really hard to understand the
> place and environment of such situation. I suppose that if we will have
> more detailed error messages output then it will be more easily to
> understand an issue's environment and the reason of it.
>
> How do you feel about enhancement of output for the case of errors? I
> mean to add messages for such places:
>
> err = some_func();
> if (err) {
> 	/* add message output here with details */
> 	return err;
> }
>
> Thanks,
> Vyacheslav Dubeyko.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

When will this be merged in the mainline kernel?
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
