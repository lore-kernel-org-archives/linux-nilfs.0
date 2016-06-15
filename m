From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Bug with future timestamp
Date: Thu, 16 Jun 2016 00:03:18 +0900 (JST)
Message-ID: <20160616.000318.1116808914986780353.konishi.ryusuke@lab.ntt.co.jp>
References: <AM4PR07MB1443A58B1332FBF20D3ED835A0540@AM4PR07MB1443.eurprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YjUx6cgrpPTRGrwy64SxHe70c/jV9oBFp/ol0tntSgA=;
        b=wp5QkOKTWdtx4Lrhzh8avY6poUS1QIcP1ohsanK4DQq2TmXGKz0mzNQpWS2b5jzNds
         I7RoJbeYlWr9GIFum3SRxxtiOunN39XYk81tPc0hTrBVzt+vdOpv+rA7VLaXuquXOjZP
         5TpruIS6O0KzjTzPSlfhTXGy84nfohoy6bMncmqhjnSfpYpkRYwyZk5tZBKwMDsJrNOz
         WHsklQdB3dhSZ0qQ60UZ2hadLsnmWceOsxBl+3IiH/y8OTgB9hs70hsWqxqHOUxGzpaV
         NwDY+z+bXYtUuBlaoSY9ShJWLwKWf6ID58Q9Y0CkHG33WJOV5uhGeULhsnDGQoOjqhxB
         lnjA==
In-Reply-To: <AM4PR07MB1443A58B1332FBF20D3ED835A0540-OW1adBbnE/AmxLT4/akQWjzdlHkvsOLVvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-8859-1"
To: Michele Marcon <M.Marcon-wB/b/6WKJkjDzftRWevZcw@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

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
> When the garbage collector starts, it will notice that the
> checkpoint "from the future" is protected and will not remove it.
> The problem is that it will not remove subsequent checkpoints (but
> with timestamp that shouldn't be protected), and therefore there
> won't be any garbage collection until 2020.

Does this state really continue even if you continue writing after the
rewind ?

Checkpoint is protected not only by the protection period but also by
a few other conditions, for instance, recent segments are "active" and
protected from GC.  (the data and checkpoints in the active segments
may be protected regardless of their timestamps).  You can confirm if
the segment is active or not through the 'a' flag of lssu command.
 =20
If every block which belongs to a checkpoint is protected by GC,
then the checkpoint will not be discarded even if it has a timestamp
that can be removed.

>=20
> The only workaround is to manually remove the "future" checkpoints
> with rmcp.
>=20

rmcp in reality doesn't help to reclaim blocks.  It only invalidates
checkpoints and makes them unaccessible.

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
> Tel. +39 0442 635939=A0Fax. +39 0442 635934
> Skype Id: =A0- Voip:=20
> E-mail: M.Marcon-wB/b/6WKJkjDzftRWevZcw@public.gmane.org
> Web: www.riello-ups.com
> ---------------------------------------------------------------------=
-----
> Per favore non stampare questo messaggio se proprio non =E8=20
> necessario=20
> Please consider the environment before printing this e-mail
> ---------------------------------------------------------------------=
-----
>=20
>=20
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs=
" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
