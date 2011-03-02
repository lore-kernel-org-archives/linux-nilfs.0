From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: nilfs_cleanerd not started for mount with relative pathname
Date: Wed, 2 Mar 2011 18:12:31 +0100
Message-ID: <201103021812.31515.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:user-agent:x-face
         :mime-version:content-type:content-transfer-encoding:message-id;
        bh=Jqu7MpSTD1Z8zMK1SHcbAutHqvkzTxWTgtoqrrLn6EY=;
        b=f76JOKLE8l2OMyGO9Gi08fNTzjmgpoU7z020XGse/D3jobNoTWJks3Fs6MRrKVv27K
         kxzIE0ur2VbLU8xrJCIoErlfAmKaXEG5fl0fwuHISjcJVV0WYoG6iZmfSHwlVzAWJgMf
         5vlvjzxHsywdq3Q77fq5A+d7hRKsAYstwcprk=
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,


when testing my other patches, the following came up:

with absolute pathname:
# mount /dev/sdb2 /mnt/x
# ps ax | grep [n]ilfs_cleanerd
30408 ?        Ss     0:00 /sbin/nilfs_cleanerd -n /dev/sdb2 /mnt/x


with relative mountpoint pathname:
# umount /mnt/x
# cd /mnt
# mount /dev/sdb2 x
# ps ax | grep [n]ilfs_cleanerd
((no such process))

with relative device pathname:
# umount /mnt/x
# cd /dev
# mount sdb2 /mnt/x
# ps ax | grep [n]ilfs_cleanerd
((no such process))

This is due to chdir(ROOTDIR) in daemonize(); currently daemonize is al=
ways=20
called with nochdir =3D=3D 0. Should I hardcode it to nochdir =3D=3D 1 =
or canonicalize=20
the `dev' and `dir' arguments with myrealpath()?

--=20
dexen deVries

[[[=E2=86=93][=E2=86=92]]]

47. As Will Rogers would have said, "There is no such thing as a free=20
variable."

(Alan Perlis, `Epigrams on Programming')
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
