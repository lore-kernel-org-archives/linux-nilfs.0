From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/17] nilfs2 updates for 2.6.31
Date: Mon, 25 May 2009 19:18:04 +0900
Message-ID: <1243246701-5193-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This series includes some cleanup and improvement patches for the next
merge window.  This is an update of the series previously posted to
this mailing list.  Most of this series is for cleanup.

The series is available from the experimental branch in nilfs2.git
tree.  The nilfs2.git tree is served by kernel.org and available from:

 * URL

   git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git
   http://www.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git

 * gitweb

   http://git.kernel.org/?p=linux/kernel/git/ryusuke/nilfs2.git


This post is for record and review.  These are not applicable to the
standalone package (i.e. nilfs2-module) and users do not have to apply
these piece by piece; I will send them to linux-next, and include them
in a later release of nilfs2-module after merged into upstream.

Thanks,
Ryusuke Konishi
--
Hisashi Hifumi (1):
      NILFS2: Pagecache usage optimization on NILFS2

Ryusuke Konishi (16):
      nilfs2: use semaphore to protect pointer to a writable FS-instance
      nilfs2: remove nilfs_dat_prepare_free function
      nilfs2: unify bmap operations starting use of indirect block address
      nilfs2: add sufile function that can modify multiple segment usages
      nilfs2: eliminate removal list of segments
      nilfs2: remove header file for segment list operations
      nilfs2: remove nilfs_bmap_put_block
      nilfs2: remove nilfs_bmap_delete_block
      nilfs2: move get block functions in bmap.c into btree codes
      nilfs2: remove pointless NULL check of bpop_commit_alloc_ptr function
      nilfs2: remove useless b_low and b_high fields from nilfs_bmap struct
      nilfs2: remove bmap pointer operations
      nilfs2: remove nilfs_direct_operations from direct mapping
      nilfs2: remove nilfs_btree_operations from btree mapping
      nilfs2: allow future expansion of metadata read out via get info ioctl
      nilfs2: set bio unplug flag for the last bio in segment

 fs/nilfs2/bmap.c      |  262 +++++++++++----------------------------------
 fs/nilfs2/bmap.h      |  131 ++++++++++++++---------
 fs/nilfs2/btree.c     |  282 ++++++++++++++++++++++---------------------------
 fs/nilfs2/btree.h     |   31 +-----
 fs/nilfs2/cpfile.c    |   33 ++++--
 fs/nilfs2/cpfile.h    |    4 +-
 fs/nilfs2/dat.c       |   36 ++-----
 fs/nilfs2/dat.h       |    2 +-
 fs/nilfs2/direct.c    |   96 +++++------------
 fs/nilfs2/direct.h    |   20 +---
 fs/nilfs2/inode.c     |    1 +
 fs/nilfs2/ioctl.c     |   35 +-----
 fs/nilfs2/mdt.c       |   10 ++-
 fs/nilfs2/recovery.c  |   37 ++++---
 fs/nilfs2/segbuf.c    |    3 +-
 fs/nilfs2/seglist.h   |   85 ---------------
 fs/nilfs2/segment.c   |  130 ++++++-----------------
 fs/nilfs2/segment.h   |   12 +-
 fs/nilfs2/sufile.c    |  119 +++++++++++++++++++--
 fs/nilfs2/sufile.h    |   62 +++++++----
 fs/nilfs2/the_nilfs.c |    4 +-
 fs/nilfs2/the_nilfs.h |   27 +----
 22 files changed, 567 insertions(+), 855 deletions(-)
