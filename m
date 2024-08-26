Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8E519993E;
	Mon, 26 Aug 2024 17:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724694101; cv=none; b=mPP3gSu9ubS/8JVoXFVAp23xlYgQVmQNb2PL+0yUwEt1dsgKMsyuymNxlpslngWreYzMg/Sboo+lgM4LSHPW5sSVOFY2vOev46t/s9KK+fmiTV1SmMpCvBUrnYOpxGpdzb2icsgC6YS7ojJ9IYQEB2Mf9CL1dYz7NAW8NvrbcJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724694101; c=relaxed/simple;
	bh=2HBsggGsl/AitU2NzdBb7heQnGUZ4t1FjGjfGF9NwdI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FbtnMkYMnST99kJ+qdCuW9/FamJu8z9n7kilgfgesGo5kqF5Er3qFvYof0/0l5aF8IVt0cerkrXhtgWjgqY5G5xcykbAx8ahIQQkwIGYlOwSbCmlaUX6MlG5jbaoMNu6Tt5lF49drSd1PsNbLCYC3xANY1IMckqC3DmFJjYMhiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A/jh8ie1; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A/jh8ie1"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-714226888dfso4139795b3a.1;
        Mon, 26 Aug 2024 10:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724694100; x=1725298900; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dkzYfKwrKWY8U5r8QEB4WhkXm8xbBAJPRKpgneYz3SM=;
        b=A/jh8ie1JcMJrnPQ3tOFCfe8cA+Oji8ArxMJwiOL937wL0DldqJrqQfb6e1li50A6b
         9r0w2T174vZQr7Cm4hhrQRiC8pAdHOvhrTYASN3eGiJU3IE2ScaU78dFJ8OSMREWIXr9
         twnVAFvB7fpw2XxK0h3m9ubI+k9to/ixF+ZqlNJw2K56LOEuPoguuwKepY8MdFGhPFGS
         mdQSRC8zqnfkfDBY+Pv+WQvRe7jyuJlfiwtCB0WORWqP5XZLhcigpEfjpj+2frp/Yoc8
         U2Adf2zUUeygWIWR2xxEnkzfymcatLW7RbJFZefJ5sMVnrOgvEo4TuOofa2vhIpKvXKN
         bnlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724694100; x=1725298900;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dkzYfKwrKWY8U5r8QEB4WhkXm8xbBAJPRKpgneYz3SM=;
        b=hShmABgeWDoGuWFaRiZbfdb06uWdkGcXmNMA996ZkrT8Ou06mTGqTcVvXV6MHaFEeG
         rRTlEEIjxhjI7uhHq1WbnyR6w9WIoPFhIOww/WyXArwvFrMugrOdrRbEzBXUlgGB+ahf
         EDIzelPuTAeN6Y4xYlY3+VOuw9AqP/h/N68QAuOIZURvNDuvFQYt45xB+dZhE4XZzt2p
         8oEBs1AqcKL2tMyZnY2Q3OcD3UrQ5/qcNVu73Nn8KM2tBZZe8jNJI0n5o8qdO48u4M4Z
         si5yOBUO9n5yejS2u2Vjv6eJOznPNyhsDPqt0CdRLS1YylFL1iPjLdPjFJtGxpyTJ7so
         rA5g==
X-Forwarded-Encrypted: i=1; AJvYcCVxHVyxgQqYx0GeYOOlCPYtWnnn5o+f/oaxAwYyUijlmd9ufAzwxMiC198R5r03Gqp8rMUzZL0j2ohVJog=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx23fWQ2k0ObEou6RPLpxGLQ2Q6pJYaQ4kFs37IdEtxcalqPjoO
	qULy/WaB1zHS/RoRzeUqU9Fwzbr3aBmxSIy7p38iKqhlt6ktpUjy/iluBw==
X-Google-Smtp-Source: AGHT+IGMdQOOC4QIvQff/SeCQGdhJBhTtCV3dwCPgpC85Z5z1qHhhdzjLLqjY4BeQuj+M7Gkab6mYg==
X-Received: by 2002:a05:6a20:439f:b0:1ca:cc16:1ebc with SMTP id adf61e73a8af0-1cc89d29a8amr12537886637.11.1724694099327;
        Mon, 26 Aug 2024 10:41:39 -0700 (PDT)
Received: from carrot.. (i222-151-34-139.s42.a014.ap.plala.or.jp. [222.151.34.139])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-203855665besm70057055ad.34.2024.08.26.10.41.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 10:41:38 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] nilfs2: eliminate the shared counter and spinlock for i_generation
Date: Tue, 27 Aug 2024 02:41:12 +0900
Message-Id: <20240826174116.5008-5-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240826174116.5008-1-konishi.ryusuke@gmail.com>
References: <20240826174116.5008-1-konishi.ryusuke@gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use get_random_u32() as the source for inode->i_generation for new
inodes, and eliminate the original source, the shared counter
ns_next_generation along with its exclusive access spinlock
ns_next_gen_lock.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/inode.c     | 6 ++----
 fs/nilfs2/the_nilfs.c | 5 -----
 fs/nilfs2/the_nilfs.h | 6 ------
 3 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 35f966cb4ece..3c4a0577bc71 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -15,6 +15,7 @@
 #include <linux/writeback.h>
 #include <linux/uio.h>
 #include <linux/fiemap.h>
+#include <linux/random.h>
 #include "nilfs.h"
 #include "btnode.h"
 #include "segment.h"
@@ -320,7 +321,6 @@ static int nilfs_insert_inode_locked(struct inode *inode,
 struct inode *nilfs_new_inode(struct inode *dir, umode_t mode)
 {
 	struct super_block *sb = dir->i_sb;
-	struct the_nilfs *nilfs = sb->s_fs_info;
 	struct inode *inode;
 	struct nilfs_inode_info *ii;
 	struct nilfs_root *root;
@@ -381,9 +381,7 @@ struct inode *nilfs_new_inode(struct inode *dir, umode_t mode)
 	/* ii->i_dir_acl = 0; */
 	ii->i_dir_start_lookup = 0;
 	nilfs_set_inode_flags(inode);
-	spin_lock(&nilfs->ns_next_gen_lock);
-	inode->i_generation = nilfs->ns_next_generation++;
-	spin_unlock(&nilfs->ns_next_gen_lock);
+	inode->i_generation = get_random_u32();
 	if (nilfs_insert_inode_locked(inode, root, ino) < 0) {
 		err = -EIO;
 		goto failed_after_creation;
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index e44dde57ab65..ac03fd3c330c 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -12,7 +12,6 @@
 #include <linux/slab.h>
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
-#include <linux/random.h>
 #include <linux/log2.h>
 #include <linux/crc32.h>
 #include "nilfs.h"
@@ -69,7 +68,6 @@ struct the_nilfs *alloc_nilfs(struct super_block *sb)
 	INIT_LIST_HEAD(&nilfs->ns_dirty_files);
 	INIT_LIST_HEAD(&nilfs->ns_gc_inodes);
 	spin_lock_init(&nilfs->ns_inode_lock);
-	spin_lock_init(&nilfs->ns_next_gen_lock);
 	spin_lock_init(&nilfs->ns_last_segment_lock);
 	nilfs->ns_cptree = RB_ROOT;
 	spin_lock_init(&nilfs->ns_cptree_lock);
@@ -754,9 +752,6 @@ int init_nilfs(struct the_nilfs *nilfs, struct super_block *sb)
 	nilfs->ns_blocksize_bits = sb->s_blocksize_bits;
 	nilfs->ns_blocksize = blocksize;
 
-	get_random_bytes(&nilfs->ns_next_generation,
-			 sizeof(nilfs->ns_next_generation));
-
 	err = nilfs_store_disk_layout(nilfs, sbp);
 	if (err)
 		goto failed_sbh;
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index 1e829ed7b0ef..4776a70f01ae 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -71,8 +71,6 @@ enum {
  * @ns_dirty_files: list of dirty files
  * @ns_inode_lock: lock protecting @ns_dirty_files
  * @ns_gc_inodes: dummy inodes to keep live blocks
- * @ns_next_generation: next generation number for inodes
- * @ns_next_gen_lock: lock protecting @ns_next_generation
  * @ns_mount_opt: mount options
  * @ns_resuid: uid for reserved blocks
  * @ns_resgid: gid for reserved blocks
@@ -161,10 +159,6 @@ struct the_nilfs {
 	/* GC inode list */
 	struct list_head	ns_gc_inodes;
 
-	/* Inode allocator */
-	u32			ns_next_generation;
-	spinlock_t		ns_next_gen_lock;
-
 	/* Mount options */
 	unsigned long		ns_mount_opt;
 
-- 
2.34.1

