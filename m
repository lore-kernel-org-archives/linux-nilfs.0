From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/1] nilfs2 additional change
Date: Tue,  7 Nov 2017 23:21:25 +0900
Message-ID: <1510064486-1728-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:lines;
        bh=FiP8A5clQAgUs0sN5ZaFY2tuMSPjU+QDo5qCy468kNc=;
        b=Ad3Vgq6iY2SGej4NCq2WlgV4DwptnqiYkPruqgBrOMQcfUPz4BALnRrAcxltAAryjF
         XNOpjRrAx4wAlTdeD4yS2MRNDKGUD3q3SAwpHaM5OFtNE4/2NH8OgiMJKfPlUh2xBZ5s
         EDDgJGzLgdlJLCIu8p5a5xoKtJjhfiB/IjJVyh+rMWNvioQ3/VftzbEw1K6KqQ1wenmI
         CJX/XfzGOvy7AnwC+eDFNd94bsxwo/I8bYmkuv3zFOIYbI5mfhpMoXkv0S9x/+jujt7A
         1m5Yd0W4eAnShEJ89etfgAK7kBFera2x7PNj6AEUoFuXvuJxlsmgZvLzn6z8xfucclYq
         R+Lg==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Hi Andrew,

Please add the following change to the queue of next merge window:

Jeff Layton (1):
      nilfs2: remove inode->i_version initialization

Thanks,
Ryusuke Konishi
--
 fs/nilfs2/super.c | 1 -
 1 file changed, 1 deletion(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
