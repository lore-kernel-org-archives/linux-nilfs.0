From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: NILFS: bad btree node
Date: Tue, 25 Dec 2012 10:02:06 +0400
Message-ID: <1356415326.2052.9.camel@slavad-ubuntu>
References: <86B5C141-ACFA-4541-999F-E17E09F22476@gmail.com>
	 <1355983713.2056.3.camel@slavad-ubuntu>
	 <3455B0CD-EF89-4227-90E1-FC6B20F5F8EB@gmail.com>
	 <1355996310.2056.28.camel@slavad-ubuntu>
	 <14BA4286-BF21-4BD3-8E41-2F8F9512D801@gmail.com>
	 <1356000112.2056.33.camel@slavad-ubuntu>
	 <44056E9A-3487-4E8A-A56A-5B9228FC7895@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=l/St48DKGSM9ZA0Fx+WXCk/RD+lEdi/9qnuxVz09/dc=;
	b=QiLNsHmoeX9O7s5w+yJH0oKkU9pNranVWyerPuFtMwMAESPdxlt5CDfaeFiAAU1619EnftZDqLBnnp4UzrUwXyZzXw/aw/SXwXK4xjqECNkDZYNMhtwTGF1YzzymkD25;
In-Reply-To: <44056E9A-3487-4E8A-A56A-5B9228FC7895-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?=E5=BC=A0_=E7=A3=8A?= <freeboy6716-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

On Thu, 2012-12-20 at 19:02 +0800, =E5=BC=A0 =E7=A3=8A wrote:
> Yes, I mounted NILFS2 as read-write. It's remounted as read-only by k=
ernel when filesystem found the bad btree node.
>=20
> That's the full backtrace. I will keep on testing, and report more in=
fomation once I found.
>=20

I am trying to reproduce the issue but currently without any success. I
have a presupposition that it can be a synchronization issue between GC
and main driver logic but I haven't any evidence of it yet. Probably, I
can't reproduce some environment's peculiarities.

So, I think that I need to understand more deeply a workload in that th=
e
issue had occurred. As I remember, you talked about several MySQL
databases and so on. Could you describe in more details about what
applications and how to work before issue occurrence?

Thanks,
Vyacheslav Dubeyko.



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
