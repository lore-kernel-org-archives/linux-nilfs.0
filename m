From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH 9/9] nilfs2: prevent starvation of segments protected
 by snapshots
Date: Sat, 14 Mar 2015 21:49:31 +0900 (JST)
Message-ID: <20150314.214931.1745438554797108598.konishi.ryusuke@lab.ntt.co.jp>
References: <1424804504-10914-10-git-send-email-andreas.rohner@gmx.net>
	<20150314.125109.1017248837083480553.konishi.ryusuke@lab.ntt.co.jp>
	<55042B53.5000101@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=D7AxhzjnHgrXT0i8isPpdYKfOz4eap6qDKjA4gasMFY=;
        b=gXGmFTvfT3XfRkONBb4F7O3oG38bdL3zwtgdQaIT4MJYkZGqSvxOeqjPaM81ZL5FpI
         /r9qcIZowII1J+ZWuvDnZVsLY155Dup2eqjUxfyM0qrqHO0iLgiDZ8HBpjL/txGeWSBv
         p/uIPP4acAlSvqt00iiYru/AKvp47Yu3lJNsY7OA+tGM78aQyqSFWbaR+jyrxbTtqOW+
         30tjUlnjy75Feg9CYUOC6CUnxuTQJfOQSVjnFBmhGZVIg7mBLqYjaBKA9sKQ/qQR1uQ/
         K3GEtPvor9UKSXOuLgju8E5YS4/DJDcKHH+TmDoOnFjNaP9gIIkbA+OoPND0coYccw4r
         I+mQ==
In-Reply-To: <55042B53.5000101-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, 14 Mar 2015 13:36:35 +0100, Andreas Rohner wrote:
> On 2015-03-14 04:51, Ryusuke Konishi wrote:
>> On Tue, 24 Feb 2015 20:01:44 +0100, Andreas Rohner wrote:
>>> diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
>>> index 6ffdc09..a3c7593 100644
>>> --- a/include/linux/nilfs2_fs.h
>>> +++ b/include/linux/nilfs2_fs.h
>>> @@ -222,11 +222,13 @@ struct nilfs_super_block {
>>>   */
>>>  #define NILFS_FEATURE_COMPAT_SUFILE_EXTENSION		(1ULL << 0)
>>>  #define NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS		(1ULL << 1)
>>> +#define NILFS_FEATURE_COMPAT_TRACK_SNAPSHOTS		(1ULL << 2)
>>>  
>>>  #define NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT		(1ULL << 0)
>>>  
>>>  #define NILFS_FEATURE_COMPAT_SUPP	(NILFS_FEATURE_COMPAT_SUFILE_EXTENSION \
>>> -				| NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS)
>>> +				| NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS \
>>> +				| NILFS_FEATURE_COMPAT_TRACK_SNAPSHOTS)
>>>  #define NILFS_FEATURE_COMPAT_RO_SUPP	NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT
>>>  #define NILFS_FEATURE_INCOMPAT_SUPP	0ULL
>>>  
>> 
>> You don't have to add three compat flags just for this one patchset.
>> Please unify it.
>> 
>> #define NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS		(1ULL << 0)
>> 
>> looks to be enough.
> 
> I could merge the TRACK_LIVE_BLKS and TRACK_SNAPSHOTS flag, but I would
> suggest to at least leave the SUFILE_EXTENSION flag (maybe with a
> different name). The SUFILE_EXTENSION flag has to be set at mkfs time
> and it cannot be set or removed later, because you cannot change the on
> disk format later. I actually set SUFILE_EXTENSION by default in mkfs,
> because it is not harmful and it gives the user the option to switch the
> other flags on later.

I see, it sounds reasonable.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
