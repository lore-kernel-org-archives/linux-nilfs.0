From: Jan de Kruyf <jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: crash
Date: Wed, 10 Feb 2010 09:26:46 +0200
Message-ID: <ee5afd761002092326k3bb3a74fq7145cdb9925d88d5@mail.gmail.com>
References: <201002100059.AA01340@capsicum.lab.ntt.co.jp>
	 <20100210.130700.55835591.ryusuke@osrg.net>
	 <ee5afd761002092314i1ba1ec66ie6fe7d0f22d6927e@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:mime-version:received:in-reply-to:references
         :date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        bh=FT3LGKqfVvQw46GoIw0UQvq5KGXGgGi5ZguwHfO8Q/w=;
        b=xVzYyxSfsmxJlK8R2LttCB1oL9b4MzxK9iiZhUxnQBlkav6h3LRGzJ3WrAxSklyCi+
         mcXMVqTo57g/WekbHNJLaZwZy65WSJLAYZhRN88uvbV7dZVktB714aXT+30wLU0ekDdB
         6Ysxfg0qD4kcrdXz4nGexldK5nSKZyYpEZXkg=
In-Reply-To: <ee5afd761002092314i1ba1ec66ie6fe7d0f22d6927e-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hallo,
This patch never made it to the module tree:

from=A0=A0=A0 Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
to=A0=A0=A0 users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org,
sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
cc=A0=A0=A0 jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org
date=A0=A0=A0 Thu, Nov 19, 2009 at 9:10 PM
subject=A0=A0=A0 Re: [NILFS users] [PATCH 4/4] nilfs2: add norepair mou=
nt option


Could I apply the original patch without a problem to the latest module=
 tree?

from=A0=A0=A0 Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
to=A0=A0=A0 users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org,
jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
date=A0=A0=A0 Sat, Nov 7, 2009 at 9:28 PM
subject=A0=A0=A0 Re: [NILFS users] [SPAM] Re: [SPAM] Re: urgent help ne=
ed!
disk partition info lost

Regards,

Jan de Kruyf.



On Wed, Feb 10, 2010 at 6:07 AM, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wro=
te:
>
> ----
> Hi,
> > (Cc'ed to linux-nilfs)
> > Hallo,
> > here is a copy of a post to the list in which you might have an int=
erest.
> > If you need me to do anything please feel free to ask, I hope I wil=
l have
> > some time tomorrow.
> >
> > Regards
> >
> > Jan de Kruyf.
> >
> > ------------------------------------------------
> > Hallo,
> > I did it again.
> > computer locked up. Most likely X, since the keyboard was dead. But=
 the
> > cleanerd was still running
> > from the flashing of the hard-drive LED.
> >
> > Press the big hard reset button
> > restart . . . /var partition (nilfs2) is now full and the restart c=
annot run
> > to completion.
> >
> > This is the 3rd time it happened to me!
> >
> > The only thing I can think of right now is that the cleaner daemon =
was
> > interrupted at the wrong moment.
> > And the /var partition was left in a full state. Is this possible?
> >
> > Does anybody want anything of the image for a post mortem?
> >
> > Does anybody want me to do some tests before I reformat?
> >
> > Further details will follow once I got the rescue HD hooked up.
> >
> > Regards,
> >
> > Jan de Kruyf.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-nil=
fs" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>
> Can you mount the partition with -o ro,norecovery ?
>
> If so, can you see if there are warnings or errors of some kind in
> syslog or daemon or messages?
>
>
> Thanks,
> Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
