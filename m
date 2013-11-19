From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Recommended Linux kernel version
Date: Tue, 19 Nov 2013 10:59:14 +0900 (JST)
Message-ID: <20131119.105914.503104768.konishi.ryusuke@lab.ntt.co.jp>
References: <W1583929863127091384816617@atl4webmail21>
	<20131119.095705.27789579.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131119.095705.27789579.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Mark Trumpold <markt-qk0wvQ0ghJwAvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 19 Nov 2013 09:57:05 +0900 (JST), Ryusuke Konishi wrote:
> On Mon, 18 Nov 2013 23:16:57 +0000, "Mark Trumpold" wrote:
>> My question: Is there a recommended Linux kernel version which has
>> all the known important patches included, or is there a known
>> version which is at a good stability point.
> 
> It looks like only the following versions include all important
> patches at present:
> 
> - kernel 3.12 and later
> - kernel 3.11.y (y >= 5)
> - kenrel 3.10.y (y >= 16)

I also found kernel 3.2.y is very well maintained.

Most important bug fixes were applied to its latest version (kernel
3.2.52) including the most recent bug fix.  It is reasonably safer
among old stable kernels.

Regards,
Ryusuke Konishi

>> Hello,
>> 
>> We are using Debian 6.0.5 with kernel 3.3.1, and I have been trying
>> to manage 'nilfs' with kernel patches -- which is not working out
>> too well.  It is hard form me to discern what patches to apply.
>> 
>> At one point Vyacheslav had suggested I upgrade to newer kernel
>> version to avoid having to patch 'nilfs'.
> 
> Yes, the kernel 3.3.y series looks rather old.  Using newer kernel is
> recommended.
> 
> 
> Regards,
> Ryusuke Konishi
> 
> 
>> I suppose we could just go with the latest kernel, but I was hoping
>> to be a little more strategic.
>> 
>> Thanks in advance,
>> Mark T.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
