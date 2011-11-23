From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [ANNOUNCE] NILFS utils 2.1.0 release
Date: Thu, 24 Nov 2011 02:46:45 +0900 (JST)
Message-ID: <20111124.024645.55859510.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

nilfs-utils-2.1.0 was released and became available on:

 http://www.nilfs.org/en/download.html

This is the first stable release of 2.1 series.  Changes from the rc2
release are just a few, a build error fix and amendments of README
file; I decided to pass some unfinished tasks for now not to delay the
stable version release any further.

Changes from 2.0 series are as follows:

 * add libmount support.
 * add nilfs-clean program.
 * add nilfs-resize program.
 * nilfs_cleanerd: allow subsecond values for time interval parameters.
 * lscp: hide internal checkpoint by default and add all option to
   show them.
 * libnilfs: add APIs for filesystem resizing
 * separate one shot garbage collection function to libnilfsgc library.
 * add libnilfscleaner library which gives control function of
   cleaner daemon.
 * nilfs_cleanerd: fix overflow of time out value.
 * nilfs_cleanerd: fix move block errors on cpfile and sufile.
 * automate selection of libraries for posix semaphore and mqueue.
 * fix autoreconf error caused by a lack of m4 directory.
 * update README file.

For details, see the changelog at:

 http://www.nilfs.org/download/ChangeLog-utils-v2


Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
