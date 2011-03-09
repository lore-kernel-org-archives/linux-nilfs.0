From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/8] clean up nilfs_sb_info structure
Date: Wed,  9 Mar 2011 21:08:05 +0900
Message-ID: <1299672493-28544-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This series removes nilfs_sb_info structure and simplifies the
hierarchy of on-memory structures of nilfs as below:
    
Before:
  super_block
       -> nilfs_sb_info
             -> the_nilfs
                   -> cptree --+-> nilfs_root (current file system)
                               +-> nilfs_root (snapshot A)
                               +-> nilfs_root (snapshot B)
                               :
             -> nilfs_sc_info (log writer structure)
After:
  super_block
       -> the_nilfs
             -> cptree --+-> nilfs_root (current file system)
                         +-> nilfs_root (snapshot A)
                         +-> nilfs_root (snapshot B)
                         :
             -> nilfs_sc_info (log writer structure)
    
The reason why we didn't design like this from the beginning is
because the initial shape also differed from the above.  The early
hierachy was composed of "per-mount-point" super_block ->
nilfs_sb_info pairs and a shared nilfs object.

On the kernel 2.6.37, it was changed to the current shape in order to
unify super block instances into one per device.  Thus, this cleanup
became applicable as the result.

I'd like to queue these for the upcoming merge window unless problem
occurs.

Thanks,
Ryusuke Konishi
---
Ryusuke Konishi (8):
      nilfs2: move mount options to nilfs object
      nilfs2: move parameters on nilfs_sb_info into nilfs object
      nilfs2: move s_inode_lock and s_dirty_files into nilfs object
      nilfs2: move next generation counter into nilfs object
      nilfs2: move log writer onto nilfs object
      nilfs2: get rid of sc_sbi back pointer
      nilfs2: use sb instance instead of nilfs_sb_info struct
      nilfs2: get rid of nilfs_sb_info structure

 fs/nilfs2/bmap.c      |    1 -
 fs/nilfs2/file.c      |    2 +-
 fs/nilfs2/inode.c     |   40 ++++----
 fs/nilfs2/ioctl.c     |   23 ++---
 fs/nilfs2/mdt.h       |    2 +-
 fs/nilfs2/namei.c     |    2 +-
 fs/nilfs2/nilfs.h     |   13 +--
 fs/nilfs2/recovery.c  |   32 +++---
 fs/nilfs2/sb.h        |   85 ----------------
 fs/nilfs2/segment.c   |  258 +++++++++++++++++++++++-------------------------
 fs/nilfs2/segment.h   |   14 +--
 fs/nilfs2/super.c     |  214 +++++++++++++++++-----------------------
 fs/nilfs2/the_nilfs.c |   33 ++++---
 fs/nilfs2/the_nilfs.h |   51 +++++++++-
 14 files changed, 341 insertions(+), 429 deletions(-)
 delete mode 100644 fs/nilfs2/sb.h

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
