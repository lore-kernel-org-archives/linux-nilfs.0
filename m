From: Hao Xu <hao.xu@linux.dev>
Subject: [PATCH 01/29] fs: split off vfs_getdents function of
 getdents64 syscall
Date: Fri, 25 Aug 2023 21:54:03 +0800
Message-ID: <20230825135431.1317785-2-hao.xu@linux.dev>
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
 bh=M7eywqhb1fMAXTeyjh6BJsPONBLehGvo8wJ7nQSmBJs=; b=nRr14dnQW6v1uI0mryHz5yAijM
 vC+Ezu3KhTLQCBz6I1CdGxJfa9/R1DWJUw6q1xdBd0e6fycxjWYs8Lz8EjndBbZlwYVutW/GODsrP
 /ts/YkOqUSoR4I+hwJzHYhqYQ4zO1jU1QLXKs2nEZktrCoYC2oCOIUDxyOfB9bKGixUE=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=M7eywqhb1fMAXTeyjh6BJsPONBLehGvo8wJ7nQSmBJs=; b=mKC2Slz5NLRVJzudrtXRTINBeA
 AgvQHHWyRIF2bDnhgZULHz50lPfikheYu24YQT2OVSOcgkacaA3KRjUmTYfnF/v3fKBOFo6WrByPv
 lVLgo/usukM3Yjkk22I99hWqxlh8kZOxN4nlgzPJG1A40hL/HXk5iMNFlMdNGGBF4t9Y=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1692971717;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=M7eywqhb1fMAXTeyjh6BJsPONBLehGvo8wJ7nQSmBJs=;
 b=sf0c3BaV5zKRH4Bb8TUwfPopplZAFyQJxSB3uPd/Bru862GHE/6uLEqra/FCbrZoDX4RQi
 CIrt1XneKgBJ/A8gWA/etx0kgRlpMUcGJTfa14yTcf5Kv3L0Wt8Br8rgcIz1PY9X6AeQ+Q
 Vrx6zJaXOEDBrQhrS+G7Zr51TGkx4FM=
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

From: Dominique Martinet <asmadeus@codewreck.org>

This splits off the vfs_getdents function from the getdents64 system
call.
This will allow io_uring to call the vfs_getdents function.

Co-developed-by: Stefan Roesch <shr@fb.com>
Signed-off-by: Stefan Roesch <shr@fb.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/internal.h |  8 ++++++++
 fs/readdir.c  | 34 ++++++++++++++++++++++++++--------
 2 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index f7a3dc111026..b1f66e52d61b 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -304,3 +304,11 @@ ssize_t __kernel_write_iter(struct file *file, struct iov_iter *from, loff_t *po
 struct mnt_idmap *alloc_mnt_idmap(struct user_namespace *mnt_userns);
 struct mnt_idmap *mnt_idmap_get(struct mnt_idmap *idmap);
 void mnt_idmap_put(struct mnt_idmap *idmap);
+
+/*
+ * fs/readdir.c
+ */
+struct linux_dirent64;
+
+int vfs_getdents(struct file *file, struct linux_dirent64 __user *dirent,
+		 unsigned int count);
diff --git a/fs/readdir.c b/fs/readdir.c
index b264ce60114d..9592259b7e7f 100644
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -21,6 +21,7 @@
 #include <linux/unistd.h>
 #include <linux/compat.h>
 #include <linux/uaccess.h>
+#include "internal.h"
 
 #include <asm/unaligned.h>
 
@@ -351,10 +352,16 @@ static bool filldir64(struct dir_context *ctx, const char *name, int namlen,
 	return false;
 }
 
-SYSCALL_DEFINE3(getdents64, unsigned int, fd,
-		struct linux_dirent64 __user *, dirent, unsigned int, count)
+
+/**
+ * vfs_getdents - getdents without fdget
+ * @file    : pointer to file struct of directory
+ * @dirent  : pointer to user directory structure
+ * @count   : size of buffer
+ */
+int vfs_getdents(struct file *file, struct linux_dirent64 __user *dirent,
+		 unsigned int count)
 {
-	struct fd f;
 	struct getdents_callback64 buf = {
 		.ctx.actor = filldir64,
 		.count = count,
@@ -362,11 +369,7 @@ SYSCALL_DEFINE3(getdents64, unsigned int, fd,
 	};
 	int error;
 
-	f = fdget_pos(fd);
-	if (!f.file)
-		return -EBADF;
-
-	error = iterate_dir(f.file, &buf.ctx);
+	error = iterate_dir(file, &buf.ctx);
 	if (error >= 0)
 		error = buf.error;
 	if (buf.prev_reclen) {
@@ -379,6 +382,21 @@ SYSCALL_DEFINE3(getdents64, unsigned int, fd,
 		else
 			error = count - buf.count;
 	}
+	return error;
+}
+
+SYSCALL_DEFINE3(getdents64, unsigned int, fd,
+		struct linux_dirent64 __user *, dirent, unsigned int, count)
+{
+	struct fd f;
+	int error;
+
+	f = fdget_pos(fd);
+	if (!f.file)
+		return -EBADF;
+
+	error = vfs_getdents(f.file, dirent, count);
+
 	fdput_pos(f);
 	return error;
 }
-- 
2.25.1
