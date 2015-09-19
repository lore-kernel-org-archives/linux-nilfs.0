From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/7] nilfs2 updates
Date: Sat, 19 Sep 2015 19:32:55 +0900
Message-ID: <1442658782-3147-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:lines;
        bh=XDQXOCIZq7K7/8OkITnIjSq0UflUyL/YOxjMRBkZL/w=;
        b=mfQFKnhXi5lPrz8qN23mzhNJ3cQHgKzzzl6fDE6otfxt9bZZugQvZiKKmnHSsuzGrC
         weFAmxx4a+iXJ/Vk8ayQdDDJbDClv4C8Tfxa6mPetX2whUrlaK92VEM3vfe5xsXXOzOO
         qmfjShVM0R+vPr69XRHoKl1ObETnYwJ0Y053bx36vPHUOYNEpcz3z1cp+LraRGjLbgiA
         uqOotJ2CgHTPv6YbXf63g6N11IU7JeaHbp81NKVqjV5YnYcHACUvQXuzLdIItOlyG2C+
         WCKm1wPfePrerP5AqBHj9HqC+MVPcqv4EF9EXz5MxUOxI6MW+gY9hr+ki3HAsXjf+9Ub
         wBEQ==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Andrew,

Please queue the following changes for the next merge window:

Julia Lawall (1):
      nilfs2: drop null test before destroy functions

Ryusuke Konishi (6):
      nilfs2: use nilfs_warning() in allocator implementation
      nilfs2: do not call nilfs_mdt_bgl_lock() needlessly
      nilfs2: refactor nilfs_palloc_find_available_slot()
      nilfs2: get rid of nilfs_palloc_group_is_in()
      nilfs2: add helper functions to delete blocks from dat file
      nilfs2: free unused dat file blocks during garbage collection

* Brief summary

> nilfs2: drop null test before destroy functions

This removes null tests before calling kmem_cache_destroy() function.

> nilfs2: use nilfs_warning() in allocator implementation
> nilfs2: do not call nilfs_mdt_bgl_lock() needlessly
> nilfs2: refactor nilfs_palloc_find_available_slot()
> nilfs2: get rid of nilfs_palloc_group_is_in()

These are for refactoring bitmap based object allocator/deallocator
(alloc.c).

> nilfs2: add helper functions to delete blocks from dat file
> nilfs2: free unused dat file blocks during garbage collection

These resolve decline of the available disk space due to bloat of DAT
metadata file.


Thanks,
Ryusuke Konishi
--

 fs/nilfs2/alloc.c | 305 +++++++++++++++++++++++++++++++++++-------------------
 fs/nilfs2/alloc.h |   1 +
 fs/nilfs2/super.c |  12 +--
 3 files changed, 203 insertions(+), 115 deletions(-)


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
