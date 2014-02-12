From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v2 1/1] nilfs2: add mount option that reduces super
 block writes
Date: Wed, 12 Feb 2014 09:58:31 +0900 (JST)
Message-ID: <20140212.095831.397309935.konishi.ryusuke@lab.ntt.co.jp>
References: <52FA2EB4.6030401@gmx.net>
	<20140212.031115.172542304.konishi.ryusuke@lab.ntt.co.jp>
	<52FA80F5.1090003@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52FA80F5.1090003-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 11 Feb 2014 20:58:45 +0100, Andreas Rohner wrote:
> On 2014-02-11 19:11, Ryusuke Konishi wrote:
>> On Tue, 11 Feb 2014 15:07:48 +0100, Andreas Rohner wrote:
>> Honestly, I'm still hesitative about the full scan approach since the
>> mount time depends on the device size and the medium type.
> 
> I wouldn't recommend it as the default recovery option. The user has to
> make a decision if it is right for his or her device and activate it.
> But until now it is just a stupid experiment. It would only be useful in
> certain corner cases anyway. Thanks for reviewing it!
> 
>> If we define some window size based on the performance of the device
>> (which would be measured and written in super block with mkfs or
>> nilfs-tune), and can limit the range of scan, things may become more
>> manageable.
> 
> That would certainly be possible. The window would start at s_last_pseg
> and end at (s_last_pseg + window size). We could then simply force a
> super block write as soon as the first segment is allocated outside of
> the window. This could still significantly reduce the number of writes
> to the super block.
> 
> Thanks for your review,

You're welcome, thank you, too.

By the way, we have another todo for flash devices.  It is FITRIM
ioctl support.  FITRIM is an API to issue TRIM/DISCARD requests
(through blkdev_issue_flash function) to a portion of underlying
device to allow batch DISCARD by userland tools.  It helps GC
optimization of underlying flash device or thinprovisioning feature of
block storage.  NILFS is suit for implementing this feature since free
space is managed in segment unit and sufile is available, but was long
time left.

If you have an interest, please take a look at it, too.

Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
