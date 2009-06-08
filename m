From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/6] nilfs2 additional changes for 2.6.31
Date: Mon,  8 Jun 2009 15:07:13 +0900
Message-ID: <1244441239-20032-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

This series is an addition to the series ("nilfs2 updates for 2.6.31")
that I posted two weeks ago.  I'm planning to send them to linux-next
except the last patch.  I may add a few more patches for performance
tuning if I have a chance by the beginning of the next merge window.

The series is available from the experimental branch in nilfs2.git
tree.  The nilfs2.git tree is served by kernel.org and available from:

 * URL

   git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git
   http://www.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git

 * gitweb

   http://git.kernel.org/?p=linux/kernel/git/ryusuke/nilfs2.git


These are not applicable to the standalone package
(i.e. nilfs2-module) and users do not have to apply these piece by
piece; I will send them to linux-next, and include them in a later
release of nilfs2-module after merged into upstream.

Thanks,
Ryusuke Konishi
--
Ryusuke Konishi (6):
      nilfs2: modify list of unsupported features in caveats
      nilfs2: return EBUSY against delete request on snapshot
      nilfs2: use device's backing_dev_info for btree node caches
      nilfs2: add sync_page method to page caches of meta data
      nilfs2: support contiguous lookup of blocks
      nilfs2: issue discard request after cleaning segments

 Documentation/filesystems/nilfs2.txt |    5 +-
 fs/nilfs2/bmap.c                     |   12 ++++-
 fs/nilfs2/bmap.h                     |    4 ++
 fs/nilfs2/btnode.c                   |    9 ++-
 fs/nilfs2/btnode.h                   |    2 +-
 fs/nilfs2/btree.c                    |   84 ++++++++++++++++++++++++++++++++++
 fs/nilfs2/cpfile.c                   |   14 +-----
 fs/nilfs2/direct.c                   |   43 +++++++++++++++++
 fs/nilfs2/gcinode.c                  |    5 +-
 fs/nilfs2/inode.c                    |   15 +++---
 fs/nilfs2/mdt.c                      |    3 +-
 fs/nilfs2/nilfs.h                    |    1 +
 fs/nilfs2/segment.c                  |    3 +
 fs/nilfs2/super.c                    |    9 +++-
 fs/nilfs2/the_nilfs.c                |   44 ++++++++++++++++++
 fs/nilfs2/the_nilfs.h                |    3 +
 16 files changed, 224 insertions(+), 32 deletions(-)
