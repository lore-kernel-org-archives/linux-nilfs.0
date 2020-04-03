From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: Re: [PATCH 0/2] nilfs2: Logging style changes
Date: Fri, 03 Apr 2020 22:31:47 +0900 (JST)
Message-ID: <20200403.223147.300007237674208339.konishi.ryusuke@gmail.com>
References: <cover.1584894497.git.joe@perches.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+5T4dr5Yj+Mhb55fdklnxhoPtZWRWoLnIoAzNL4iVzc=;
        b=YOS+cGlm77/Ojm1G7l/cgTl+O9eIf7FvOdio5AmN0XCQNvKAlcgfvAA8nPvEnxc60/
         UeEutpFvnmnXG+k29rtqTnWG5wKEeF3nsoh2YIN4w/zdDLmDz/pzID+bWlKrATeRO7Vs
         ORor44JDozSzkP6XSEBEV9XPa6Na0AzTRvvS1mKtrxZdgBEVYhVhT1E6mE5CXk58rX77
         vuceNkSa7MJiYMFrSLXmivaptAQP+unrQloq5ziJE4kzFvfuRxNcdSYbiWONymUpN6B0
         3/vEaKHhqNFIX1mg37gDSq7EP5OEuxqcpQzuxHN+fHrGr7sfeAUpoZTvfTOTvbPc+71p
         /xvg==
In-Reply-To: <cover.1584894497.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Joe Perches <joe@perches.com>
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Sun, 22 Mar 2020 09:38:09 -0700, Joe Perches <joe@perches.com> wrote:
> Reduce object size and use more common kernel logging styles.
> 
> Joe Perches (2):
>   nilfs2: Convert __nilfs_msg to integrate the level and format
>   nilfs2: Use a more common logging style

Applied. Thank you.

Ryusuke Konishi

> 
>  fs/nilfs2/alloc.c     | 38 +++++++++----------
>  fs/nilfs2/btree.c     | 42 ++++++++++-----------
>  fs/nilfs2/cpfile.c    | 10 ++---
>  fs/nilfs2/dat.c       | 14 +++----
>  fs/nilfs2/direct.c    | 14 ++++---
>  fs/nilfs2/gcinode.c   |  2 +-
>  fs/nilfs2/ifile.c     |  4 +-
>  fs/nilfs2/inode.c     | 29 +++++++--------
>  fs/nilfs2/ioctl.c     | 37 +++++++++----------
>  fs/nilfs2/mdt.c       |  2 +-
>  fs/nilfs2/namei.c     |  6 +--
>  fs/nilfs2/nilfs.h     | 18 ++++++---
>  fs/nilfs2/page.c      | 11 +++---
>  fs/nilfs2/recovery.c  | 32 +++++++---------
>  fs/nilfs2/segbuf.c    |  2 +-
>  fs/nilfs2/segment.c   | 38 +++++++++----------
>  fs/nilfs2/sufile.c    | 29 +++++++--------
>  fs/nilfs2/super.c     | 73 +++++++++++++++++++------------------
>  fs/nilfs2/sysfs.c     | 29 +++++++--------
>  fs/nilfs2/the_nilfs.c | 85 ++++++++++++++++++++-----------------------
>  20 files changed, 254 insertions(+), 261 deletions(-)
> 
> -- 
> 2.24.0
> 
