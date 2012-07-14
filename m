From: Ivan Shmakov <oneingray-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: NILFS for a "chroot": a kind of a work-around
Date: Sat, 14 Jul 2012 23:31:03 +0700
Message-ID: <86zk72xq2g.fsf@gray.siamics.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

	It was mentioned recently [1] that NILFS doesn=E2=80=99t handle freque=
nt
	file =E2=80=9Ccreation-removal=E2=80=9D cycles well, and these are typ=
ical to,
	in particular, # apt-get install (upgrade) operation.

	I=E2=80=99m currently using NILFS for =E2=80=9Croot=E2=80=9D filesyste=
ms of a couple of
	chrooted environments I use to test new software, which implies
	that Debian packages are installed and upgraded quite often.

	As a work-around, I=E2=80=99ve made a copy of the filesystem on tmpfs,
	and run # apt-get from there, like:

# chroot /tmp/debian.UvYusUaj apt-get upgrade=20

	Then, I propagate the changes back to the original NILFS root
	with rsync(1), like:

# rsync -x -a -v -rlOtH \
      -b --suffix=3D.~$(date +%s)~ --backup-dir=3D.rsync-backup \
      --exclude=3D/.rsync-backup/ --exclude=3D/.nilfs \
      --delete \
      -- /tmp/debian.UvYusUaj/ /srv/chroot/2012-07-06-unsafe/=20

	This obviously results in much less checkpoints, too, and thus,
	AIUI, less overall stress to the filesystem.

	(Sometimes, I=E2=80=99d also chcp(8) the latest of the newly-made
	checpoints into a snapshot.)

[1] http://permalink.gmane.org/gmane.comp.file-systems.nilfs.user/2397

--=20
=46SF associate member #7257	http://sf-day.org/

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
