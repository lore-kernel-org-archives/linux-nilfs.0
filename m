From: Michele Marcon <M.Marcon-wB/b/6WKJkjDzftRWevZcw@public.gmane.org>
Subject: Bug with future timestamp
Date: Tue, 14 Jun 2016 14:54:26 +0000
Message-ID: <AM4PR07MB1443A58B1332FBF20D3ED835A0540@AM4PR07MB1443.eurprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=rielloups.onmicrosoft.com; s=selector1-rielloups-com01e;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=yE5xWinqmTRwxARkEOh7JHka2OZWzJFZtNOzNrCKEFw=;
 b=SV04AHS50S7mHqBnqPEUwu1hgJ48zYXErg6TrI/h8p5RWAW8bu//ypbU29Cs9jAFJ0cCtSBnXeHEJzNvB2PqBo05sRbmTx2vIfOtryodr3eu1jvkJRVKRYIsLkPrZ2c6Wsn4eGtAhauj3NFK/QSYgf+UccFXGI0Kze/dvDbPo3Q=
Content-Language: it-IT
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi,
I'm using nilfs on ARM I have found a problem when these conditions are=
 met:

- set protection period to 60 seconds
- set current time on the future (example: year 2020)
- write something on flash, so that some checkpoints are created
- set current time to the present
- perform writes on flash.

When the garbage collector starts, it will notice that the checkpoint "=
from the future" is protected and will not remove it.
The problem is that it will not remove subsequent checkpoints (but with=
 timestamp that shouldn't be protected), and therefore there won't be a=
ny garbage collection until 2020.

The only workaround is to manually remove the "future" checkpoints with=
 rmcp.

Is this a known issue? Thanks!



Michele Marcon

Centro Ricerche
RPS SpA
Viale Europa, 7
37045=A0Legnago=A0VR
Tel. +39 0442 635939=A0Fax. +39 0442 635934
Skype Id: =A0- Voip:=20
E-mail: M.Marcon-wB/b/6WKJkjDzftRWevZcw@public.gmane.org
Web: www.riello-ups.com
-----------------------------------------------------------------------=
---
Per favore non stampare questo messaggio se proprio non =E8=20
necessario=20
Please consider the environment before printing this e-mail
-----------------------------------------------------------------------=
---




--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
