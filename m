From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: nilfs_cleanerd won't start for root filesystem
Date: Wed, 01 Aug 2012 11:32:58 +0200
Message-ID: <1544142.eijMQvyoNB@coil>
References: <3290425.VTORBmyZ72@coil> <20120801090028.GT1478@wloczykij>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-face:user-agent:in-reply-to
         :references:mime-version:content-transfer-encoding:content-type;
        bh=L8rETIbC9gZZcP3Koav1mSDJETyJUSGLbVTPhSW0VZI=;
        b=S7Z8ZpklY+pce/Tyx5SP23ko0T4UNe6Caib+UEWaiDWDgWuSh3N8MJetzm5losbYfj
         hS1t0m6/d7k54nkvzTOlvCqXPn5CDq/a0oMeYlIl1+0nKTHRXVbg13wCg1xfd9lLG3QM
         x3AwS3SmTa0izCTfkOrSRPpzIyk8ADIAPDV+t3slo2K6L46Z4OIiX76DO8HEuId7CqUI
         EpMa5FBandvEP/N8oZQAsHlROU9z3KbfDA+vS6w4iC6ynd217lnzQkQfiyQpqL+xGBcn
         5WSPrmOiFq9WTwNP8sQt35PG6zijb/uS3KfSn3y/xb4zNeMxoM77lldmLDRSNQ1TkEz9
         EzWw==
In-Reply-To: <20120801090028.GT1478@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>

Hi Piotr,


On Wednesday 01 of August 2012 11:00:28 you wrote:
> Got similar issue [1] few days ago.
>=20
> [1] http://www.mail-archive.com/linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg01186.=
html

quick recap, have you gotten any solution better than creating /dev/roo=
t=20
symlink by hand? ;-)


btw., greetings from poland ;-)


cheers,
--=20
dexen deVries

[[[=E2=86=93][=E2=86=92]]]

"all dichotomies are either true or false" is a true paradox because it=
's=20
paradoxical only if it is a paradox ;)
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
