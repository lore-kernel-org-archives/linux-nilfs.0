From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/3] nilfs2 bug fixes
Date: Tue,  3 Nov 2009 13:53:36 +0900
Message-ID: <1257224019-29261-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

This series includes additional fixes for nilfs in the mainline
kernel.  I will send the first two upstream along with the previous
patch that resolves a hang issue on ARM-based targets.  The third one
will be dealt with a 2.6.33 material.

Users do not have to apply these piece by piece.

Thanks,
Ryusuke Konishi
--
Ryusuke Konishi (3):
      nilfs2: fix irregular checkpoint creation due to data flush
      nilfs2: add zero-fill for new btree node buffers
      nilfs2: get rid of BUG_ON use in btree lookup routines

 fs/nilfs2/btnode.c  |    1 +
 fs/nilfs2/btree.c   |   18 ++++++++++++++++--
 fs/nilfs2/segment.c |   19 ++++++++++++-------
 3 files changed, 29 insertions(+), 9 deletions(-)
