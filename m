From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [ANNOUNCE] NILFS utils 2.1.6 release
Date: Mon, 27 Jan 2014 12:40:31 +0900 (JST)
Message-ID: <20140127.124031.27803061.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


nilfs-utils-2.1.6 was released on:

 http://www.nilfs.org/en/download.html

Main changes from nilfs-utils-2.1.5 are as follows:

 * cleanerd related fixes and improvements 
   - fix wrong cleaner speed of manual clean mode
   - cleanerd: adjust the OOM killer
   - rework daemonize() of cleanerd
   - cleaner_exec.c: get process ID of cleanerd through pipe
 * lib/nilfs.c fixes:
   - add missing initializations of ioctl arguments
   - remove broken readonly fs check at nilfs_sync()
   - add missing comments of API functions
 * mkfs
   - check sizes of important structs at build time
 * build related changes:
   - allow to make without libblkid
   - compile legacy {mount,umount}.nilfs2 with libselinux
   - add --with-libmount build option
 * fix many coding style issues

Please see the following changelog for details:

 http://www.nilfs.org/download/ChangeLog-utils-v2


Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
