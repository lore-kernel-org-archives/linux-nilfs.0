From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/2] nilfs2: simplify atomic bit operations on buffer state bitmap
Date: Mon,  9 Feb 2015 00:30:46 +0900
Message-ID: <1423409448-5430-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:lines;
        bh=E8LGL1YDhsarN2m0sG6zFxjjhjKu8Eom7P2nUmZDIts=;
        b=FvKMMvWhrsBzT/veTbwgReDAG9+ajqQKVCS56C9FSgLkONO8aDCY1lj7KGIAqsd4AU
         yPLYkR5Lryd0htRnzT7bcSz27XkgVxt5302Yxy3iC/nt3c5+ABgRovdRF2Xk+KA2J6Rd
         LxLSWa26fg+H/OB1T2BEaYiwQ5AefTEDl5dOM7MXFsIv7WLvv34uxAJl5Ha1Hgh5aSnC
         L1/Jxpn/5KuMWkpE27Kpw/TcnCLRcixoPHuw/1ihA7mFVhimNiat5LFaGg7Z5gIof9/v
         8cm4fO5mRo+FH33n8P5vf3a8s9T8LsvIQhrRGyjgia3wDLQc/PUCyukL2wRpcyWAUu99
         3p/w==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This series reduces the number of atomic bit operations for buffer
state bitmap in nilfs2.

Ryusuke Konishi
--
Ryusuke Konishi (2):
      nilfs2: do not use async write flag for segment summary buffers
      nilfs2: use set_mask_bits() for operations on buffer state bitmap

 fs/nilfs2/page.c    | 22 ++++++++++------------
 fs/nilfs2/segment.c | 16 ++++++++--------
 2 files changed, 18 insertions(+), 20 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
