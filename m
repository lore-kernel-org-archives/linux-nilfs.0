From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 0/6] nilfs2 cleanups around get_sb and remount functions
Date: Mon,  8 Jun 2009 01:39:27 +0900
Message-ID: <1244392773-14230-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, users@nilfs.org

This is a revised series of the ("cleanups on nilfs_get_sb()") which I
posted last month.

The purpose of this series is to simpify sget() use in nilfs and
improve exclusion control of mount state in mount/remount/umount
procedures.

In the previous version, I cut by two of three sget() calls and
reduced some bd_mount_sem use.  This version will add the following
changes:

 * Simplify test callback function passed to the remaining sget()
   call.  The confusing down_write_trylock for sb->s_umount in the
   test function was removed.

 * Introduce a new semaphore to protect mount state. Previously, lock
   order reversal between sb->s_umount and bdev->bd_mount_sem was
   arising in nilfs_remount(), and protection for the mount state was
   imperfect in nilfs_remount(). The new semaphore corrects both
   problems.

 * Delete every bd_mount_sem use from nilfs including the pair left
   around sget() call in the previous version.

 * The way for detecting exclusive mount was simplified. This series
   uses a back pointer to a current mount from nilfs object instead of
   scanning list of super block instances.

 * Rebased to the latest kernel version.

I will queue this for 2.6.31.

--
Ryusuke Konishi (6):
      nilfs2: remove meaningless EBUSY case from nilfs_get_sb function
      nilfs2: get rid of sget use for acquiring nilfs object
      nilfs2: get rid of sget use for checking if current mount is present
      nilfs2: simplify remaining sget() use
      nilfs2: correct exclusion control in nilfs_remount function
      nilfs2: get rid of bd_mount_sem use from nilfs

 fs/nilfs2/cpfile.c    |    6 +-
 fs/nilfs2/sb.h        |    1 +
 fs/nilfs2/super.c     |  242 ++++++++++++++++---------------------------------
 fs/nilfs2/the_nilfs.c |  113 ++++++++++++++++++++++-
 fs/nilfs2/the_nilfs.h |   23 ++++-
 5 files changed, 212 insertions(+), 173 deletions(-)

Thanks,
Ryusuke Konishi


