From: David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
Subject: Re: nilfs_check_page: bad entry in directory #37945
Date: Mon, 16 Mar 2009 23:17:03 +0100
Message-ID: <49BECFDF.1060802@prnet.org>
References: <49BE2765.2050200@prnet.org>	<20090317.000905.79144599.ryusuke@osrg.net>
	<20090317.002333.93458556.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020009070903000608030902"
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090317.002333.93458556.ryusuke-sG5X7nlA6pw@public.gmane.org>
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

This is a multi-part message in MIME format.
--------------020009070903000608030902
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,

The volume is now restored from a backup of yesterday. As there have
been no changes since then, no data has been lost. I also tried to do a
tar of the nilfs volume having errors in order to see how this failed
partition would be handled. The partition had 13 gb of data and the tar
file keeped growing, I cancelled at 46 gb, so I think there was a loop
in here somewhere. I also received numerous nilfs related error
messages. I have attached them to the end of this mail.
As the backup of yesterday worked flawlessly, the corruption must have
occured today.

As I am doing video editing on nilfs2 filesystems, and so I don't want
the cleaner to interfere with it, I always do mount -i and if I am short
on space, I call the cleaner manually and send it a SIGTERM signal, once
I see no more cleaning activity. I have modified the number of segments
to clean from 2 to 20 in order to speed up cleaning.

As this moring, I had 95% of used space, I called the cleaner manually.
The cleaner seemed to work normally so after there was no more disk
activity, I sent it a SIGTERM signal. As I am running on gentoo, I did
an emerge --sync followed by an emerge --update --deep --ask world, so
there was lots of io on this partition (it was the root one). During
this, the system crashed completely  without reaction to any key. As I
find no data on this crash in the log files, I can't say if the nilfs
corruption was leading to this crash or if this crash was leading to the
nilfs corruption.

After this crash, I first saw error messages from nilfs.

I did a dd if=/dev/sda3 of=imagefile bs=8192 of the partition prior to
the restore, so if you like to further investigate into this, the
corrupted partition is still mountable via a loop device. If this data
is useless for you, please tell me so, then I will delete the image file.

Bye,
David Arendt

Ryusuke Konishi wrote:
> On Tue, 17 Mar 2009 00:09:05 +0900 (JST), Ryusuke Konishi wrote:
>   
>> Hi David,
>> On Mon, 16 Mar 2009 11:18:13 +0100, David Arendt wrote:
>>     
>>> Hi,
>>>
>>> this morning I discovered this in /var/log/messages
>>>
>>> Mar 16 10:59:00 server NILFS error (device sda3): nilfs_check_page: bad
>>> entry in directory #37945: unaligned directory entry - offset=0,
>>> inode=1919250021, rec_len=14411, name_len=67
>>>
>>> I am using nilfs 2.0.10.
>>>
>>> What should I do about this error ? Should I ignore it or should special
>>> care be taken about it ?
>>>
>>>       
>> offset=0 --> first entry of the directory.
>> inode=1919250021 --> unnatural inode number. seems invalid.
>> rec_len=14411 --> invalid.
>>
>> So, this directory is completely broken. Maybe b-tree of the directory
>> is pointing to a wrong block.
>>
>> Is this reproducible by umount/mount and ls -R ?
>>     
>
> The directory's inode number was shown in the log!
> You can find it by:
>
>  $ find /mount-dir -inum 37945 -ls
>
>
> Regards,
> Ryusuke Konishi
>
>   



--------------020009070903000608030902
Content-Type: text/plain;
 name="messages"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="messages"

Mar 16 18:12:52 server NILFS error (device sda3): nilfs_check_page: bad entry in directory #37945: unaligned directory entry - offset=0, inode=1919250021, rec_len=14411, name_len=67
Mar 16 18:12:52 server NILFS error (device sda3): nilfs_readdir: bad page in #37945
Mar 16 18:14:19 server NILFS error (device sda3): nilfs_check_page: bad entry in directory #37945: unaligned directory entry - offset=0, inode=1919250021, rec_len=14411, name_len=67
Mar 16 18:14:19 server NILFS error (device sda3): nilfs_readdir: bad page in #37945
Mar 16 18:15:08 server NILFS error (device sda3): nilfs_readdir: bad page in #37945
Mar 16 18:16:58 server ntpd[5351]: synchronized to 80.92.79.12, stratum 2
Mar 16 18:16:58 server ntpd[5351]: kernel time sync status change 0001
Mar 16 18:20:01 server cron[5826]: (root) CMD (test -x /usr/sbin/run-crons && /usr/sbin/run-crons )
Mar 16 18:20:21 server login[5739]: pam_unix(login:session): session opened for user root by LOGIN(uid=0)
Mar 16 18:20:21 server login[5838]: ROOT LOGIN  on 'tty2'
Mar 16 18:26:27 server NILFS: The specified checkpoint is not a snapshot (checkpoint number=579013).
Mar 16 18:28:09 server NILFS error (device sda3): nilfs_check_page: bad entry in directory #1476: directory entry across blocks - offset=0, inode=1666168340, rec_len=53456, name_len=185
Mar 16 18:28:09 server NILFS error (device sda3): nilfs_readdir: bad page in #1476
Mar 16 18:30:01 server cron[5875]: (root) CMD (test -x /usr/sbin/run-crons && /usr/sbin/run-crons )
Mar 16 18:30:17 server NILFS error (device sda3): nilfs_check_page: bad entry in directory #37945: unaligned directory entry - offset=0, inode=1919250021, rec_len=14411, name_len=67
Mar 16 18:30:17 server NILFS error (device sda3): nilfs_readdir: bad page in #37945
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<c015911b>] page_address+0xcb/0xd0
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<c014d18a>] find_or_create_page+0x2a/0x90
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<f832fedd>] __nilfs_get_page_block+0x3d/0x80 [nilfs2]
Mar 16 18:32:48 server [<c0195a4f>] do_mpage_readpage+0x3ff/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f833232f>] nilfs_bmap_read+0x9f/0x150 [nilfs2]
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c016eb7e>] do_sys_open+0xbe/0xf0
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 0 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8332e26>] nilfs_btree_do_lookup+0x286/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c018d9be>] all+0x7e/0xfd0/0x [nil [<c01832c1b297>5cfe>] fs_gealloc_pages_internal+03232f]
Mar 16 18:32:48 server []
Mar 16 18:32:48 server [<adahelfs_g015300x2b/read+nc_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_ope/0x136360vfs_rexf0
Mar 16 17:32:47 server unparseable log message: "<[<c01ll+0x1>Pid:4>Callookup+_btrelfs_bmap_l [<f84> [<4> [<[nilf550"
Mar 16 17:32:47 server unparseable log message: "<fs2]"
Mar 16 18:32:48 server xc0
Mar 16 17:32:47 server unparseable log message: "<4[<f830150733232f>32b1a152c9b>] __do_page_cac0x230/0x1e0 adahead+0neric01705c017a<4> [0/0x5x130"
Mar 16 18:32:48 server [<c016eb7e>] do_sys_open+0xbe/0xf0
Mar 16 18:32:48 server [<c01704c0>] dread+0031d5>] l mismatcserverdo_los_btrlfs_btreef8331ffs2]
Mar 16 17:32:47 server unparseable log message: "<4ilfs26/0x1e0 [n+0x7e1d0/0[nilfx550"
Mar 16 18:32:48 server ]
Mar 16 18:32:48 server 0
Mar 16 18:32:48 server [32c1f015074b>] __alloc_pag30
Mar 16 17:32:47 server unparseable log message: "<4x150 [n0x20 [niage_c832c1fs2]"
Mar 16 18:32:48 server c_reaic_fi0587>] do_sync_read+0xc7/0x110p_o720
Mar 16 17:32:47 server unparseable log message: "<4<c0170e5_open[<c017ll+0x1>Pid:4>Callookup+_btrelfs_bmap_l [<f84> [<f84> [<[nilfs550"
Mar 16 17:32:47 server unparseable log message: "<fs2]"
Mar 16 18:32:48 server xc0
Mar 16 17:32:47 server unparseable log message: "<4[<f830150733232f>32b1a152c9b>] __do_page0x230/0x1e0 adahead+0neric01705c017a<4> [0/0x50x130"
Mar 16 18:32:48 server [<c016eb7e>] do_sys_open+0xbe/0xf0
Mar 16 18:32:48 server [<c01704c0>] dread+0031d5>] l mism tains_btr<4> [
Mar 16 18:32:48 server nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_levl+0x3kup+0x2ock+0page_ull_pag+0x0/0xage_rblock+ add_] mpage_readpa0>] n [<c015 [<f8332150 [dpage] __d230
Mar 16 17:32:47 server unparseable log message: "<e0 [n_sync_readahead+0x2b/0x30"
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c016eb7e>] do_sys_open+0xbe/0xf0
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 0 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c0195a4f>] do_mpage_readpage+0x3ff/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f833232f>] nilfs_bmap_read+0x9f/0x150 [nilfs2]
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c016eb7e>] do_sys_open+0xbe/0xf0
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 0 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8332e26>] nilfs_btree_do_lookup+0x286/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c018d9be>] alloc_page_buffers+0x7e/0xf0
Mar 16 18:32:48 server [<c01907d0>] block_read_full_page+0x1d0/0x2c0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c019599e>] do_mpage_readpage+0x34e/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f833232f>] nilfs_bmap_read+0x9f/0x150 [nilfs2]
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c016eb7e>] do_sys_open+0xbe/0xf0
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 0 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c0195a4f>] do_mpage_readpage+0x3ff/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f833232f>] nilfs_bmap_read+0x9f/0x150 [nilfs2]
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c016eb7e>] do_sys_open+0xbe/0xf0
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 0 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8332e26>] nilfs_btree_do_lookup+0x286/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c018d9be>] alloc_pac014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c016eb7e>] do_sys_open+0xbe/0xf0
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 111 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8332e26>] nilfs_btree_do_lookup+0x286/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c018d9be>] alloc_page_buffers+0x7e/0xf0
Mar 16 18:32:48 server [<c01907d0>] block_read_full_page+0x1d0/0x2c0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c019599e>] do_mpage_readpage+0x34e/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f833232f>] nilfs_bmap_read+0x9f/0x150 [nilfs2]
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c016eb7e>] do_sys_open+0xbe/0xf0
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 111 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c0195a4f>] do_mpage_readpage+0x3ff/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f833232f>] nilfs_bmap_read+0x9f/0x150 [nilfs2]
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c016eb7e>] do_sys_open+0xbe/0xf0
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 111 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8332e26>] nilfs_btree_do_lookup+0x286/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c018d9be>] alloc_page_buffers+0x7e/0xf0
Mar 16 18:32:48 server [<c01907d0>] block_read_full_page+0x1d0/0x2c0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c019599e>] do_mpage_readpage+0x34e/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f833232f>] nilfs_bmap_read+0x9f/0x150 [nilfs2]
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c016eb7e>] do_sys_open+0xbe/0xf0
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 111 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c0195a4f>] do_mpage_readpage+0x3ff/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f833232f>] nilfs_bmap_read+0x9f/0x150 [nilfs2]
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c016eb7e>] do_sys_open+0xbe/0xf0
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 111 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8332e26>] nilfs_btree_do_lookup+0x286/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c018d9be>] alloc_page_buffers+0x7e/0xf0
Mar 16 18:32:48 server [<c01907d0>] block_read_full_page+0x1d0/0x2c0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c019599e>] do_mpage_readpage+0x34e/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f833232f>] nilfs_bmap_read+0x9f/0x150 [nilfs2]
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c016eb7e>] do_sys_open+0xbe/0xf0
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 111 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<c018d9be>] alloc_page_buffers+0x7e/0xf0
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<c0119bbc>] kmap_atomic+0x1c/0x30
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01907d0>] block_read_full_page+0x1d0/0x2c0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c019599e>] do_mpage_readpage+0x34e/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<f833232f>] nilfs_bmap_read+0x9f/0x150 [nilfs2]
Mar 16 18:32:48 server [<c0195bde>] mpage_readpage+0x3e/0x60
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014ae90>] find_get_page+0x30/0xc0
Mar 16 18:32:48 server [<c014cb7b>] generic_file_aio_read+0x28b/0x670
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c016eb7e>] do_sys_open+0xbe/0xf0
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 111 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<c014d18a>] find_or_create_page+0x2a/0x90
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<f832fedd>] __nilfs_get_page_block+0x3d/0x80 [nilfs2]
Mar 16 18:32:48 server [<c0195a4f>] do_mpage_readpage+0x3ff/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f833232f>] nilfs_bmap_read+0x9f/0x150 [nilfs2]
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c016eb7e>] do_sys_open+0xbe/0xf0
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 0 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8332e26>] nilfs_btree_do_lookup+0x286/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c018d9be>] alloc_page_buffers+0x7e/0xf0
Mar 16 18:32:48 server [<c01907d0>] block_read_full_page+0x1d0/0x2c0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c019599e>] do_mpage_readpage+0x34e/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f833232f>] nilfs_bmap_read+0x9f/0x150 [nilfs2]
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c016eb7e>] do_sys_open+0xbe/0xf0
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 0 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c0195a4f>] do_mpage_readpage+0x3ff/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f833232f>] nilfs_bmap_read+0x9f/0x150 [nilfs2]
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c016eb7e>] do_sys_open+0xbe/0xf0
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 0 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8332e26>] nilfs_btree_do_lookup+0x286/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c018d9be>] alloc_page_buffers+0x7e/0xf0
Mar 16 18:32:48 server [<c01907d0>] block_read_full_page+0x1d0/0x2c0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c019599e>] do_mpage_readpage+0x34e/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f833232f>] nilfs_bmap_read+0x9f/0x150 [nilfs2]
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c016eb7e>] do_sys_open+0xbe/0xf0
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 0 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c0195a4f>] do_mpage_readpage+0x3ff/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015358c>] __lru_cache_add+0x5c/0x70
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f833232f>] nilfs_bmap_read+0x9f/0x150 [nilfs2]
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c016eb7e>] do_sys_open+0xbe/0xf0
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 0 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8332e26>] nilfs_btree_do_lookup+0x286/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c018d9be>] alloc_page_buffers+0x7e/0xf0
Mar 16 18:32:48 server [<c01907d0>] block_read_full_page+0x1d0/0x2c0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<f832b873>] nilfs_dirty_inode+0x63/0x70 [nilfs2]
Mar 16 18:32:48 server [<c018df8e>] __set_page_dirty+0xce/0x120
Mar 16 18:32:48 server [<c019599e>] do_mpage_readpage+0x34e/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c014c5bf>] generic_file_aio_write+0x5f/0xd0
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 0 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<c018d9be>] alloc_page_buffers+0x7e/0xf0
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<c0119bbc>] kmap_atomic+0x1c/0x30
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<f832b873>] nilfs_dirty_inode+0x63/0x70 [nilfs2]
Mar 16 18:32:48 server [<c018df8e>] __set_page_dirty+0xce/0x120
Mar 16 18:32:48 server [<c01907d0>] block_read_full_page+0x1d0/0x2c0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c019599e>] do_mpage_readpage+0x34e/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c0195bde>] mpage_readpage+0x3e/0x60
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014ae90>] find_get_page+0x30/0xc0
Mar 16 18:32:48 server [<c014cb7b>] generic_file_aio_read+0x28b/0x670
Mar 16 18:32:48 server [<c014c5bf>] generic_file_aio_write+0x5f/0xd0
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 0 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<c015911b>] page_address+0xcb/0xd0
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<c014d18a>] find_or_create_page+0x2a/0x90
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<f832fedd>] __nilfs_get_page_block+0x3d/0x80 [nilfs2]
Mar 16 18:32:48 server [<c0195a4f>] do_mpage_readpage+0x3ff/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f833232f>] nilfs_bmap_read+0x9f/0x150 [nilfs2]
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c016eb7e>] do_sys_open+0xbe/0xf0
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 0 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8332e26>] nilfs_btree_do_lookup+0x286/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c018d9be>] alloc_page_buffers+0x7e/0xf0
Mar 16 18:32:48 server [<c01907d0>] block_read_full_page+0x1d0/0x2c0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015911b>] page_address+0xcb/0xd0
Mar 16 18:32:48 server [<c019599e>] do_mpage_readpage+0x34e/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f833232f>] nilfs_bmap_read+0x9f/0x150 [nilfs2]
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c016eb7e>] do_sys_open+0xbe/0xf0
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 0 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c0195a4f>] do_mpage_readpage+0x3ff/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f833232f>] nilfs_bmap_read+0x9f/0x150 [nilfs2]
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c016eb7e>] do_sys_open+0xbe/0xf0
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 0 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8332e26>] nilfs_btree_do_lookup+0x286/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c018d9be>] alloc_page_buffers+0x7e/0xf0
Mar 16 18:32:48 server [<c01907d0>] block_read_full_page+0x1d0/0x2c0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c019599e>] do_mpage_readpage+0x34e/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f833232f>] nilfs_bmap_read+0x9f/0x150 [nilfs2]
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c016eb7e>] do_sys_open+0xbe/0xf0
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 0 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c0195a4f>] do_mpage_readpage+0x3ff/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f833232f>] nilfs_bmap_read+0x9f/0x150 [nilfs2]
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c016eb7e>] do_sys_open+0xbe/0xf0
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 0 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8332e26>] nilfs_btree_do_lookup+0x286/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c018d9be>] alloc_page_buffers+0x7e/0xf0
Mar 16 18:32:48 server [<c01907d0>] block_read_full_page+0x1d0/0x2c0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c019599e>] do_mpage_readpage+0x34e/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f833232f>] nilfs_bmap_read+0x9f/0x150 [nilfs2]
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c016eb7e>] do_sys_open+0xbe/0xf0
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 0 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c0195a4f>] do_mpage_readpage+0x3ff/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f833232f>] nilfs_bmap_read+0x9f/0x150 [nilfs2]
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c016eb7e>] do_sys_open+0xbe/0xf0
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 0 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8332e26>] nilfs_btree_do_lookup+0x286/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c018d9be>] alloc_page_buffers+0x7e/0xf0
Mar 16 18:32:48 server [<c01907d0>] block_read_full_page+0x1d0/0x2c0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c019599e>] do_mpage_readpage+0x34e/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f833232f>] nilfs_bmap_read+0x9f/0x150 [nilfs2]
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c016eb7e>] do_sys_open+0xbe/0xf0
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 0 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<c018d9be>] alloc_page_buffers+0x7e/0xf0
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<c0119bbc>] kmap_atomic+0x1c/0x30
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01907d0>] block_read_full_page+0x1d0/0x2c0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c019599e>] do_mpage_readpage+0x34e/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<f833232f>] nilfs_bmap_read+0x9f/0x150 [nilfs2]
Mar 16 18:32:48 server [<c0195bde>] mpage_readpage+0x3e/0x60
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014ae90>] find_get_page+0x30/0xc0
Mar 16 18:32:48 server [<c014cb7b>] generic_file_aio_read+0x28b/0x670
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c016eb7e>] do_sys_open+0xbe/0xf0
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 0 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<c015911b>] page_address+0xcb/0xd0
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<c014d18a>] find_or_create_page+0x2a/0x90
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<f832fedd>] __nilfs_get_page_block+0x3d/0x80 [nilfs2]
Mar 16 18:32:48 server [<c0195a4f>] do_mpage_readpage+0x3ff/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f833232f>] nilfs_bmap_read+0x9f/0x150 [nilfs2]
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c016eb7e>] do_sys_open+0xbe/0xf0
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 0 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8332e26>] nilfs_btree_do_lookup+0x286/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c018d9be>] alloc_page_buffers+0x7e/0xf0
Mar 16 18:32:48 server [<c01907d0>] block_read_full_page+0x1d0/0x2c0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015911b>] page_address+0xcb/0xd0
Mar 16 18:32:48 server [<c019599e>] do_mpage_readpage+0x34e/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f833232f>] nilfs_bmap_read+0x9f/0x150 [nilfs2]
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c016eb7e>] do_sys_open+0xbe/0xf0
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 0 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c0195a4f>] do_mpage_readpage+0x3ff/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f833232f>] nilfs_bmap_read+0x9f/0x150 [nilfs2]
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c016eb7e>] do_sys_open+0xbe/0xf0
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 0 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8332e26>] nilfs_btree_do_lookup+0x286/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c018d9be>] alloc_page_buffers+0x7e/0xf0
Mar 16 18:32:48 server [<c01907d0>] block_read_full_page+0x1d0/0x2c0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c019599e>] do_mpage_readpage+0x34e/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f833232f>] nilfs_bmap_read+0x9f/0x150 [nilfs2]
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c016eb7e>] do_sys_open+0xbe/0xf0
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 0 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c0195a4f>] do_mpage_readpage+0x3ff/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f833232f>] nilfs_bmap_read+0x9f/0x150 [nilfs2]
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c016eb7e>] do_sys_open+0xbe/0xf0
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 0 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8332e26>] nilfs_btree_do_lookup+0x286/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c018d9be>] alloc_page_buffers+0x7e/0xf0
Mar 16 18:32:48 server [<c01907d0>] block_read_full_page+0x1d0/0x2c0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c019599e>] do_mpage_readpage+0x34e/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f833232f>] nilfs_bmap_read+0x9f/0x150 [nilfs2]
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c016eb7e>] do_sys_open+0xbe/0xf0
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 0 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c0195a4f>] do_mpage_readpage+0x3ff/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f833232f>] nilfs_bmap_read+0x9f/0x150 [nilfs2]
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c016eb7e>] do_sys_open+0xbe/0xf0
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 0 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8332e26>] nilfs_btree_do_lookup+0x286/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c018d9be>] alloc_page_buffers+0x7e/0xf0
Mar 16 18:32:48 server [<c01907d0>] block_read_full_page+0x1d0/0x2c0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c019599e>] do_mpage_readpage+0x34e/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f833232f>] nilfs_bmap_read+0x9f/0x150 [nilfs2]
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c016eb7e>] do_sys_open+0xbe/0xf0
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 0 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<c018d9be>] alloc_page_buffers+0x7e/0xf0
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<c0119bbc>] kmap_atomic+0x1c/0x30
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01907d0>] block_read_full_page+0x1d0/0x2c0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c019599e>] do_mpage_readpage+0x34e/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<f833232f>] nilfs_bmap_read+0x9f/0x150 [nilfs2]
Mar 16 18:32:48 server [<c0195bde>] mpage_readpage+0x3e/0x60
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014ae90>] find_get_page+0x30/0xc0
Mar 16 18:32:48 server [<c014cb7b>] generic_file_aio_read+0x28b/0x670
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c016eb7e>] do_sys_open+0xbe/0xf0
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 0 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<c015911b>] page_address+0xcb/0xd0
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<f832b7b5>] nilfs_mark_inode_dirty+0x75/0xd0 [nilfs2]
Mar 16 18:32:48 server [<f832b873>] nilfs_dirty_inode+0x63/0x70 [nilfs2]
Mar 16 18:32:48 server [<c018df8e>] __set_page_dirty+0xce/0x120
Mar 16 18:32:48 server [<c0195a4f>] do_mpage_readpage+0x3ff/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c014c5bf>] generic_file_aio_write+0x5f/0xd0
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 0 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8332e26>] nilfs_btree_do_lookup+0x286/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c018d9be>] alloc_page_buffers+0x7e/0xf0
Mar 16 18:32:48 server [<c01907d0>] block_read_full_page+0x1d0/0x2c0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<f832b873>] nilfs_dirty_inode+0x63/0x70 [nilfs2]
Mar 16 18:32:48 server [<c018df8e>] __set_page_dirty+0xce/0x120
Mar 16 18:32:48 server [<c015911b>] page_address+0xcb/0xd0
Mar 16 18:32:48 server [<c019599e>] do_mpage_readpage+0x34e/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c014c5bf>] generic_file_aio_write+0x5f/0xd0
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 0 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<f832b873>] nilfs_dirty_inode+0x63/0x70 [nilfs2]
Mar 16 18:32:48 server [<c018df8e>] __set_page_dirty+0xce/0x120
Mar 16 18:32:48 server [<c0195a4f>] do_mpage_readpage+0x3ff/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015358c>] __lru_cache_add+0x5c/0x70
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c014c5bf>] generic_file_aio_write+0x5f/0xd0
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 0 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8332e26>] nilfs_btree_do_lookup+0x286/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c018d9be>] alloc_page_buffers+0x7e/0xf0
Mar 16 18:32:48 server [<c01907d0>] block_read_full_page+0x1d0/0x2c0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<f832b873>] nilfs_dirty_inode+0x63/0x70 [nilfs2]
Mar 16 18:32:48 server [<c018df8e>] __set_page_dirty+0xce/0x120
Mar 16 18:32:48 server [<c019599e>] do_mpage_readpage+0x34e/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015358c>] __lru_cache_add+0x5c/0x70
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c014c5bf>] generic_file_aio_write+0x5f/0xd0
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 0 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c016d2c9>] cache_alloc_refill+0x169/0x4e0
Mar 16 18:32:48 server [<c0195a4f>] do_mpage_readpage+0x3ff/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c014c5bf>] generic_file_aio_write+0x5f/0xd0
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 0 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8332e26>] nilfs_btree_do_lookup+0x286/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c018d9be>] alloc_page_buffers+0x7e/0xf0
Mar 16 18:32:48 server [<c01907d0>] block_read_full_page+0x1d0/0x2c0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c016d2c9>] cache_alloc_refill+0x169/0x4e0
Mar 16 18:32:48 server [<c019599e>] do_mpage_readpage+0x34e/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c014c5bf>] generic_file_aio_write+0x5f/0xd0
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 0 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c016d2c9>] cache_alloc_refill+0x169/0x4e0
Mar 16 18:32:48 server [<c0195a4f>] do_mpage_readpage+0x3ff/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c014c5bf>] generic_file_aio_write+0x5f/0xd0
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 0 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8332e26>] nilfs_btree_do_lookup+0x286/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c018d9be>] alloc_page_buffers+0x7e/0xf0
Mar 16 18:32:48 server [<c01907d0>] block_read_full_page+0x1d0/0x2c0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c016d2c9>] cache_alloc_refill+0x169/0x4e0
Mar 16 18:32:48 server [<c019599e>] do_mpage_readpage+0x34e/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c014c5bf>] generic_file_aio_write+0x5f/0xd0
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 0 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c016d2c9>] cache_alloc_refill+0x169/0x4e0
Mar 16 18:32:48 server [<c0195a4f>] do_mpage_readpage+0x3ff/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c014c5bf>] generic_file_aio_write+0x5f/0xd0
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 0 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8332e26>] nilfs_btree_do_lookup+0x286/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c018d9be>] alloc_page_buffers+0x7e/0xf0
Mar 16 18:32:48 server [<c01907d0>] block_read_full_page+0x1d0/0x2c0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c016d2c9>] cache_alloc_refill+0x169/0x4e0
Mar 16 18:32:48 server [<c019599e>] do_mpage_readpage+0x34e/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c014c5bf>] generic_file_aio_write+0x5f/0xd0
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 0 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c016d2c9>] cache_alloc_refill+0x169/0x4e0
Mar 16 18:32:48 server [<c0195a4f>] do_mpage_readpage+0x3ff/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c014c5bf>] generic_file_aio_write+0x5f/0xd0
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 0 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8332e26>] nilfs_btree_do_lookup+0x286/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c018d9be>] alloc_page_buffers+0x7e/0xf0
Mar 16 18:32:48 server [<c01907d0>] block_read_full_page+0x1d0/0x2c0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c016d2c9>] cache_alloc_refill+0x169/0x4e0
Mar 16 18:32:48 server [<c019599e>] do_mpage_readpage+0x34e/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c014c5bf>] generic_file_aio_write+0x5f/0xd0
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 0 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c016d2c9>] cache_alloc_refill+0x169/0x4e0
Mar 16 18:32:48 server [<c0195a4f>] do_mpage_readpage+0x3ff/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c014c5bf>] generic_file_aio_write+0x5f/0xd0
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 0 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8332e26>] nilfs_btree_do_lookup+0x286/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c018d9be>] alloc_page_buffers+0x7e/0xf0
Mar 16 18:32:48 server [<c01907d0>] block_read_full_page+0x1d0/0x2c0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c016d2c9>] cache_alloc_refill+0x169/0x4e0
Mar 16 18:32:48 server [<c019599e>] do_mpage_readpage+0x34e/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c014c5bf>] generic_file_aio_write+0x5f/0xd0
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 0 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c016d2c9>] cache_alloc_refill+0x169/0x4e0
Mar 16 18:32:48 server [<c0195a4f>] do_mpage_readpage+0x3ff/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c014c5bf>] generic_file_aio_write+0x5f/0xd0
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 0 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8332e26>] nilfs_btree_do_lookup+0x286/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c018d9be>] alloc_page_buffers+0x7e/0xf0
Mar 16 18:32:48 server [<c01907d0>] block_read_full_page+0x1d0/0x2c0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c016d2c9>] cache_alloc_refill+0x169/0x4e0
Mar 16 18:32:48 server [<c019599e>] do_mpage_readpage+0x34e/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c014c5bf>] generic_file_aio_write+0x5f/0xd0
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 0 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<c018d9be>] alloc_page_buffers+0x7e/0xf0
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<c0119bbc>] kmap_atomic+0x1c/0x30
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c016d2c9>] cache_alloc_refill+0x169/0x4e0
Mar 16 18:32:48 server [<c01907d0>] block_read_full_page+0x1d0/0x2c0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c019599e>] do_mpage_readpage+0x34e/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c0195bde>] mpage_readpage+0x3e/0x60
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014ae90>] find_get_page+0x30/0xc0
Mar 16 18:32:48 server [<c014cb7b>] generic_file_aio_read+0x28b/0x670
Mar 16 18:32:48 server [<c014c5bf>] generic_file_aio_write+0x5f/0xd0
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 0 != 1
Mar 16 18:32:48 server NILFS error (device sda3): nilfs_check_page: bad entry in directory #429208: unaligned directory entry - offset=0, inode=24, rec_len=8698, name_len=0
Mar 16 18:32:48 server NILFS error (device sda3): nilfs_readdir: bad page in #429208
Mar 16 18:32:48 server NILFS error (device sda3): nilfs_check_page: bad entry in directory #429387: unaligned directory entry - offset=0, inode=1836597052, rec_len=29554, name_len=105
Mar 16 18:32:48 server NILFS error (device sda3): nilfs_readdir: bad page in #429387
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<c015911b>] page_address+0xcb/0xd0
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014f586>] __rmqueue_smallest+0xb6/0x120
Mar 16 18:32:48 server [<c014f60e>] __rmqueue+0x1e/0x1d0
Mar 16 18:32:48 server [<c0195a4f>] do_mpage_readpage+0x3ff/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c014c5bf>] generic_file_aio_write+0x5f/0xd0
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 63 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8332e26>] nilfs_btree_do_lookup+0x286/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c018d9be>] alloc_page_buffers+0x7e/0xf0
Mar 16 18:32:48 server [<c01907d0>] block_read_full_page+0x1d0/0x2c0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014f60e>] __rmqueue+0x1e/0x1d0
Mar 16 18:32:48 server [<c015911b>] page_address+0xcb/0xd0
Mar 16 18:32:48 server [<c019599e>] do_mpage_readpage+0x34e/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c014c5bf>] generic_file_aio_write+0x5f/0xd0
Mar 16 18:32:48 server [<c01705ilp_openunctioc01701/0x70NILFSmm: tTrace:
Mar 16 18:32:48 server a/0x2+0x60/0ilfs_> [<f<4> [<f<4> [< [nil[<c0132c1f0>]014b25cfe>lfs_getlloc_fs_readpado_page<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server b/0x30
Mar 16 17:32:47 server unparseable log message: "<4aio_rneric<c01717afbc0136360>] autoremove_wake_function+0x0/0x50"
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x0171201>]do_cach: 6#3
Mar 16 17:32:47 server unparseable log message: "<4s_btr] nil6>] ni[nilfel+0xokup+0xlock+_pagefull_page+0xfs_gemqueuege_reblock+0x0age_cac>] mp0>] nilf4b>] __al0"
Mar 16 18:32:48 server x20 [age_cf0>] nilf<4> [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c014c5bf>] generic_file_aio_write+0x5f/0xd0
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 63 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014f60e>] __rmqueue+0x1e/0x1d0
Mar 16 18:32:48 server [<c0195a4f>] do_mpage_readpage+0x3ff/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015358c>] __lru_cache_add+0x5c/0x70
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c014c5bf>] generic_file_aio_write+0x5f/0xd0
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 63 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8332e26>] nilfs_btree_do_lookup+0x286/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c018d9be>] alloc_page_buffers+0x7e/0xf0
Mar 16 18:32:48 server [<c01907d0>] block_read_full_page+0x1d0/0x2c0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014f60e>] __rmqueue+0x1e/0x1d0
Mar 16 18:32:48 server [<c019599e>] do_mpage_readpage+0x34e/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015358c>] __lru_cache_add+0x5c/0x70
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c014c5bf>] generic_file_aio_write+0x5f/0xd0
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 63 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014f60e>] __rmqueue+0x1e/0x1d0
Mar 16 18:32:48 server [<c0195a4f>] do_mpage_readpage+0x3ff/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c014c5bf>] generic_file_aio_write+0x5f/0xd0
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 63 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8332e26>] nilfs_btree_do_lookup+0x286/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c018d9be>] alloc_page_buffers+0x7e/0xf0
Mar 16 18:32:48 server [<c01907d0>] block_read_full_page+0x1d0/0x2c0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014f60e>] __rmqueue+0x1e/0x1d0
Mar 16 18:32:48 server [<c019599e>] do_mpage_readpage+0x34e/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c014c5bf>] generic_file_aio_write+0x5f/0xd0
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 63 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014f60e>] __rmqueue+0x1e/0x1d0
Mar 16 18:32:48 server [<c0195a4f>] do_mpage_readpage+0x3ff/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c014c5bf>] generic_file_aio_write+0x5f/0xd0
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 63 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8332e26>] nilfs_btree_do_lookup+0x286/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c018d9be>] alloc_page_buffers+0x7e/0xf0
Mar 16 18:32:48 server [<c01907d0>] block_read_full_page+0x1d0/0x2c0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014f60e>] __rmqueue+0x1e/0x1d0
Mar 16 18:32:48 server [<c019599e>] do_mpage_readpage+0x34e/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c014c5bf>] generic_file_aio_write+0x5f/0xd0
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 63 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014f60e>] __rmqueue+0x1e/0x1d0
Mar 16 18:32:48 server [<c0195a4f>] do_mpage_readpage+0x3ff/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c014c5bf>] generic_file_aio_write+0x5f/0xd0
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 63 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8332e26>] nilfs_btree_do_lookup+0x286/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c018d9be>] alloc_page_buffers+0x7e/0xf0
Mar 16 18:32:48 server [<c01907d0>] block_read_full_page+0x1d0/0x2c0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014f60e>] __rmqueue+0x1e/0x1d0
Mar 16 18:32:48 server [<c019599e>] do_mpage_readpage+0x34e/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c014c5bf>] generic_file_aio_write+0x5f/0xd0
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 63 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014f60e>] __rmqueue+0x1e/0x1d0
Mar 16 18:32:48 server [<c0195a4f>] do_mpage_readpage+0x3ff/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c014c5bf>] generic_file_aio_write+0x5f/0xd0
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 63 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8332e26>] nilfs_btree_do_lookup+0x286/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c018d9be>] alloc_page_buffers+0x7e/0xf0
Mar 16 18:32:48 server [<c01907d0>] block_read_full_page+0x1d0/0x2c0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014f60e>] __rmqueue+0x1e/0x1d0
Mar 16 18:32:48 server [<c019599e>] do_mpage_readpage+0x34e/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c014c5bf>] generic_file_aio_write+0x5f/0xd0
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 63 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<c018d9be>] alloc_page_buffers+0x7e/0xf0
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<c0119bbc>] kmap_atomic+0x1c/0x30
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014f60e>] __rmqueue+0x1e/0x1d0
Mar 16 18:32:48 server [<c01907d0>] block_read_full_page+0x1d0/0x2c0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c019599e>] do_mpage_readpage+0x34e/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c0195bde>] mpage_readpage+0x3e/0x60
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014ae90>] find_get_page+0x30/0xc0
Mar 16 18:32:48 server [<c014cb7b>] generic_file_aio_read+0x28b/0x670
Mar 16 18:32:48 server [<c014c5bf>] generic_file_aio_write+0x5f/0xd0
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 63 != 1
Mar 16 18:32:48 server NILFS error (device sda3): nilfs_check_page: bad entry in directory #429422: unaligned directory entry - offset=0, inode=1836597052, rec_len=29554, name_len=105
Mar 16 18:32:48 server NILFS error (device sda3): nilfs_readdir: bad page in #429422
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<c014d18a>] find_or_create_page+0x2a/0x90
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<f832fedd>] __nilfs_get_page_block+0x3d/0x80 [nilfs2]
Mar 16 18:32:48 server [<c0195a4f>] do_mpage_readpage+0x3ff/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015358c>] __lru_cache_add+0x5c/0x70
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f833232f>] nilfs_bmap_read+0x9f/0x150 [nilfs2]
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c016eb7e>] do_sys_open+0xbe/0xf0
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 63 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8332e26>] nilfs_btree_do_lookup+0x286/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c018d9be>] alloc_page_buffers+0x7e/0xf0
Mar 16 18:32:48 server [<c01907d0>] block_read_full_page+0x1d0/0x2c0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c019599e>] do_mpage_readpage+0x34e/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015358c>] __lru_cache_add+0x5c/0x70
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f833232f>] nilfs_bmap_read+0x9f/0x150 [nilfs2]
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c016eb7e>] do_sys_open+0xbe/0xf0
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 63 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c0195a4f>] do_mpage_readpage+0x3ff/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f833232f>] nilfs_bmap_read+0x9f/0x150 [nilfs2]
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c016eb7e>] do_sys_open+0xbe/0xf0
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 63 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8332e26>] nilfs_btree_do_lookup+0x286/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c018d9be>] alloc_page_buffers+0x7e/0xf0
Mar 16 18:32:48 server [<c01907d0>] block_read_full_page+0x1d0/0x2c0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c019599e>] do_mpage_readpage+0x34e/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f833232f>] nilfs_bmap_read+0x9f/0x150 [nilfs2]
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c016eb7e>] do_sys_open+0xbe/0xf0
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 63 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c0195a4f>] do_mpage_readpage+0x3ff/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015358c>] __lru_cache_add+0x5c/0x70
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f833232f>] nilfs_bmap_read+0x9f/0x150 [nilfs2]
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c016eb7e>] do_sys_open+0xbe/0xf0
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 63 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8332e26>] nilfs_btree_do_lookup+0x286/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c018d9be>] alloc_page_buffers+0x7e/0xf0
Mar 16 18:32:48 server [<c01907d0>] block_read_full_page+0x1d0/0x2c0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c019599e>] do_mpage_readpage+0x34e/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015358c>] __lru_cache_add+0x5c/0x70
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f833232f>] nilfs_bmap_read+0x9f/0x150 [nilfs2]
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c016eb7e>] do_sys_open+0xbe/0xf0
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 63 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c0195a4f>] do_mpage_readpage+0x3ff/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f833232f>] nilfs_bmap_read+0x9f/0x150 [nilfs2]
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c016eb7e>] do_sys_open+0xbe/0xf0
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 63 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<f8332e26>] nilfs_btree_do_lookup+0x286/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c018d9be>] alloc_page_buffers+0x7e/0xf0
Mar 16 18:32:48 server [<c01907d0>] block_read_full_page+0x1d0/0x2c0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c019599e>] do_mpage_readpage+0x34e/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c0195cfe>] mpage_readpages+0x9e/0xe0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c015074b>] __alloc_pages_internal+0x9b/0x430
Mar 16 18:32:48 server [<f833232f>] nilfs_bmap_read+0x9f/0x150 [nilfs2]
Mar 16 18:32:48 server [<f832b1a0>] nilfs_readpages+0x0/0x20 [nilfs2]
Mar 16 18:32:48 server [<c0152c9b>] __do_page_cache_readahead+0x16b/0x230
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01530db>] page_cache_sync_readahead+0x2b/0x30
Mar 16 18:32:48 server [<c014cdc0>] generic_file_aio_read+0x4d0/0x670
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c016eb7e>] do_sys_open+0xbe/0xf0
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 63 != 1
Mar 16 18:32:48 server Pid: 5869, comm: tar Not tainted 2.6.28.7server #3
Mar 16 18:32:48 server Call Trace:
Mar 16 18:32:48 server [<f8332e0a>] nilfs_btree_do_lookup+0x26a/0x290 [nilfs2]
Mar 16 18:32:48 server [<f8334530>] nilfs_btree_lookup+0x60/0xb0 [nilfs2]
Mar 16 18:32:48 server [<c018d9be>] alloc_page_buffers+0x7e/0xf0
Mar 16 18:32:48 server [<f8331fbf>] nilfs_bmap_lookup_at_level+0x3f/0xa0 [nilfs2]
Mar 16 18:32:48 server [<c0119bbc>] kmap_atomic+0x1c/0x30
Mar 16 18:32:48 server [<f8332049>] nilfs_bmap_lookup+0x29/0x50 [nilfs2]
Mar 16 18:32:48 server [<f832c276>] nilfs_get_block+0x86/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c01907d0>] block_read_full_page+0x1d0/0x2c0
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014b297>] add_to_page_cache_locked+0x87/0xc0
Mar 16 18:32:48 server [<c019599e>] do_mpage_readpage+0x34e/0x550
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<f833232f>] nilfs_bmap_read+0x9f/0x150 [nilfs2]
Mar 16 18:32:48 server [<c0195bde>] mpage_readpage+0x3e/0x60
Mar 16 18:32:48 server [<f832c1f0>] nilfs_get_block+0x0/0x1e0 [nilfs2]
Mar 16 18:32:48 server [<c014ae90>] find_get_page+0x30/0xc0
Mar 16 18:32:48 server [<c014cb7b>] generic_file_aio_read+0x28b/0x670
Mar 16 18:32:48 server [<c0170587>] do_sync_read+0xc7/0x110
Mar 16 18:32:48 server [<c017afb8>] do_filp_open+0x168/0x720
Mar 16 18:32:48 server [<c0136360>] autoremove_wake_function+0x0/0x50
Mar 16 18:32:48 server [<c0170e51>] vfs_read+0xa1/0x130
Mar 16 18:32:48 server [<c016eb7e>] do_sys_open+0xbe/0xf0
Mar 16 18:32:48 server [<c01704c0>] do_sync_read+0x0/0x110
Mar 16 18:32:48 server [<c0171201>] sys_read+0x41/0x70
Mar 16 18:32:48 server [<c01031d5>] sysenter_do_call+0x12/0x25
Mar 16 18:32:48 server NILFS: btree level mismatch: 63 != 1
Mar 16 18:33:10 server init_special_inode: bogus i_mode (35154)
Mar 16 18:33:10 server init_special_inode: bogus i_mode (72156)
Mar 16 18:33:10 server NILFS error (device sda3): nilfs_check_page: bad entry in directory #443787: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0
Mar 16 18:33:10 server NILFS error (device sda3): nilfs_readdir: bad page in #443787
Mar 16 18:33:10 server init_special_inode: bogus i_mode (71474)
Mar 16 18:33:10 server init_special_inode: bogus i_mode (115670)
Mar 16 18:33:11 server NILFS error (device sda3): nilfs_check_page: bad entry in directory #443398: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0
Mar 16 18:33:11 server NILFS error (device sda3): nilfs_readdir: bad page in #443398
Mar 16 18:33:11 server init_special_inode: bogus i_mode (71160)
Mar 16 18:33:11 server init_special_inode: bogus i_mode (36051)
Mar 16 18:33:11 server init_special_inode: bogus i_mode (5076)
Mar 16 18:33:11 server init_special_inode: bogus i_mode (72156)
Mar 16 18:33:11 server init_special_inode: bogus i_mode (70165)
Mar 16 18:33:11 server init_special_inode: bogus i_mode (72553)
Mar 16 18:33:11 server init_special_inode: bogus i_mode (37164)
Mar 16 18:33:14 server nilfs_palloc_commit_free_entry: entry number 292088 already freed
Mar 16 18:33:14 server nilfs_palloc_commit_free_entry: entry number 292122 already freed
Mar 16 18:33:14 server nilfs_palloc_commit_free_entry: entry number 443479 already freed
Mar 16 18:33:14 server nilfs_palloc_commit_free_entry: entry number 443572 already freed
Mar 16 18:33:14 server nilfs_palloc_commit_free_entry: entry number 443630 already freed
Mar 16 18:33:14 server nilfs_palloc_commit_free_entry: entry number 443678 already freed
Mar 16 18:33:14 server nilfs_palloc_commit_free_entry: entry number 443743 already freed
Mar 16 18:33:14 server nilfs_palloc_commit_free_entry: entry number 443951 already freed
Mar 16 18:33:14 server nilfs_palloc_commit_free_entry: entry number 443311 already freed
Mar 16 18:33:14 server nilfs_palloc_commit_free_entry: entry number 443312 already freed
Mar 16 18:33:14 server nilfs_palloc_commit_free_entry: entry number 443313 already freed
Mar 16 18:33:14 server nilfs_palloc_commit_free_entry: entry number 443316 already freed
Mar 16 18:33:14 server nilfs_palloc_commit_free_entry: entry number 443320 already freed
Mar 16 18:33:14 server nilfs_palloc_commit_free_entry: entry number 443323 already freed
Mar 16 18:33:14 server nilfs_palloc_commit_free_entry: entry number 443325 already freed
Mar 16 18:33:14 server nilfs_palloc_commit_free_entry: entry number 443327 already freed
Mar 16 18:33:14 server nilfs_palloc_commit_free_entry: entry number 443349 already freed
Mar 16 18:33:14 server nilfs_palloc_commit_free_entry: entry number 443358 already freed
Mar 16 18:33:14 server nilfs_palloc_commit_free_entry: entry number 443374 already freed
Mar 16 18:33:14 server nilfs_palloc_commit_free_entry: entry number 443377 already freed
Mar 16 18:33:14 server nilfs_palloc_commit_free_entry: entry number 443379 already freed
Mar 16 18:33:14 server nilfs_palloc_commit_free_entry: entry number 443381 already freed
Mar 16 18:33:14 server nilfs_palloc_commit_free_entry: entry number 443385 already freed
Mar 16 18:33:14 server nilfs_palloc_commit_free_entry: entry number 443387 already freed
Mar 16 18:33:14 server nilfs_palloc_commit_free_entry: entry number 443389 already freed
Mar 16 18:33:14 server nilfs_palloc_commit_free_entry: entry number 443483 already freed
Mar 16 18:33:14 server nilfs_palloc_commit_free_entry: entry number 443732 already freed
Mar 16 18:33:14 server nilfs_palloc_commit_free_entry: entry number 443761 already freed
Mar 16 18:33:14 server nilfs_palloc_commit_free_entry: entry number 443559 already freed
Mar 16 18:33:14 server nilfs_palloc_commit_free_entry: entry number 443581 already freed
Mar 16 18:33:14 server nilfs_palloc_commit_free_entry: entry number 443639 already freed
Mar 16 18:33:14 server nilfs_palloc_commit_free_entry: entry number 443646 already freed
Mar 16 18:33:14 server nilfs_palloc_commit_free_entry: entry number 443679 already freed
Mar 16 18:33:14 server nilfs_palloc_commit_free_entry: entry number 443771 already freed
Mar 16 18:33:14 server nilfs_palloc_commit_free_entry: entry number 443836 already freed
Mar 16 18:33:14 server nilfs_palloc_commit_free_entry: entry number 443866 already freed
Mar 16 18:33:14 server nilfs_palloc_commit_free_entry: entry number 443934 already freed
Mar 16 18:33:14 server nilfs_palloc_commit_free_entry: entry number 443962 already freed
Mar 16 18:33:14 server nilfs_palloc_commit_free_entry: entry number 443445 already freed
Mar 16 18:33:14 server nilfs_palloc_commit_free_entry: entry number 443560 already freed
Mar 16 18:33:14 server nilfs_palloc_commit_free_entry: entry number 443644 already freed
Mar 16 18:33:14 server nilfs_palloc_commit_free_entry: entry number 443900 already freed

--------------020009070903000608030902
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--------------020009070903000608030902--
