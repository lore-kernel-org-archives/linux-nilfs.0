From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Problem report: cannot run nilfs_cleanerd on full filesystem
Date: Sat, 19 Mar 2011 17:37:59 +0100
Message-ID: <201103191738.00187.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:user-agent:x-face
         :mime-version:content-type:content-transfer-encoding:message-id;
        bh=sWU8+m/b7ADKnzTTG8drSNz/mr+aN49YKqCn3AIbT0I=;
        b=E8K7jipvusVQBBUKF/zmmKeE0+zjKNNeCPzonlV7wzhYXdCcSSG3UbW50DzittAFdJ
         pxqDNkf0bMPLXUeMVzt0u6GJfLgGxc4o5wm/ifb1XB6bC/eGIOk5AJ8MgDdDizmeGwuy
         f+BAuvzrmmPpfhyX4ClERRjZE/A3bLHNoPFXw=
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

It seems on a completely filled filesystem nilfs_cleanerd cannot be started
(nor other utilities that rely on the same libnilfs nilfs_open() function).

This is seriously troubling because removing some files does not free up the space
(per NILFS2 design), so it looks like there is no way to use this filesystem ever again,
at least without manual intervetion into on-disk metadata.


strace shows the following:

blitz!root!/tmp# strace -f /sbin/nilfs_cleanerd /dev/sda1 /mnt/x -p 2
(...lotsa normal output...)
open("/mnt/x/.nilfs", O_RDWR|O_CREAT, 0666) = -1 ENOSPC (No space left on device)
close(4)                                = 0
sendto(3, "<27>Mar 19 17:27:42 nilfs_cleane"..., 97, MSG_NOSIGNAL, NULL, 0) = 97
sendto(3, "<27>Mar 19 17:27:42 nilfs_cleane"..., 102, MSG_NOSIGNAL, NULL, 0) = 102
sendto(3, "<30>Mar 19 17:27:42 nilfs_cleane"..., 50, MSG_NOSIGNAL, NULL, 0) = 50
close(3)                                = 0
exit_group(1)                           = ?
Process 8111 detached


The nilfs_cleanerd exits quietly, without any indication of trouble.
I guess solution ought to be two-prong: open NILFS before daemonize()
and make it possible for nilfs_cleanerd to open filesystem at all when full.


To make it clear: if the nilfs_cleanerd is *running*, it will work *OK*. But
any attempt to start nilfs_cleanerd on full filesystem will fail -- for example
on system boot.


-- 
dexen deVries

``One can't proceed from the informal to the formal by formal means.''
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
