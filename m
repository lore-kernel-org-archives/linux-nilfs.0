From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/2] nilfs2 updates
Date: Mon, 25 Oct 2021 17:51:00 +0900
Message-ID: <1635151862-11547-1-git-send-email-konishi.ryusuke@gmail.com>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=r21X5ADW0WlJHmSicl9xy7PcAUT0+LrXxeiJShv+0ng=;
        b=pHL+ZgfxUV119tjBOMgg1P7U3VLBbIgEZz7n0cuL4yKX61leTCTD0n6VszCTgkAbKI
         BpxtmAhDxnn/wVhgZdnBv3z/sDOeASnPTIQOfGJMOgH/FCcbZAI8iO7AOUbVyR/l0oAy
         ceufvvsw4YdJi3P6TZVxUsikdTsfVs3tj61ZvTihgcZfO9BuOZ2bxZ/YaTwSvALZqeII
         ijN8GrsxOBqab61T1suYoXJcB1mp051xfLlZcGsvZ0X4MHPO2yDLNP0LXA2KC1k/CrUE
         A+YyjsfIw8BWHYMvSSNFXJMKLfMDm8fLgGAs7trXdhIEWnjRfxU66lhG9q5uDKwEsToE
         SUew==
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi, Andrew

Please queue the following changes for the next merge window:

Qing Wang (1):
  nilfs2: replace snprintf in show functions with sysfs_emit

Ryusuke Konishi (1):
  nilfs2: remove filenames from file comments

Thanks,
Ryusuke Konishi
--
 fs/nilfs2/alloc.c     |  2 +-
 fs/nilfs2/alloc.h     |  2 +-
 fs/nilfs2/bmap.c      |  2 +-
 fs/nilfs2/bmap.h      |  2 +-
 fs/nilfs2/btnode.c    |  2 +-
 fs/nilfs2/btnode.h    |  2 +-
 fs/nilfs2/btree.c     |  2 +-
 fs/nilfs2/btree.h     |  2 +-
 fs/nilfs2/cpfile.c    |  2 +-
 fs/nilfs2/cpfile.h    |  2 +-
 fs/nilfs2/dat.c       |  2 +-
 fs/nilfs2/dat.h       |  2 +-
 fs/nilfs2/dir.c       |  2 +-
 fs/nilfs2/direct.c    |  2 +-
 fs/nilfs2/direct.h    |  2 +-
 fs/nilfs2/file.c      |  2 +-
 fs/nilfs2/gcinode.c   |  2 +-
 fs/nilfs2/ifile.c     |  2 +-
 fs/nilfs2/ifile.h     |  2 +-
 fs/nilfs2/inode.c     |  2 +-
 fs/nilfs2/ioctl.c     |  2 +-
 fs/nilfs2/mdt.c       |  2 +-
 fs/nilfs2/mdt.h       |  2 +-
 fs/nilfs2/namei.c     |  2 +-
 fs/nilfs2/nilfs.h     |  2 +-
 fs/nilfs2/page.c      |  2 +-
 fs/nilfs2/page.h      |  2 +-
 fs/nilfs2/recovery.c  |  2 +-
 fs/nilfs2/segbuf.c    |  2 +-
 fs/nilfs2/segbuf.h    |  2 +-
 fs/nilfs2/segment.c   |  2 +-
 fs/nilfs2/segment.h   |  2 +-
 fs/nilfs2/sufile.c    |  2 +-
 fs/nilfs2/sufile.h    |  2 +-
 fs/nilfs2/super.c     |  2 +-
 fs/nilfs2/sysfs.c     | 78 +++++++++++++++++++++++++--------------------------
 fs/nilfs2/sysfs.h     |  2 +-
 fs/nilfs2/the_nilfs.c |  2 +-
 fs/nilfs2/the_nilfs.h |  2 +-
 39 files changed, 77 insertions(+), 77 deletions(-)

-- 
1.8.3.1

