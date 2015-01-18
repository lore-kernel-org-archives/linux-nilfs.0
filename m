From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH v2 0/3] nilfs-utils: fix leak at nilfs_open and remove null checks before free()
Date: Mon, 19 Jan 2015 03:02:50 +0900
Message-ID: <1421604173-3397-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:lines;
        bh=4HU3L36TdJUuDIM4kBt6stQXJNz7uAROKKIBWxRm750=;
        b=YlkXfS1lRFVTdTJcGrKohlJPfRIcSloUbeSklbxToPNb34XvpLs9l99swvGrmKwjzf
         Zd9KrA6EmeKqdakd9vKs0Rs4eOxWIbeBLIw21O9GIaOlyG9SsDHIil1IbI5Vi2ac2U5w
         hcsFlhwUH8vporWvEpSGwhU1U5quExHsiOdWJsm2Iv+xvuxv9f83RgetbViCqyDTj0EY
         UhxJJBXdFofrmdok3aBa3+JCcn7diWIyPYuKKI4A1SHvij1HTVS02BifllTxJZmr+KJT
         oTOc0Du3uItF0Oj/s6wLe7sp4cNPI7s08IWV0QAb9dCtuSuB/UGAt+mPdCWUSzgQavZH
         afVg==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This series fixes potential leak at nilfs_open and removes unnecessary
null checks before calling free().

Changes from v1:
 * fix warnings at sbin/mount/{fstab.c,mount.nilfs2.c,umount.nilfs2.c}

Ryusuke Konishi
--
Ryusuke Konishi (3):
      lib/nilfs.c: fix potential leak at nilfs_open()
      nilfs-utils: get rid of my_free()
      nilfs-utils: get rid of null checks before calling free()

 lib/cleaner_ctl.c          |  6 ++----
 lib/gc.c                   |  3 +--
 lib/nilfs.c                | 26 ++++++++++----------------
 lib/realpath.c             |  9 +++------
 sbin/mount/fstab.c         | 20 +++++++-------------
 sbin/mount/mount.nilfs2.c  | 38 +++++++++++++++-----------------------
 sbin/mount/mount_mntent.h  |  8 ++++----
 sbin/mount/umount.nilfs2.c | 15 ++++-----------
 8 files changed, 46 insertions(+), 79 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
