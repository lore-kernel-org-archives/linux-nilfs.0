From: Hao Xu <hao.xu@linux.dev>
Subject: [PATCH 08/11] vfs: move file_accessed() to the beginning
 of iterate_dir()
Date: Sun, 27 Aug 2023 21:28:32 +0800
Message-ID: <20230827132835.1373581-9-hao.xu@linux.dev>
References: <20230827132835.1373581-1-hao.xu@linux.dev>
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
 bh=X5RgYva0uI/YfpMcRAQXXXC0hBNumZORbEO2XQnoCOE=; b=em3yKlbsCGtaTI2NUu5EqW+ED/
 Rrl7GlZv/VFYODBSFq3PhGTd9IyFsRmDy2hB66QARsUm4z/byGSzosMdQvOlifzRkTCuERS7UO2VD
 vc65UEGQ3bmcLWqjh0U6qssO9QqybFDSOheJnKh4XYSfyiRhmooi0vI2WiDwNTQQ+jkc=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=X5RgYva0uI/YfpMcRAQXXXC0hBNumZORbEO2XQnoCOE=; b=m6JI+4LIeWxqtnKAK9cUIq3DQC
 DIEnnI6nTlyHvE5jWjknnTiXnikIBjG2y46kkDeGMdo2XVBMEWcYmm4nqJ/xoJRPVsDBfylmx2hJF
 Cwp0XEEQftRWfyE2coSKh+C102giTMKEpP6w3O4yICOD1egeI5yiKP25VGDMZSbW9l+g=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1693143280;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=X5RgYva0uI/YfpMcRAQXXXC0hBNumZORbEO2XQnoCOE=;
 b=WXr39RUhGjmbBKUuqHmNng9tnfRreU8ks2ZtLjekYh53jHM4CnAQcsfBzBDABn1mkShot8
 ZX46/udLE4Y2+Gp8W4OGBBchscS3B/zTnSSJs8rd29bz5YyB6Ia5W1tSVuXmmsCsWASJVj
 OhE3i3OIyl7cEamjJGJ1G7EdndXC44c=
In-Reply-To: <20230827132835.1373581-1-hao.xu@linux.dev>
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

Move file_accessed() to the beginning of iterate_dir() so that we don't
need to rollback all the work done when file_accessed() returns -EAGAIN
at the end of getdents.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/readdir.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/readdir.c b/fs/readdir.c
index 2f4c9c663a39..6469f076ba6e 100644
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -61,6 +61,10 @@ int iterate_dir(struct file *file, struct dir_context *ctx)
 
 	res = -ENOENT;
 	if (!IS_DEADDIR(inode)) {
+		res = file_accessed(file, ctx->flags & DIR_CONTEXT_F_NOWAIT);
+		if (res == -EAGAIN)
+			goto out_unlock;
+
 		ctx->pos = file->f_pos;
 		if (shared)
 			res = file->f_op->iterate_shared(file, ctx);
@@ -68,8 +72,9 @@ int iterate_dir(struct file *file, struct dir_context *ctx)
 			res = file->f_op->iterate(file, ctx);
 		file->f_pos = ctx->pos;
 		fsnotify_access(file);
-		file_accessed(file, ctx->flags & DIR_CONTEXT_F_NOWAIT);
 	}
+
+out_unlock:
 	if (shared)
 		inode_unlock_shared(inode);
 	else
-- 
2.25.1
