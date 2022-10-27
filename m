From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/2] nilfs2: fix UBSAN shift-out-of-bounds warnings on mount time
Date: Thu, 27 Oct 2022 13:43:04 +0900
Message-ID: <20221027044306.42774-1-konishi.ryusuke@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=N0isRSvxKOUKWvo+ShVUDgJ9UCs7Mq+apMEV7CTZEMk=;
        b=N2AJ9L/0qCKpQPijTw8x49MBqW2P0RpzCe8819sLrCro+2o24U/vLj05vRH3Q/mWIK
         uMzgF2KBW+sOJtrHUxHojNiPKvKE14OsrchOSK/EiYNEzNj7xkzR0QYzH8m9XmW+llm7
         V+a4NCGC+5B3c0bNLref33ejocHMoHVUbawBLStmL/qxkbAbk85YZKOhcRhFpIibxjOo
         qmQ387RT1I9h9SD1esWs5cr+c+H1I1L6Ge6taNcWykUfVCcBrq+5RdbV/o1Ssr9/e+oP
         Eg72UOZMWjax0G+DKrAqLy23+HHYAu5PCAkCfai7Vdixjax/Xm6elFn0qz+A0+eeTyoB
         sntQ==
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, syzbot <syzbot+e91619dd4c11c4960706-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Andrew,

please apply the following bug fixes to -mm tree:

Ryusuke Konishi (2):
  nilfs2: fix shift-out-of-bounds/overflow in nilfs_sb2_bad_offset()
  nilfs2: fix shift-out-of-bounds due to too large exponent of block
    size

The first patch fixes a reported bug by syzbot, and the second one
fixes the remaining bug of the same kind.  Although they are triggered
by the same super block data anomaly, I divided it into the above two
because the details of the issues and how to fix it are different.

Both are required to eliminate the shift-out-of-bounds issues on mount time.

Thanks,
Ryusuke Konishi

 fs/nilfs2/the_nilfs.c | 73 ++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 65 insertions(+), 8 deletions(-)

-- 
2.34.1

