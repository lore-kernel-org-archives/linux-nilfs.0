From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/1] nilfs2: fix potential memory overrun on inode
Date: Fri, 20 Feb 2015 22:46:34 +0900
Message-ID: <1424439995-613-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:lines;
        bh=p298NAz0dOHb7H5YRPZKO+NQfk4UG77CLQbVTTpt7co=;
        b=MQeqKdvftWicHyXsMWJxIGp5ZQ0PmdslHM3OhS6WWPsBehNLtKGaeH0dyqjGJyjtJk
         lOE6hic5c4QCH/NniC/xHzcWI2/B6jBGCe81rouRc5cPfOgtyoQHNib9o3q9QwmkZ9RK
         0spyoFvWm4eyIXmn+pSmev//zK5bCbyN86uL2aWvAsorjcaKF4tQZmvRn8aNrzrCjE12
         qzVI1kPMhrsRHmDorn+Pprz+0RoXCUBB8q60VaMX+u0g0qpWFMwqNJoyad4jg/airC4+
         js7DzdxbHv/c9pI0fK+Qt8YlDeHLtPI8jXAnXi76lsIDZenBiEj6FligSJeETsWh+M+6
         5myg==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Hi Andrew,

please queue the following patch as a bug fix.  It fixes a memory
overrun issue recently I found in the b-tree implementation of nilfs2.

Thanks,
Ryusuke Konishi
--
Ryusuke Konishi (1):
      nilfs2: fix potential memory overrun on inode

 fs/nilfs2/btree.c | 47 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 44 insertions(+), 3 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
