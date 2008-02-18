From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: NILFS 2.0.0 release
Date: Mon, 18 Feb 2008 15:04:00 +0900
Message-ID: <1203314640.8603.31.camel@localhost.localdomain>
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

It is our great pleasure to announce the release of NILFS 2.0.0,
a stable snapshot.

Most of the known bugs were fixed by the previous -testing
release, and this release only includes a few minor changes:

- Ioctl32 errors that arose when using 32-bit nilfs userland
  tools and cleanerd on a 64-bit kernel, were fixed.
- It also removed fastcall specifiers to fix a compile-time error 
  on the kernel 2.6.25-rc2.

The packages can be found at:
http://www.nilfs.org/en/download.html

Good luck,
Ryusuke Konishi
-- 
NILFS Team, NTT Labs.
nilfs-sG5X7nlA6pw@public.gmane.org
