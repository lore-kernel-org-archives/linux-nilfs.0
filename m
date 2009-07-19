From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: NILFS utils 2.0.14 released
Date: Mon, 20 Jul 2009 02:33:20 +0900 (JST)
Message-ID: <20090720.023320.89188070.ryusuke@osrg.net>
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

Hi everyone,

We have released nilfs-utils-2.0.14.

This release fixed a privilege escalation vulnerability found in
mkfs.nilfs2.  The problem comes from the fact that a Makefile of the
utility package inadequately set suid bit, and it is highly
recommended to upgrade to this version if you built tools from the
sources on this site.  Sorry for inconvenience.

Users using a distro package do not suffer the problem because the
suid bit is dropped in that case.

Other changes are as follows:

 * fix a reported start-up failure of GC which occurs if nilfs is
   applied to a root filesystem.
 * add -p option to cleanerd which overrides protection period
 * make the invocation of badblocks from mkfs.nilfs2 safer
 * drop other suid bits for safety
 * drop suid/sgid in proper order when invoking cleaner
 * fix code checker warnings reported by Eric Sandeen

The updated package is available at
http://www.nilfs.org/en/download.html

Thanks,
Ryusuke Konishi
