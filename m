From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/2] nilfs2 bug-fixes against 2.6.30-rc4
Date: Tue,  5 May 2009 21:33:01 +0900
Message-ID: <1241526783-25671-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

This series fixes two known problems.

The "fix possible recovery failure due to block creation without writer"
    fixes possible recovery failure on mount.

The "fix circular locking dependency of writer mutex"
    fixes a possible circular locking problem detected by lockdep check
    on the latest kernel.

The lockdep has detected more circular locking problems, but they are
not solved yet.  I will send them to linux-next for compile test
to work on other problems prior to remains.

This post is for record and review.  These are not applicable to the
standalone package (i.e. nilfs2-module) and users do not have to apply
these piece by piece; I will include them in the next release of
nilfs2-module after merged into upstream.

Thanks,
Ryusuke Konishi
--
Ryusuke Konishi (2):
      nilfs2: fix possible recovery failure due to block creation without writer
      nilfs2: fix circular locking dependency of writer mutex

 fs/nilfs2/ioctl.c    |    8 +++++---
 fs/nilfs2/mdt.c      |   13 +++++++------
 fs/nilfs2/recovery.c |    6 ++++--
 3 files changed, 16 insertions(+), 11 deletions(-)
