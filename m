From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/2] nilfs2: fix build warnings
Date: Mon, 12 Oct 2015 12:45:29 +0900
Message-ID: <1444621531-14142-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:lines;
        bh=SEldI/xxPlaXvk2q3l3HZeKYQr6HzSGEMgnZBn7VKU4=;
        b=Kuwk8ykXxkIEV9zweGUIf+WRUd/WsC4Wz/LA4vVuBNVxB4807stUQ2UkBxysaHEOes
         1HQYxV8Oei1GmoK7vE9uvDiJvmp6lX2yvpcAWSSupi8wzSH+V3vXSdUTrKHi6702LGSe
         0Ao4aqe1X25T3DKsqOgsSfVkNUWfNEFEgkn0FxTfh+Xvk2lCk5e5LNqaMqsEbh2i/zXW
         /yPmkcogRSp8YLdYUMWK5XU114h1ZUVD5kbxW7KfP7AQTXVbHGqyJuzpn4DM5mHmL2Er
         mEaGE3NdXDQUqx54z+WUOvwZXtfQtI+xPlwd449xZn7xO/mnIff9IQshP82k6JHk4KKj
         ZdGg==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Hi Andrew,

Please send the following fixes to upstream:

Ryusuke Konishi (2):
      nilfs2: fix gcc unused-but-set-variable warnings
      nilfs2: fix gcc uninitialized-variable warnings in powerpc build

These prevent reported warnings in powerpc build and minor warnings
during build with "W=1".  Both were detected on the mainline.

Thanks,
Ryusuke Konishi
--

 fs/nilfs2/alloc.c    | 3 +--
 fs/nilfs2/btree.c    | 7 +------
 fs/nilfs2/dat.c      | 2 --
 fs/nilfs2/recovery.c | 4 ++--
 fs/nilfs2/segment.c  | 3 +--
 fs/nilfs2/sufile.c   | 3 +--
 fs/nilfs2/super.c    | 5 ++++-
 7 files changed, 10 insertions(+), 17 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
