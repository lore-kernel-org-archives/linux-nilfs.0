From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Recommended partition scheme for nilfs2
Date: Thu, 7 Jul 2011 11:13:48 +0200
Message-ID: <201107071113.49938.dexen.devries@gmail.com>
References: <a6cda77328d5712a296a687a0e05e298.squirrel@linuxbsdos.com> <20110707.122142.41457972.ryusuke@osrg.net> <20110707.130423.56377867.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:references:in-reply-to:x-face
         :mime-version:content-type:content-transfer-encoding:message-id;
        bh=Lw2K3/wTGJOFnbh4TXWTNjQK0ZrDcHsXmJwOmpk2s+U=;
        b=iZOOyn6vDLxsbyktQ8xfPm+61Ow7HgFM2lW7ScGp3gYNvsc7qVqVd7zANDFmjtILO+
         UICSUx78IUm9YOWeTuY4PnXNDc8uo+TDi2q5kARWexXnYJKzO7lUYRJ2zBf8cQxg30xc
         Se88xOwDRTTDdF+fm85N2ZKnezRsmM4gO0TmA=
In-Reply-To: <20110707.130423.56377867.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thursday 07 of July 2011 06:04:23 you wrote:=20
> > This topic was once discussed with the title of "FIBMAP ioctl
> > missing".
> >=20
> > fibmap internally uses bmap vfs method.  Adding the feature is not =
so
> > difficult, but it must not be used for overwriting data blocks beca=
use
> > nilfs everytime changes allocation of file blocks due to its COW
> > nature.  Garbage collection also blows up safety of such operation.
> > Unfortunately, swap file is actually doing it.
> >=20
> > Does LILO use fibmap for read-only purpose ?
> >=20
> > If so, we only need a method to deny direct block write by the swap
> > file.
>=20
> That was not enough.  I guess LILO uses block mapping assuming it's
> pinned to the place.  It's not easy to implement within nilfs.

That's my understanding as well. LILO, upon `installation' (the `lilo' =
command) creates a static map of which blocks make up kernel file (and =
optionally initial ramdisk). Basically we'd have to ensure the kernel f=
ile blocks are never moved around, which'd increase complexity of NILFS=
2. Leaving 128MB /boot partition gets the job done at benign cost.

=46WIW, I got fingers burned by grub's complexity a few times, so I sti=
ck to the simple LILO.

Btw., Ryusuke, you've mentioned that blocks being part of a snapshot ar=
e never moved  around, right? If that's the case, keeping kernel files =
on snapshot would be enough, but snapshots can be deleted (and subseque=
ntly GC'd) at any time.

We could hack around that in a somewhat standard way with `chattr +i /b=
oot/vmlinuz-xxx', provided NILFS2 supported the `i' (immutable) attribu=
te (as discussed in man chattr(1)), but again that's some complexity. O=
r +t which was meant to secure against tail-merging for use with LILO.


--=20
dexen deVries

[[[=E2=86=93][=E2=86=92]]]

=46or example, if the first thing in the file is:
   <?kzy irefvba=3D"1.0" rapbqvat=3D"ebg13"?>
an XML parser will recognize that the document is stored in the traditi=
onal ROT13 encoding.

(( Joe English, http://www.flightlab.com/~joe/sgml/faq-not.txt ))
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
