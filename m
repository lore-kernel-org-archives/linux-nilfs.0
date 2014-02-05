From: Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [static superblock discussion] Does nilfs2 do any in-place writes?
Date: Wed, 5 Feb 2014 21:47:37 +0100
Message-ID: <CAFvQSYStT4uwxqtxATLbPOvHYjww=sw=C=f3vBi_qdu6MXAn5A@mail.gmail.com>
References: <1389787304.3913.28.camel@slavad-ubuntu>
	<20140116.002353.94325733.konishi.ryusuke@lab.ntt.co.jp>
	<1389866912.2565.44.camel@slavad-ubuntu>
	<20140118.090008.194171715.konishi.ryusuke@lab.ntt.co.jp>
	<1390901114.2942.11.camel@slavad-ubuntu-12.04>
	<CAFvQSYSu5CGxs+K6bZUCtq17PrS_paX3bXBuLBRTba_XWYGgAg@mail.gmail.com>
	<71B2806D-7CF2-4992-A588-EB73EADFFF9F@dubeyko.com>
	<CAFvQSYQ84_BsqVC_ZM77P92jkP+1dh7NexvZWg4mFE7B3wSK0A@mail.gmail.com>
	<AE0F313D-5934-452B-80AB-5D691AF8A4BE@dubeyko.com>
	<CAFvQSYQGDXmUit1zFZ9_LAjdLjxM-i_yR2L6pwFDX_BEdjdXxQ@mail.gmail.com>
	<1391088759.2637.13.camel@ubuntu>
	<CAFvQSYQ-qkXz677-obgHVN5fLQiF10-A=T2yNNAHKRcOGm_Pqw@mail.gmail.com>
	<720AFF13-6203-4A28-9850-3C2CAFF3B7BF@dubeyko.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        bh=nOlpXSezCtdPYCxEQjCfX+dR0s68pv+1L7Cd0eCY7nA=;
        b=exded9HMn79nnF+khao5TfQPLbWlMG034nS2t5XwhJE+MnB+cU/ZoqhddXV+wITcJA
         a+uKMZzQFBo0GARJpJikxfig0FcBNq0+CjTS6he6SpMCBy0D3FV1rQMBo6IM3Yv7wr+y
         W+L6Zf+SiL8NZBHLvMnAa93WfID1nY2eYhDt2Imi9O+KkwCDcat78DUBDGnyOkB/McSz
         9hKocpZ69jGcPNnJFmr70jDMrrI/Hp+Sl5rBaEWczD8KFzAh4PNjRZIKmxqjgbNEd1Sd
         B4vM3SKZmPE21hY1ir32bTd6bfBOOgXzH61pGZ4M5zPX4X9HOUC6Yi8gnu+kRkvyawyf
         aDcg==
In-Reply-To: <720AFF13-6203-4A28-9850-3C2CAFF3B7BF-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Vyacheslav,

> But, anyway, how 128 KB correlates with physical erase blocks or
> physical writing units size? :) Physical sizes can be much more and 128 KB
> unable to defend from all possible situations. Sure, there isn't good
> approach for all cases of real life.

I agree that modifying filesystem-code to work arround every single
firmware quirk isn't a good idea.
My enthusiasm stems from the fact that nilfs2 by design is as good as
you can get on devices with weak FTL implementations - except for the
frequent superblock updates.


> Moreover, if you have FTL then you
> expect that block layer will operate with 4 KB block sizes. Otherwise,
> it means that you sell bad storage devices.

Efficient block sizes as small as 4K are only doable with a (DRAM)
cache, which isn't a viable solution for small/cheap devices - even
the best SD cards can't handle that efficiently. So those "bad storage
devices" are unfortunately a common reality (sd/mmc cards, usb pen
drives, ...).

When looking through the raspberry pi forums, you'll find a lot
reports about dead SD cards, worn out where the ext4 journal or
metadata was placed. I admit this is a very specific example, but
quite a lot of embedded linux-powered solutions exist - and all of
them I know boot from (micro-)SD cards. So an improvement in this
situation (such as the mount option proposed by Andreas) could lower
the pain for this quite wide-spread use-case, without altering the
experience for present use-cases where nilfs2 does fine.

Rgerdas, Clemens
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
