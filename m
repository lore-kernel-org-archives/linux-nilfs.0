From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/3] nilfs-utils: a few updates to utilize min_reclaimable_blocks
Date: Tue, 19 Aug 2014 08:52:13 +0900
Message-ID: <1408405936-6130-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:lines;
        bh=mQoEG+atw1Py1qW6Z1iptwa32qYsAxdy55kPvvJ1rS0=;
        b=qdyJ+4VhfQM3GI7MoVM46gziGT6TsGnZYT6BZzcveVa2+qoYc1DHwOs1OGzm8BRpIk
         bL2Dc4bdrTXyrPBUPIXAYjfqp6kF0HUSeAvijYSmXIHJ+ym7wzCEQJiaWri528QEgX+B
         wwChi2v34wq+k31tmTO9OSuJw5Gz5YULGsqhgGe2eFiV19YlNmsqHvfGMTW4vgk8LvCN
         Kin6DBJEzgzEURqA7KkUVo26UqBHT5p8oxoNqsyo8YEeIpeDVwRQmgAg9/ZW5b6I67M3
         FApCB0LvR2L/Nl8tJMJJAOXmGUkhvCjZ00Fa0DWI5xwjA1nPVjvFqaCa05CjkaZ0XILu
         0GoA==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>, Ryusuke konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This series remedies an inconvenience of nilfs-clean command related
to min_reclaimable_blocks parameter and enables set_suinfo ioctl use
by default in nilfs_cleanerd.conf.

The first patch changes nilfs-clean so that it doesn't override
min_reclaimable_blocks paramater when -m option is not explicitly
used.

The second patch just fixes a harmless issue in program of nilfs-clean.

And, the third patch changes the template file of nilfs_cleanerd.conf
so that nilfs_cleanerd tries to use set_suinfo ioctl by default if the
underlying kernel supports the feature.

Regards,
Ryuuke Konishi
--
 man/nilfs-clean.8                 |    1 -
 sbin/cleanerd/nilfs_cleanerd.conf |    2 +-
 sbin/nilfs-clean/nilfs-clean.c    |   18 ++++++++++--------
 3 files changed, 11 insertions(+), 10 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
