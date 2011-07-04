From: "LinuxBSDos.com" <finid-aEpbUQpJQqXlKS8GlytQkw@public.gmane.org>
Subject: Recommended partition scheme for nilfs2
Date: Mon, 4 Jul 2011 13:28:39 -0600
Message-ID: <4c09eb01174eecf704c751d7bf1b4bb2.squirrel@linuxbsdos.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


Hi,

A couple of Linux distributions now have nilfs2 as an optional file system
during installation and I just want to find out what the minimum number of
partitions required for a nilfs2-based installation is.

Is it necessary to create separate partitions for the major file systems,
or does nilfs2 require just one root file system directory? Is /home on a
separate partition necessary?

Lastly, can I encrypt a nilfs2 partition?

Thanks,

--
Fini D.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
