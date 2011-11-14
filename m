From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: One checkpoint doesn't get GC'd
Date: Mon, 14 Nov 2011 13:51:50 +0100
Message-ID: <201111141351.50798.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:x-face:mime-version:content-type
         :content-transfer-encoding:message-id;
        bh=bQodalBJBbBm4b2du33cg5AhmO/AB+padaP0GiGOV3o=;
        b=cLdyvukgdbEOBrHYEP0veYwQMUVB5/RiR+Dpxvwxo/+By2R/v5y/1u3i6VwK18QfAT
         hD5WDaroiU3vBmVFoU2LhXvEJyjp659rvhxv+GOplnuEUneI4BOcJgo+yzPd0G1b5oNe
         1i8fcF3knL2hopv6dJbuoL81Jd9mmUjsxm7ic=
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,


I have strange problem: one checkpoint doesn't get garbage-collected, i=
n spite=20
of subsequent checkpoints getting GC'd just alright.

for example:
1170140  2011-10-14 09:34:17   cp    -           50     379222
1171655  2011-10-14 14:43:14   cp    -         1345     379479
1171663  2011-10-14 14:45:06   cp    -           54     379480
1171664  2011-10-14 14:45:17   cp    -           51     379479
(...)

A few hours ago there were much more checkpoints between 1170140 and 11=
71655=20
and they all got GC'd as expected -- but not the 1170140 itself.

=46or reference,
kernel: 3.1.0 (stock)
nilfs-utils: 2.1.0-rc1


Cheers,
--=20
dexen deVries

[[[=E2=86=93][=E2=86=92]]]

``As my friend Jacob Gabrielson once put it, advocating Object-Oriented=
=20
Programming is like advocating Pants-Oriented Clothing.''
 -- Steve Yegge, in http://steve-yegge.blogspot.com/2006/03/execution-i=
n-
kingdom-of-nouns.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
