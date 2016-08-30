From: mikael-m2T68/X/qvZAfugRpC6u6w@public.gmane.org
Subject: nilfs_cleanerd not running
Date: Tue, 30 Aug 2016 22:01:09 +0200
Message-ID: <2a90bda59a98d4f35e8dbab5534c014e@fripost.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fripost.org; h=
        user-agent:message-id:subject:subject:from:from:date:date
        :content-transfer-encoding:content-type:content-type
        :mime-version; s=20140703; t=1472587275; x=1474401676; bh=nzRwlu
        Oc5NmrsF2d6qz773ja4yRs1FvuTEl7BvwjF9M=; b=0tQTRtWOEg318xX2G3t7v+
        gxYtWQ+4VoJyMuf7sN4+Xdxx8D8E3R7ieMnbVnAm5fJueJ3mobs4y+dC9oDRDjTS
        V/nB9pk0P4dSwvwS+TgIg14LaZzk2ZbsFxgN5CfNxu1uNCD3teLLkm+GDgx5dcy/
        lGyBAJ5PFf4yxLMHzXFBs=
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

It seems my NILFS is not garbage collected. The other day I was not able 
to boot up my NixOS due to a full disk. I booted on a USB stick and ran 
nilfs-clean which freed about 20 Gbytes. I suppose there should always 
be a process nilfs_cleanerd running on a system in order to clean up old 
check points. I have actually not read on the NILFS web site that 
nilfs_cleanerd should be running normally, but maybe I have missed this. 
Should it not be running normally?

When I am running nilfs-clean on my device, I get:

'No cleaner found on /dev/dm-0.'

mount | grep nilfs gives:

/dev/mapper/cryptroot on / type nilfs2 (rw,relatime)
/dev/mapper/cryptroot on /nix/store type nilfs2 (ro,relatime)

nilfs-clean -V gives:

nilfs-clean version 2.2.3

I am only able to run nilfs_cleanerd after setting LD_LIBRARY_PATH to 
/nix/store/*-nilfs-utils-2.2.3/lib

nilfs_cleanerd /dev/mapper/cryptroot
NILFS_CLEANERD_PID=24468

It seems however like the process terminates since there does not seem 
to exist any process when running 'ps aux | grep nilfs'

When trying 'sudo mount -t nilfs2 -o remount,pp=1 /dev/mapper/cryptroot 
/', I get:

/nix/store/y0ldq0j9qpax23d6g5iww7nz17xgx32q-nilfs-utils-2.2.3/sbin/nilfs_cleanerd: 
error while loading shared libraries: libnilfs.so.0: cannot open shared 
object file: No such file or directory
mount.nilfs2: Warning: cannot get pid of cleanerd
mount.nilfs2: cannot modify /etc/mtab.
Please remount the partition with -f option after making /etc/mtab 
writable.

I am running NixOS 16.03

'uname -r' gives:
4.4.14

Any ideas?

Thanks in advance.

Kind regards,

Mikael Andersson
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
