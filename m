Received: from mail-vs2-f12.google.com (mail-vs2-f12.google.com [74.125.227.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A6C4D9908
	for <linux-nilfs@vger.kernel.org>; Wed, 16 Sep 2026 23:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789602638; cv=none; b=C3ddngn1GRVySX0TPxDCfb8Y58bMPNQS3lYWsero6Dp0AVZ4Tdd3Jimo6TFRD3sphb6WiHKOEbrORtB6hWkAT2UqgyxdTJlZay+GVNvYKKQBtnkddkBMgYLOVAKD0c0HWoJwPBsApSGLZ+o4UO7wanlavmeV7XUO+v3bzv7iRg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789602638; c=relaxed/simple;
	bh=VGpc1VGo/Rid6j2yd7798v5BZCQYyZlxZiprXTOuxOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dRyEgae93k14ENBMEREVAvD9e2QLVSLTp9JhCQcqJlENEJ4cpJHBc3O0R5VjcC8HBDSFW89eKn9JQ/OBTSlt+iEEUIyPLVoTzEgoz5a7PmP0wNh1y4tMkDp7eOcBoGL83NebLzwYkSEPwH2NDJXlth0oDX7L23SlOopnNf5sMhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jODA/oi9; arc=none smtp.client-ip=74.125.227.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jODA/oi9"
Received: by mail-vs2-f12.google.com with SMTP id 71dfb90a1353d-5c67e504d59so77174e0c.1
        for <linux-nilfs@vger.kernel.org>; Wed, 16 Sep 2026 16:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789602635; x=1790207435; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8j5a7WFfG0NuSv/XKgDsxGhXHDIsTdHKd7Yxxjneaq0=;
        b=jODA/oi9lzvmBRJjutgkgASJHmP2FMxGPbhQmA7aYeurqKVI6v8imThy/PDO98g+wW
         I8/ChEhMjKjB4X1DyNSx6eO9lh6Gn2gRVowpxvPtchyGqvpaPhXPzCQc8asybXw0CWBa
         uyyswcqO4YaTgkZZwfHieOlf2wvdgMMUHZUMBrKZ9BCQ5AU1ng6cRG9rmHX8isHRxtfi
         ZhI+LKFbbPFzSjekxEjoNm2THwSvw02xsjIa6Dh/BiDhDxVusnIVgs3YPKzLOtb7zQPG
         l0EVM2FJExgQq7TgL19k0JlIggdZcDydxmg4v9sCjWE7d9iw9ZRjhgtQg/qRF783+aZN
         /YMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789602635; x=1790207435;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8j5a7WFfG0NuSv/XKgDsxGhXHDIsTdHKd7Yxxjneaq0=;
        b=GXTwELTeRt1Wb3MuZfIWeR6MOQKz7hmTkDo4lpiSth9N9jL/vzkZCBlXIUKNvW22WE
         TT8H/YQPFfKrru1g3pk5lXr2qswDWxgFwC0WejH5rLImiZusJaJq5asaEjlGEaiQVQ3B
         J2gfswJNNC6dOHLZIamU4T4BaSSYTZo5pnSvNpfe4ir4Sqk5wLT84dDM72K/JJGW65qw
         5C5/jIIvcNn63PkOSYIJzNf0aI/JoJAFG3wMi2r3i/2l1vg72u2cdbk79Wf9nwzZcHpa
         JHil3LlVIUQkxcrXU3fmcg52BufTTqcPgGvja8Bx2IsGqJ1KQI9QZr9wWV3Z8NVDLlLa
         qwmw==
X-Forwarded-Encrypted: i=1; AKwUvBwtI2T9b4ByxC0K529n8dBMCeXtZgAwmeWWksRQo6H3oEjdnr6YHe4rMkQH1160e5LuMGgSLpf1ZtUDdw==@vger.kernel.org
X-Gm-Message-State: AFuF++nqYzJ5+qNy36dqK3AK9X4h9gdjkrkQHCszusbHjprJ/cz5Gzhi
	v91RM3VfgjbSZ7BVIi7pIPcQvDhnjd53j6uKFRmW4qOIVuTa297BkFxI
X-Gm-Gg: AYBFou2gKSJomTmrFEdKcL7nBB8W4iF/KOWY9BChEKrPdF16b7YzyHaxTGy6qfN8KUS
	Bk6ygjPTQZ8i1i8ESGYWML+ycQ+0s+ji1bHCirJ6aDvkw19K8F9Frlaxumhode5BOZYSxCI8NSk
	kc8rBIEdcNYXT4UaF6JE7CJQMwrgcyYeXXAnEJbAmeyx8QatkRrXkkcHc76cZ74cAxCe+iimx/R
	XCWPrCPq3PYsTD6+fYqbcJUsjoxUkjRXqTicZTjkRnyxWByEjPU1p8X8nFxzuntGIKWYw4QY45j
	Db9tisK75ubnSKOWE4R82427XsqlpNUrNc5TMzwe7BhDGUjdxov88soJZDOidJvJLkBINfo9OtY
	E3ZGamotVFpWN6BpB9kf76rkyObMH+AhPE5eUUocsDJ/LY06A8LleQQVzvmfp+TgcXD8JRIoeqv
	NG36xupr7aZZDr40xqLNGyY4weyDfQysRb0tlru92L7L3jCFyxpXLbs36aRo1wEjnX
X-Received: by 2002:a05:6102:8511:20b0:7a1:43d2:bb72 with SMTP id ada2fe7eead31-7a143d2c168mr2974538137.13.1789602634592;
        Wed, 16 Sep 2026 16:50:34 -0700 (PDT)
Received: from beelink.. ([187.13.206.89])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7a1e334979asm1533796137.10.2026.09.16.16.50.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 16:50:34 -0700 (PDT)
From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>,
	linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Subject: [PATCH v3] nilfs2: fix checkpoint root lifetime on sysfs errors
Date: Wed, 16 Sep 2026 20:50:25 -0300
Message-ID: <20260916235025.379600-1-qwe.aldo@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260915041206.2430937-1-qwe.aldo@gmail.com>
References: <20260915041206.2430937-1-qwe.aldo@gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nilfs_find_or_create_root() publishes a new root in the checkpoint
tree before creating its sysfs object.  If sysfs registration fails,
the root is freed while it is still reachable from the tree.  A
concurrent nilfs_lookup_root() can then dereference freed memory.

The fix needs the lock to be held across the sysfs call, but
nilfs_sysfs_create_snapshot_group() can sleep, so the existing
spinlock is not suitable.

Convert ns_cptree_lock from a spinlock to a mutex.  All existing
callers are in process context (mount, lookup, segctor, recovery),
and nilfs_put_root() can use refcount_dec_and_mutex_lock() as the
atomic decrement-and-acquire primitive.

With the mutex, nilfs_find_or_create_root() can hold it across the
sysfs registration and only insert the root into the rbtree after
sysfs succeeds.  On failure, the root was never visible and can be
freed after waiting for the kobject release callback to complete.

Both the creation error path and the normal removal path must wait
for the embedded kobject release via wait_for_completion() before
freeing the container, because kobject_put() does not guarantee
synchronous release (CONFIG_DEBUG_KOBJECT_RELEASE defers it).

Fixes: dd70edbde262 ("nilfs2: integrate sysfs support into driver")
Cc: stable@vger.kernel.org
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
---

Changes in v3:
  - Move wait_for_completion() after mutex_unlock() in
    nilfs_put_root() to avoid holding the lock during an
    unbounded wait, as noted by Viacheslav Dubeyko.
    After rb_erase() the root is no longer in the tree
    and the refcount is zero, so no concurrent path can
    reach it.

Changes in v2:
  - Convert ns_cptree_lock from spinlock to mutex instead of adding
    a second lock, as suggested by Viacheslav Dubeyko.  Use
    refcount_dec_and_mutex_lock() in nilfs_put_root().

 fs/nilfs2/the_nilfs.c | 37 ++++++++++++++++++++-----------------
 fs/nilfs2/the_nilfs.h |  2 +-
 2 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 7b23e373a1..XXXXXXX 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -70,7 +70,7 @@ struct the_nilfs *alloc_nilfs(struct super_block *sb)
 	spin_lock_init(&nilfs->ns_inode_lock);
 	spin_lock_init(&nilfs->ns_last_segment_lock);
 	nilfs->ns_cptree = RB_ROOT;
-	spin_lock_init(&nilfs->ns_cptree_lock);
+	mutex_init(&nilfs->ns_cptree_lock);
 	init_rwsem(&nilfs->ns_segctor_sem);
 	nilfs->ns_sb_update_freq = NILFS_SB_FREQ;

@@ -846,7 +846,7 @@ struct nilfs_root *nilfs_lookup_root(struct the_nilfs *nilfs, __u64 cno)
 	struct rb_node *n;
 	struct nilfs_root *root;

-	spin_lock(&nilfs->ns_cptree_lock);
+	mutex_lock(&nilfs->ns_cptree_lock);
 	n = nilfs->ns_cptree.rb_node;
 	while (n) {
 		root = rb_entry(n, struct nilfs_root, rb_node);
@@ -857,11 +857,11 @@ struct nilfs_root *nilfs_lookup_root(struct the_nilfs *nilfs, __u64 cno)
 			n = n->rb_right;
 		} else {
 			refcount_inc(&root->count);
-			spin_unlock(&nilfs->ns_cptree_lock);
+			mutex_unlock(&nilfs->ns_cptree_lock);
 			return root;
 		}
 	}
-	spin_unlock(&nilfs->ns_cptree_lock);
+	mutex_unlock(&nilfs->ns_cptree_lock);

 	return NULL;
 }
@@ -881,7 +881,7 @@ nilfs_find_or_create_root(struct the_nilfs *nilfs, __u64 cno)
 	if (!new)
 		return NULL;

-	spin_lock(&nilfs->ns_cptree_lock);
+	mutex_lock(&nilfs->ns_cptree_lock);

 	p = &nilfs->ns_cptree.rb_node;
 	parent = NULL;
@@ -896,7 +896,7 @@ nilfs_find_or_create_root(struct the_nilfs *nilfs, __u64 cno)
 			p = &(*p)->rb_right;
 		} else {
 			refcount_inc(&root->count);
-			spin_unlock(&nilfs->ns_cptree_lock);
+			mutex_unlock(&nilfs->ns_cptree_lock);
 			kfree(new);
 			return root;
 		}
@@ -909,17 +909,19 @@ nilfs_find_or_create_root(struct the_nilfs *nilfs, __u64 cno)
 	atomic64_set(&new->inodes_count, 0);
 	atomic64_set(&new->blocks_count, 0);

-	rb_link_node(&new->rb_node, parent, p);
-	rb_insert_color(&new->rb_node, &nilfs->ns_cptree);
-
-	spin_unlock(&nilfs->ns_cptree_lock);
-
 	err = nilfs_sysfs_create_snapshot_group(new);
 	if (err) {
+		mutex_unlock(&nilfs->ns_cptree_lock);
+		wait_for_completion(&new->snapshot_kobj_unregister);
 		kfree(new);
-		new = NULL;
+		return NULL;
 	}

+	rb_link_node(&new->rb_node, parent, p);
+	rb_insert_color(&new->rb_node, &nilfs->ns_cptree);
+
+	mutex_unlock(&nilfs->ns_cptree_lock);
+
 	return new;
 }

@@ -927,14 +929,15 @@ void nilfs_put_root(struct nilfs_root *root)
 {
 	struct the_nilfs *nilfs = root->nilfs;

-	if (refcount_dec_and_lock(&root->count, &nilfs->ns_cptree_lock)) {
+	if (refcount_dec_and_mutex_lock(&root->count,
+					&nilfs->ns_cptree_lock)) {
 		rb_erase(&root->rb_node, &nilfs->ns_cptree);
-		spin_unlock(&nilfs->ns_cptree_lock);
-
 		nilfs_sysfs_delete_snapshot_group(root);
-		iput(root->ifile);
+		mutex_unlock(&nilfs->ns_cptree_lock);

+		wait_for_completion(&root->snapshot_kobj_unregister);
+		iput(root->ifile);
 		kfree(root);
 	}
 }
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index 4776a70f01..074644c64a 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -150,7 +150,7 @@ struct the_nilfs {

 	/* Checkpoint tree */
 	struct rb_root		ns_cptree;
-	spinlock_t		ns_cptree_lock;
+	struct mutex		ns_cptree_lock; /* Protects ns_cptree */

 	/* Dirty inode list */
 	struct list_head	ns_dirty_files;
--
2.43.0
