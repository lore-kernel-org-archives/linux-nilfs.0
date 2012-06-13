From: Ivan Shmakov <oneingray-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: off-line resizing?
Date: Wed, 13 Jun 2012 23:06:54 +0700
Message-ID: <86fw9zw601.fsf@gray.siamics.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

	The FAQ reads:

--cut: http://www.nilfs.org/en/faq.html --
   5. Can I resize NILFS volumes ?

      Yes, you can both enlarge and shrink NILFS volumes with
      nilfs-resize command.  This feature is available on Linux 3.0 and
      later.  Resizing for unmounted file systems are not supported at
      present.

      For details, please see the man page of nilfs-resize(8).
--cut: http://www.nilfs.org/en/faq.html --

	Unfortunately, I don't plan to switch my =E2=80=9Cproduction=E2=80=9D =
hosts to
	Linux 3 yet.  However, for the purposes I want to give NILFS a
	try I can assume that I can easily umount the volume whenever I
	need to resize it, to run whatever user-space code necessary.

	Thus, I'm curious, are there any plans to implement =E2=80=9Coff-line=E2=
=80=9D
	NILFS resizing?

	TIA.

--=20
=46SF associate member #7257	np. =D0=94=D0=BE=D0=B6=D0=B4=D1=8C =E2=80=94=
 =D0=94=D0=94=D0=A2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
