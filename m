From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/3] nilfs-utils: fix leak at nilfs_open and remove null checks before calling free()
Date: Mon, 19 Jan 2015 02:34:35 +0900
Message-ID: <1421602478-1896-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:lines;
        bh=hgNTD5BcmTl3vxpP4Zm5zk1xvwhAkMo9QLi4JD+DGvs=;
        b=fkJNH4ZkKdLbNWq0ZPAv8rX8LFIzaSjDaJeJP5KK+5y14U7GzniyA1nlxj/kUpuDD0
         OqvPHxAoTduYByC3duXvQw5NAs9nomfp+E/k42s8b5e3ISpDJlJJF8GMjI/EmfmWOufg
         NuseLwlKgZgMpXpzEvmMuYv7bUdYm71zVqMAzd1FVu3PRqunXix7Wuw3drk9ja4E4Tb3
         ojz2G0xGsy6/Pit6D7R/X1rZKk9XUI5hsj+PVmu3JDU1KHzl4EcMQLqnefUBJauo+QdQ
         lrPwatnw0++l6C34Uwz52t/iM0zgjVTIqtGAZSnUwa4JshHDLd1hybQ7ZRvy5n3e2iVJ
         4a/w==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This series fixes potential leak at nilfs_open and removes unnecessary
null checks before calling free().

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
 sbin/mount/umount.nilfs2.c | 15 ++++-----------
 7 files changed, 42 insertions(+), 75 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
