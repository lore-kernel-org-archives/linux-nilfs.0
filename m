From: Yuri Chislov <yuri-EJC0RcYdacHR7s880joybQ@public.gmane.org>
Subject: Fail to mount NILFS.
Date: Fri, 21 Aug 2009 19:18:34 +0300
Message-ID: <200908211918.34720.yuri@itinteg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Content-Disposition: inline
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

Hi,

 I get error when mount nilfs2 partition.

mount.nilfs2 /dev/cciss/c0d1p1 /home/
mount.nilfs2: WARNING! - The NILFS on-disk format may change at any time.
mount.nilfs2: WARNING! - Do not place critical data on a NILFS filesystem.
mount.nilfs2: Error while mounting /dev/cciss/c0d1p1 on /home/: Invalid 
argument

dmesg output:
segctord starting. Construction interval = 5 seconds, CP frequency < 30 
seconds
NILFS: corrupt root inode.

Used kernel: 2.6.30.4
nilfs-utils-2.0.12-3.i386


Is it possible to fix the partition?
Is it some tools exists, like fsck?

Thank you.
Yuri.
