From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH -mm 0/2] nilfs2 minor changes
Date: Tue, 24 Jan 2017 00:17:33 +0900
Message-ID: <1485184655-3895-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:lines;
        bh=AcF2mvMe3HSE/fM7c1EadI22Gmi2ljy2APoLbtGNPPU=;
        b=HcR5nC9Pp9kOD7edQquVX9AS9GXXYKbNbNYrPD0Bm2NegWK8UznkdfAfcFSyNdj6/o
         zxtRzbg3NVydwGNw/2qnaskof1m+iPH/N82g53YbSrggR1533WQbxHqCzY3iLwukKcOM
         iUh40eNXPnKcxRJS0+RuDBJKA4dYR5P7XWk0nDpkcuW8M29mAyQCvMksXRc/QqzlOzWs
         8IqgmqUdZxX4z/SkbAA1PxPqeTdkrhU9iZx3N7e2v4AJquUtKFnu6sBp1CfARdNLsfHu
         ufCEyswZzfXj92dik0i0KB4Rf+XH20i//4ALkQ9KVU3dAO6X6RFQIF0aMALWMOdqPaXX
         C31g==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Geliang Tang <geliangtang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Hi Andrew,

Please queue the following changes for the next merge window:

Geliang Tang (2):
      nilfs2: use nilfs_btree_node_size()
      nilfs2: use i_blocksize()

where "nilfs2: use i_blocksize()" requires the patch "fs: add
i_blocksize()" which resides in -mm tree.

Meanwhile "nilfs2: use nilfs_btree_node_size()" is applicable
independently.

Thanks,
Ryusuke Konishi
--
 fs/nilfs2/alloc.c | 2 +-
 fs/nilfs2/btree.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
