From: Michele Marcon <M.Marcon-wB/b/6WKJkjDzftRWevZcw@public.gmane.org>
Subject: Bug with future timestamp
Date: Fri, 17 Jun 2016 07:28:47 +0000
Message-ID: <AM4PR07MB144378F2ABD60581AED209D6A0570@AM4PR07MB1443.eurprd07.prod.outlook.com>
References: <AM4PR07MB1443A58B1332FBF20D3ED835A0540@AM4PR07MB1443.eurprd07.prod.outlook.com>
 <20160616.000318.1116808914986780353.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=rielloups.onmicrosoft.com; s=selector1-rielloups-com01e;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=xVZQ1CxG2AJ24JPKS95cPAIU1BnpEGuMKOz7Vag0eew=;
 b=bDOpYsA/BwU1DrASx2ogLxw2xLryyyoDzGzz+OPEICyTBZhWyCsDzRKQZldodiEE6GH3ySFM2cUswefWKzPlsO9wnG+7XtTOm77GqDdmL24ZjtPRd0I6ex9fLdmmApr6UjKqfZHBRzYdHNopGZ5lI/9CqbI+9E+CkAZAOxhi820=
Content-Language: it-IT
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>


Yes, the state continues until the system become unusable.
No, these fragments aren't active.

This is the log of the commands issued and the results:

http://pastebin.com/jf6C5SST

Thanks.

-----Messaggio originale-----
Da: Ryusuke Konishi [mailto:konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org] Per conto di Ryu=
suke Konishi
Inviato: mercoled=EC 15 giugno 2016 17:03
A: Michele Marcon <M.Marcon-wB/b/6WKJkjDzftRWevZcw@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Oggetto: Re: Bug with future timestamp

Hi,
On Tue, 14 Jun 2016 14:54:26 +0000, Michele Marcon wrote:
> Hi,
> I'm using nilfs on ARM I have found a problem when these conditions a=
re met:
>=20
> - set protection period to 60 seconds
> - set current time on the future (example: year 2020)
> - write something on flash, so that some checkpoints are created
> - set current time to the present
> - perform writes on flash.
>=20
> When the garbage collector starts, it will notice that the checkpoint=
=20
> "from the future" is protected and will not remove it.
> The problem is that it will not remove subsequent checkpoints (but=20
> with timestamp that shouldn't be protected), and therefore there won'=
t=20
> be any garbage collection until 2020.

Does this state really continue even if you continue writing after the =
rewind ?

Checkpoint is protected not only by the protection period but also by a=
 few other conditions, for instance, recent segments are "active" and p=
rotected from GC.  (the data and checkpoints in the active segments may=
 be protected regardless of their timestamps).  You can confirm if the =
segment is active or not through the 'a' flag of lssu command.
 =20
If every block which belongs to a checkpoint is protected by GC, then t=
he checkpoint will not be discarded even if it has a timestamp that can=
 be removed.

>=20
> The only workaround is to manually remove the "future" checkpoints=20
> with rmcp.
>=20

rmcp in reality doesn't help to reclaim blocks.  It only invalidates ch=
eckpoints and makes them unaccessible.

Regards,
Ryusuke Konishi


> Is this a known issue? Thanks!
>=20
>=20
>=20
> Michele Marcon
>=20
> Centro Ricerche
> RPS SpA
> Viale Europa, 7
> 37045=A0Legnago=A0VR
> Tel. +39 0442 635939=A0Fax. +39 0442 635934 Skype Id: =A0- Voip:
> E-mail: M.Marcon-wB/b/6WKJkjDzftRWevZcw@public.gmane.org
> Web:=20
> https://emea01.safelinks.protection.outlook.com/?url=3Dwww.riello-ups=
=2Eco
> m&data=3D01%7c01%7cM.Marcon%40riello-ups.com%7c9bd83d76a4a74e5957cc08=
d39
> 52e3523%7cd8fd0d398b2f4760af9e84aadb8587ef%7c0&sdata=3DepS8f0YmqRj5iG=
%2f
> xh27hngehxiqYPYKHpsq5EPFnRxI%3d
> ---------------------------------------------------------------------=
-
> ---- Per favore non stampare questo messaggio se proprio non =E8=20
> necessario Please consider the environment before printing this e-mai=
l
> ---------------------------------------------------------------------=
-
> ----
>=20
>=20
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs=
"=20
> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo=20
> info at=20
> https://emea01.safelinks.protection.outlook.com/?url=3Dhttp%3a%2f%2fv=
ger
> .kernel.org%2fmajordomo-info.html&data=3D01%7c01%7cM.Marcon%40riello-=
ups
> .com%7c9bd83d76a4a74e5957cc08d3952e3523%7cd8fd0d398b2f4760af9e84aadb8=
5
> 87ef%7c0&sdata=3DZPLbeEsIU%2fXq%2bXhA5LyU5jBEUUO31zLeLbIa8kijIK4%3d
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
