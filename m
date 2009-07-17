From: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Subject: [PATCH 0/3] write_super clean up
Date: Fri, 17 Jul 2009 18:12:45 +0900
Message-ID: <1247821968-31232-1-git-send-email-jir@unicus.jp>
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
Cc: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

Hi, this is a candidate patch to cleanup write_super callback.

VFS layer calls ->write_super callback periodically.  However,
it looks like that calling back is ommited when disk I/O is busy.
And when cleanerd is runnig, disk I/O tend to be busy thus
nilfs superblock is not synchronized as nilfs designed.

To avoid it, syncing superblock by nilfs thread instead of VFS pdflush.

These patches show the basic idea.

First one is a just clean up for nilfs_sync_fs.  writing superblock
must be done very end of the function.

Second one will separeate condition for syncing superblock and alternative
superblock as a inline function.

Third one is the actual patch to sync the superblock in nilfs internal thread.
Because the conditions in nilfs_write_super are using seconds, I used
it as well in the patch.  However, it might be good to use jiffies instead
of using get_seconds.

 
 fs/nilfs2/segment.c   |   13 ++++++++++++-
 fs/nilfs2/super.c     |   16 +++++++---------
 fs/nilfs2/the_nilfs.h |   10 ++++++++++
 3 files changed, 29 insertions(+), 10 deletions(-)

-- 
Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
