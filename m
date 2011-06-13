From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [GIT PULL] nilfs2 fixes for 3.0-rc3
Date: Mon, 13 Jun 2011 10:39:42 +0200
Message-ID: <201106131039.43298.dexen.devries@gmail.com>
References: <20110613.131659.170025547.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:user-agent:references
         :in-reply-to:x-face:mime-version:content-type
         :content-transfer-encoding:message-id;
        bh=yU7rpTR+XD37XuJDe4owHfiQD5Po6MdZqkVZH3V5UbM=;
        b=ngouYeVswNpbaT2X1uiRnFVY25b9OcgMrv6ic49Bzwh915glHHYNwnugcJLd/o/OmC
         Pxc0GUoSTTIJ+82dnvjYJl6za3uknmwHNRVamW49IrkqGUGVK4iD4uvUBFCil9EkbQ7f
         gaIONeuYeccI3SxfNI0sauP2Wwzn1MXjiJ7c4=
In-Reply-To: <20110613.131659.170025547.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Ryusuke,


On Monday 13 of June 2011 06:16:59 you wrote:
> Hi Linus,
>=20
> please pull from:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git
> for-linus
>=20
> to receive the following bug fixes.  These fix a reported bug and two
> boundary condition bugs recently found in btree code.
>=20
> Thanks,
>=20
> Ryusuke Konishi
> --
> The following changes since commit
> 59c5f46fbe01a00eedf54a23789634438bb80603:
>=20
>   Linux 3.0-rc2 (2011-06-06 18:06:33 +0900)
>=20
> are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git
> for-linus
>=20
> Ryusuke Konishi (3):
>       nilfs2: fix incorrect block address termination in node concate=
nation
>       nilfs2: fix missing block address termination in btree node shr=
inking
>       nilfs2: fix problem in setting checkpoint interval


it seems only two of the above commits were pulled; the ``fix problem i=
n=20
setting checkpoint interval'' is missing from Linus' repo as of now.


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
