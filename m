From: Peter Volkov <pva-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Subject: nilfs_cleanerd doesn't get started when /etc/mtab is a symlink to 
 /proc/self/mounts
Date: Sat, 12 Oct 2013 21:12:56 +0400
Message-ID: <1381597976.9351.22.camel@i7>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi. 

nifs_cleanerd doesn't get started when /etc/mtab is a symlink
to  /proc/self/mounts:
# mount -f -o remount /
mount.nilfs2: cannot modify /etc/mtab.
Please remount the partition with -f option after making /etc/mtab
writable.
nilfs_cleanerd not started

This is now real problem as most (all?) distributions are moving or
moved toward having /etc/mtab being symlink:
Fedora already did this. 
Debian: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=494001
Gentoo: https://bugs.gentoo.org/show_bug.cgi?id=477498

This was already discussed
http://marc.info/?l=linux-nilfs&m=130832696129454&w=2 and it was planed
for 2.1 but this is still an issue with 2.1.5. Do you have any idea when
this change will happen? Thanks.

--
Peter.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
