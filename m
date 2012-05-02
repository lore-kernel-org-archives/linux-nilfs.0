From: Tiago Caxias <tiago.caxias-FFYn/CNdgSA@public.gmane.org>
Subject: man nilfs-clean
Date: Wed, 2 May 2012 15:44:33 +0100
Message-ID: <CAJi=nxo9vTiYeHYRZ+vXSP_weHbW+0XaENAm7QhrAaebGeRYuw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:from:date:x-google-sender-auth:message-id
         :subject:to:content-type:content-transfer-encoding;
        bh=bHsLKrc2wnHQvzpBSmYGdSY/qgboeWP/LEEKjz7UtKU=;
        b=s3WYrXkJmTe6iHS00u/jy/cBeYLiIktABp/ta9MAQPF2ABYi9alN7Vz0yqsG1uDzJn
         4TkOiJ+Ne0HIYOMOoH8XN0P0TYtJi/EREtoPKZ4JwdpbHJ3ND3lAXpTHq2844z9pCKp4
         0LE+ZifMpmKH4J+ghrgo8/xOQb8xBF66+CfANj2iDmV22u8km+6ZgXkx4u+zHmw6pi9V
         RX9BGv23hWI9ILw2KjIiXjKesmx14mWBDQATlursZAHIzklstOcOS4bVHnj3FJHUfPGT
         G59+32moZD2TB/oukLPQbpEQeIYwJfzwBj0BwPXbsnOylcD8FnNankvKbZ4A3aZ6ixIF
         JjJg==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi all.

=46irst of all let me thank and congratulate everyone on the nilfs2 pro=
ject.

I believe I found a typo in the nilfs-clean man page. (is an interger
value -> is an integer value)
I cloned the git repo, edited the file and then I did a git diff.
Not sure if this is the proper way to post a "patch" but here's my firs=
t try.

diff --git a/man/nilfs-clean.8 b/man/nilfs-clean.8
index 758b9e1..04e11c6 100644
--- a/man/nilfs-clean.8
+++ b/man/nilfs-clean.8
@@ -45,7 +45,7 @@ Display help message and exit.
=A0.TP
=A0\fB\-p\fR, \fB\-\-protection-period=3D\fIinterval\fR
=A0Set protection period for a cleaner run.=A0 The \fIinterval\fR param=
eter
-is an interger value and specifies the minimum time that deleted or
+is an integer value and specifies the minimum time that deleted or
=A0overrode data will be preserved in the file system.=A0 Smaller value=
s will
=A0increase free space made by garbage collection.=A0 Optionally, the
=A0\fIinterval\fP parameter may be suffixed by one of the following

--
Best regards,
Tiago Caxias
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
