From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] lscp: support opening mounted filesystem by directory pathname
Date: Wed, 2 Mar 2011 13:43:53 +0100
Message-ID: <201103021343.54036.dexen.devries@gmail.com>
References: <201103021113.32637.dexen.devries@gmail.com> <20110302.202345.74569955.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:user-agent:references
         :in-reply-to:x-face:mime-version:content-type
         :content-transfer-encoding:message-id;
        bh=y/nko6nLYLMsJLnxPuLEdCx+YQOEzMnI9QIRKwkbt2w=;
        b=osOEFeKOxcxOjsmeMOKb/ZUQ/4u/tOKGSUnAt4HeXJSjgIWbouiN7Pj4MNsCDo3ls1
         v+gdAZWtXmjZ8/Fw6U/hBacAJ7wRrSR4mIUVeB7vKVtRdoUxLc53y8pKVzueVmenQwec
         7w9tHNODd8KBfqv4JA9hh0EhU+STD9bTvl+Os=
In-Reply-To: <20110302.202345.74569955.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wednesday 02 of March 2011 12:23:45 you wrote:
> Hi,
>=20
> On Wed, 2 Mar 2011 11:13:32 +0100, dexen deVries wrote:
> > The patch I've submited may be a wrong solution; perhaps instead th=
e
> > algorithm of nilfs_find_fs() (around lib/nilfs.c:179,211) should be
> > improved.
> >=20
> > Regards,
>=20
> Well, allowing directory pathname for nilfs commands seems a good ide=
a
> to me.  Why not apply it to other commands except nilfs_cleanerd ?
>=20

Goot point, I'm on it right now.

Reading through sbin/cleanerd/cleanerd.c, it seems it doesn't make any=20
distinction between dev and dir, just supplies program's argument as bo=
th dev=20
and dir arguments to nilfs_open(). In my understanding, that'd be the c=
leanest=20
way of using it.=20

However, the current behavior of nilfs_open() (or more exactly, of=20
nilfs_find_fs()) doesn't support that semantics -- if dev is passed, it=
 kind of=20
ignores the dir argument. Perhaps I should try to fix nilfs_find_fs() r=
ather=20
than put stat() and S_ISDIR() in every program?

--
dexen deVries

[[[=E2=86=93][=E2=86=92]]]

47. As Will Rogers would have said, "There is no such thing as a free=20
variable."

(Alan Perlis, `Epigrams on Programming')
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
