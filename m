Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B20A418A28
	for <linux-nilfs@vger.kernel.org>; Tue, 15 Sep 2026 04:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789445537; cv=none; b=ILHkCd7A9xgUVQBWsPrvp9CHTb+oJfmSHpfxnRGX6DuaCOf0NuIkhiAhseFx2HsQDTVzZKVJBR2kVITu0XYLDq2rp3c976Pj/rcaWGEl50KWCHFVSn7ZhdfaeBoeXF5wma8LqzPPqgvfP8Z2nsdHFRJoa5W4oLsCjHkQF6yBAhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789445537; c=relaxed/simple;
	bh=1gmbEigSLHg0i7bT9mw0MD9g5euC0bVT4jLe4Ta7ZW0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LmIMdgf399N9nYVwS75YyLm1czGXQEdCQX497emQJjA9qCAYh1I/V2IMXKyR5pg8veY7ydSlfCtZn6oTtCsJ94iMtF4RQOi83T2he/d2HSXZpcN7bsqxxrpiJpJceZy0hg34K9tEQ5Q/a1+P4RTRT19v5w8KoG08H9TKr0ODp3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EWrp3DYb; arc=none smtp.client-ip=209.85.221.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EWrp3DYb"
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-5c989be99abso334019e0c.1
        for <linux-nilfs@vger.kernel.org>; Mon, 14 Sep 2026 21:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789445535; x=1790050335; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vuT48i8nAD7BsuLmGtFIqeLB1ZSfBya8jF/X5lCprRw=;
        b=EWrp3DYbyQq/XJvhYRbCgMg1G2Mc88BShQWJHOpIGE5aCc8x0qr22QyvgSKlNx1JyW
         xScdcIwzIQKIWi9ILujgV4xezSKH+QyjNPyHzd6wnUFQiAc85vtCr9g9zwMqEzMf6kj/
         H80QQlopMZX7XtlKzMoG8U6eUhbJBN9sLqcYHXZNxv+ivV5QjAk4N2HdJvSFPTOQpcky
         n8gjb6bpXIv1UziCchcKoxacvdBMNNOH+Pl8ih8rHAX4TDHx8yRCUq4hlJo0XlWti4KR
         wCokt4QPd4qXsF5oeYp9ka0naxkrWSMBtqyVXmgwkurIkVkLNevcgb/DIrFwh4TwvlNM
         54WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789445535; x=1790050335;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vuT48i8nAD7BsuLmGtFIqeLB1ZSfBya8jF/X5lCprRw=;
        b=DSQB8P0R3CaZ5yC0PLp9PzBIt33vmZ/CE6kIygfm7jIxmq7zQnmysJaG/NtPZU4Bdm
         FSSlS6oqnMKgjyXWS6H5yKo74QIr1JoKIOvhliVAI+0BT9nyb3cBmfqwYAxakyJQF93u
         WgSIxCLJHlOYG4ptW79+7qS7UHht7bAYv1P1IQ89+yL/RLuOz6jHEn4W54rEXvGdQhly
         NoN3uccDpBKDZkItQLxbl5H+oKCYYvS7OpdreZ1v01E+Iv58gajW5wyfVsGQx0q9s11a
         u68aOOBKA3wo489qB4/nisUTWe58YnBHBtPN/8L/vhGj6qqhaI26HjpN02YbJYogMKwd
         5IXg==
X-Forwarded-Encrypted: i=1; AKwUvBzYjM9DNqB5dFHxR+6S/uWPbwz150BbGvRZGTADOmPjR2jtpjbZv8sDMP6tDRR2wBKunS9QDOd7U1hTpg==@vger.kernel.org
X-Gm-Message-State: AFuF++nZe2ohF6Z8ZQ58I+mz2+I852syuEBLOcJq2Lu+/HRXdHSifejt
	hs9BdCDLEtCPknmA4CHRApjCLEYlOGnqLrZhNHpf3cidhDMrtLJp2QGu
X-Gm-Gg: AYBFou2qY1VjcZqfIP70O+4/3KrIe4v3B0GWAt297aZGcINw0vH+1otw7Xvn1ktrjZ9
	efL/lJdA8IP0Mlca4BSMIbOJuzB+jtYEYC5XsSOMjUmcQv8/4+uKQjLxvdWz+xEfnlwpzFYxN5v
	N+TPNWRuiVo9AiP+xorhXAgGyaEYPyuSYWZ91R64tXPfCny+n8NNuzwGVmgmbo9IIlLIdlLADbv
	Fnauev680qk/ce0vbpOIlRCQkHUnQFAAsL572mRckSHWHTcbmmhYpZfWtEW4nD7cMgVnJosqfSe
	l5FDglQBwizRjLUgMTOVEtTK8mHtKn1TFDMpYqqLMofdg9lMtBpKxoPBXhpr9JPt6G0tHflV4aG
	slgtl/v7TvljuRLgPycwKzKrb9GHADQ6mL0AvjWPR8QNBnl9cwLTN4CvxOb9NpPi8sYUkqBVAHV
	vofdhd7GcdF/32fuVioE40ujehHjHqKbMtBA8MAf/DsFESorq0Al+IdgL2uieWm/XY
X-Received: by 2002:a05:6122:469f:b0:5bf:7f98:9657 with SMTP id 71dfb90a1353d-5c981d4c288mr6299213e0c.6.1789445534889;
        Mon, 14 Sep 2026 21:12:14 -0700 (PDT)
Received: from beelink.. ([187.13.206.89])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c846e05523sm15329021e0c.0.2026.09.14.21.12.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 21:12:14 -0700 (PDT)
From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>,
	linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Subject: [PATCH] nilfs2: fix checkpoint root lifetime on sysfs errors
Date: Tue, 15 Sep 2026 01:12:06 -0300
Message-ID: <20260915041206.2430937-1-qwe.aldo@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nilfs_find_or_create_root() publishes a new root in the checkpoint
tree before creating its sysfs object.  If sysfs registration fails,
the root is freed while it is still reachable from the tree.  Merely
erasing it in the error path is insufficient because a concurrent
lookup may already hold a reference.

Serialize root creation and removal, finish sysfs registration before
publishing the root, and wait for the embedded kobject release before
freeing its container.  The wait also makes normal root removal safe
when kobject release is delayed.

Fixes: dd70edbde262 ("nilfs2: integrate sysfs support into driver")
Cc: stable@vger.kernel.org
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
---
 fs/nilfs2/the_nilfs.c | 38 +++++++++++++++++++++++++-------------
 fs/nilfs2/the_nilfs.h |  3 +++
 2 files changed, 28 insertions(+), 13 deletions(-)

diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 7b23e373a..01389dba2 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -71,6 +71,7 @@ struct the_nilfs *alloc_nilfs(struct super_block *sb)
 	spin_lock_init(&nilfs->ns_last_segment_lock);
 	nilfs->ns_cptree = RB_ROOT;
 	spin_lock_init(&nilfs->ns_cptree_lock);
+	mutex_init(&nilfs->ns_cptree_mutex);
 	init_rwsem(&nilfs->ns_segctor_sem);
 	nilfs->ns_sb_update_freq = NILFS_SB_FREQ;
 
@@ -881,8 +882,15 @@ nilfs_find_or_create_root(struct the_nilfs *nilfs, __u64 cno)
 	if (!new)
 		return NULL;
 
-	spin_lock(&nilfs->ns_cptree_lock);
+	new->cno = cno;
+	new->ifile = NULL;
+	new->nilfs = nilfs;
+	refcount_set(&new->count, 1);
+	atomic64_set(&new->inodes_count, 0);
+	atomic64_set(&new->blocks_count, 0);
 
+	mutex_lock(&nilfs->ns_cptree_mutex);
+	spin_lock(&nilfs->ns_cptree_lock);
 	p = &nilfs->ns_cptree.rb_node;
 	parent = NULL;
 
@@ -897,29 +905,28 @@ nilfs_find_or_create_root(struct the_nilfs *nilfs, __u64 cno)
 		} else {
 			refcount_inc(&root->count);
 			spin_unlock(&nilfs->ns_cptree_lock);
+			mutex_unlock(&nilfs->ns_cptree_mutex);
 			kfree(new);
 			return root;
 		}
 	}
-
-	new->cno = cno;
-	new->ifile = NULL;
-	new->nilfs = nilfs;
-	refcount_set(&new->count, 1);
-	atomic64_set(&new->inodes_count, 0);
-	atomic64_set(&new->blocks_count, 0);
-
-	rb_link_node(&new->rb_node, parent, p);
-	rb_insert_color(&new->rb_node, &nilfs->ns_cptree);
-
 	spin_unlock(&nilfs->ns_cptree_lock);
 
 	err = nilfs_sysfs_create_snapshot_group(new);
 	if (err) {
+		mutex_unlock(&nilfs->ns_cptree_mutex);
+		wait_for_completion(&new->snapshot_kobj_unregister);
 		kfree(new);
-		new = NULL;
+		return NULL;
 	}
 
+	spin_lock(&nilfs->ns_cptree_lock);
+	rb_link_node(&new->rb_node, parent, p);
+	rb_insert_color(&new->rb_node, &nilfs->ns_cptree);
+
+	spin_unlock(&nilfs->ns_cptree_lock);
+	mutex_unlock(&nilfs->ns_cptree_mutex);
+
 	return new;
 }
 
@@ -927,13 +934,18 @@ void nilfs_put_root(struct nilfs_root *root)
 {
 	struct the_nilfs *nilfs = root->nilfs;
 
+	mutex_lock(&nilfs->ns_cptree_mutex);
 	if (refcount_dec_and_lock(&root->count, &nilfs->ns_cptree_lock)) {
 		rb_erase(&root->rb_node, &nilfs->ns_cptree);
 		spin_unlock(&nilfs->ns_cptree_lock);
 
 		nilfs_sysfs_delete_snapshot_group(root);
+		mutex_unlock(&nilfs->ns_cptree_mutex);
+		wait_for_completion(&root->snapshot_kobj_unregister);
 		iput(root->ifile);
 
 		kfree(root);
+	} else {
+		mutex_unlock(&nilfs->ns_cptree_mutex);
 	}
 }
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index 4776a70f0..72affad9e 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -68,6 +68,7 @@ enum {
  * @ns_sufile: segusage file inode
  * @ns_cptree: rb-tree of all mounted checkpoints (nilfs_root)
  * @ns_cptree_lock: lock protecting @ns_cptree
+ * @ns_cptree_mutex: mutex serializing checkpoint root creation and removal
  * @ns_dirty_files: list of dirty files
  * @ns_inode_lock: lock protecting @ns_dirty_files
  * @ns_gc_inodes: dummy inodes to keep live blocks
@@ -151,6 +152,8 @@ struct the_nilfs {
 	/* Checkpoint tree */
 	struct rb_root		ns_cptree;
 	spinlock_t		ns_cptree_lock;
+	/* Serialize root creation and removal. */
+	struct mutex		ns_cptree_mutex;
 
 	/* Dirty inode list */
 	struct list_head	ns_dirty_files;
-- 
2.43.0

