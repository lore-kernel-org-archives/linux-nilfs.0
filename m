From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/3] a few nilfs2 updates for 3.19
Date: Tue,  2 Dec 2014 01:41:44 +0900
Message-ID: <1417452107-6411-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:lines;
        bh=gFU5Bw7gaJs6QBWSBNUsWVvfzmxSePiHdP8ZvBoIfGQ=;
        b=pgUAbln3bFxKI6a6LeO69XOU/2BPkAjfPxDCNofpDRJDZYgU5pJ50stQKZo1DCCmZ6
         PunCj5sHNsWzjJf0HFdOEoR/l1A9s0eNpQOhuj8Xt9lNaA/Bim5hsFuYKqhNQB2vL6Af
         Lp9QmXviV95CtZf2gJsqOSKSpGyLdgcGXz8f7WVWkBIqg4oWgywG7thP3PnIK+3+hqZ/
         HTonGFpmbApaFJslUJIxTPfCwOdR09kkaSa5+56uOw7RDaHklxgLu0gf2QcCCg5i93h3
         hGdw8InqT+Zzvz0pNbDRlHGDmgqkqylIvDMIxC9m3CcwQdqE8Cw9yWXamAd6g6TegJjZ
         5XIg==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Hi Andrew,

Please add the following patches to the queue for the next merge
window.

Andreas's one simplifies nilfs_sync_file() function to avoid duplicate
segment construction on fsync(), and mine fixes a race issue between
nilfs_iget() and nilfs_new_inode().  Markus's one removes an
unnecessary NULL check related to iput().

Thanks,
Ryusuke Konishi
--
Andreas Rohner (1):
      nilfs2: avoid duplicate segment construction for fsync()

Markus Elfring (1):
      nilfs2: Deletion of an unnecessary check before the function call "iput"

Ryusuke Konishi (1):
      nilfs2: fix the nilfs_iget() vs. nilfs_new_inode() races

 fs/nilfs2/file.c      | 21 ++++++++-------------
 fs/nilfs2/inode.c     | 32 ++++++++++++++++++++++++--------
 fs/nilfs2/namei.c     | 15 ++++++++++++---
 fs/nilfs2/the_nilfs.c |  3 +--
 4 files changed, 45 insertions(+), 26 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
