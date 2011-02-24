From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: FIBMAP ioctl missing
Date: Thu, 24 Feb 2011 23:34:37 +0100
Message-ID: <201102242334.38044.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:user-agent:mime-version
         :content-type:content-transfer-encoding:message-id;
        bh=jBcFP1mzYBq66XWqds1SU0xMcAUo9Z1LRssyyMn0oD4=;
        b=YuOWuSNVIPfM6vwbonxaFxEmz2nPaMCd8O0rLyzKQIVtwDfH6xNmWKarxLS5i688GA
         cum2BsadpA64vkqE6WQVHQUz1Ae3tWiII+jTou47/A8iKmYJQaSsx7V2jKBj4bWwCZ2e
         NuYMDAQ6yuyqZ5/Kn049cx19VNHQCXnNOE1KA=
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

as NILFS2 doesn't implement the FIBMAP ioctl, LILO cannot be used on it=
=2E
I've just learned about it the hard way -- after migrating computer's o=
nly=20
filesystem to NILFS2, running LILO returns:
ioctl FIBMAP: Invalid argument

I see the FS_IOC_FIEMAP is implemented; perhaps some wrapper around cou=
ld be=20
used to provide FIBMAP as well?


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
