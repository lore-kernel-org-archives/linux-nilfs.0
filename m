From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: One checkpoint just won't get GC'd
Date: Thu, 17 Feb 2011 15:29:43 +0100
Message-ID: <201102171529.43904.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:user-agent:mime-version
         :content-type:content-transfer-encoding:message-id;
        bh=KAdq/prR1luskF452KBkWsdQvBvMQrRr296V0NqurQs=;
        b=j/HX7zfTfMnlzcPnJ5ZHEHtbW58uZEZhGj+LRj4pwgjNhnHysrmb/KOjXfvL4MpyiN
         hRyKyqVe98YmZJDcJaJu9k7d1sYK8pxjzbvUJHMkNMkck2FKBaxAx+xNbUwNPPrYhaUX
         Abd6iSoVTFI3b7NBZkmZY2qjLPRfvrITD5mAQ=
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

I have a few snapshots and between two of them (few days old) there is =
a lone=20
checkpoint (68) that just won't get GC'd:
CNO        DATE     TIME  MODE  FLG   NBLKINC       ICNT
67  2011-02-11 10:58:34   ss    -      10214     183442
68  2011-02-11 11:00:07   cp    -         12     183442
11205  2011-02-11 13:13:44   ss    -       2229     245061
40205  2011-02-16 18:16:04   ss    -         59     260421

Lots and lots of subsequent checkpoints has been GC'd sine then; curren=
t is=20
79450.

How do I pinpoint the reason the checkpoint is not getting GC'd?

Running Linux 2.6.38-rc4 with nilfs-utils-2.0.21 right now, but the che=
ckpoint=20
and the snapshots around it were created with 2.6.37 and nilfs-utils-2.=
0.20,=20
IIRC.

--=20
dexen deVries

[[[=E2=86=93][=E2=86=92]]]

> how does a C compiler get to be that big? what is all that code doing=
?

iterators, string objects, and a full set of C macros that ensure
boundary conditions and improve interfaces.

ron minnich, in response to Charles Forsyth

http://9fans.net/archive/2011/02/90
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
