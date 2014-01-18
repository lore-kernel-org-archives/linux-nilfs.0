From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/2] lscp: change default option of lscp command
Date: Sat, 18 Jan 2014 22:57:11 +0900
Message-ID: <1390053433-13598-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This series changes default option of lscp command about block count
to '-b' (print BLKCNT) from '-g' (print NBLKINC), and also updates
relevant man pages.  The second patch just removes a note
"experimental" on the description of FLG field in the man pages of
lscp.

For each checkpoint of NILFS2, total block count (BLKCNT) is more
meaningful information than appended block count (NBLKINC).  This
changes the default display information of lscp command on block count
to BLKCNT from NBLKINC, and updates relevant man pages.  NBLKINC can
be still displayed when we specified '-g' option.

Though BLKCNT information is not supported by NILFS2 in earlier Linux
kernels, I am thinking to apply this for convenience on the recent and
future environment.

Ryusuke Konishi
---
Ryusuke Konishi (2):
      lscp: show block count by default
      man/lscp.1: remove "experimental" from the description of FLG field

 bin/lscp.c  |    2 +-
 man/lscp.1  |   22 ++++++++++++----------
 man/nilfs.8 |   24 ++++++++++++------------
 3 files changed, 25 insertions(+), 23 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
