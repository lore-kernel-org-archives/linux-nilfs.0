From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: One checkpoint doesn't get GC'd
Date: Thu, 17 Nov 2011 13:05:47 +0100
Message-ID: <201111171305.49635.dexen.devries@gmail.com>
References: <201111141351.50798.dexen.devries@gmail.com> <20111116.011102.126207784.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:references:in-reply-to:x-face
         :mime-version:content-type:content-transfer-encoding:message-id;
        bh=hxe5HalyvOjgpv2l1DT7FOCX1tcSP22LXcjb6nxjS9Q=;
        b=NX8fcUvSMrIVBC50QQ3ctY9yobxYosavnqgg4hKpfQtxhNZSoaco+S1+ROMF4xOFuy
         ZkroFMTVpUEoLRyd62YFrv4kmRwnLVGLgOIMzP3+rqUycS+5U7ElSKrbHFv+guIYK9jP
         9MJiOqlyRkL9Lx+gX95DifBBgK5T9FF/VTR2Y=
In-Reply-To: <20111116.011102.126207784.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Ryusuke,


On Tuesday 15 of November 2011 17:11:02 you wrote:
> This may happen since garbage collection of nilfs is done for each
> disk segment instead of checkpoint.
>=20
> If GC did not reclaim any blocks for a checkpoint, the checkpoint wil=
l
> survive transiently.

Thanks for clarification. I've always assumed that GC just removes chec=
kpoints=20
in natural order; good to see it's smarter than that ;-)

The CP got GC'd recently alright.


Cheers,
--=20
dexen deVries

[[[=E2=86=93][=E2=86=92]]]

``As my friend Jacob Gabrielson once put it, advocating Object-Oriented=
=20
Programming is like advocating Pants-Oriented Clothing.''
 -- Steve Yegge, in
http://steve-yegge.blogspot.com/2006/03/execution-in-kingdom-of-nouns.h=
tml
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
