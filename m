From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: RAID and file system encryption
Date: Tue, 2 Aug 2011 10:45:45 +0200
Message-ID: <201108021045.45239.dexen.devries@gmail.com>
References: <889e085c06295b2f79289eb86be534ef.squirrel@linuxbsdos.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:references:in-reply-to:x-face
         :mime-version:content-type:content-transfer-encoding:message-id;
        bh=bZwO/PiXoHr7vY8RyabSsDubv16uBeXnP8n0XU6Qtkk=;
        b=i1SVe0EocU1k6M+ry0sBcNw+0UPQIRI3Aj5qUHloqqaD1HQ/3i7zlDg0GpvOXfx+TQ
         k5aWI1wn8RwIwlW2S60P2gEWD8jBlJPIAmk9b6u5AObTn55WQETMAQbaWG2f+W2aR2Tw
         DMilgDdyBQvReU/28GpvrB9hWfSdgJtzQOSoU=
In-Reply-To: <889e085c06295b2f79289eb86be534ef.squirrel-aEpbUQpJQqXlKS8GlytQkw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tuesday 02 of August 2011 10:22:24 you wrote:
> Hi,
>=20
> Just want to find out if nilfs2 supports RAID and native file system
> encryption. Any plans to, if it does not?

not by itself, but it stacks nicely over LVM2 and LUKS for, respectivel=
y, RAID=20
and encryption. Guess that's more unix-ish than having one program (her=
e:=20
nilfs2 driver) have every possible feature built-in.


> Also, at this stage in its development, are there any serious drawbac=
ks to
> using nilfs2 on a desktop distribution?

there are small ones. There is no KDE GUI for browsing snapshots (as of=
 yet).

=46ree space does not increase immediately after removing files, which =
may=20
surprise users that aren't aware of the snapshotting.

Last but not least, the filesystem plays badly with Bitcoin (and perhap=
s other=20
similar programs). Bitcoin causes very many checkpoints to be created, =
quickly=20
eating up the free space. AFAIK, it's because bitcoin issues numberous =
small=20
transactions to the underlying BDB very often, even 2...4/second in som=
e=20
cases. And bitcoin's BDB is configured to use 64kb `page' size, IIRC. I=
've got=20
sick of it and moved entire bitcoin database to XFS, leaving only walle=
t.dat=20
on NILFS2.

On the other hand, NILFS2 works well under mild-loaded MySQL, both on t=
est www=20
server and for KDE's internal data like Nepomuk and Akonadi storage. I =
keep 30=20
days worth of checkpoints on the test server, has already helped us onc=
e to=20
recover certain old files. On PCs and workstations I keep about 10...48=
h worth=20
of checkpoints.

NILFS2 performs nicely under mixed workload, both in home and workplace=
 use.=20
Worth noting is that checkout of large GIT repository (kernel sources) =
takes=20
exceptionally short.


Regards,
--=20
dexen deVries

[[[=E2=86=93][=E2=86=92]]]

=46or example, if the first thing in the file is:
   <?kzy irefvba=3D"1.0" rapbqvat=3D"ebg13"?>
an XML parser will recognize that the document is stored in the traditi=
onal=20
ROT13 encoding.

(( Joe English, http://www.flightlab.com/~joe/sgml/faq-not.txt ))
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
