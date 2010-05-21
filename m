From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [GIT PULL] nilfs2 updates for 2.6.35
Date: Fri, 21 May 2010 23:32:34 +0900 (JST)
Message-ID: <20100521.233234.82137980.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

to receive the following updates from nilfs2 tree.  Mostly cleanups
and minor fixes.  There are a few minor changes:

 * A mount option change that makes read-only remount the default of
   when critical metadata inconsistency was found.
 * Enlarged filesystem label.
 * An extension of log header format in order to ensure that
   diagnostic tool or fsck obtains checkpoint number from on-disk
   logs.

But no influential change is made.

Thanks,

Ryusuke Konishi

--
The following changes since commit b57f95a38233a2e73b679bea4a5453a1cc2a1cc9:
  Linus Torvalds (1):
        Linux 2.6.34-rc7

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

Jiro SEKIBA (1):
      nilfs2: enlarge s_volume_name member in nilfs_super_block

Li Hong (6):
      nilfs2: Combine nilfs_btree_alloc_path() and nilfs_btree_init_path()
      nilfs2: Combine nilfs_btree_release_path() and nilfs_btree_free_path()
      nilfs2: cleanup multi kmem_cache_{create,destroy} code
      nilfs2: add a print message after loading nilfs2
      nilfs2: remove nilfs_segctor_init() in segment.c
      nilfs2: change sc_timer from a pointer to an embedded one in struct nilfs_sc_info

Qinghuang Feng (1):
      nilfs2: update comment for struct nilfs_dat_entry

Ryusuke Konishi (15):
      nilfs2: fix style problems in nilfs2_fs.h
      nilfs2: change default of 'errors' mount option to 'remount-ro' mode
      nilfs2: move pointer to super root block into logs
      nilfs2: move out checksum routines to segment buffer code
      nilfs2: insert checkpoint number in segment summary header
      nilfs2: add kernel doc comments to persistent object allocator functions
      nilfs2: make nilfs_sc_*_ops static
      nilfs2: add missing endian conversion on super block magic number
      nilfs2: use checkpoint number instead of timestamp to select super block
      nilfs2: fix misuse of open_bdev_exclusive/close_bdev_exclusive
      nilfs2: add missing initialization of s_mode
      nilfs2: replace MS_VERBOSE with MS_SILENT
      nilfs2: update comment on deactivate_super at nilfs_get_sb
      nilfs2: use huge_encode_dev/huge_decode_dev
      nilfs2: disallow remount of snapshot from/to a regular mount

 Documentation/filesystems/nilfs2.txt |    4 +-
 fs/nilfs2/alloc.c                    |  154 ++++++++++++++++++++++++-
 fs/nilfs2/alloc.h                    |    7 +
 fs/nilfs2/btree.c                    |   91 +++------------
 fs/nilfs2/btree.h                    |   23 +++-
 fs/nilfs2/inode.c                    |    4 +-
 fs/nilfs2/recovery.c                 |    2 +
 fs/nilfs2/segbuf.c                   |   70 ++++++-----
 fs/nilfs2/segbuf.h                   |   10 +-
 fs/nilfs2/segment.c                  |  157 ++++++------------------
 fs/nilfs2/segment.h                  |    6 +-
 fs/nilfs2/super.c                    |  218 ++++++++++++++++++----------------
 fs/nilfs2/the_nilfs.c                |   10 +-
 include/linux/nilfs2_fs.h            |   17 ++--
 14 files changed, 423 insertions(+), 350 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
