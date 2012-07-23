From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: read error on superblock
Date: Mon, 23 Jul 2012 10:45:10 +0200
Message-ID: <19753282.RhzHOQAfKG@coil>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:subject:date:message-id:x-face:user-agent:mime-version
         :content-transfer-encoding:content-type;
        bh=yW0BFdjsk/d/IpgymlqZJN8Op8h3KJ/cHmSuwHFvRCM=;
        b=lcGjyiG3s431EtyHdQoE/EDyuqvglxACuv36CWjnk1PBMG13h6L/mzCJ3URdCqb9b/
         5tCwc2PlTGZfLMnBGch4a1mbWoeNJdo5lNKoPkk6b9JlWZf3f2dyaZsZZfQ9htjsY53k
         onRNEM2DIwP9ea2LTbSUnehFnBy8gOMpVhN8ZElprKSzNmqgaMXG9gFPCiEDQ1WCG5O+
         FqozXQDIiuGUllLA0gsO46GwTQ/tiZTPi2RVFhPu8eoQWH4JxUCKO97ILNrmyGGD6PUN
         iHwlf3lUOw3mjlfFYBtXVUvRfej5p7wFEcmElpfO0lTNO+ip5SLFF4m2agGCi1xuzLag
         F6OQ==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi list,


a harddrive got some bad sectors and now one NILFS filesystem can't be =
mounted;

mount: /dev/sda3: can't read superblock

I can (try to) copy this filesystem to another drive; how do I proceed =
form=20
that point? Does it make any sense to substitute another superblock for=
 this=20
one? (either to use a spare superblock, if such exists, or put a new=20
superblock on the damaged sector(s)).


Regards,
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
