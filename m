From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: NILFS2 get stuck after bio_alloc() fail
Date: Sun, 14 Jun 2009 15:30:46 +0900 (JST)
Message-ID: <20090614.153046.25768784.konishi.ryusuke@gmail.com>
References: <20090614013211.GA22552@homero.springfield.home>
	<20090614015240.GW30412@blitiri.com.ar>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752432AbZFNGaz@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:received:received:sender:date:message-id:to:cc
         :subject:from:in-reply-to:references:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        bh=0tRLyET1Hacm4yBtR2toK5uYk4KIfTBQwt2Bi1LkKmU=;
        b=ugYZA59d91/7fRFeUnluNAwsUv8Q4bsnisZdBrOAUbZ18MUlRU9NpSwLQT9lFGKaec
         c6EOO/sMwtp6bWZrgcTuoXsi4BWgfPAKkaEH65dFmONbKzr6JLincZmblzK36so6FRit
         K6Hr9RkCiQaZk9QcS0/S1YfYXtPaG1KAUJmuM=
In-Reply-To: <20090614015240.GW30412@blitiri.com.ar>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: albertito@blitiri.com.ar
Cc: llucax@gmail.com, linux-kernel@vger.kernel.org, konishi.ryusuke@lab.ntt.co.jp, users@nilfs.org

Hi!
On Sat, 13 Jun 2009 22:52:40 -0300, Alberto Bertogli wrote:
> On Sat, Jun 13, 2009 at 10:32:11PM -0300, Leandro Lucarella wrote:
>> Hi!
>> 
>> While testing nilfs2 (using 2.6.30) doing some "cp"s and "rm"s, I noticed
>> sometimes they got stucked in D state, and the kernel had said the
>> following message:
>> 
>>         NILFS: IO error writing segment
>> 
>> A friend gave me a hand and after adding some printk()s we found out that
>> the problem seems to occur when bio_alloc()s inside nilfs_alloc_seg_bio()
>> fail, making it return NULL; but we don't know how that causes the
>> processes to get stucked.
> 
> By the way, those bio_alloc()s are using GFP_NOWAIT but it looks like they
> could use at least GFP_NOIO or GFP_NOFS, since the caller can (and sometimes
> do) sleep. The only caller is nilfs_submit_bh(), which calls
> nilfs_submit_seg_bio() which can sleep calling wait_for_completion(). Is there
> something I'm missing?
> 
> Thanks a lot,
> 		Alberto

The original GFP flag was GFP_NOIO, but replaced to GFP_NOWAIT at a
preliminary release in February 2008.  It was because a user
experienced system memory shortage by the bio_alloc() call.

Even though nilfs_alloc_seg_bio() repeatedly calls bio_alloc()
reducing the number of bio vectors in case of failure, this fallback
did not work well.

I'm in two minds whether I should change it back to GFP_NOIO.
Or should I switch the gfp as follows?

Thanks,
Ryusuke Konishi

diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index 1e68821..6b8f00a 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -306,6 +306,7 @@ static int nilfs_submit_seg_bio(struct nilfs_write_info *wi, int mode)
  * @sb: super block
  * @start: beginning disk block number of this BIO.
  * @nr_vecs: request size of page vector.
+ * @gfp_mask: gfp flags
  *
  * alloc_seg_bio() allocates a new BIO structure and initialize it.
  *
@@ -313,14 +314,14 @@ static int nilfs_submit_seg_bio(struct nilfs_write_info *wi, int mode)
  * On error, NULL is returned.
  */
 static struct bio *nilfs_alloc_seg_bio(struct super_block *sb, sector_t start,
-				       int nr_vecs)
+				       gfp_t gfp_mask, int nr_vecs)
 {
 	struct bio *bio;
 
-	bio = bio_alloc(GFP_NOWAIT, nr_vecs);
+	bio = bio_alloc(gfp_mask, nr_vecs);
 	if (bio == NULL) {
 		while (!bio && (nr_vecs >>= 1))
-			bio = bio_alloc(GFP_NOWAIT, nr_vecs);
+			bio = bio_alloc(gfp_mask, nr_vecs);
 	}
 	if (likely(bio)) {
 		bio->bi_bdev = sb->s_bdev;
@@ -353,9 +354,14 @@ static int nilfs_submit_bh(struct nilfs_write_info *wi, struct buffer_head *bh,
  repeat:
 	if (!wi->bio) {
 		wi->bio = nilfs_alloc_seg_bio(wi->sb, wi->blocknr + wi->end,
-					      wi->nr_vecs);
-		if (unlikely(!wi->bio))
-			return -ENOMEM;
+					      GFP_NOWAIT, wi->nr_vecs);
+		if (unlikely(!wi->bio)) {
+			wi->bio = nilfs_alloc_seg_bio(wi->sb,
+						      wi->blocknr + wi->end,
+						      GFP_NOIO, 1);
+			if (!wi->bio)
+				return -ENOMEM;
+		}
 	}
 
 	len = bio_add_page(wi->bio, bh->b_page, bh->b_size, bh_offset(bh));

