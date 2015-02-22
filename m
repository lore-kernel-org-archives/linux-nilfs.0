From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/4] nilfs2: shorten execution time of lscp command
Date: Sun, 22 Feb 2015 21:34:06 +0900
Message-ID: <1424608450-32240-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:lines;
        bh=zT3RgxIwo+Are7VNiFqXPZfYQfJui9OSin17LtOAZaA=;
        b=gYOhZDzhpgfeC+A+byOLGDLakhXPPxkDA9Xg6HB0DZ7h4Qm8rBivVu1/RPSlq3Ivjt
         xT+A5zb6K1ESQE3BwDrjiPc1aaB0GKtmYQtmBD1TxaTFkrE8hi2YLroGpxusGQBI7zpO
         rMWUp8IbPKBwFFQA2zV54graD3oL1KQ+8xrrNZggeQevl3mgdRTUDQZTt8iWAkWiasbo
         URTBww6tjefC834EKo+8ZHQr+NVfyXY0WhjV5yq4ohaoxrMY0t1XiLXY5KIq8cwDf71Q
         9dTB9iyUPtPUBi5ZdF2K3U0JcKOAR9nIMMfm8zzwX5Mk3q00biQuqrInjKvmt1HmJnGk
         JkGA==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

The older a filesystem gets, the slower lscp command becomes.  This is
because nilfs_cpfile_do_get_cpinfo() function meets more hole blocks
as the start offset of valid checkpoint numbers gets bigger.

This series introduces some helper functions which help to skip hole
blocks efficiently, and reduces the overhead with them.

A measurement result of this series is as follows:

Before:
$ time lscp
                 CNO        DATE     TIME  MODE  FLG      BLKCNT       ICNT
             5769303  2015-02-22 19:31:33   cp    -          108          1
             5769304  2015-02-22 19:38:54   cp    -          108          1

real    0m0.182s
user    0m0.003s
sys     0m0.180s

After:
$ time lscp
                 CNO        DATE     TIME  MODE  FLG      BLKCNT       ICNT
             5769303  2015-02-22 19:31:33   cp    -          108          1
             5769304  2015-02-22 19:38:54   cp    -          108          1

real    0m0.003s
user    0m0.001s
sys     0m0.002s


Thanks,
Ryusuke Konishi
--
Ryusuke Konishi (4):
      nilfs2: unify type of key arguments in bmap interface
      nilfs2: add bmap function to seek a valid key
      nilfs2: add helper to find existent block on metadata file
      nilfs2: improve execution time of NILFS_IOCTL_GET_CPINFO ioctl

 fs/nilfs2/alloc.c  |  5 +++--
 fs/nilfs2/bmap.c   | 48 ++++++++++++++++++++++++++++++---------
 fs/nilfs2/bmap.h   | 13 ++++++-----
 fs/nilfs2/btree.c  | 66 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/cpfile.c | 58 ++++++++++++++++++++++++++++++++++++++++++-----
 fs/nilfs2/direct.c | 17 ++++++++++++++
 fs/nilfs2/inode.c  |  6 ++---
 fs/nilfs2/mdt.c    | 54 ++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/mdt.h    |  3 +++
 9 files changed, 243 insertions(+), 27 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
