From: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Subject: [PATCH v2 0/7] nilfs-utils: fsck: add skeleton of fsck.nilfs2
Date: Fri, 03 Aug 2012 07:48:37 -0600
Message-ID: <63a8dcda0cfb6b582fd520b3e977b2a7@dubeyko.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Message-ID:Subject:Cc:To:From:Date:Content-Transfer-Encoding:Content-Type:MIME-Version; bh=em8MJYjjoFchXHrEobhW0JocrnxACkrNyvuQ8gjl/OI=;
	b=Oj8F7BC4zyLe8IvDNmzXCnBQ1ThhwPScORX8Uy88UqYO9SoygaGhxef1oQtqUYPsUwZR4dFSFiU/4bWIfOnGUTQrV11V/Cf9xjnUC/6dr94G7HqKuhGHi7rNzky3i+Ci;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

Hi,

This patch set adds skeleton of fsck.nilfs2 utility into nilfs-utils 
package. Currently, fsck.nilfs2 only try to check presence of primary 
and secondary superblocks. It checks magic signature and CRC checksum in 
superblock.

v1->v2
* Coding style was reworked (checkpatch.pl script).
* libfsck.la library was added (print routines + raw ops with disk).
* nilfs.h - several constants and function declarations was added.
* ismounted.c - check_mount() function is reworked for checking on RO 
mount.
* sb.c - nilfs_sb_is_valid() function is reworked; 
nilfs_sb_read_unchecked() was added.
* fsck_message.h, fsck_message.def, fsck_raw_ops.h are moved into 
include folder.
* fsck_message.c, fsck_raw_ops.c are moved into lib folder.
* Superblocks are read by means of library function 
nilfs_sb_read_unchecked().
* Superblocks are checked by means of library function 
nilfs_sb_is_valid().
* fsck_debug() identifies reported function by means of __func__ macro.

With the best regards,
Vyacheslav Dubeyko.
--
  configure.ac        |    3 +-
  include/Makefile.am |    2 +-
  include/nilfs.h     |   15 ++++
  lib/Makefile.am     |    8 ++-
  lib/ismounted.c     |   15 ++++-
  lib/sb.c            |  197 
++++++++++++++++++++++++++++++++++++++++++++++++---
  sbin/Makefile.am    |    2 +-
  7 files changed, 226 insertions(+), 16 deletions(-)

  include/fsck_messages.def    |   80 +++++++
  include/fsck_messages.h      |  126 ++++++++++
  include/fsck_raw_ops.h       |   55 +++++
  lib/fsck_messages.c          |  274 ++++++++++++++++++++++
  lib/fsck_raw_ops.c           |  473 
+++++++++++++++++++++++++++++++++++++
  sbin/fsck/Makefile.am        |   11 +
  sbin/fsck/fsck_nilfs2.c      |  385 ++++++++++++++++++++++++++++++
  sbin/fsck/fsck_nilfs2.h      |   34 +++
  sbin/fsck/nilfs_superblock.c |  526 
++++++++++++++++++++++++++++++++++++++++++
  sbin/fsck/nilfs_superblock.h |   48 ++++
  10 files changed, 2012 insertions(+), 0 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
