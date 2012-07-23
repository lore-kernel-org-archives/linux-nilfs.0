From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: read error on superblock
Date: Mon, 23 Jul 2012 11:42:37 +0200
Message-ID: <1662915.ExQE7jMHJu@coil>
References: <19753282.RhzHOQAfKG@coil> <1343035048.1974.6.camel@slavad-ubuntu-11> <20120723.183907.154986664.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-face:user-agent:in-reply-to
         :references:mime-version:content-transfer-encoding:content-type;
        bh=f2WwHw4SWR0Z8yoqSZEp3SZZqXo8omOSfBrlDT6L/gQ=;
        b=WBBtgT1Dz9fygECzqb+dvD7sEWr2QFsVFMPMC48C2oyrtHHMEt81r3poTjht6P9XXY
         omMUwVMcf07GHdhbSB3WV+nzIvsH1ugMhPS7dXOa7MYOzMpaIk1IOy5x15rhNVlQF57u
         OLWGJeFQWq8KssXOxEXGrn03GnwO9Ij2r78oS9gWkncPl3bAU9ZFT7A0h2AsgE1zfLS6
         /OeVki3EoZZSfkjbfdOPtWfiSgUyFs/JiyjOROyK/6+5ZpdJLr3Bqh1BoxrVALht6OOk
         jGumSNljP3geY6ymm333UejI7tB5N51bk9aqny0swE0/+4XKiRanvvqEIpoRC8E6sPiu
         r0TQ==
In-Reply-To: <20120723.183907.154986664.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Hi Ryusuke,


On Monday 23 of July 2012 18:39:07 you wrote:
>=20
> # mount -t nilfs2 <device> <mount-point>

that's what I've tried.

I guess the problem is, the harddrive have not re-allocated the sector =
as of=20
yet, so it is /unreadable/ rather than merely containing wrong data.


I'll see later on a while if the drive can re-allocate the sector.

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
