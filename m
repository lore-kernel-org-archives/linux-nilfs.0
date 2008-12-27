From: John Huttley <John-jE24nFfhqzU3hwNNidygWXTaI6DYlTYJ@public.gmane.org>
Subject: Crash bug, was cleanerd stopping
Date: Sun, 28 Dec 2008 10:57:42 +1300
Message-ID: <4956A4D6.2010004@mib-infotech.co.nz>
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
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

Hi Ryusuke,

I built from your git repo.

It seemed to work for the first few days, then it crashed and now its 
hard crashed with the following
message


008-12-28T08:40:47+13:00 nilfs_cleanerd[5063]: 2 segments selected to be 
cleaned
2008-12-28T08:40:49+13:00 nilfs_cleanerd[5063]: segment 16 cleaned
2008-12-28T08:40:49+13:00 nilfs_cleanerd[5063]: segment 17 cleaned
2008-12-28T08:40:49+13:00 nilfs_cleanerd[5063]: wait 3.559549000
2008-12-28T08:40:50+13:00 kernel BUG at 
/var/git/nilfs2-module/fs/btree.c:503!
2008-12-28T08:40:50+13:00 Modules linked in: iscsi_trgt nilfs2 reiserfs 
ohci_hcd lpfc qla2xxx scsi_wait_scan
2008-12-28T08:40:50+13:00 RIP: 0010:[<ffffffffa00b85a9>]  
[<ffffffffa00b85a9>] nilfs_btree_do_lookup+0x249/0x260 [nilfs2]
2008-12-28T08:40:50+13:00 [<ffffffffa00b9d58>] 
nilfs_btree_lookup+0x68/0xb0 [nilfs2]
2008-12-28T08:40:50+13:00 [<ffffffffa00b78c4>] 
nilfs_bmap_lookup_at_level+0x44/0x90 [nilfs2]
2008-12-28T08:40:50+13:00 [<ffffffffa00b792a>] 
nilfs_bmap_lookup+0x1a/0x40 [nilfs2]
2008-12-28T08:40:50+13:00 [<ffffffffa00b1442>] 
nilfs_get_block+0xa2/0x240 [nilfs2]
2008-12-28T08:40:50+13:00 [<ffffffffa00b5a7c>] ? 
nilfs_grab_buffer+0x7c/0x160 [nilfs2]
2008-12-28T08:40:50+13:00 [<ffffffffa00b13a0>] ? 
nilfs_get_block+0x0/0x240 [nilfs2]
2008-12-28T08:40:50+13:00 [<ffffffffa00b13a0>] ? 
nilfs_get_block+0x0/0x240 [nilfs2]
2008-12-28T08:40:50+13:00 [<ffffffffa00b022a>] nilfs_readpages+0x1a/0x20 
[nilfs2]
2008-12-28T08:40:50+13:00 RIP  [<ffffffffa00b85a9>] 
nilfs_btree_do_lookup+0x249/0x260 [nilfs2]
2008-12-28T08:40:52+13:00 nilfs_cleanerd[5063]: wake up
2008-12-28T08:40:52+13:00 nilfs_cleanerd[5063]: ncleansegs = 245
2008-12-28T08:40:52+13:00 nilfs_cleanerd[5063]: 2 segments selected to 
be cleaned
2008-12-28T08:54:30+13:00 NILFS warning (device dm-64): 
nilfs_sync_super: barrier-based sync failed. disabling barriers
2008-12-28T08:59:06+13:00 kernel BUG at 
/var/git/nilfs2-module/fs/btree.c:503!
2008-12-28T08:59:06+13:00 Modules linked in: nilfs2 iscsi_trgt reiserfs 
ohci_hcd lpfc qla2xxx scsi_wait_scan
2008-12-28T08:59:06+13:00 RIP: 0010:[<ffffffffa00cd5a9>]  
[<ffffffffa00cd5a9>] nilfs_btree_do_lookup+0x249/0x260 [nilfs2]
2008-12-28T08:59:06+13:00 [<ffffffffa00ced58>] 
nilfs_btree_lookup+0x68/0xb0 [nilfs2]
2008-12-28T08:59:06+13:00 [<ffffffffa00cc8c4>] 
nilfs_bmap_lookup_at_level+0x44/0x90 [nilfs2]
2008-12-28T08:59:06+13:00 [<ffffffffa00cc92a>] 
nilfs_bmap_lookup+0x1a/0x40 [nilfs2]
2008-12-28T08:59:06+13:00 [<ffffffffa00c6442>] 
nilfs_get_block+0xa2/0x240 [nilfs2]
2008-12-28T08:59:06+13:00 [<ffffffffa00caa7c>] ? 
nilfs_grab_buffer+0x7c/0x160 [nilfs2]
2008-12-28T08:59:06+13:00 [<ffffffffa00c63a0>] ? 
nilfs_get_block+0x0/0x240 [nilfs2]
2008-12-28T08:59:06+13:00 [<ffffffffa00c63a0>] ? 
nilfs_get_block+0x0/0x240 [nilfs2]
2008-12-28T08:59:06+13:00 [<ffffffffa00c522a>] nilfs_readpages+0x1a/0x20 
[nilfs2]
2008-12-28T08:59:06+13:00 RIP  [<ffffffffa00cd5a9>] 
nilfs_btree_do_lookup+0x249/0x260 [nilfs2]

I've switched back to xfs in the mean time.

--John
