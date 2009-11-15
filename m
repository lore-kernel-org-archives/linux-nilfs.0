From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/23] nilfs2 updates for 2.6.33
Date: Sun, 15 Nov 2009 21:46:38 +0900
Message-ID: <1258289221-3827-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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


This series is a part of the nilfs updates I am planning to send to
the next merge window.  In this series, I did some performance tuning
based on ftrace analyses.  There are other chances to get much gain,
but I once break this work to give priority to remaining bugfix patch
submission to upstream.

Changes since the latest -next tree are as follows:

 - Eliminate redundant lock buffer uses from btree and inode code.
 - Move out mark_inode_dirty uses from bmap routines to shorten the
   time of file removals.
 - Allow each metadata file to allocate private memory for individual
   optimization.
 - Reduce overhead of begin-transaction function due to metadata file
   access.
 - Add a cache framework for persistent object allocator to make
   access to DAT or ifile faster.
 - Cleanup related to these changes.

There is neither ABI change nor disk format change in this series.  I
will later push them to for-next branch of the nilfs tree:

 git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git

Thanks,
Ryusuke Konishi
--
Ryusuke Konishi (23):
      nilfs2: remove buffer locking in nilfs_mark_inode_dirty
      nilfs2: remove buffer locking from btree code
      nilfs2: stop marking metadata inode dirty within btree operations
      nilfs2: move out mark_inode_dirty calls from bmap routines
      nilfs2: add size option of private object to metadata file allocator
      nilfs2: separate constructor of metadata files
      nilfs2: separate read method of meta data files on super root block
      nilfs2: eliminate inlines to directly read/write inode of metadata files
      nilfs2: hide nilfs_mdt_clear calls in nilfs_mdt_destroy
      nilfs2: unfold nilfs_sufile_block_get_header function
      nilfs2: add local variable to cache the number of clean segments
      nilfs2: simplify nilfs_sufile_get_ncleansegs function
      nilfs2: avoid readahead on metadata file for create mode
      nilfs2: separate function for creating new btree node block
      nilfs2: use nilfs_btnode_create_block function
      nilfs2: remove newblk argument from nilfs_btnode_submit_block
      nilfs2: eliminate nilfs_btnode_get function
      nilfs2: unfold nilfs_palloc_block_get_bitmap function
      nilfs2: add cache framework for persistent object allocator
      nilfs2: add palloc cache to dat
      nilfs2: flush palloc cache before manipulating data pages of GC dat
      nilfs2: add palloc cache to ifile
      nilfs2: insert cache operation in palloc get block routines

 fs/nilfs2/alloc.c     |  108 +++++++++++++++++++++++++++++++++++----------
 fs/nilfs2/alloc.h     |   21 +++++++++
 fs/nilfs2/bmap.c      |    8 ---
 fs/nilfs2/btnode.c    |   76 ++++++++++++++-----------------
 fs/nilfs2/btnode.h    |    6 +-
 fs/nilfs2/btree.c     |   86 ++++++++---------------------------
 fs/nilfs2/cpfile.c    |   26 +++++++++++
 fs/nilfs2/cpfile.h    |    3 +
 fs/nilfs2/dat.c       |   47 ++++++++++++++++++++
 fs/nilfs2/dat.h       |    3 +
 fs/nilfs2/gcdat.c     |    3 +
 fs/nilfs2/gcinode.c   |    6 +-
 fs/nilfs2/ifile.c     |   35 +++++++++++++++
 fs/nilfs2/ifile.h     |    2 +
 fs/nilfs2/inode.c     |    6 +-
 fs/nilfs2/mdt.c       |   56 +++++++++++++++--------
 fs/nilfs2/mdt.h       |   25 ++--------
 fs/nilfs2/recovery.c  |    6 ---
 fs/nilfs2/segment.c   |   12 +++---
 fs/nilfs2/sufile.c    |  117 ++++++++++++++++++++++++++++++++-----------------
 fs/nilfs2/sufile.h    |    6 ++-
 fs/nilfs2/super.c     |    7 +---
 fs/nilfs2/the_nilfs.c |   65 ++++++++-------------------
 23 files changed, 437 insertions(+), 293 deletions(-)
