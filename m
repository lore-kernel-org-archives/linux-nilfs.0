From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: NILFS: bad btree node
Date: Thu, 27 Dec 2012 14:43:37 +0400
Message-ID: <1356605017.2050.8.camel@slavad-ubuntu>
References: <86B5C141-ACFA-4541-999F-E17E09F22476@gmail.com>
	 <1355983713.2056.3.camel@slavad-ubuntu>
	 <3455B0CD-EF89-4227-90E1-FC6B20F5F8EB@gmail.com>
	 <1355996310.2056.28.camel@slavad-ubuntu>
	 <14BA4286-BF21-4BD3-8E41-2F8F9512D801@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=VDtJxVpIDpQujd+aoSHBFuDic05SDAr5yGIgPlwJP9U=;
	b=GrxVw50Fu7W9MqaM6GDjYJ9ofJooqJyE7UH7jwP3U3Qn1geH/oZVJ74T7jTega0UPeZ2mm8+WI+6VhtGYI0XcKQGvgcVjGXXOiaWEIafVoNtFjohTQDXPvILZDjKGCn6;
In-Reply-To: <14BA4286-BF21-4BD3-8E41-2F8F9512D801-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?=E5=BC=A0_=E7=A3=8A?= <freeboy6716-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, 2012-12-20 at 18:16 +0800, =E5=BC=A0 =E7=A3=8A wrote:
> 1. Linux kernel version: 2.6.32-220.13.1.el6.x86_64=20

Why do you use 2.6.32 Linux kernel? Could you try to use one of the las=
t
vanilla kernel (for example, 3.7.1)?

To be honestly, I tried to reproduce the issue on 3.6.0 version but
without any success. And I know that such issue was reported on 3.6.8
kernel version also. But this issue has not stable reproducing in the
case of 3.6.8 kernel version.

> 2. nilfs-utils version: nilfs-utils-2.1.4
> 3. "mount" output:
> /dev/sdb2 on /data0 type nilfs2 (rw,noatime,gcpid=3D22909)
>=20
> 4. "df -h" output:
> /dev/sdb2 9.6T 5.9T 3.2T 66% /data0=20

Do you use any RAID technology?

By the way, what HDD hardware do you use? What vendor?

With the best regards,
Vyacheslav Dubeyko.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
