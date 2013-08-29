From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Kernel Bug: unable to handle kernel paging request
Date: Thu, 29 Aug 2013 23:10:44 +0400
Message-ID: <72C60256-983E-43D0-9DA1-D4A446B578BB@dubeyko.com>
References: <CALJXSJqV5nYb_t6GMS0FpWyf1aRehAgpvebwgbJzMJfctf1b2A@mail.gmail.com> <1376054125.2272.84.camel@slavad-ubuntu> <20130815.073806.260411879.konishi.ryusuke@lab.ntt.co.jp> <20130816.134934.27810145.konishi.ryusuke@lab.ntt.co.jp> <1376636610.2301.28.camel@slavad-ubuntu>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=+17t84pjUU9y1Q2BsXuGtNPZcRCADHn+6FIHr+pgzLQ=;
	b=jRn+ypPCClC5K7T9KXZv0ls9xgFjl5iYNm+LloLEU6Ht66CR3SvmBXm8i1eIR0jXvJZ92E31bg0WAO7MjBm/LqpbAsJVx4CnOsXIlSHpkPBvVI3OK/yYs08HEplSa2pZ;
In-Reply-To: <1376636610.2301.28.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?iso-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi J=E9r=F4me,

I need to check independently some my suspicions about the issue. So, I=
 need in additional details.

Did you have any mounted ext4/ext3 partitions in the background of the =
reproduced issue?

Could you check that you can reproduce the issue in the case of absence=
 any mounted
ext4/ext3 partitions?

Could you check also that you can reproduce the issue for 3.2 or earlie=
r kernel version?

Thanks,
Vyacheslav Dubeyko.=20

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
