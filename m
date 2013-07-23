From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Kernel Bug: unable to handle kernel paging request
Date: Tue, 23 Jul 2013 15:15:41 +0400
Message-ID: <1374578141.2226.5.camel@slavad-ubuntu>
References: <CALJXSJquK6YxGKuH97Ec2CTMyJaZrJjOfePSKtgPDm8_9YXzzw@mail.gmail.com>
	 <CALJXSJoW9Qpp9t42u_k4cW3gO6qzSPoeCjtQDU3tDKq6TJ=K8Q@mail.gmail.com>
	 <F4156394-8A25-4F81-81C3-9921CB00BD92@dubeyko.com>
	 <CALJXSJrj0J_-ZUCOurJXaYhx_wEJwxb2_5OOJjQSSmmP-PQDgg@mail.gmail.com>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=2az+ld+ZbRM/RAsOfx9pV31dtGBkVl4C9oPU9P48fCw=;
	b=Oix2kgRGRoDwhDO85Y4UG1UEHsWuV430YbuxpYhGOvLA7dXhr+aDf64c+3SR8MzIuf6agQi5/mc0tNpL1wqjjtor3SsyYnzWOmbiDw4+GN4dVaejqCQ9/LH0Z2gjvKBY;
In-Reply-To: <CALJXSJrj0J_-ZUCOurJXaYhx_wEJwxb2_5OOJjQSSmmP-PQDgg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?ISO-8859-1?Q?J=E9r=F4me?= Poulin <jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, 2013-07-22 at 15:11 -0400, J=C3=A9r=C3=B4me Poulin wrote:

[snip]
>=20
> I'm back using my laptop but wasn't able to reproduce it again, it is
> not as easy as it was before to reproduce, sometimes apt-get update
> works, sometimes it freezes. Here is a different paste bin as
> pastebin.ca seems to be down for some time now:
> http://pastebin.com/ALmuHdfh
>=20

Thank you. Now I downloaded this output.

> > So, as I see, the reproducing path is: (1) delete /var/cache/apt; (=
2) issue apt-get update.
>=20
> In fact it is the other way around;
> (1) Issue apt-get update: Crash.
> (2) Reboot, try again: Crash.
> (3) Delete /var/lib/apt/lists/* and try again: Works for some time.
>=20

Ok. Thank you for additional details.

>=20
> > (1) The strace output for the case of issuing the apt-get update (i=
n the case of issue reproducing).
>=20
> That will be hard to obtain except maybe if I alias my apt-get update
> to strace -f -o /boot/somefile.txt apt-get update and hope the proble=
m
> occur again. It sometimes happen when launched from the Ubuntu Store
> which doesn't use bash to launch the update.
>=20

Ok. I see. I'll try to analyze the issue on the basis of available
information. But it will be a great to have the requested strace output=
=2E

Thanks,
Vyacheslav Dubeyko.

> > (2) I need more details about your NILFS2 partition. Could you shar=
e output of "nilfs-tune -l"?
>=20
> $ sudo nilfs-tune -l /dev/vgUbuntu/root
> nilfs-tune 2.1.4
> Filesystem volume name:  root
> Filesystem UUID:  336f247d-c8d1-4e91-887a-258121c4face
> Filesystem magic number:  0x3434
> Filesystem revision #:  2.0
> Filesystem features:      (none)
> Filesystem state:  invalid or mounted
> Filesystem OS type:  Linux
> Block size:  4096
> Filesystem created:  Thu Apr 11 22:34:29 2013
> Last mount time:  Mon Jul 22 13:35:46 2013
> Last write time:  Mon Jul 22 15:06:02 2013
> Mount count:  86
> Maximum mount count:  50
> Reserve blocks uid:  0 (user root)
> Reserve blocks gid:  0 (group root)
> First inode:  11
> Inode size:  128
> DAT entry size:  32
> Checkpoint size:  192
> Segment usage size:  16
> Number of segments:  25599
> Device size:  214748364800
> First data block:  1
> # of blocks per segment:  2048
> Reserved segments %:  5
> Last checkpoint #:  3229012
> Last block address:  17242181
> Last sequence #:  136170
> Free blocks count:  17827840
> Commit interval:  0
> # of blks to create seg:  0
> CRC seed:  0x7ab1d7ed
> CRC check sum:  0xfab54710
> CRC check data size:  0x00000118
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
