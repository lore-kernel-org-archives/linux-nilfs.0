From: Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: nilfs_cleanerd doesn't get started when /etc/mtab is a symlink
Date: Thu, 16 Jun 2011 15:57:07 -0500
Message-ID: <4DFA6E23.6040700@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

https://bugzilla.redhat.com/show_bug.cgi?id=701735

From the bug:

> # mount -t nilfs2 /dev/nbd1 /media/fedora/src
> mount.nilfs2: cannot modify /etc/mtab.
> Please remount the partition with -f option after making /etc/mtab writable.
> nilfs_cleanerd not started
> 
> But /etc/mtab is now a symlink, which just exists for the benefit of legacy
> code which expects to be able to read it.

Any suggestions?  (/etc/mtab is now a symlink to /proc/partitions)

Thanks,
-Eric
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
