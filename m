From: Hao Xu <hao.xu@linux.dev>
Subject: [PATCH 23/29] xfs: don't print warn info for -EAGAIN
 error in xfs_buf_get_map()
Date: Fri, 25 Aug 2023 21:54:25 +0800
Message-ID: <20230825135431.1317785-24-hao.xu@linux.dev>
References: <20230825135431.1317785-1-hao.xu@linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Content-Transfer-Encoding:MIME-Version:References:
 In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=sCdpGKioQF34weG5w+z0/y3PF/fjvtNNI35yO4EvtLk=; b=bWf3wKRaIcyZvuW/brto++iwAc
 s9Jvo2aLFMIG3F/sUvr66qfljhBQKwTyHcrlenSJGTSUqjzDc0ZuQN/kefIyWrUCcY1HSS9icKaF2
 1/zSKfMQV/QR7nLOIWu9TjqVGYWvgVBFA9suM7DkIwUXNWn+QyP8bRN2cdCnopyPtiCw=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=sCdpGKioQF34weG5w+z0/y3PF/fjvtNNI35yO4EvtLk=; b=YS7oAXopoIPkY6vsQ03Rxob+je
 DXxEMul8AwrLhix8imB9THtQyur5wToKHV9D4HqHK1ZPi8JQ1Qv8YQhbIepbX/lST9wRa74MCA7R3
 zO8PBOY3kv865VfVoGBg+L3dwz2hhMPBJig9QQQvp5K2sMmfhU8Sg4XUPxHPaw1R6ta4=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1692972277;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=sCdpGKioQF34weG5w+z0/y3PF/fjvtNNI35yO4EvtLk=;
 b=cYsDGPpjRbWUMOTIPyMO/haz1FlbbiWizE4L6+4KiNimBQndM5dbyTTkg9jBA2egpwU6Cb
 fkg5cTnWwTpMK0RxO73BKMbVgecaeb3ZdD5hvh5LwNn8nQIo0z4wNaoOSgDtnANIdxLDF6
 nhdxpWfLei5X8co+EkZeZUy0T4PzeHk=
In-Reply-To: <20230825135431.1317785-1-hao.xu@linux.dev>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Wanpeng Li <wanpengli@tencent.com>, "Darrick J . Wong" <djwong@kernel.org>, Dominique Martinet <asmadeus@codewreck.org>, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>, linux-s390@vger.kernel.org, linux-nilfs@vger.kernel.org, codalist@coda.cs.cmu.edu, cluster-devel@redhat.com, linux-cachefs@redhat.com, linux-ext4@vger.kernel.org, devel@lists.orangefs.org, linux-cifs@vger.kernel.org, ecryptfs@vger.kernel.org, linux-nfs@vger.kernel.org, linux-block@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, netdev@vger.kernel.org, samba-technical@lists.samba.org, linux-unionfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org, bpf@vger.kernel.o

From: Hao Xu <howeyxu@tencent.com>

-EAGAIN is internal error to indicate a retry, no needs to print a
warn.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/xfs/xfs_buf.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 57bdc4c5dde1..cdad80e1ae25 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -730,9 +730,10 @@ xfs_buf_get_map(
 	if (!bp->b_addr) {
 		error = _xfs_buf_map_pages(bp, flags);
 		if (unlikely(error)) {
-			xfs_warn_ratelimited(btp->bt_mount,
-				"%s: failed to map %u pages", __func__,
-				bp->b_page_count);
+			if (error != -EAGAIN)
+				xfs_warn_ratelimited(btp->bt_mount,
+					"%s: failed to map %u pages", __func__,
+					bp->b_page_count);
 			xfs_buf_relse(bp);
 			return error;
 		}
-- 
2.25.1
