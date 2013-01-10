From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: A lot of NILFS: bad btree node messages (readonly fs)
Date: Thu, 10 Jan 2013 11:12:05 +0400
Message-ID: <1357801925.2050.41.camel@slavad-ubuntu>
References: <20121129210650.GA4028@wloczykij>
	 <1354255744.2090.3.camel@slavad-ubuntu> <20121130073219.GB4028@wloczykij>
	 <1356415552.2052.11.camel@slavad-ubuntu> <20130103214913.GE2080@wloczykij>
	 <28ABE57F-66DD-491E-9FDB-A6CE3CF773FB@dubeyko.com>
	 <20130104191633.GF2080@wloczykij>
	 <C2F4A5DE-538B-4468-9A6A-BA619EDDA462@dubeyko.com>
	 <20130105164752.GG2080@wloczykij>
	 <504C0292-D0C6-426C-BDFD-1CD50FB32617@dubeyko.com>
	 <20130109210943.GA22054@wloczykij>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=A6DQ9rG9wDAgZ8V60o5YRQDux/FehEl6Hc1chSv+lvc=;
	b=PWtMfpuFkozLPWw7XieYcJSxppw7AraSal51k2QiunVsLdyoXTmpaUW15WHcemm9aQNnN4ZA0vqJu3iLYRdAbA8XEr6Dj1mGsRBXcH69hXPtN5cz7Fm0H26QFnuhf/2T;
In-Reply-To: <20130109210943.GA22054@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Cc: Elmer Zhang <freeboy6716-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, =?UTF-8?Q?=D0=A1=D0=B5=D1=80=D0=B3=D0=B5=D0=B9_?= =?UTF-8?Q?=D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B0=D0=BD=D0=B4=D1=80=D0=BE?= =?UTF-8?Q?=D0=B2?= <splavgm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 2013-01-09 at 22:09 +0100, Piotr Szymaniak wrote:
> On Tue, Jan 08, 2013 at 03:52:30PM +0300, Vyacheslav Dubeyko wrote:
> > 
[snip]

Thank you for additional details.

As I remember, you reported about issue with flush kernel thread firstly
and, then, about this issue. So, I think that you can have some similar
environment peculiarities as Elmer Zhang.

Could you share details of your virtual memory configuration
(especially, vm.min_free_kbytes)?

Could you share more detailed output of your system log? Especially, I
interested what was in the first case of the issue occurrence. But it
can be interested also part of system log that begins from system start
and ends with messages about remounting in RO state.

Thanks,
Vyacheslav Dubeyko.

> 
> 
> Piotr Szymaniak.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
