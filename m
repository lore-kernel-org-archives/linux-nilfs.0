From: =?UTF-8?Q?Rodrigo_E=2E_De_Le=C3=B3n_Plicet?= <rdeleonp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Error while testing (using loop device)
Date: Fri, 23 Jul 2010 10:47:38 -0500
Message-ID: <AANLkTikY4joAzVe-3BSpX9KNSmFPr8cXqpJ_0pJ+rX0P@mail.gmail.com>
References: <AANLkTikwTRGooDQD+Uo08MkywS+KJ8BXxqqytxbNFiqr@mail.gmail.com> 
	<AANLkTin0qMJvDgs705a9Nu0hWNLCdGEXWn7q_2sXQ6yZ@mail.gmail.com> 
	<20100723.113125.163336402.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:received:mime-version:received:in-reply-to
         :references:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        bh=YkYm1ZXuwngr6u9dmafe3U7IAaD6EE1rYltHk2XEyXY=;
        b=wPzE0oBAxnBnMoSEI1qRa0Vmi2LMXgxB0vNg77Ek9jW8JTKNKlTtFLsZKevXkPeHXa
         ObasQVeYRY0hhyXoe31tzJ8XFcjreDX/ROQ3DfdTUZFqFNCohQGKk3gIY2coZktDucz1
         N3fmJOk159s4hl5dyP+bt/pV71hyu2lJxfMEE=
In-Reply-To: <20100723.113125.163336402.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jul 22, 2010 at 9:31 PM, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wro=
te:
> How about this?
>
> =C2=A0$ sudo mount -t nilfs2 -o ro,cp=3D3,loop=3D/dev/loop0 /tmp/test=
=2Eimg /tmp/t2
>
> or
>
> =C2=A0$ sudo mount -t nilfs2 -r -o cp=3D3,loop=3D/dev/loop0 /tmp/test=
=2Eimg /tmp/t2
> =C2=A0...
> =C2=A0$ sudo umount /tmp/t2

Hi. Thanks for the reply.

rdl@linage:/tmp$ lscp
                 CNO        DATE     TIME  MODE  FLG   NBLKINC       IC=
NT
                   1  2010-07-23 10:36:35   cp    -         11         =
 3
                   2  2010-07-23 10:37:22   cp    -          8         =
 3
                   3  2010-07-23 10:38:13   ss    -        615         =
 4
                   4  2010-07-23 10:38:58   cp    -         77         =
 5
                   5  2010-07-23 10:39:05   cp    -         21         =
10
                   6  2010-07-23 10:39:12   cp    -         26         =
 7
                   7  2010-07-23 10:39:43   cp    i          8         =
 7

rdl@linage:/tmp$ ls -lad t*
drwxrwxrwx 3 root root       4096 2010-07-23 10:39 t
drwxrwxrwx 2 rdl  rdl           6 2010-07-23 10:36 t2
-rw-r--r-- 1 rdl  rdl  1049624576 2010-07-23 10:36 test.img

rdl@linage:/tmp$ mount|grep loop
/dev/loop0 on /tmp/t type nilfs2 (rw,gcpid=3D2980)

rdl@linage:/tmp$ sudo mount -t nilfs2 -o ro,cp=3D3,loop=3D/dev/loop1
/tmp/test.img /tmp/t2
mount.nilfs2: Error while mounting /dev/loop1 on /tmp/t2: Read-only fil=
e system

:(
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
