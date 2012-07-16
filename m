From: Ivan Shmakov <oneingray-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: NILFS for a "chroot": a kind of a work-around
Date: Mon, 16 Jul 2012 12:13:24 +0700
Message-ID: <86mx30waob.fsf@gray.siamics.net>
References: <86zk72xq2g.fsf@gray.siamics.net>
	<7292C0D8-99A6-4A9E-A1B6-976138550FFA@dubeyko.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

>>>>> Vyacheslav Dubeyko writes:

 > As I know, checkpointing is a fundamental technique of the NILFS.  I=
t
 > is possible to imagine checkpointing as an act of final placing of
 > file system blocks on disk storage.  Another filesystems also writin=
g
 > on disk but, usually, without possibility to keep history of file
 > system operations and manage by history.  Checkpoint in NILFS is
 > natural possibility to prevent from file system inconsistency and
 > failure by means of Copy-On-Write policy.  Of course, checkpoints
 > keep duplicates of metadata and data information but obsolete
 > checkpoints can be deleted by nilfs_cleanerd.  So, from my point of
 > view, your approach is trying to overcome the main goal of the NILFS=
=2E

	Not at all.  The idea is to utilize NILFS snapshots to record
	consistent states of the chroot environment.  So, e. g., having
	found that certain software package did break, I can bisect the
	filesystem history to find the version of the package which have
	introduced the bug.

	Using rsync(1) makes this easier, as there's both much less work
	to the GC, and it takes less time to perform the changes, so
	there are only a few checkpoints to check.

 > What about reliability in your approach?  Everything can occur durin=
g
 > operations under tmpfs partition (for example, sudden power off).

	Then, the latest operation (# apt-get install something) won't
	be effective and will have to be repeated.  But the target
	chroot environment will still be in a consistent state.

[=E2=80=A6]

--=20
=46SF associate member #7257	http://sf-day.org/

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
