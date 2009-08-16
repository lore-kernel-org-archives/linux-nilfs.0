From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/7] some nilfs2 cleanups for 2.6.32
Date: Sun, 16 Aug 2009 15:51:03 +0900
Message-ID: <1250405470-23326-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

This is a series of cleanups I'm planning to send to the next merge
window.

In the middle of bug hunting for a reported corruption problem, I felt
some more cleanup is necessary for maintenance mainly around the btree
code.  This round I'd like to cut out the cleanup with this unless
required for other improvement.

As usual, these are not applicable to the standalone package and users
do not have to apply these piece by piece; they will be applied to the
module package after merged upstream.

Thanks,
Ryusuke Konishi
--
Ryusuke Konishi (7):
      nilfs2: remove nilfs_dat_abort_start and nilfs_dat_abort_free
      nilfs2: remove unused btree argument from btree functions
      nilfs2: stop zero-fill of btree path just before free it
      nilfs2: remove individual gfp constants for each metadata file
      nilfs2: add update functions of virtual block address to dat
      nilfs2: allow btree code to directly call dat operations
      nilfs2: convert nilfs_bmap_lookup to an inline function

 fs/nilfs2/bmap.c      |  151 ++-----------
 fs/nilfs2/bmap.h      |   76 +++----
 fs/nilfs2/btree.c     |  625 +++++++++++++++++++++++--------------------------
 fs/nilfs2/cpfile.h    |    2 -
 fs/nilfs2/dat.c       |   42 +++-
 fs/nilfs2/dat.h       |    8 +-
 fs/nilfs2/direct.c    |  161 +++++--------
 fs/nilfs2/ifile.h     |    1 -
 fs/nilfs2/mdt.c       |    9 +-
 fs/nilfs2/mdt.h       |    3 +-
 fs/nilfs2/sufile.h    |    1 -
 fs/nilfs2/super.c     |    3 +-
 fs/nilfs2/the_nilfs.c |   12 +-
 13 files changed, 452 insertions(+), 642 deletions(-)
