From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: error on kernel 2.6.29 while running cleaner on a
 1tb volume
Date: Fri, 27 Mar 2009 14:58:31 +0900 (JST)
Message-ID: <20090327.145831.16149916.ryusuke@osrg.net>
References: <49C9BF81.6090203@prnet.org>
	<20090326.021932.61004088.ryusuke@osrg.net>
	<49CC6193.9040900@prnet.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <49CC6193.9040900-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org

Hi David,

On Fri, 27 Mar 2009 05:18:11 +0000, David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org> wrote:
> Hi,
> 
> There seems to be some bug in the kernel. On another partition 
> reformatted on week ago, I had again the following error:
> 
> NILFS error (device sda3): nilfs_check_page: bad entry in directory 
> #28261: unaligned directory entry - offset=4096, inode=1647255843, 
> rec_len=29537, name_len=104
> NILFS error (device sda3): nilfs_check_page: bad entry in directory 
> #28261: unaligned directory entry - offset=4096, inode=1647255843, 
> rec_len=29537, name_len=104
> NILFS warning (device sda3): nilfs_ifile_get_inode_block: unable to read 
> inode: 42880
<snip>
> NILFS warning (device sda3): nilfs_ifile_get_inode_block: unable to read 
> inode: 42910
> NILFS warning (device sda3): nilfs_ifile_get_inode_block: unable to read 
> inode: 42911
> init_special_inode: bogus i_mode (35070)
> init_special_inode: bogus i_mode (30055)
<snip>
> init_special_inode: bogus i_mode (36504)

Uum, this time, ifile (i.e. inode index file) seems to be broken.

Do you think probability of the fault depends on the kernel version?

And, is it reproducible after umount(or reboot) and mount -i (= mount
without GC) ?

We partially succeeded to reproduce corrpution under a near disk full
condition, and are trying to narrow down the occurrence condition.  I
now suspect cache coherence violation between GC cache and regular
page caches, but it's uncorroborated so far.

With regards,
Ryusuke Konishi
