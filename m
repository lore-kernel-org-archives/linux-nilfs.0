From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 00/11] nilfs-utils: fsck: add skeleton of fsck.nilfs2
Date: Wed, 5 Sep 2012 23:13:12 +0400
Message-ID: <1AD0E166-35EB-4AB8-917D-AB6C151480FE@dubeyko.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:To:Message-Id:Date:Subject:Content-Transfer-Encoding:Content-Type:From; bh=VA6NbN6SxCiBH6DEvl1t4WEL2E6G06h9rE6pdCgeZr0=;
	b=HogOXkaxzCtq/uSbcLNeObkjpdvVXqafjp86DSHUjyr860SsL0/3yLhdwMEQc4l4i21OU+Mxs7mpo49xdQucE9a9Y9LJI58jJiJ8/qGvA5X3mhjzYUIN+m4nOdizfM1U;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi,

This patch set adds skeleton of fsck.nilfs2 utility into nilfs-utils package. Currently, fsck.nilfs2 only try to check presence of primary and secondary superblocks. It was implemented functionality of NILFS superblock correctness checking, also.

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
 configure.ac     |    3 ++-
 sbin/Makefile.am |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--
 include/nilfs.h     |   17 +++++++++++++++++
 include/nilfs2_fs.h |    5 +++++
 sbin/mkfs/mkfs.c    |    1 -
 3 files changed, 22 insertions(+), 1 deletions(-)

--
 include/Makefile.am |    3 ++-
 lib/Makefile.am     |   16 ++++++++++++++--
 2 files changed, 16 insertions(+), 3 deletions(-)

--
 include/nilfs_messages.def |  132 +++++++++++++++++
 include/nilfs_messages.h   |  126 ++++++++++++++++
 lib/nilfs_messages.c       |  346 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 604 insertions(+), 0 deletions(-)

--
 include/fsck_raw_ops.h |   55 ++++++
 lib/fsck_raw_ops.c     |  478 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 533 insertions(+), 0 deletions(-)

--
 lib/ismounted.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

--
 lib/sb.c | 1428 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 1418 insertions(+), 10 deletions(-)

--
 include/fsck_nilfs2.h |  111 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 111 insertions(+), 0 deletions(-)

--
 sbin/fsck/Makefile.am |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

--
 sbin/fsck/fsck_common.h |   43 +++++
 sbin/fsck/fsck_nilfs2.c |  429 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 472 insertions(+), 0 deletions(-)

--
 sbin/fsck/nilfs_superblock.c |  546 ++++++++++++++++++++++++++++++++++++++++++
 sbin/fsck/nilfs_superblock.h |   41 ++++
 2 files changed, 587 insertions(+), 0 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
