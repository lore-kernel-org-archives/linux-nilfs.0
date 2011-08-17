From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [clarification] an irritating problem and possible source of quiet data loss
Date: Wed, 17 Aug 2011 14:12:10 +0200
Message-ID: <201108171412.10488.dexen.devries@gmail.com>
References: <201108171207.22032.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:references:in-reply-to:x-face
         :mime-version:content-type:content-transfer-encoding:message-id;
        bh=V95xp/I9lwn5daploM+/QVkNhZjEkiKpWlf0G0P1GDg=;
        b=cQRmZnDVVLhvXZEUbQyOVpo0jvhClkybelDde4G9N7eg0DFrAZEozdoFZjv/48gRnA
         H486aZjrerHYqOvwG8PETFO/DNJaL/cRzlueyPrHeN8I13tYyeZ7VGe4+l4jO0zVCMxr
         2mXxCnCmkKUJf2NOLC9NjRhC8TUbtCxvs3W4Q=
In-Reply-To: <201108171207.22032.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wednesday 17 of August 2011 14:07:21 i wrote:
> (...)
> so far so good. However!
>=20
> # cp etc/adjtime /etc
> cp: `etc/adjtime' and `/etc/adjtime' are the same file
>
> (...)

a small clarification: at this moment, i was in /mnt/x/, so the source =
file to=20
be copied was actually /mnt/x/etc/adjtime -- the older version i wanted=
 to=20
restore.

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
