From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Problem report: cannot run nilfs_cleanerd on full filesystem
Date: Mon, 21 Mar 2011 13:00:47 +0100
Message-ID: <201103211300.50177.dexen.devries@gmail.com>
References: <20110319220157.GA681@heethoofdje.13thmonkey.org> <20110320125040.GA735@heethoofdje.13thmonkey.org> <20110321.200706.260176646.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:user-agent:references
         :in-reply-to:x-face:mime-version:content-type
         :content-transfer-encoding:message-id;
        bh=gJSElsNmnccWLJoaao7gXUOg9PT0gBmqYlgPLFR5Qeo=;
        b=lS6v7vQlE2Fb9ct8tVv9nMFgNGxqATfQhO7O00u7J3mqj2aOHOV95hFdjUK8p0+FXo
         0pcKWhaMhSpW+0txObDWPeN9QJutQu7QKvjbnHZaFbU94Z17YMp1eS6HeJW+sQdy7qGa
         ZCXBotGvq5adDjLK+eckVJh6we0l2Qri1y4XQ=
In-Reply-To: <20110321.200706.260176646.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,


On Monday 21 of March 2011 12:07:06 you wrote:
> The ".nilfs" file is used for two purposes:
>=20
>  1) As the file on which the nilfs library issues ioctls.
>=20
>  2) For advisory locks (i.e. fcntl(F_GETLK/F_SETLK/FSETLKW)).  This
>     works as a mutex between the cleaner and other nilfs-tools.
>=20
> Note that the nilfs2 kernel code never uses the .nilfs file; it's jus=
t
> a regular file for nilfs2.
>=20
> As for the item (1), we can use the root directory of each filesystem
> instead.  And for (2), a Posix semaphore or other lock primitives may
> be available.


I tried but failed; it seems Linux doesn't allow opening directory O_RD=
WR or=20
O_WRONLY. And a modyfying ioctl() on directory opened O_RDONLY also ret=
urned=20
some error, I think it was EBADF. I did not dig any further, so I dunno=
 if=20
that's done by kernel's general code or NILFS' ioctl() handler.

I believe nilfs_cleanerd could, on principle, use file descriptor of an=
y file on=20
the filesystem in case the user runs into a full fylesystem. Kernel cod=
e=20
handles that OK, only nilfs_cleanerd would need an extra argument to op=
en a=20
different file. What's your oppinion on that?


Regards,
--=20
dexen deVries

[[[=E2=86=93][=E2=86=92]]]

``In other news, STFU and hack.''
mahmud, in response to Erann Gat's ``How I lost my faith in Lisp''
http://news.ycombinator.com/item?id=3D2308816
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
