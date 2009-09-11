From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: NILFS 2.0.16 released
Date: Sat, 12 Sep 2009 02:50:25 +0900 (JST)
Message-ID: <20090912.025025.54461074.ryusuke@osrg.net>
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

I have released nilfs-2.0.16 standalone package which backported
corrections from the kernel 2.6.31 including bug-fixes of reported
hang or kernel oopses.

Here is a summary of changes from the previous version:

 * fix preempt count underflow in nilfs_btnode_prepare_change_key
 * fix oops due to inconsistent state in page with discreate b-tree
   nodes
 * fix missing a read lock for segment writer in
   nilfs_attach_checkpoint()
 * fix missing unlock in error path of nilfs_mdt_write_page
 * support is_partially_uptodate aops
 * support contiguous b-tree lookup
 * include FAQ patch for RHEL/CentOS in kern feature file
 * add sync_page method to page caches of meta data
 * use device's backing_dev_info for btree node caches
 * return EBUSY against delete request on snapshot
 * allow future expansion of metadata read out via get info ioctl
 * eliminate removal list of segments and header file for segment
   list operations
 * code cleanups in bmap/btree
 * correct exclusion control in nilfs_remount() function
 * correct misuse of sget() function
 * get rid of bd_mount_sem use from nilfs

The updated package is available at http://www.nilfs.org/en/download.html.

Thanks,
Ryusuke Konishi
