From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v4 0/9] nilfs2: introduce functionality of creation of sysfs
 groups and attributes
Date: Fri, 30 May 2014 17:16:02 +0400
Message-ID: <1401455762.2537.42.camel@slavad-ubuntu-14.04>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Content-Transfer-Encoding:Mime-Version:Content-Type:Date:Cc:To:From:Subject:Message-ID; bh=NBSpZVejUxRpEvTmiKySIzCI9BKgtByDw7OGwpCleUk=;
	b=kpdkfmkHMLSVdVUC1qrmFPSo4Js/8QtjHvbjUaYsuJmQOe2EOtIqOXSOz7BdhdvK2w+xtTXcUDhrNnmq9EXtC5AcZu4N5clfRTq1d4GTJPste7RDElYGQcVTwPu8Nntw;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org, "Michael L. Semon" <mlsemon35-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hi,

This fourth version of patchset implements creation of
sysfs groups and attributes with the purpose to show
NILFS2 volume details, internal state of the driver and
to manage internal state of NILFS2 driver.

v3->v4
 * Fix issue with volume's UUID output (Ryusuke Konishi)

v2->v3
 * Add sysfs file for every format of timestamp output (Ryusuke Konishi)
 * Exclude global switching of the time format (Ryusuke Konishi)
 * Rename sysfs group from /sys/fs/nilfs into /sys/fs/nilfs2 (Ryusuke Konishi)
 * Add description of sysfs interface in sysfs-fs-nilfs2 (Ryusuke Konishi)

v1->v2
 * Improve human-readable format of timestamp output (Michael L. Semon)
 * Fix issue with nilfs_sysfs_{create/delete}_snapshot_group (Michael L. Semon)

Sysfs is a virtual file system that exports information about devices
and drivers from the kernel device model to user space, and is also used
for configuration. NILFS2 is a complex file system that has segctor thread,
GC thread, checkpoint/snapshot model and so on. Sysfs namespace provides
native and easy way for: (1) getting info and statistics about volume state;
(2) getting info and configuration of internal subsystems (segctor thread);
(3) snapshots management.

Suggested patchset provides basis for managing segctor thread behaviour and
manipulation by snapshots. Currently, it informs only about segctor thread's
internal parameters and about mounted snapshots. But sysfs interface can
provide easy and simple way for deep management of segctor thread and
snapshots.

This patchset provides opportunity to manage interval of periodical update
of superblock (in seconds). Default value is 10 seconds. Now a user can
increase this value by means of nilfs2/<device>/superblock/sb_update_frequency
attribute in the case of necessity.

Also the patchset provides opportunity to get information easily about key
volumes's parameters (free blocks, superblock write count, superblock update
frequency, latest segment info, dirty data blocks count, count of clean
segments, count of dirty segments and so on) in real time manner. Such
information can be used in scripts for subtle management of filesystem.

Implemented functionality creates such groups:
(1) /sys/fs/nilfs2 - root group
(2) /sys/fs/nilfs2/features - group contains attributes that describe NILFS
file system driver features
(3) /sys/fs/nilfs2/<device> - group contains attributes that describe file
system partition's details
(4) /sys/fs/nilfs2/<device>/superblock - group contains attributes that describe
superblock's details
(5) /sys/fs/nilfs2/<device>/segctor - group contains attributes that describe
segctor thread activity details
(6) /sys/fs/nilfs2/<device>/segments - group contains attributes that describe
details about volume's segments
(7) /sys/fs/nilfs2/<device>/checkpoints - group contains attributes that describe
details about volume's checkpoints
(8) /sys/fs/nilfs2/<device>/mounted_snapshots - group contains group for every
mounted snapshot
(9) /sys/fs/nilfs2/<device>/mounted_snapshots/<snapshot> - group contains
details about mounted snapshot

With the best regards,
Vyacheslav Dubeyko.
---
 Documentation/ABI/testing/sysfs-fs-nilfs2 |  269 +++++++
 fs/nilfs2/Makefile                        |    2 +-
 fs/nilfs2/nilfs.h                         |    8 +
 fs/nilfs2/super.c                         |    9 +-
 fs/nilfs2/sysfs.c                         | 1137 +++++++++++++++++++++++++++++
 fs/nilfs2/sysfs.h                         |  176 +++++
 fs/nilfs2/the_nilfs.c                     |   17 +-
 fs/nilfs2/the_nilfs.h                     |   20 +-
 8 files changed, 1634 insertions(+), 4 deletions(-)
-- 
1.7.9.5


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
