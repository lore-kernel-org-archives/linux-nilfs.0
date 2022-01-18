From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 03/19] nfs/blocklayout: remove bl_alloc_init_bio
Date: Tue, 18 Jan 2022 08:19:36 +0100
Message-ID: <20220118071952.1243143-4-hch@lst.de>
References: <20220118071952.1243143-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=pMAOIxwEWgivE8T/8jAutxBqi67ojpc7aSJ9Dfvp1Nk=; b=kFKC1f6LHbffT6qzEiLaEuNO4Z
        y5Wa6DZ64ihxEa532MbgjcReTwtC60BjPLQEj05bs6YuEeVI3sM977SdQzX4xmobJdlgPZVs2xWyC
        EMJ38PRJqUFy7XNiizvMrGIgprvIHQUp93bgTey3sz0jg7eZMOPncNFBYMmaEZWsV/sf41kUB2N71
        F5CwruEap8s8xzf4gj6k+YJ16+23/Z0Hl+DOqrPk1VXeoCpYu2IIRMb8Gs68ph2j0gtiX2+uWw4CJ
        twPIBYTRWRfw9YLbtir6ZkrrfCdWs9qy8EIvSFTnNOFAOKv/ZGihXdRGCZZictQuPhGrpOtQoXsyI
        Sb9DHpsQ==;
In-Reply-To: <20220118071952.1243143-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Konstantin Komarov <almaz.alexandrovich-m5I1DM4ARimttCpgsWEBFlaTQe2KTcn/@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Md . Haris Iqbal " <haris.iqbal-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>, Jack Wang <jinpu.wang-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>, =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau-Sxgqhf6Nn4Bhl2p70BpVqQ@public.gmane.org>, Philipp Reisner <philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ntfs3-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org

bio_alloc will never fail when it can sleep.  Remove the now simple
bl_alloc_init_bio helper and open code it in the only caller.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 fs/nfs/blocklayout/blocklayout.c | 26 +++++---------------------
 1 file changed, 5 insertions(+), 21 deletions(-)

diff --git a/fs/nfs/blocklayout/blocklayout.c b/fs/nfs/blocklayout/blocklayout.c
index fe860c5387476..38e063af7e98a 100644
--- a/fs/nfs/blocklayout/blocklayout.c
+++ b/fs/nfs/blocklayout/blocklayout.c
@@ -115,23 +115,6 @@ bl_submit_bio(struct bio *bio)
 	return NULL;
 }
 
-static struct bio *bl_alloc_init_bio(unsigned int npg,
-		struct block_device *bdev, sector_t disk_sector,
-		bio_end_io_t end_io, struct parallel_io *par)
-{
-	struct bio *bio;
-
-	npg = bio_max_segs(npg);
-	bio = bio_alloc(GFP_NOIO, npg);
-	if (bio) {
-		bio->bi_iter.bi_sector = disk_sector;
-		bio_set_dev(bio, bdev);
-		bio->bi_end_io = end_io;
-		bio->bi_private = par;
-	}
-	return bio;
-}
-
 static bool offset_in_map(u64 offset, struct pnfs_block_dev_map *map)
 {
 	return offset >= map->start && offset < map->start + map->len;
@@ -171,10 +154,11 @@ do_add_page_to_bio(struct bio *bio, int npg, int rw, sector_t isect,
 
 retry:
 	if (!bio) {
-		bio = bl_alloc_init_bio(npg, map->bdev,
-				disk_addr >> SECTOR_SHIFT, end_io, par);
-		if (!bio)
-			return ERR_PTR(-ENOMEM);
+		bio = bio_alloc(GFP_NOIO, bio_max_segs(npg));
+		bio->bi_iter.bi_sector = disk_addr >> SECTOR_SHIFT;
+		bio_set_dev(bio, map->bdev);
+		bio->bi_end_io = end_io;
+		bio->bi_private = par;
 		bio_set_op_attrs(bio, rw, 0);
 	}
 	if (bio_add_page(bio, page, *len, offset) < *len) {
-- 
2.30.2

