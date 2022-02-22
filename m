From: NeilBrown <neilb@suse.de>
Subject: [PATCH 10/11] block/bfq-iosched.c: use "false" rather
 than "BLK_RW_ASYNC"
Date: Tue, 22 Feb 2022 14:17:17 +1100
Message-ID: <164549983746.9187.7949730109246767909.stgit@noble.brown>
References: <164549971112.9187.16871723439770288255.stgit@noble.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Content-Transfer-Encoding:Content-Type:MIME-Version
 :References:In-Reply-To:Message-ID:Date:Cc:To:From:Subject:Sender:Reply-To:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=ViDG/yMqWZxCAxTaqQtcLcHL6JhRHELXtVbiJuJsPUo=; b=Mwk+KWuZORuAR6Pw59fIR5rErR
 PU+PRzOsWs8syCwCGpwbYIB3dPcIJvpbvb/v0G7u+uGNcw/0bsvo9OefIoBWfuUEBmEQhtSOcMsYf
 9HGqdBgKAH+IJK48RPN7wc34b6acqmJSAMMlDRPXRFjwOHeWmte0W8G17hXUCIL5lUtY=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
 In-Reply-To:Message-ID:Date:Cc:To:From:Subject:Sender:Reply-To:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=ViDG/yMqWZxCAxTaqQtcLcHL6JhRHELXtVbiJuJsPUo=; b=U4c8ZT6k9/6oKup5oX4NvL+pxq
 Mk4lmRjOQd5xTRUua/Ulf+0t1Hdzgy9TCd7+bBt8gU1enMO5IgPuYzah4ZmBgwtedjo3DzVdoKTsu
 SytTI01+3qUtYefUsA2tj6R4qAQdZHJfemPqlv61DvaC35wsD/C7LBZ1AR9nh/X4UYMw=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
 t=1645500024; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=ViDG/yMqWZxCAxTaqQtcLcHL6JhRHELXtVbiJuJsPUo=;
 b=Tmz1uo8woLZXqpnP6AmoA/NTuRgmjrgW2cLueq9/kp9TCyUa6S7R3LyYWeiTFJaHuy3dUM
 KZRmOxRvt9ZDQSR+hpxKFewxvdZZ9Urtb6en4poxusvXIBIlgrBpBLKDAdWO2ORb+DR1Mi
 bSVP8TV+gQpT0TCoBjfqhnJf7D5nXLw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
 s=susede2_ed25519; t=1645500024;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=ViDG/yMqWZxCAxTaqQtcLcHL6JhRHELXtVbiJuJsPUo=;
 b=BbqDPkZmtQqupAAVe4rSFiNNNRKLh+0XT0FLFde2mCgSKOwY64NUe64xN29OsgNhaJyglf
 D4tHxubXuewZC/CA==
In-Reply-To: <164549971112.9187.16871723439770288255.stgit@noble.brown>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>, Wu Fengguang <fengguang.wu@intel.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, Trond Myklebust <trond.myklebust@hammerspace.com>, Anna Schumaker <anna.schumaker@netapp.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, "Darrick J. Wong" <djwong@kernel.org>, Philipp Reisner <philipp.reisner@linbit.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, Paolo Valente <paolo.valente@linaro.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org, drbd-dev@lists.linbit.com

bfq_get_queue() expects a "bool" for the third arg, so pass "false"
rather than "BLK_RW_ASYNC" which will soon be removed.

Acked-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: NeilBrown <neilb@suse.de>
---
 block/bfq-iosched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 36a66e97e3c2..ed9bb1054bf2 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -5448,7 +5448,7 @@ static void bfq_check_ioprio_change(struct bfq_io_cq *bic, struct bio *bio)
 	bfqq = bic_to_bfqq(bic, false);
 	if (bfqq) {
 		bfq_release_process_ref(bfqd, bfqq);
-		bfqq = bfq_get_queue(bfqd, bio, BLK_RW_ASYNC, bic, true);
+		bfqq = bfq_get_queue(bfqd, bio, false, bic, true);
 		bic_set_bfqq(bic, bfqq, false);
 	}
