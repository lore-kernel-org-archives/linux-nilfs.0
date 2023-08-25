From: Hao Xu <hao.xu@linux.dev>
Subject: [PATCH 21/29] xfs: return -EAGAIN when bulk memory
 allocation fails in nowait case
Date: Fri, 25 Aug 2023 21:54:23 +0800
Message-ID: <20230825135431.1317785-22-hao.xu@linux.dev>
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
 bh=k/4ZXSLCSyhuRHiUlNViF+vdvrXezEQu+Nm95mQGfD4=; b=NT50RMw+ubHCjF+hmC/4/4qjZA
 aX+VQuoyx4BAt/sCykkvjYcnc7F1VE0iy5PZ1fceZ5gu/341on9/D/Zw8Tz3/8RWxAK+7SkMnfXvs
 KK+pNAfbuH6zaAaWUbOVszEX+uk4J4YA6NExOebZ3oLONSm2EHQ8JE09ameUGa0IXwcc=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=k/4ZXSLCSyhuRHiUlNViF+vdvrXezEQu+Nm95mQGfD4=; b=juDuDxKdacVLDj9l0B3crDoXcI
 3nswYppIXhDttdgwqdkUmKQuiRZS8GBUWLaNKhzlFLfMNNgawdSG6MuvpozeGhoWZEtuJfY/P+y1T
 nPBKl6xJ3o93e76fpISc3GKEeheFmWbTWAgb8EfrH+TqjHKqzzLv5z83Ld4T9qbTf1lA=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1692972229;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=k/4ZXSLCSyhuRHiUlNViF+vdvrXezEQu+Nm95mQGfD4=;
 b=XN4VKQ0vJWdKOqygAoO6O9s0mfT9sbRl6WKC6PlM4YizrHDbuoZWPHymJ4boioTyhTPsXz
 mzB7w7XoqaVp3khAiC/KVcJAYhLbwQjG/YZ+xeSDe8Sd8K9S+AePqNUb6KBAAuKlTSuaCl
 kFQBsj5S1c42QHrr1w1CZcr0QQo5mJc=
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

Rather than wait for a moment and retry, we return -EAGAIN when we fail
to allocate bulk memory in xfs_buf_alloc_pages() in nowait case.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/xfs/xfs_buf.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index a6e6e64ff940..eb3cd7702545 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -404,6 +404,11 @@ xfs_buf_alloc_pages(
 		if (filled != last)
 			continue;
 
+		if (nowait) {
+			xfs_buf_free_pages(bp);
+			return -EAGAIN;
+		}
+
 		if (flags & XBF_READ_AHEAD) {
 			xfs_buf_free_pages(bp);
 			return -ENOMEM;
-- 
2.25.1
