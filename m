From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/7] nilfs2 updates
Date: Thu, 12 Mar 2015 23:38:07 +0900
Message-ID: <1426171094-27414-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:lines;
        bh=aFSl0XQXlbbuv1KpOHBRgJMPa8aSt1nja/jES4n+TPk=;
        b=WvDYzzQYvegxRwRQsElIKL0OB4b8iqfuDegHdv0E5Guzl1fh3IlcIwN+NIbHVvCiN9
         0GlKaNt/JSTiBpFiLIQeTqybD3Xa4RfVGEzBJzJKG5LP02TAdQIgTBo85Ptdw2BdrRw7
         4smCotVtzgsKk2MrG2Ld0bjlAePegz5e1tYzfObrWTAHiHDnYTxjGJ1GseTga5ZyXoOf
         OhMbf4gSpXFnSTLSjrFo4o8QAHBtl8+9oRGMoVDEGd6uwzsIjjhfqzjA6gPXKW1BnWH5
         LlvTyfSbqJVyeZ+lM440njmimyrPO3iVo/QlNqEpbFj2NYW854WQUzjSgsV+sic0i8oj
         19/A==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Hi Andrew,

Please queue the following changes for the next merge window:

Ryusuke Konishi (7):
      nilfs2: do not use async write flag for segment summary buffers
      nilfs2: use set_mask_bits() for operations on buffer state bitmap
      nilfs2: use bgl_lock_ptr()
      nilfs2: unify type of key arguments in bmap interface
      nilfs2: add bmap function to seek a valid key
      nilfs2: add helper to find existent block on metadata file
      nilfs2: improve execution time of NILFS_IOCTL_GET_CPINFO ioctl

* Brief summary

> nilfs2: do not use async write flag for segment summary buffers
> nilfs2: use set_mask_bits() for operations on buffer state bitmap

These reduce the number of atomic bit operations against b_state
bitmap by utilizing set_mask_bits() common helper, or by removing
unnecessary bit operations.

> nilfs2: use bgl_lock_ptr()

This is a cleanup patch, which makes use of bgl_lock_ptr() common
helper for simplicity.

> nilfs2: unify type of key arguments in bmap interface
> nilfs2: add bmap function to seek a valid key
> nilfs2: add helper to find existent block on metadata file
> nilfs2: improve execution time of NILFS_IOCTL_GET_CPINFO ioctl

These improve execution time of the ioctl for checkpoint listing,
which gets worse as the file system ages.

Example:
  [The current implementation]
  $ time lscp
                   CNO        DATE     TIME  MODE  FLG      BLKCNT       ICNT
               5769303  2015-02-22 19:31:33   cp    -          108          1
               5769304  2015-02-22 19:38:54   cp    -          108          1
    
  real    0m0.182s
  user    0m0.003s
  sys     0m0.180s
    
  [With the patchset]
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

 fs/nilfs2/alloc.c   |  5 ++--
 fs/nilfs2/bmap.c    | 48 +++++++++++++++++++++++++++++---------
 fs/nilfs2/bmap.h    | 13 +++++++----
 fs/nilfs2/btree.c   | 66 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/cpfile.c  | 58 +++++++++++++++++++++++++++++++++++++++++-----
 fs/nilfs2/direct.c  | 17 ++++++++++++++
 fs/nilfs2/inode.c   |  6 ++---
 fs/nilfs2/mdt.c     | 54 +++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/mdt.h     | 10 ++++++--
 fs/nilfs2/page.c    | 24 ++++++++-----------
 fs/nilfs2/segment.c | 17 +++++++-------
 11 files changed, 266 insertions(+), 52 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
