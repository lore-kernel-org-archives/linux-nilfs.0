From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v4 00/15] nilfs-utils: fsck: add fsck.nilfs2 utility into
 nilfs-utils package
Date: Mon, 12 Nov 2012 13:34:17 +0400
Message-ID: <1352712857.2555.35.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:To:From:Subject:Message-ID; bh=mVEDOAosTC4xDluEtIFmnJuWONhTc+f4EY2GdeTmC9o=;
	b=adsF6Y4SoTbh6SouGQpSC1CbkM7LyE+vjBj4bELpdN38AFjLRnfikJ/XrFz+JqXa82HwFvxFixBrtmCP4MnE/hIr+xHBe+d0C2k2ugkZgdh36tQ1TmwMvWkyvlMxWSo1;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi,

This patch set adds fsck.nilfs2 utility into nilfs-utils package. Currently, fsck.nilfs2 checks primary and secondary superblocks and segment summary headers of segments' logs.

v3->v4
* Every message is associated with subsystem.
* It was introduced complex error and it was implemented output of complex error number with segment and log numbers.
* Functionality of primary and secondary superblocks comparing was added.
* Preliminary vision of architecture of checking functionality was implemented.
* Functionality of segment summary header checking was implemented.
* Some bugs in superblock checking functionality were fixed.

v2->v3
* It was implemented functionality of NILFS superblock correctness checking.
* Message printing primitives are generalized into single library (libnilfsmessages.la).
* Error definition is associated with definition of error id, error severity and error message.
* It was introduced conception of detected errors database in the form of set of checking flags bitmaps. The checking flags bitmap defines what should be checked (for example, in superblock) and, then, it keeps information about detected corrupted items after check execution.

v1->v2
* Coding style was reworked (checkpatch.pl script).
* libfsck.la library was added (print routines + raw ops with disk).
* nilfs.h - several constants and function declarations was added.
* ismounted.c - check_mount() function is reworked for checking on RO mount.
* sb.c - nilfs_sb_is_valid() function is reworked; nilfs_sb_read_unchecked() was added.
* fsck_message.h, fsck_message.def, fsck_raw_ops.h are moved into include folder.
* fsck_message.c, fsck_raw_ops.c are moved into lib folder.
* Superblocks are read by means of library function nilfs_sb_read_unchecked().
* Superblocks are checked by means of library function nilfs_sb_is_valid().
* fsck_debug() identifies reported function by means of __func__ macro.

With the best regards,
Vyacheslav Dubeyko.
--
 configure.ac                   |    3 +-
 include/Makefile.am            |    3 +-
 include/fsck_nilfs2.h          |  148 +++++
 include/fsck_raw_ops.h         |   55 ++
 include/nilfs.h                |   55 ++
 include/nilfs2_fs.h            |    5 +
 include/nilfs_messages.def     |  180 +++++
 include/nilfs_messages.h       |  248 +++++++
 lib/Makefile.am                |   18 +-
 lib/fsck_raw_ops.c             |  467 +++++++++++++
 lib/ismounted.c                |   15 +-
 lib/nilfs_messages.c           |  474 +++++++++++++
 lib/sb.c                       | 1429 +++++++++++++++++++++++++++++++++++++++-
 lib/segment.c                  |  509 ++++++++++++++
 sbin/Makefile.am               |    2 +-
 sbin/fsck/ChangeLog.fsck       |   44 ++
 sbin/fsck/Makefile.am          |   18 +
 sbin/fsck/fsck_common.h        |  119 ++++
 sbin/fsck/fsck_nilfs2.c        |  734 +++++++++++++++++++++
 sbin/fsck/nilfs_checkpoint.c   |  154 +++++
 sbin/fsck/nilfs_checkpoint.h   |   50 ++
 sbin/fsck/nilfs_fs_hierarchy.c |   73 ++
 sbin/fsck/nilfs_fs_hierarchy.h |   38 ++
 sbin/fsck/nilfs_segment.c      |  934 ++++++++++++++++++++++++++
 sbin/fsck/nilfs_segment.h      |   55 ++
 sbin/fsck/nilfs_superblock.c   |  851 ++++++++++++++++++++++++
 sbin/fsck/nilfs_superblock.h   |   44 ++
 sbin/fsck/nilfs_volume_check.c |   71 ++
 sbin/fsck/nilfs_volume_check.h |   45 ++
 sbin/mkfs/mkfs.c               |    1 -
 30 files changed, 6824 insertions(+), 18 deletions(-)


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
