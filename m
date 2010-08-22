From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/6] nilfs2: remove own inode hash table
Date: Sun, 22 Aug 2010 19:05:00 +0900
Message-ID: <1282471506-29618-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Nick Piggin <npiggin-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This is a patchset to remove own inode hash table from nilfs.

The current version of nilfs uses inode not only to manage regular
files, directories, symlinks but also for some types of metadata and
for caching file blocks relocated by GC.

The last type of inodes is called gc-inodes, and nilfs keeps them with
an own hash table.

With this patchset, the gc-inodes will be stored in vfs inode cache
like regular inodes, and the own inode hash is deleted.

I hope this would be helpful for the vfs scalability work.

The patchset is also available from "remove-own-inode-hash" branch on:

 git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git


My next goal is to remove own inode allocator used to manage metadata
as files, but it still looks to need more effort.

I'd like to queue this for the next merge window if there are no
objections.

Thanks,
Ryusuke Konishi
--
Ryusuke Konishi (6):
      nilfs2: allow nilfs_destroy_inode to destroy metadata file inodes
      nilfs2: allow nilfs_dirty_inode to mark metadata file inodes dirty
      nilfs2: keep zero value in i_cno except for gc-inodes
      nilfs2: use iget5_locked to get inode
      nilfs2: separate initializer of metadata file inode
      nilfs2: remove own inode hash used for GC

 fs/nilfs2/gcinode.c       |  136 ++++++++------------------------------------
 fs/nilfs2/inode.c         |   64 ++++++++++++++++++++-
 fs/nilfs2/ioctl.c         |   17 +++--
 fs/nilfs2/mdt.c           |   46 +++++++++------
 fs/nilfs2/mdt.h           |    4 +-
 fs/nilfs2/nilfs.h         |    9 +--
 fs/nilfs2/segment.c       |   32 +++++------
 fs/nilfs2/segment.h       |    3 +-
 fs/nilfs2/super.c         |    7 ++
 fs/nilfs2/the_nilfs.c     |    8 +--
 fs/nilfs2/the_nilfs.h     |    7 +--
 include/linux/nilfs2_fs.h |    8 +++
 12 files changed, 164 insertions(+), 177 deletions(-)


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
