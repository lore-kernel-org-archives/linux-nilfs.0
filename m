From: sh1v4_0h-/E1597aS9LQAvxtiuMwx3w@public.gmane.org
Subject: nilfs_cleanerd shutdown
Date: Sun, 21 Jun 2009 12:10:56 -0700 (PDT)
Message-ID: <280074.80083.qm@web43411.mail.sp1.yahoo.com>
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


When I mount nilfs filesystems, nilfs_cleanerd does something like this:

Jun 21 19:44:06 localhost mount.nilfs2: WARNING! - The NILFS on-disk format may change at any time.
Jun 21 19:44:06 localhost mount.nilfs2: WARNING! - Do not place critical data on a NILFS filesystem.
Jun 21 19:44:07 localhost nilfs_cleanerd[4120]: start
Jun 21 19:44:07 localhost nilfs_cleanerd[4120]: cannot create cleanerd on /dev/mapper/system-root
Jun 21 19:44:07 localhost nilfs_cleanerd[4120]: shutdown


but if I run 'nilfs_cleanerd' without any arguments as root everything works just fine and nilfs_cleanerd seems to find the mounted device automatically and frees space on it:

Jun 21 20:27:50 localhost nilfs_cleanerd[7704]: start

Is there someting I can do so nilfs_cleanerd will work with mount.nilfs2?
