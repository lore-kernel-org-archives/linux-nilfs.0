From: Ivan Shmakov <oneingray-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: user-level toolkit for off-line operations
Date: Sun, 17 Jun 2012 22:44:04 +0700
Message-ID: <86r4terliz.fsf_-_@gray.siamics.net>
References: <86fw9zw601.fsf@gray.siamics.net>
	<20120614.110607.87804359.konishi.ryusuke@lab.ntt.co.jp>
	<86lijqv7ye.fsf@gray.siamics.net>
	<20120616.101523.24077441.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

>>>>> Ryusuke Konishi writes:
>>>>> On Thu, 14 Jun 2012 11:22:17 +0700, Ivan Shmakov wrote:
>>>>> Ryusuke Konishi writes:

[=E2=80=A6]

 >>> Implementing Off-line resizing is a bit tough task because it
 >>> requires a user space library to read internal meta data of the
 >>> nilfs file system and append updated blocks to it.

	=E2=80=A6 I guess that a user-level toolkit akin to e2fsprogs would be
	handy anyway.  (Shouldn't there be an fsck(8) for NILFS, BTW?)

	Other than resizing, there could be a feature to =E2=80=9Csplit=E2=80=9D=
 a
	filesystem =E2=80=94 take one or more =E2=80=9Csnapshot=E2=80=9D check=
points and make a
	copy of the parts of the filesystem =E2=80=9Creachable=E2=80=9D from t=
hese
	checkpoints on a distinct block device (perhaps of a differing
	size), which seems like one more way to do backups.

 >>> This is almost equivalent to implementing kernel functions of nilf=
s
 >>> in user land.

[=E2=80=A6]

 >> I wonder, how complicated this task would be?  In particular, do I
 >> need to alter all the segments to resize filesystem, or only
 >> specific ones?  Also, are these internal metadata records just =E2=80=
=9Ca
 >> bunch of C structs=E2=80=9D, or something more complex?

 > This needs at least the following tasks:

 > 1) Update two super blocks to increase/decrease the number of total
 > segments and the device size. (easy)

 > 2) Update segment usage information to adjust free segment count of
 > nilfs_sufile_header struct (sh_ncleansegs) which is written in
 > the segment usage file. (Sadly not easy)

 > 3) If truncating in-use segments, relocating blocks and updating dis=
k
 > address translation information are also needed. (very hard)

	ACK.  (Fortunately, I'm not that interested in shrinking
	filesystems right now.)

 > For reference, a discussion on this topic is found in the archives o=
f
 > the list:

 > http://marc.info/?t=3D128419843600003&r=3D1&w=3D2

	ACK, thanks!  I hope to take a closer look at this problem
	within two weeks or so.

	(JFTR: those reading via Gmane may access the thread via either
	of [1, 2]; the first message in the thread is [3].)

[1] http://comments.gmane.org/gmane.comp.file-systems.nilfs.user/397
[2] http://thread.gmane.org/gmane.comp.file-systems.nilfs.user/397/focu=
s=3D1686
[3] news:BAEFA5609CC3AB4BAE1625CAD4C27E5C02986E1D-qPLjlnsG5hmCmmEZ8mJCX7uPtZ6Ynr+y@public.gmane.org=
a.com

--=20
=46SF associate member #7257

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
