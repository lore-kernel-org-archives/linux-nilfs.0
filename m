From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: NILFS 2.0.15 released
Date: Sat, 11 Jul 2009 23:53:25 +0900 (JST)
Message-ID: <20090711.235325.105375961.ryusuke@osrg.net>
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

I have released nilfs-2.0.15 standalone package, which includes
several bug fixes including hang problem after write failures.  This
also includes a change to improve read performance on some fast
drives.

Here is a summary of changes from the previous version:

* enable sync_page method; this adds a missing sync_page method which
  unplugs bio requests during lock retries on pages. This will improve
  read performance of nilfs.
* fix bh leak in nilfs_cpfile_delete_checkpoints function
* fix disorder in checkpoint count on error during deleting
  checkpoints
* fix hang problem of log writer which occurs after write failures
* remove unlikely directive causing mis-conversion of error code
* fix lockdep warning between regular file and inode file
* fix incorrect KERN_CRIT messages in case of write failures
* correct display of sequence counter printed when request has
  completed
* separate debug message related to transaction from ones for segment


The updated package is available at http://www.nilfs.org/en/download.html.

Thanks,
Ryusuke Konishi
