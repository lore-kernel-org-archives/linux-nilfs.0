From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/5] nilfs2 fixes for 2.6.31-rc3
Date: Tue,  7 Jul 2009 12:53:07 +0900
Message-ID: <1246938792-14681-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

This is a series of bug-fixes I'm planning to send to 2.6.31-rc3.

These are not applicable to the standalone package
(i.e. nilfs2-module) and users do not have to apply these piece by
piece; I will include them in nilfs2-module after merged upstream.

Thanks,
Ryusuke Konishi
--
Jiro SEKIBA (1):
      nilfs2: fix disorder in cp count on error during deleting checkpoints

Ryusuke Konishi (4):
      nilfs2: remove unlikely directive causing mis-conversion of error code
      nilfs2: fix hang problem of log writer which occurs after write failures
      nilfs2: fix incorrect KERN_CRIT messages in case of write failures
      nilfs2: fix lockdep warning between regular file and inode file

 fs/nilfs2/bmap.c    |    5 +++++
 fs/nilfs2/cpfile.c  |    5 ++---
 fs/nilfs2/dat.c     |    9 ---------
 fs/nilfs2/segment.c |   30 ++++++++----------------------
 4 files changed, 15 insertions(+), 34 deletions(-)
