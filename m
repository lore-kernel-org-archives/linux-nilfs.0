From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 0/3] mm/fs: get PG_error out of the writeback reporting business
Date: Sun,  5 Mar 2017 08:35:32 -0500
Message-ID: <20170305133535.6516-1-jlayton@redhat.com>
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: viro@zeniv.linux.org.uk, konishi.ryusuke@lab.ntt.co.jp
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org

I recently did some work to wire up -ENOSPC handling in ceph, and found
I could get back -EIO errors in some cases when I should have instead
gotten -ENOSPC. The problem was that the ceph writeback code would set
PG_error on a writeback error, and that error would clobber the mapping
error.

While I fixed that problem by simply not setting that bit on errors,
that led me down a rabbit hole of looking at how PG_error is being
handled in the kernel.

This patch series is a few fixes for things that I 100% noticed by
inspection. I don't have a great way to test these since they involve
error handling. I can certainly doctor up a kernel to inject errors
in this code and test by hand however if these look plausible up front.

Jeff Layton (3):
  nilfs2: set the mapping error when calling SetPageError on writeback
  mm: don't TestClearPageError in __filemap_fdatawait_range
  mm: set mapping error when launder_pages fails

 fs/nilfs2/segment.c |  1 +
 mm/filemap.c        | 19 ++++---------------
 mm/truncate.c       |  6 +++++-
 3 files changed, 10 insertions(+), 16 deletions(-)

-- 
2.9.3

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
