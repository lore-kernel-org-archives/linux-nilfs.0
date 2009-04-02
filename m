From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: NILFS utils 2.0.12 released
Date: Thu, 02 Apr 2009 20:00:24 +0900 (JST)
Message-ID: <20090402.200024.15080918.ryusuke@osrg.net>
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

We have released nilfs-utils-2.0.12.

This release fixed some reported bugs of userland tools, reduced
latency time of lssu and lscp commands, and added options to these
tools for allowing partial output of checkpoints or segments.

The bugfixes include:

 * fix problem of libnilfs which didn't follow symbolic links for devices.
 * fix incorrect behavior of mkfs.nilfs2 with -q option.
 * fix command line buffer overflow error for mkfs -c.
 * fix wrong access right check of mount.nilfs2 for its device arugment.
 * fix problems around bind mount.

The updated package is available at http://www.nilfs.org/en/download.html.

Thanks,
Ryusuke Konishi
