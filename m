From: NeilBrown <neilb@suse.de>
Subject: [PATCH 10/11] block/bfq-iosched.c: use "false" rather
 than "BLK_RW_ASYNC"
Date: Thu, 10 Feb 2022 16:37:52 +1100
Message-ID: <164447147264.23354.2763356897218946255.stgit@noble.brown>
References: <164447124918.23354.17858831070003318849.stgit@noble.brown>
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
 bh=zUXE+p4nU0NR3LK33keTKiC3MiGpqHZzDnhCV/FYFVc=; b=cNtKVLYjlYJnuS533+2zSs0kuy
 Xpl8W2kK0to64g9QHEFHjqS9AgkiIcuiJB2R46OS1QbkhG6snxzKDf5uX7pO4bfZ8rKYpW9kqVdlR
 p3n5TgTodiY59G/52gHT+RYo/2S0kTnYxozMzbiZfLm8XCgnRjAezYzhh/6aL8ug49Cw=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
 In-Reply-To:Message-ID:Date:Cc:To:From:Subject:Sender:Reply-To:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=zUXE+p4nU0NR3LK33keTKiC3MiGpqHZzDnhCV/FYFVc=; b=Cd1C2L16NRMhMx8AlFQeWWBYS6
 /c/LiYi7A/UysX9ywzOFzKjvx6GDyN+s47o9Kt7Q9fw6qhfKhdacqOzU33XNE0Ad/uAkrvwlCHAja
 IowkcVo/lu+10TIKA/ptOGLk/dNUXwua8LyIgUg+HYDTAnIZ8ZPhmHgc5V5uqByU7SO8=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
 t=1644471706; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=zUXE+p4nU0NR3LK33keTKiC3MiGpqHZzDnhCV/FYFVc=;
 b=1iOjcBu6oE+BXqXEFHtabUHK7sZNNAt+F9BXNB5uV7m3v4yti6KzGXBiLv7VLruTI3nEpR
 RzUf48rnigX5xLwZY9cqLSfPrG7m7EbPedvqO83z8P0IJauCacL1yhTk9JKT9feAU1DqJI
 KUpM8T9cgXJ5IztxA4OlP16a8F1IH8w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
 s=susede2_ed25519; t=1644471706;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=zUXE+p4nU0NR3LK33keTKiC3MiGpqHZzDnhCV/FYFVc=;
 b=0ZiiWmrlykQukuniHTdmeJDPxTmHcRtiUSrL0vXadFeW3t9RQIDNXluXWa7JinzIWwJ++B
 zkp5vHuwQfZju0DQ==
In-Reply-To: <164447124918.23354.17858831070003318849.stgit@noble.brown>
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
Cc: linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org, drbd-dev@lists.linbit.com

bfq_get_queue() expects a "bool" for the third arg, so pass "false"
rather than "BLK_RW_ASYNC" which will soon be removed.

Acked-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: NeilBrown <neilb@suse.de>
---
 block/bfq-iosched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 0c612a911696..4e645ae1e066 100644
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
