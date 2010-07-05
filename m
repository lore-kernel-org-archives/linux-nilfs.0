From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/5] nilfs2: sanitize mount options and remount checks
Date: Tue,  6 Jul 2010 00:09:45 +0900
Message-ID: <1278342590-5912-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This series sanitizes the code around mount options and especially
improves consistency check on remount.

The "nilfs2: add barrier mount option" and "nilfs2: add nodiscard
mount option" add complementary mount options for existing "discard"
and "nobarrier" options.  These allow user to re-enable or re-disable
non default options through remount.

The "nilfs2: use seq_puts to print mount options without argument"
replaces seq_printf uses in nilfs_show_options with simpler seq_puts
function.

The "nilfs2: pass remount flag to parse_options" adds a flag to the
argument of parse_options function and allows proper check of mount
options depending on the caller's context (i.e. new mount or remount).

Finally, the "nilfs2: get rid of nilfs_mount_options struct" is just a
cleanup which became possible by the previous change.

I will queue this series for linux next.

Thanks,
Ryusuke Konishi
--
Ryusuke Konishi (5):
      nilfs2: add barrier mount option
      nilfs2: add nodiscard mount option
      nilfs2: use seq_puts to print mount options without argument
      nilfs2: pass remount flag to parse_options
      nilfs2: get rid of nilfs_mount_options struct

 Documentation/filesystems/nilfs2.txt |   12 +++--
 fs/nilfs2/sb.h                       |    8 ---
 fs/nilfs2/super.c                    |   81 +++++++++++++++++++---------------
 3 files changed, 53 insertions(+), 48 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
