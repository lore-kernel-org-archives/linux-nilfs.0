From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/23] nilfs2: remove own inode allocator
Date: Tue, 14 Sep 2010 00:37:01 +0900
Message-ID: <1284392244-27100-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Nick Piggin <npiggin-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This patchset is intended to unify super block instances allocated for
one device into one sb and to eliminate own inode allocator from
nilfs.

Previously the super block instances were allocated per snapshot, and
this was preventing removal of the own inode allocator; a part of
inodes treating metadata as files, didn't have a valid inode->i_sb
since they outlive the life cycle of an sb.

With this patchset, mounted snapshots and the current tree will be
managed with an rb-tree.  Each checkpoint/snapshot is represented by a
"root object" and this object is used to identify the checkpoint to
which inodes belong.

Snapshots are still mounted on a mountpoint specified with the mount
system call.

To make user interface compatible like this, root dentries of
snapshots and the current filesystem tree are binded to their
mnt->mnt_root, whereas sb->s_root always holds the root dentry of the
current tree.

After these changes were applied, sb instances are unified per device.
And, by the latter half of the patches, all inodes used in nilfs will
be allocated and released through iget5_locked() and iput()
respectively.  The own inode allocator is removed by the final patch.


Along with the previous removal of the own inode hash table, I hope
this would help to avoid bothersome inode related changes on nilfs.

Most changes are confined to the code of nilfs, but exceptionally I
had to add a new type of file handle to "exportfs.h" in order to make
snapshots exportable.

As for conflict, the patch #7 seems to conflict with a recent patch
that modifies iop->permission().

The patchset is also available from "remove-own-inode-allocator" branch on:

 git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git


I carefully tested this patchset since it makes a lot of changes.
So far, this works stably and seems able to replace the old
implementation.

So, I'm planning to queue this for the next merge window unless there
are objections.

Thanks,
Ryusuke Konishi
--
Ryusuke Konishi (23):
      nilfs2: add checkpoint tree to nilfs object
      nilfs2: set pointer to root object in inodes
      nilfs2: make snapshots in checkpoint tree exportable
      nilfs2: use root object to get ifile
      nilfs2: move inode count and block count into root object
      nilfs2: use checkpoint tree for mount check of snapshots
      nilfs2: deny write access to inodes in snapshots
      nilfs2: split out nilfs_get_root_dentry
      nilfs2: split out nilfs_attach_snapshot
      nilfs2: do not allocate multiple super block instances for a device
      nilfs2: simplify life cycle management of nilfs object
      nilfs2: get rid of snapshot mount flag
      nilfs2: allow nilfs_clear_inode to clear metadata file inodes
      nilfs2: do not allocate nilfs_mdt_info structure to gc-inodes
      nilfs2: add routines to save and restore bmap state
      nilfs2: add routines to roll back state of DAT file
      nilfs2: add routines to redirect access to buffers of DAT file
      nilfs2: get rid of GCDAT inode
      nilfs2: use iget for all metadata files
      nilfs2: see state of root dentry for mount check of snapshots
      nilfs2: get rid of mi_nilfs back pointer to nilfs object
      nilfs2: get rid of back pointer to writable sb instance
      nilfs2: remove own inode allocator and destructor for metadata files

 fs/nilfs2/Makefile        |    2 +-
 fs/nilfs2/bmap.c          |   22 +-
 fs/nilfs2/bmap.h          |   10 +-
 fs/nilfs2/btnode.c        |   17 +--
 fs/nilfs2/cpfile.c        |   72 ++++---
 fs/nilfs2/cpfile.h        |    4 +-
 fs/nilfs2/dat.c           |   89 ++++++---
 fs/nilfs2/dat.h           |    4 +-
 fs/nilfs2/export.h        |   17 ++
 fs/nilfs2/gcdat.c         |   87 --------
 fs/nilfs2/gcinode.c       |   32 ++--
 fs/nilfs2/ifile.c         |   51 +++--
 fs/nilfs2/ifile.h         |    4 +-
 fs/nilfs2/inode.c         |  111 +++++++---
 fs/nilfs2/ioctl.c         |    4 +-
 fs/nilfs2/mdt.c           |  293 +++++++++++++------------
 fs/nilfs2/mdt.h           |   34 ++--
 fs/nilfs2/namei.c         |  139 +++++++++++--
 fs/nilfs2/nilfs.h         |   29 +--
 fs/nilfs2/page.c          |   55 +++---
 fs/nilfs2/page.h          |    6 +
 fs/nilfs2/recovery.c      |   19 +-
 fs/nilfs2/sb.h            |   10 -
 fs/nilfs2/segment.c       |   66 +++---
 fs/nilfs2/segment.h       |    7 +-
 fs/nilfs2/sufile.c        |   77 ++++---
 fs/nilfs2/sufile.h        |    6 +-
 fs/nilfs2/super.c         |  528 ++++++++++++++++++++++-----------------------
 fs/nilfs2/the_nilfs.c     |  323 +++++++++-------------------
 fs/nilfs2/the_nilfs.h     |   92 ++++-----
 include/linux/exportfs.h  |   13 ++
 include/linux/nilfs2_fs.h |    1 -
 32 files changed, 1132 insertions(+), 1092 deletions(-)
 create mode 100644 fs/nilfs2/export.h
 delete mode 100644 fs/nilfs2/gcdat.c


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
