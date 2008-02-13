From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: NILFS 2.0.0-testing-9 release
Date: Wed, 13 Feb 2008 17:57:00 +0900
Message-ID: <1202893020.14545.17.camel@localhost.localdomain>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
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
Content-Type: text/plain; charset="us-ascii"
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Dear NILFS users,

We have decided to release one more -testing version,
NILFS 2.0.0-testing-9 because we were backlogged on
enough minor changes and bug-fixes after the previous
release.

This release fixes compiler errors when CONFIG_LBD kernel
option is not defined, a hangup problem under a near disk
full condition, write routine bugs that cause system hangup,
and a problem that drives manual unmount of NILFS partitions
mounted at boot time into failure.

nilfs-utils must be upgraded together to the latest
version (2.0.0-testing-9) for this release.

The updated package can be found at:
http://www.nilfs.org/en/download.html

Thanks,
Ryusuke Konishi
-- 
NILFS Team, NTT Labs.
nilfs-sG5X7nlA6pw@public.gmane.org
