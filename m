From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 04/19] ntfs3: remove ntfs_alloc_bio
Date: Tue, 18 Jan 2022 08:19:37 +0100
Message-ID: <20220118071952.1243143-5-hch@lst.de>
References: <20220118071952.1243143-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=EcXfe+QJLbyEaBSYcI8IdLx+VpwVU+Twsx7L0heUO1Q=; b=Crht+UUgONjGH1v8HmgHBuR0Pw
        3+FhXNSZnyjRNWPG58Wm2G5KNvvpy1aGmBMUIrUK1u4m17TdekCh3eo0S2wKQYJJCbvDqXQsRo2wK
        voVwIithhKd6AwW1XgXVCGDM2qY6luEVdRs+f8pN0VmiQubGiTFrLb9HST+OMYWI2ooLOR0H3H2W4
        vveuXxxHUHwA+40YbvmOhhsxe1wU4IgQ9dJEnKgPFvwGnegPrJbbGgCJPHOwX/k9PMvLPupdzEJoQ
        dshYui2V9dLVx8Ag4GNgYySKuflXOClHoN9+HnAX1vSgCn5EnBRDfedOUMh6tHzNLJ5kJKsxDwFUO
        XkKnK+AQ==;
In-Reply-To: <20220118071952.1243143-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Konstantin Komarov <almaz.alexandrovich-m5I1DM4ARimttCpgsWEBFlaTQe2KTcn/@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Md . Haris Iqbal " <haris.iqbal-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>, Jack Wang <jinpu.wang-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>, =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau-Sxgqhf6Nn4Bhl2p70BpVqQ@public.gmane.org>, Philipp Reisner <philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ntfs3-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org

bio_alloc will never fail if it is allowed to sleep, so there is no
need for this loop.  Also remove the __GFP_HIGH specifier as it doesn't
make sense here given that we'll always fall back to the mempool anyway.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 fs/ntfs3/fsntfs.c | 23 ++---------------------
 1 file changed, 2 insertions(+), 21 deletions(-)

diff --git a/fs/ntfs3/fsntfs.c b/fs/ntfs3/fsntfs.c
index 4de9acb169689..4a255e21ecf5f 100644
--- a/fs/ntfs3/fsntfs.c
+++ b/fs/ntfs3/fsntfs.c
@@ -1443,17 +1443,6 @@ int ntfs_write_bh(struct ntfs_sb_info *sbi, struct NTFS_RECORD_HEADER *rhdr,
 	return err;
 }
 
-static inline struct bio *ntfs_alloc_bio(u32 nr_vecs)
-{
-	struct bio *bio = bio_alloc(GFP_NOFS | __GFP_HIGH, nr_vecs);
-
-	if (!bio && (current->flags & PF_MEMALLOC)) {
-		while (!bio && (nr_vecs /= 2))
-			bio = bio_alloc(GFP_NOFS | __GFP_HIGH, nr_vecs);
-	}
-	return bio;
-}
-
 /*
  * ntfs_bio_pages - Read/write pages from/to disk.
  */
@@ -1496,11 +1485,7 @@ int ntfs_bio_pages(struct ntfs_sb_info *sbi, const struct runs_tree *run,
 		lbo = ((u64)lcn << cluster_bits) + off;
 		len = ((u64)clen << cluster_bits) - off;
 new_bio:
-		new = ntfs_alloc_bio(nr_pages - page_idx);
-		if (!new) {
-			err = -ENOMEM;
-			goto out;
-		}
+		new = bio_alloc(GFP_NOFS, nr_pages - page_idx);
 		if (bio) {
 			bio_chain(bio, new);
 			submit_bio(bio);
@@ -1599,11 +1584,7 @@ int ntfs_bio_fill_1(struct ntfs_sb_info *sbi, const struct runs_tree *run)
 		lbo = (u64)lcn << cluster_bits;
 		len = (u64)clen << cluster_bits;
 new_bio:
-		new = ntfs_alloc_bio(BIO_MAX_VECS);
-		if (!new) {
-			err = -ENOMEM;
-			break;
-		}
+		new = bio_alloc(GFP_NOFS, BIO_MAX_VECS);
 		if (bio) {
 			bio_chain(bio, new);
 			submit_bio(bio);
-- 
2.30.2

