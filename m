From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [ANNOUNCE] git repositories moved to github
Date: Sat, 19 Nov 2011 01:36:10 +0900 (JST)
Message-ID: <20111119.013610.106621387.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi everyone,

We have moved nilfs.org git repositories to
https://github.com/nilfs-dev/.  New URLs are as follows:

 * NILFS utilities git repo

   http://git.nilfs.org/nilfs2-utils.git
   -->  git://github.com/nilfs-dev/nilfs-utils.git

 * Kernel module for RHEL6 clones (CentOS 6 and Scientific Linux 6)

   http://git.nilfs.org/nilfs2-kmod-centos6.git
   -->  git://github.com/nilfs-dev/nilfs2-kmod-centos6.git

 * Kernel module for RHEL5 clones and old vanilla kernels (2.6.18~2.6.29).

   http://git.nilfs.org/nilfs2-module.git
   -->  git://github.com/nilfs-dev/nilfs2-module.git


If you are subscribing one of the above repos, please rewrite
.git/config file to follow these changes.

The prior repositories are still maintained, but we have a plan to close
them around the begining of January 2012.

Thank you,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
