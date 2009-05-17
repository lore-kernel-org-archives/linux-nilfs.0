From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/6] nilfs2 cleanups for 2.6.31
Date: Mon, 18 May 2009 00:29:40 +0900
Message-ID: <1242574186-21554-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

This series includes some cleanup patches for the next merge window.

Patches improving performance and giving functional enhancement would
be successively appended to these patches.

I will later build an experimental branch in nilfs2.git tree to manage
new patches publicly.  The nilfs2.git tree is served by kernel.org and
available from:

 * URL

   git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git
   http://www.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git

 * gitweb

   http://git.kernel.org/?p=linux/kernel/git/ryusuke/nilfs2.git

At present, there are only a clone of linus tree and branches used to
send patches upsteam.

--
Ryusuke Konishi (6):
      nilfs2: use semaphore to protect pointer to a writable FS-instance
      nilfs2: remove nilfs_dat_prepare_free function
      nilfs2: unify bmap operations starting use of indirect block address
      nilfs2: add sufile function that can modify multiple segment usages
      nilfs2: remove list of freeing segments
      nilfs2: remove header file for segment list operations

 fs/nilfs2/bmap.c      |   36 +++-----------
 fs/nilfs2/bmap.h      |    9 +---
 fs/nilfs2/btree.c     |    7 +--
 fs/nilfs2/dat.c       |   15 ------
 fs/nilfs2/direct.c    |    7 +--
 fs/nilfs2/ioctl.c     |   26 ----------
 fs/nilfs2/mdt.c       |   10 +++-
 fs/nilfs2/recovery.c  |   37 +++++++++-----
 fs/nilfs2/segbuf.c    |    1 -
 fs/nilfs2/seglist.h   |   85 --------------------------------
 fs/nilfs2/segment.c   |  130 +++++++++++++-----------------------------------
 fs/nilfs2/segment.h   |   12 ++--
 fs/nilfs2/sufile.c    |   99 +++++++++++++++++++++++++++++++++++++-
 fs/nilfs2/sufile.h    |   60 ++++++++++++++--------
 fs/nilfs2/the_nilfs.c |    4 +-
 fs/nilfs2/the_nilfs.h |   27 ++--------
 16 files changed, 229 insertions(+), 336 deletions(-)

This post is for record and review.  These are not applicable to the
standalone package (i.e. nilfs2-module) and users do not have to apply
these piece by piece; I will include them in a later release of
nilfs2-module after merged into upstream.

Thanks,
Ryusuke Konishi
