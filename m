From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Cleaner won't start
Date: Fri, 30 Aug 2013 09:48:22 +0400
Message-ID: <1377841702.2343.16.camel@slavad-ubuntu>
References: <CALJXSJq9DR6tapLRvq3rZGFsne-CUriruGAyzgO7pAB9ESe-bA@mail.gmail.com>
	 <1377511770.2621.11.camel@slavad-ubuntu>
	 <CALJXSJrsGhW4noeXpwnpco_W1mS4DVEfdcc-pvipQJ5fsir=qA@mail.gmail.com>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=qBoaN/mu4VsAOyF3Kl9XEZ/D0NwKUT1+vj27mqYTx/Y=;
	b=SxwfceLU4CqtAZG7I6egN9k28eFqvAEbbGJDMQa+VAt6ybBYl/PoyYSDzZGxilcWW2by0wsI/rlBj068hQfj2wpOKZXE70F8tNVOvXsnqH2viYnhK0IRV3Dn1hD9cg+a;
In-Reply-To: <CALJXSJrsGhW4noeXpwnpco_W1mS4DVEfdcc-pvipQJ5fsir=qA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?ISO-8859-1?Q?J=E9r=F4me?= Poulin <jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, 2013-08-29 at 19:47 -0400, J=C3=A9r=C3=B4me Poulin wrote:
> On Mon, Aug 26, 2013 at 6:09 AM, Vyacheslav Dubeyko <slava-yeENwD64cLyIwRZHo2/mJg@public.gmane.org=
m> wrote:
> > As I remember, one of the report is contained such error message. B=
ut I
> > can't recollect in what environment such error message was.
> >
> > I suspect that it is a sequence of the problem that it was more ear=
lier.
> > Did you have any NILFS2 error messages in your system log earlier? =
Or,
> > maybe, do you try to use NILFS2 volume after getting some NILFS2 is=
sue
> > earlier?
>=20
> I continued using the volume daily as the issue only popped out when
> using apt-get, so I was safe for the rest. Now I migrated to ext4 to
> get my laptop working, I was able to succesfully rsync all the data o=
n
> a new volume and keep the NILFS2 volume archived.
>=20
> Earlier logs:
> Aug 23 22:08:50 JeromeCauca nilfs_cleanerd[2369]: start
> Aug 23 22:08:50 JeromeCauca nilfs_cleanerd[2369]: pause (clean check)
> First time it happened was there:
> Aug 24 03:59:10 JeromeCauca nilfs_cleanerd[2369]: resume (clean check=
)
> Aug 24 03:59:40 JeromeCauca kernel: [21196.506395]
> nilfs_ioctl_move_inode_block: conflicting data buffer: ino=3D76070,
> cno=3D3769693, offset=3D0, blocknr=3D46096310, vblocknr=3D4731085
> Aug 24 03:59:40 JeromeCauca kernel: [21196.506425] NILFS: GC failed
> during preparation: cannot read source blocks: err=3D-17
> Aug 24 03:59:40 JeromeCauca nilfs_cleanerd[2369]: cannot clean
> segments: File exists
> Aug 24 03:59:40 JeromeCauca nilfs_cleanerd[2369]: shutdown
>=20
> I don't have anything earlier than August 21st and not any other log
> has "nilfs" in them.

Yes, I think that it needs to investigate the issue more deeply. But I
haven't enough time currently for investigated several issues
simultaneously. :) So, this issue will be in my TODO list.

But, anyway, it needs to understand the reproducing path. Do you have
any assumptions how to reproduce this situation?

Thanks,
Vyacheslav Dubeyko.

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
