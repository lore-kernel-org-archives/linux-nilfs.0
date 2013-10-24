From: Michael Conrad <mconrad-HsDW+lVSy7tZ66HEZ9PjWw@public.gmane.org>
Subject: Bug? Kernel doesn't prevent multiple rw nilfs mounts
Date: Thu, 24 Oct 2013 13:21:08 -0400
Message-ID: <52695704.3010507@intellitree.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,  When I mount a NILFS partition twice (not on purpose), it correctly 
prints:

   mount.nilfs2: the device already has a rw-mount on /mnt/_bak.
                 multiple rw-mount is not allowed.

But the mount happens anyway?!

   /dev/sdb4 on /mnt/_bak type nilfs2 (rw,relatime)
   /dev/sdb4 on /mnt/sdb4 type nilfs2 (rw,relatime)

I saw this in Linux 3.2.16, then upgraded to 3.10.7 and it still 
happens.  Writing to these mounts in parallel causes buggy behavior, 
though it didn't corrupt my partition (yet).

Has no-one tested this lately?

-Mike

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
