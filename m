From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCHv2 0/3] nilfs2 add feature flags
Date: Thu, 22 Jul 2010 03:22:17 +0900
Message-ID: <1279736540-21556-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

This is a revised patchset that introduces feature flags and makes
nilfs refuse to mount future incompatibile filesystems.

The first patch is just for improving readability of super block
format.  The second patch extends super block and adds three flags to
record feature sets (i.e. "compat features", "read-only compat
features", and "incompat features").  The semantics of these flags is
mimic of ext3.  At present, no feature flags are defined.

The third patch makes nilfs reject filesystems with unknown features.
This serves as a safety for future disk format change which is not
forward compatible.

* Change from the v1 patchset is as follows:

 - insert the same test of feature flags also before proceed with
   recovery for read-only mount.

Thanks,
Ryusuke Konishi
--
 fs/nilfs2/nilfs.h         |    2 ++
 fs/nilfs2/super.c         |   39 +++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/the_nilfs.c     |   20 ++++++++++++++++++++
 include/linux/nilfs2_fs.h |   41 +++++++++++++++++++++++++++--------------
 4 files changed, 88 insertions(+), 14 deletions(-)


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
