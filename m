From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: NILFS 2.0.11 released
Date: Mon, 16 Mar 2009 01:25:23 +0900 (JST)
Message-ID: <20090316.012523.85948053.ryusuke@osrg.net>
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

Dear NILFS users,

We have released nilfs-2.0.11, which fixed the symbolic link
corruption reported on this mailing list.

The problem (seen in the tar program) turned out to be a bug in
timestamp initialization of on-memory inodes.  Instead of just
correcting the bug, I've introduced nanosecond resolution timestamps
which can also solve this issue.

It was introduced using a needless field of on-disk inodes, so
compatibility was not broken.

However, mount.nilfs2 was even changed this time so as to warn
possibility of on-disk format change.  Sorry if this confuse you, but
this is a preparation for mainline inclusion and is an action based on
recommendation from a linux maintainer.  The message will be removed
after things get stabilized.

The updated package can be found at:
http://www.nilfs.org/en/download.html

Thanks,
Ryusuke Konishi
