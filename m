From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 0/3] nilfs2 additional updates
Date: Mon, 13 Jun 2016 22:45:04 +0900
Message-ID: <1465825507-3407-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:lines;
        bh=YNg/tC0WPdYFy3aiEuLvnRPZqx5Sqf3Fm6i04zY2yp4=;
        b=P9eWbzHs7UF1b3ZSVL9BYVDSmaCMLDr+zD5UhB2z5xtUJSphcybiXxOVqCEG92WSMm
         4/2KXzYWyKatcZXv8FUYFxA2QQ8RmsEGitjDSB/D4zv0OfGDFJk9rCiJrfvt7cHxtTtP
         cUpGNOnEyUT97moo7cunN48XjeOMW2E664gqoCJstb6iGINm4bBX47srAbxxD5EiZhli
         MJSEi/IchCMprE6MImaVDLHwyZq2W3I1xcR7EJDXrPDMSFCAfLJJMt0tByZdwh9h+VYG
         8+OLokPJv+OCVI8IXMWSKFJ35by8pyVSzLBXa2HFx8RVGgUo+qqGWiIp7VkZcQPlIErY
         3ABQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

Hi Andrew,

please add the following changes for the next merge window:

Ryusuke Konishi (3):
      nilfs2: fix misuse of a semaphore in sysfs code
      nilfs2: use BIT() macro
      nilfs2: move ioctl interface and disk layout to uapi separately

In this series,

>      nilfs2: fix misuse of a semaphore in sysfs code

corrects, as its name suggests, wrong use of a semaphore, though we
don't know any real problem that it causes.  Then,

>      nilfs2: use BIT() macro

replaces "(1 << b)" style bit shifts with the generic BIT() macro for
simplicity.

Finally,

>      nilfs2: move ioctl interface and disk layout to uapi separately

moves nilfs2_fs.h header, which is currently stored in the
"include/linux" directory, to the uapi directory, splitting the file
into two headers "nilfs2_api.h" and "nilfs2_ondisk.h"; the former
separates ioctl related definitions and the latter collects up on-disk
structures.


Thanks,
Ryusuke Konishi
--
 Documentation/filesystems/nilfs2.txt |   3 +-
 Documentation/ioctl/ioctl-number.txt |   2 +-
 MAINTAINERS                          |   3 +-
 fs/nilfs2/bmap.h                     |   2 +-
 fs/nilfs2/btnode.c                   |   4 +-
 fs/nilfs2/btree.h                    |   2 +-
 fs/nilfs2/cpfile.c                   |   1 -
 fs/nilfs2/cpfile.h                   |   3 +-
 fs/nilfs2/dat.h                      |   1 +
 fs/nilfs2/dir.c                      |  22 +
 fs/nilfs2/direct.h                   |  10 -
 fs/nilfs2/ifile.h                    |   1 -
 fs/nilfs2/inode.c                    |   4 +-
 fs/nilfs2/ioctl.c                    |   1 -
 fs/nilfs2/nilfs.h                    |  18 +-
 fs/nilfs2/page.c                     |  26 +-
 fs/nilfs2/segment.c                  |  14 +-
 fs/nilfs2/segment.h                  |   1 -
 fs/nilfs2/sufile.c                   |  13 +-
 fs/nilfs2/sufile.h                   |   1 -
 fs/nilfs2/sysfs.c                    |  44 +-
 fs/nilfs2/the_nilfs.h                |   7 +-
 include/linux/nilfs2_fs.h            | 934 -----------------------------------
 include/uapi/linux/nilfs2_api.h      | 292 +++++++++++
 include/uapi/linux/nilfs2_ondisk.h   | 650 ++++++++++++++++++++++++
 25 files changed, 1037 insertions(+), 1022 deletions(-)
 delete mode 100644 include/linux/nilfs2_fs.h
 create mode 100644 include/uapi/linux/nilfs2_api.h
 create mode 100644 include/uapi/linux/nilfs2_ondisk.h


