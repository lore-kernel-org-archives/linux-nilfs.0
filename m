From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: return an ERR_PTR from __filemap_get_folio v2
Date: Sat, 21 Jan 2023 07:57:48 +0100
Message-ID: <20230121065755.1140136-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=o5i5qXxICSG+cq4jO8TGXskNtUwwrBBqvoBV9YksFl0=; b=WOXQpn1PzakC+RFN34/XzUonXP
        vsoTRXKMhhTh26lIMHpqZJCj89ilMzL9Xs9wuuOgcKtvV4w7MNLKQ24CYHAmpB7yKqLM9N2sObTUq
        C3atVe/a0mm/s2AFxCA3H4HDAbsOdwh1j1HF0GKBTpIaBh0MKmsv040zNn/2nMVy/bIE2x/B1PAtJ
        5LQq9MjNF9Td8J/WqI13GW1GkKbc8hl/wa0C4JIGvGU1KDiDq13qGaCMLPK7aUb09i2TcD6ByW4+3
        mlDvAbBEJ+VGbuw628D7djrokVdfqZbOirBrNjGQmL8Q7vdXaHGVHqotN7Z00B3pMNKCRjhh93Qcz
        ONM5PLwA==;
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi all,

__filemap_get_folio and its wrappers can return NULL for three different
conditions, which in some cases requires the caller to reverse engineer
the decision making.  This is fixed by returning an ERR_PTR instead of
NULL and thus transporting the reason for the failure.  But to make
that work we first need to ensure that no xa_value special case is
returned and thus return the FGP_ENTRY flag.  It turns out that flag
is barely used and can usually be deal with in a better way.

Note that the shmem patches in here are non-trivial and need some
careful review and testing.

Changes since v1:
 - drop the patches to check for errors in btrfs and gfs2
 - document the new calling conventions for the wrappers around
   __filemap_get_folio
 - rebased against the iomap changes in latest linux-next

Diffstat
 fs/afs/dir.c             |   10 +++----
 fs/afs/dir_edit.c        |    2 -
 fs/afs/write.c           |    4 +-
 fs/btrfs/disk-io.c       |    2 -
 fs/ext4/inode.c          |    2 -
 fs/ext4/move_extent.c    |    8 ++---
 fs/hugetlbfs/inode.c     |    2 -
 fs/iomap/buffered-io.c   |   15 +----------
 fs/netfs/buffered_read.c |    4 +-
 fs/nilfs2/page.c         |    6 ++--
 include/linux/pagemap.h  |   15 +++++------
 include/linux/shmem_fs.h |    1 
 mm/filemap.c             |   27 ++++++++-----------
 mm/folio-compat.c        |    4 +-
 mm/huge_memory.c         |    5 +--
 mm/memcontrol.c          |    2 -
 mm/mincore.c             |    2 -
 mm/shmem.c               |   64 +++++++++++++++++++----------------------------
 mm/swap_state.c          |   17 ++++++------
 mm/swapfile.c            |    4 +-
 mm/truncate.c            |   15 +++++------
 21 files changed, 94 insertions(+), 117 deletions(-)
