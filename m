From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] lscp: support opening mounted filesystem by directory pathname
Date: Wed, 2 Mar 2011 11:13:32 +0100
Message-ID: <201103021113.32637.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:user-agent:x-face
         :mime-version:content-type:content-transfer-encoding:message-id;
        bh=SsBeGk5VHaFjo6Tbr2MTkSw8CA0dsrYN08Y6+0n6fJY=;
        b=UXKUWulhKBTbAGV3KUDEy3lyXIS45VG+klS0GjlzJ7ieMNvbjqqOADqd1DOnvi0FRY
         6uQqzVtUIM0kEPyBjof0n8dfICghcMs/8NHic08fVfSVL/YVItXpCACvfDtqvnsKZ2G5
         g7Zf79FgA//zvhOnORGU7v0X9bWT4PUEzMf1w=
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The patch I've submited may be a wrong solution; perhaps instead the al=
gorithm=20
of nilfs_find_fs() (around lib/nilfs.c:179,211) should be improved.

Regards,
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
