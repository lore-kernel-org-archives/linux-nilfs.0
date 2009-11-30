From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/6] nilfs2 logwriter updates for 2.6.33
Date: Mon, 30 Nov 2009 22:30:39 +0900
Message-ID: <1259587845-3436-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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


This series contains additional updates for the next merge window.  In
this series, I refined log writer so that it partially hides io
latency with double buffering.

At this point, the effect is limited (measured gain is about 15
percent for sequential write) due to a restriction on lock order
between filemap and log writer lock.  Also, it is disabled for
blocksize < pagesize by another restriction on page handling.  So, I'd
like to revise this further when time allows.

Thanks,
Ryusuke Konishi
--
Ryusuke Konishi (6):
      nilfs2: use list_splice_tail or list_splice_tail_init
      nilfs2: do not return io error for bio allocation failure
      nilfs2: relocate io status variables to segment buffer
      nilfs2: hide nilfs_write_info struct in segment buffer code
      nilfs2: add iterator for segment buffers
      nilfs2: separate wait function from nilfs_segctor_write

 fs/nilfs2/btree.c    |    2 +-
 fs/nilfs2/recovery.c |    2 +-
 fs/nilfs2/segbuf.c   |  185 +++++++++++++++++++++---------
 fs/nilfs2/segbuf.h   |   54 +++------
 fs/nilfs2/segment.c  |  306 ++++++++++++++++++++++++++------------------------
 fs/nilfs2/segment.h  |    2 +
 6 files changed, 313 insertions(+), 238 deletions(-)
