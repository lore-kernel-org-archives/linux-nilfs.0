From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: nilfs_cleanerd doesn't get started when /etc/mtab is a symlink
Date: Sat, 18 Jun 2011 01:08:58 +0900 (JST)
Message-ID: <20110618.010858.91423049.ryusuke@osrg.net>
References: <4DFA6E23.6040700@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DFA6E23.6040700-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Eric,
On Thu, 16 Jun 2011 15:57:07 -0500, Eric Sandeen wrote:
> https://bugzilla.redhat.com/show_bug.cgi?id=701735
> 
> From the bug:
> 
> > # mount -t nilfs2 /dev/nbd1 /media/fedora/src
> > mount.nilfs2: cannot modify /etc/mtab.
> > Please remount the partition with -f option after making /etc/mtab writable.
> > nilfs_cleanerd not started
> > 
> > But /etc/mtab is now a symlink, which just exists for the benefit of legacy
> > code which expects to be able to read it.
> 
> Any suggestions?  (/etc/mtab is now a symlink to /proc/partitions)

Thank you for letting me know this.

The problem is mount/umount helper programs of nilfs2 are using a few
userspace mount options like "uhelper=" option; these userspace
options ("gcpid=", "pp=", and "nogc" options in the case of nilfs)
required modifying mtab.

I will consider eliminating them before upcoming nilfs-utils-2.1
release.


Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
