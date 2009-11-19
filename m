From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/4] nilfs2 mount/recovery updates for 2.6.33
Date: Fri, 20 Nov 2009 02:09:09 +0900
Message-ID: <1258650553-10743-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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
Cc: jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This is another series for the next merge window.

The first patch improves recovery time after unclean unmount, and the
remaining is a revision of the patch I posted in the thread titled
("[NILFS users] urgent help need! disk partition info lost"); the last
one adds `norepair' mount option, which allows users to avoid temporal
write access in a read-only mount or snapshots at mount/recovery.
And, the middle two are the cleanup for it.

This series is made against the latest for-next branch of

 git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git

But, possibly applicable to the mainline.

Thanks,
Ryusuke Konishi
--
Ryusuke Konishi (4):
      nilfs2: apply readahead for recovery on mount
      nilfs2: move recovery completion into load_nilfs function
      nilfs2: add helper to get if volume is in a valid state
      nilfs2: add norepair mount option

 Documentation/filesystems/nilfs2.txt |    4 ++
 fs/nilfs2/recovery.c                 |   26 +++++++---
 fs/nilfs2/super.c                    |   53 +++++++-------------
 fs/nilfs2/the_nilfs.c                |   92 ++++++++++++++++++++++++----------
 fs/nilfs2/the_nilfs.h                |   10 ++++
 include/linux/nilfs2_fs.h            |    2 +
 6 files changed, 118 insertions(+), 69 deletions(-)
