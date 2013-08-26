From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Cleaner won't start
Date: Mon, 26 Aug 2013 14:09:30 +0400
Message-ID: <1377511770.2621.11.camel@slavad-ubuntu>
References: <CALJXSJq9DR6tapLRvq3rZGFsne-CUriruGAyzgO7pAB9ESe-bA@mail.gmail.com>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=gzfW26bV28uLEZOcNLlKE2sIOK8efAQzzUM6qoF+VZw=;
	b=iW6qX2NL34Wae1SKZ5qsfDNK4WKtj4IS7JjMz4woFbNFUVXIXbhsGhnddKpy2+3Ur13y0zgXJhL7Yz9EviUgsT8VjULn+a1bUGzlio8Kbbczd1GG9WTd5ZAAiXKFjAoN;
In-Reply-To: <CALJXSJq9DR6tapLRvq3rZGFsne-CUriruGAyzgO7pAB9ESe-bA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?ISO-8859-1?Q?J=E9r=F4me?= Poulin <jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Sun, 2013-08-25 at 18:43 -0400, J=C3=A9r=C3=B4me Poulin wrote:
> I don't know if it is related to my other problem, but now, the
> cleaner won't start. I noticed low disk space warnings and now at 91%
> used space.
>=20
> Here is what syslog has to say:
> Aug 25 18:37:22 nilfs_cleanerd[3512]: start
> Aug 25 18:37:22 nilfs_cleanerd[3512]: pause (clean check)
> Aug 25 18:37:22 nilfs_cleanerd[3512]: resume (clean check)
> Aug 25 18:37:23 kernel: [  758.822120] nilfs_ioctl_move_inode_block:
> conflicting data buffer: ino=3D76070, cno=3D3769693, offset=3D0,
> blocknr=3D46096310, vblocknr=3D4731085
> Aug 25 18:37:23 kernel: [  758.822158] NILFS: GC failed during
> preparation: cannot read source blocks: err=3D-17

As I remember, one of the report is contained such error message. But I
can't recollect in what environment such error message was.

I suspect that it is a sequence of the problem that it was more earlier=
=2E
Did you have any NILFS2 error messages in your system log earlier? Or,
maybe, do you try to use NILFS2 volume after getting some NILFS2 issue
earlier?

Thanks,
Vyacheslav Dubeyko.

> Aug 25 18:37:23 nilfs_cleanerd[3512]: cannot clean segments: File exi=
sts
> Aug 25 18:37:23 nilfs_cleanerd[3512]: shutdown
>=20
> If it is related, should I start from scratch or should we debug this=
?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs=
" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
