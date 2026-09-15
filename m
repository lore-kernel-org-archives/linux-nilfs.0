Received: from mail-vs2-f12.google.com (mail-vs2-f12.google.com [74.125.227.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C63F4418F0
	for <linux-nilfs@vger.kernel.org>; Tue, 15 Sep 2026 19:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789501813; cv=none; b=QCHEyr3f3QoWGxVgXEIAYATFv3pNUGL6RlUEUUokIaHP5lQMnfp30PT0c+iuYA6E3PVJ4ta2+7mL94D6zj+i6Pt6sYHIh3rEkfqn0fImqF7lpxQFzbS2qt5ZLftZgEik2rWi32yzDoYSu2rsKP+V4gichapNOolNnbWCd+qy024=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789501813; c=relaxed/simple;
	bh=WeH/8wp2sWi7Z70NYaw47QFPsfIoz3LH20gbDuOOXlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UP9+ba2MK0lGTnV4Zdx/WbQHtFLK7gCPVbbZ863yRJ8iHarRxamd97ZcAcJqmgHNf/stlAWd7NxGYtLrGKH210N9nqxr+jnqSzaBIDOs5HlRot1+cjrptHcGxh3CQYKtDLPY6SM4R60QUUfHFViV73EI8tXXWj3r7wx3AtPbnWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Drr+97KB; arc=none smtp.client-ip=74.125.227.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Drr+97KB"
Received: by mail-vs2-f12.google.com with SMTP id ada2fe7eead31-78a6c77d255so34410137.2
        for <linux-nilfs@vger.kernel.org>; Tue, 15 Sep 2026 12:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789501811; x=1790106611; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zRgmaq8sDZ8Ohc7llQ4Y6mN+rj16NiGtGOpwmUKB9S4=;
        b=Drr+97KBsCrVCr58L7y8T5ALuzLSah3fWHWJU5V0hFMhLxXl9ouTGRLcLDgDFeJrJ5
         WlvvMTYX5OGZ2ooH+ML6xg6h7dQPUcqdRhlR3Cgo2UmB1ULUYr5Vqtw9QD77TJp/q8BF
         IvV5sgLRR+XYp5O7yE24OyMbHW9ihrsB5CyszM56I8UcLH4L5gxW56h7v52fQFPWRh5g
         JL/vAMTAuZn9GQ8TxyZLaDH2YKgMIL2B8uG2CrQr9WFE+MiSATQo+S5ebnOXjgOczF96
         dM2UVnuZrXYuhuH5hzodfZ1wNjltYVODjTj7/ZUfR2h6d4+DDNGHjJ7jZs6BxQi48llk
         10Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789501811; x=1790106611;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zRgmaq8sDZ8Ohc7llQ4Y6mN+rj16NiGtGOpwmUKB9S4=;
        b=JvYdaiTFoNmtvultTiY3GJ1IOZGhBQ91tIH6EwhGO6E/C4whQiXNI4si2nohelEIte
         q3rdE1wlNu85QtWT+aagY/auzK02QfYmn63MC2OeFmuv5gSn9/Q7KRaTtUJeizvSYbRF
         Y8j3EHxlAcEI6WeK5qA3Ht/ipdCb+yySwhly7c21dadIwYobneG61EBUp3E6xaZdXf9C
         wX5Q/zkePsYQ89x3pdX1x96NFzP0t2RLjOB8pcWmDu3UgXHStETZFSKqAf/LQJk5D6H1
         h1nd+lZN6I4h2KS9wt5IL2c5CAlYCdR5chB88W+hx0VJDAw8B6Rw9CCSsMMmyuugwQ3I
         3jEQ==
X-Forwarded-Encrypted: i=1; AKwUvBx0WoL2GD7mW3YYz7IDfudyQGHHD4AGhzkc1UcXHmStaRft57hF+e5hwc1ULYdS7uymm32slz2NjPkRJA==@vger.kernel.org
X-Gm-Message-State: AFuF++k22kbi+H8A21wR0eED6f7PN615OLQUKkOL/pqL+qWr4W3ej4tR
	FFTRODomm04OZNTQQh5ScGffhmH2u82e/uQde+a09JQNzatkcW3UVH51S9rtOcG2CXQ=
X-Gm-Gg: AYBFou1RSz+rwahmkDH5nkReir9e178tuD/DSNuIHTgxO6cPAaygJjpHrMcU7HotUyU
	uGt+kpTpQbQeU+xa6h4fLVXsCAm6424YQ0Bf/Mvecqnq7UL82ge1J8xvgujZoYOCIM3MOm3phgN
	otEyB8LX7YbSUAJ6NT2/yMePANNN2bXuGUK7i8hn0mpIQ9P+ld64yQBNFINsNKMFrhQ/CwncN+y
	+7y2y+OGN1Xq7IP/43albE4DKjmXg8/fuWPtjajIiFNF9z0rR4BPD0Bdqqf7h4Fe2nnYHwbDesL
	ZVmhhtjhSSS1O7HGovpGza0QFJmbZeiTpBY4gLbrNAMaODTYViRmMa945o/fziO4H1XMP6dhIW9
	pSI6mv+fDMkOgBUfFu1vVoDTa35tkiM2joOI5GrAjz+WT+Js/kFEGWYQbAw2UKYoAUtdSiEOFHu
	n0an6uSQAUn7JcSToE9ugY/4lzP2iG1oVrWBwDcoDobCFiA/5Xf15ay7ULVFeWv4Pa
X-Received: by 2002:a05:6102:2924:b0:79f:7e2e:c637 with SMTP id ada2fe7eead31-79f7e2ed733mr887831137.12.1789501810214;
        Tue, 15 Sep 2026 12:50:10 -0700 (PDT)
Received: from beelink.. ([187.13.206.89])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-983151dddc3sm515151241.3.2026.09.15.12.50.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 12:50:09 -0700 (PDT)
From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>,
	linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Subject: [PATCH v2] nilfs2: fix checkpoint root lifetime on sysfs errors
Date: Tue, 15 Sep 2026 16:49:58 -0300
Message-ID: <20260915194958.3329611-1-qwe.aldo@gmail.com>
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

Changes in v2:
  - Convert ns_cptree_lock from spinlock to mutex instead of adding
    a second lock, as suggested by Viacheslav Dubeyko.  Use
    refcount_dec_and_mutex_lock() in nilfs_put_root().

 fs/nilfs2/the_nilfs.c | 35 +++++++++++++++++++----------------
 fs/nilfs2/the_nilfs.h |  2 +-
 2 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 7b23e373a1..5bfa853471 100644
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
 
@@ -927,13 +929,14 @@ void nilfs_put_root(struct nilfs_root *root)
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
+		wait_for_completion(&root->snapshot_kobj_unregister);
+		mutex_unlock(&nilfs->ns_cptree_lock);
 
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

