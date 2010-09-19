From: David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
Subject: nilfs error
Date: Sun, 19 Sep 2010 07:36:56 +0200
Message-ID: <4C95A178.3020701@prnet.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

  Hi,

yesterday I had the following error:

Sep 18 18:03:24 server kernel: NILFS: bad btree node 
(blocknr=226497086): level
= 37, flags = 0x18, nchildren = 22092
Sep 18 18:03:24 server kernel: NILFS error (device sdb1): 
nilfs_truncate_bmap: b
map is broken (ino=69)
Sep 18 18:03:24 server kernel: Remounting filesystem read-only
Sep 18 18:03:24 server kernel: nilfs_palloc_commit_free_entry: entry 
number 69 already freed

Remounting the filesytem worked correctly. What could be the cause of 
this error ? Should I preventively reformat the disk and recreate the 
filesystem ?

Thanks in advance
Bye,
David Arendt
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
