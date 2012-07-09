From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: nilfs2 weird issue - snapshots are gone, cleanerd not running
Date: Mon, 09 Jul 2012 11:33:13 +0200
Message-ID: <10181027.pPHs7IDARt@coil>
References: <20120709073300.GP1478@wloczykij>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-face:user-agent:in-reply-to
         :references:mime-version:content-transfer-encoding:content-type;
        bh=cGnn/KMgg8tTjbsct/sIsyNPXr6vjJ12KvYG/fxWp6g=;
        b=FELAE2VSAgada8YmUC7FxT9V2W9/57LlItoUMF64q3uTEIAK9XlnkN05yAkbNzeA1p
         UgkHqJMpDfhKxgiwkywOqSpSmucYHY9sWcup3S94gRlHx9h/MXfKOK6BD7ZVkEMCUp1S
         I5sgSMBpkKMaJV/3x+rPhH37wKKtYNPlodmblqG29W2JK9txCxzvHs4xwdZsBxjuEUZ6
         3DUshJMLYnVutJG1P8Ej0aEQOa0BkBy5Pu3ePfSjWpLM12x5qqdr0DxQK5r/6kTWqohN
         LOUt1XsmIcgu1wdGPuSuV/3vmQ1UbUGo50uVswCMimFdvC4Ihp1Xa5sb/4mgDA8nu5Uy
         peFQ==
In-Reply-To: <20120709073300.GP1478@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>

On Monday 09 of July 2012 09:33:00 you wrote:
>(...)
> Where to go from this point? How to debug nilfs_cleanerd issue?

using strace -f  on the nilfs_cleanerd should give you a clue what caus=
es the=20
exit. it may exit if can't connect to syslogd.


if `lscp' reports no checkpoints, try `lscp -a' -- should show even min=
or=20
checkpoints (which are checkpoints created by GC, AFAIK).

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
