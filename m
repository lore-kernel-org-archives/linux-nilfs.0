From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v4 4/6] nilfs-utils: add suport for
 NILFS_IOCTL_SET_SUINFO ioctl
Date: Thu, 06 Feb 2014 09:04:53 +0900 (JST)
Message-ID: <20140206.090453.57458618.konishi.ryusuke@lab.ntt.co.jp>
References: <6b62cd72448c48055cfab9017753349cb2cd7da9.1391566347.git.andreas.rohner@gmx.net>
	<20140206.042518.139122814.konishi.ryusuke@lab.ntt.co.jp>
	<52F2CC85.3000004@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52F2CC85.3000004-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, 06 Feb 2014 00:43:01 +0100, Andreas Rohner wrote:
> Hi Ryusuke,
> 
> On 2014-02-05 20:25, Ryusuke Konishi wrote:
>>>  /**
>>> + * nilfs_set_suinfo - sets segment usage info
>>> + * @nilfs: nilfs object
..
>> 
>> This invalidation should be done in utils or upper library.
>> Simply return here as follows:
>> 
>>      return ioctl(nilfs->n_iocfd, NILFS_IOCTL_SET_SUINFO, &argv);
>> }
> 
> Thanks for your review. I have fixed everything you pointed out. Sorry
> for all the missing stuff. I will wait with sending in a new version of
> the patch set, until you finished your review. I suspect you will also
> find some things in patch 5, since it is the crucial part of the
> implementation.

Yes, I am still reviewing the remaining patches.
Please wait for it.

Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
