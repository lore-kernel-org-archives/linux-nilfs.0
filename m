From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: an irritating problem and possible source of quiet data loss
Date: Wed, 17 Aug 2011 12:07:21 +0000
Message-ID: <201108171207.22032.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:x-face:mime-version:content-type
         :content-transfer-encoding:message-id;
        bh=uESkaCBnpXgXW4Seqv2+op7VN+kUjWcLO5korZXw9iU=;
        b=TrjgOCkW4w7WvJCEiOSsHjTYNxxxn+gYsY2MokR4WVfdYBagfbzH6jTV5xz6hHvnaZ
         Lj4FnPdAVMe9MwwNzN/kA1fK1IISUXxMVq01FY5Gz5q/mCSB4btI9x18Xfq6i2pZqFVH
         YbZTXgQ1GZWpE0JC53URdvqSo1aUnjOJNhYow=
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

theres' that irritating problem that two files on the same device and w=
ith same=20
pathname -- but different content -- can have same inode number on NILF=
S2. It=20
really can screw automated and manual backup/restore. Best of all, it s=
eems to=20
be against POSIX. Actually, two `versions' of the same file.

Today I wanted to revert a config file to certain older version:

(/dev/sda3 is the current root filesystem)

# chcp ss /dev/sda3 7591068
# mount /dev/sda3 /mnt/x -o ro,cp=3D7591068
# diff -burN /etc/adjtime  /mnt/x/etc/adjtime | diffstat
 adjtime |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

so far so good. However!

# cp etc/adjtime /etc
cp: `etc/adjtime' and `/etc/adjtime' are the same file

and it did /not/ copy the original version over the new file.


The thing is, till recently the `diff' would also (errorously!) not rep=
ort=20
difference between those two files, because it relied on comparing devi=
ce and=20
inode numbers. If those matched, the files must be the same file. Just =
like=20
pointer equality in C programming language: if two objects are located =
at the=20
same address (pointer equality), they are the same object.

MVFS (a ClearCase thingie) and NILFS2 break that; diff now contains spe=
cial=20
workaround because of MVFS. But some other utilities do not.

=46rom diff's sources:
> POSIX says that two files are identical if st_ino and st_dev are
> the same, but many file systems incorrectly assign the same (device,
> inode) pair to two distinct files, including:
>=20
> ((short list: Linux NFS, Network Appliance NFS, MVFS))=20

Please consider fixing that: either report different inode numbers on m=
ounted=20
snapshots, or use different device numbers for mounted snapshots. The l=
ater=20
could make more sense -- a snapshot of filesystem is a much different e=
ntity=20
than the current state -- and also could be way easier to implement in =
kernel=20
without changing filesystem format.

Before any fix is ready, a manual workaround is possible, by using loop=
 device:

coil!root!/mnt # losetup -f -v /dev/sda3
Loop device is /dev/loop0
coil!root!/mnt # mount /dev/loop0 /mnt/x -o cp=3D7591068,ro
(now /dev/loop0 mounted at /mnt/x has different device ID than the root=
=20
filesystem at /dev/sda3)
coil!root!~ # cp /mnt/x/etc/adjtime /etc/adjtime=20

(worked!)


Regards,
--=20
dexen deVries

[[[=E2=86=93][=E2=86=92]]]

=46or example, if the first thing in the file is:
   <?kzy irefvba=3D"1.0" rapbqvat=3D"ebg13"?>
an XML parser will recognize that the document is stored in the traditi=
onal=20
ROT13 encoding.

(( Joe English, http://www.flightlab.com/~joe/sgml/faq-not.txt ))
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
