From: Alexander Schier <alex-W0ZHf6uU1cg@public.gmane.org>
Subject: OOM while deleting very large files
Date: Sun, 4 May 2008 18:54:26 +0200
Message-ID: <20080504165426.GA2826@laxu.de>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi!
I had a large Nilfs2 (about 250 GB), and 2 files with about 100 GB in
it. When i tried to delete the file, either
rm bigfile1

or after it failed

echo '' >bigfile1

the pc worked a long time, and then nilfs2 used so much ram, that the
kernel killed all programs, and finally the pc was unusable. It was not
possible to delete the files, other than reformatting the partition.

At the moment, i can not do any further tests, because the partition is
now filled with useful files, and i do not want to fill the rest with
undeletable files. But maybe you can find the memleak(?) in the Source.

Alex
