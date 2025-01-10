Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74CB713AD18;
	Fri, 10 Jan 2025 01:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736471235; cv=none; b=sSG+YajhiFYJ0tJDfA7GQLh+HYzL+VtEJM1nkHhQwbacG9ZRSMDDvy6rfP9IXaiqFxaYe0JYq7H3F1j4pA9nBu7isHwLX5qmuTdK24tE454DmwS2fhv83z8DAziphK1g1weIiNAIn67j1QynDg5oljAFfneMWncC0gTL6eW6UCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736471235; c=relaxed/simple;
	bh=i+31Oe4HJH4Z4mDbrpqaoZhwB66Z0qk21SMKnzLqvsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VR7xFjodGH8nrCBLcYvB5+iDHCeDnALyNO5s5bLRk6hytQfB5DePoAeeiPEed04+DY8typ9W3vGHk0HD0VFVmT7rsfSM2KHw5Ds3ldjW5/fymPntEMnZutsZIR2ke+pRisfPQ0gKwzFQdiT5kM5h+S5w4J1T37LwLhb39YaVzM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hi7QgrB8; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hi7QgrB8"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-21619108a6bso25312435ad.3;
        Thu, 09 Jan 2025 17:07:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736471233; x=1737076033; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dhJS34wxLk7i278VwHMQLGtDlLmK6CMtnTa5VDV3+ws=;
        b=Hi7QgrB8nX912ocV/7F/y2ztzqqr8TEak0FX8YfZqiOdoyaxSakeav3Cfd51f3h60e
         isgqWK5vtaWsQaHaZGmshgmM+KIS4O4pWmdJlyxA2NKLanaWXplHZy2I2koztWXmTo6h
         NVx7G9R1p87f1GbVSeL7t/55DZuz4ZlFEUv68xnaKV6Qbfww/eHzvjKpLXfJp7Os4SfU
         H6mviUFxs89UUPukoRaOx2cC5yDI5Yhp3zLKGDuC5sKa2zWGQ/MZ34KbyzAhNi0vIis6
         UQ4oWIJ+rHA8eISxIgvxZ7F4TI0l3KvShw90staamP4ZjJz/yaq0rQXTO+lidnpDCgOy
         V1PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736471233; x=1737076033;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dhJS34wxLk7i278VwHMQLGtDlLmK6CMtnTa5VDV3+ws=;
        b=Rx8jllJV1QiIgJHjijVFIO4MEQhYYIw6aGU6jG1pmr6NABBfecugEwZNUTooI3E82w
         QuEX56U3cRmt/LKXfRxyi85NhyASUwUWwfHNOy2NWb/BhZCf7yB9vsLsT4OGd4MxlJcN
         cC1PrCrCUVVPTbsitmge2l2SEneuWuEi2BReR3r0DiE2/nTBwkXIZPdSLcGkfRWqTf3s
         vE8f9hD7Ezi7KlE0RCwGVI2ENlrupFpVr6vZsJtHg6aHAa81i63+3prs3sadkUjvK2JI
         ICsVPJQtMq+oOkjdlbZoOY1a+Nyv9Fw/C3Mh7FFzTntH/hRoPOOdU8ccPD2Q2aYhb/eJ
         Uq3g==
X-Forwarded-Encrypted: i=1; AJvYcCUle0rxoGcLMtPfPBJ8TKxV1pe9SRvKP0lW84J+jGpa7sKStlsZiNgr0JwiiExVcipLdQhOQ6pbYaZFHY8=@vger.kernel.org, AJvYcCXXMxa3iu5d/Lu2etrhdp637fjAonS4RU8Flna+JuBYtMt4Kc6VzEeu4UT2YYNGEmYJrrDIri86mfB4Aic=@vger.kernel.org
X-Gm-Message-State: AOJu0YyF8z3KB3SsRNEE/Wv7yBdzpGkaJaVUZCEPgB51JBxRDSTm/x5G
	PkfUpvEGfqQTXgHkVhkkqoQb+7WolrLzjDSWsK8eSJBPGOd7WUyO
X-Gm-Gg: ASbGncv2Fqz93J81eqapdwzuIkFJS9GxK1CjXUEBYi4ljhn5cdCe1qbaSBRFLtR3hPi
	+R9MLaHrZUWA8ERIq+4JkV0v2/UAyFAV8gNWXrQEYq2m9ojyc8NPQKWOSyv9QyswKH/O7HrTBz3
	bu6H3mwis9m3UNrcGsjKNEgwbNToui4UHveJLdNj6imwrIGdhLMXk/cC76EK/8bYztUZEL3OVX7
	dBHWh8WFopzz8Tzxxj02BVi87/rU78vnB3/kh0/V93C7atRjZ1fVi9WnzoHRmyr/puqb3oTdBEa
	6/NkWMRxUGdbEQiVNk7AnmSlqg2j
X-Google-Smtp-Source: AGHT+IEoFSioOOFe8Hir/BemJOe7cfjrRuPDcszGrxkrcPx3jDnl9Zz8SmePJR/3VbEyhfBOOF+8tA==
X-Received: by 2002:a05:6a20:8403:b0:1e0:c378:6f5b with SMTP id adf61e73a8af0-1e88d3208ddmr15271421637.38.1736471232700;
        Thu, 09 Jan 2025 17:07:12 -0800 (PST)
Received: from carrot.. (i114-186-237-30.s41.a014.ap.plala.or.jp. [114.186.237.30])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-a31ddb9e4b4sm1862834a12.70.2025.01.09.17.07.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2025 17:07:11 -0800 (PST)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Brian G ." <gissf1@gmail.com>,
	linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH -v2 2/7] nilfs2: correct return value kernel-doc descriptions for bmap functions
Date: Fri, 10 Jan 2025 10:01:45 +0900
Message-ID: <20250110010530.21872-3-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250110010530.21872-1-konishi.ryusuke@gmail.com>
References: <CAKFNMoksY6f5NtVwmn6K0K2QKTvdjq+s0FbdgLvHzS3YueKqYQ@mail.gmail.com>
 <20250110010530.21872-1-konishi.ryusuke@gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Similar to the previous patch to fix the ioctl return value
descriptions, this fixes the format of the return value descriptions
for bmap (and btree)-related functions, which was causing the
kernel-doc script to emit a number of warnings.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/bmap.c  | 124 ++++++++++++++++++++--------------------------
 fs/nilfs2/btree.c |   7 ++-
 2 files changed, 56 insertions(+), 75 deletions(-)

diff --git a/fs/nilfs2/bmap.c b/fs/nilfs2/bmap.c
index c9e8d9a7d820..ccc1a7aa52d2 100644
--- a/fs/nilfs2/bmap.c
+++ b/fs/nilfs2/bmap.c
@@ -47,17 +47,14 @@ static int nilfs_bmap_convert_error(struct nilfs_bmap *bmap,
  * @ptrp: place to store the value associated to @key
  *
  * Description: nilfs_bmap_lookup_at_level() finds a record whose key
- * matches @key in the block at @level of the bmap.
- *
- * Return Value: On success, 0 is returned and the record associated with @key
- * is stored in the place pointed by @ptrp. On error, one of the following
- * negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
- *
- * %-ENOENT - A record associated with @key does not exist.
+ * matches @key in the block at @level of the bmap.  The record associated
+ * with @key is stored in the place pointed to by @ptrp.
+ *
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOENT	- A record associated with @key does not exist.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_bmap_lookup_at_level(struct nilfs_bmap *bmap, __u64 key, int level,
 			       __u64 *ptrp)
@@ -138,14 +135,11 @@ static int nilfs_bmap_do_insert(struct nilfs_bmap *bmap, __u64 key, __u64 ptr)
  * Description: nilfs_bmap_insert() inserts the new key-record pair specified
  * by @key and @rec into @bmap.
  *
- * Return Value: On success, 0 is returned. On error, one of the following
- * negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
- *
- * %-EEXIST - A record associated with @key already exist.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EEXIST	- A record associated with @key already exists.
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_bmap_insert(struct nilfs_bmap *bmap, __u64 key, unsigned long rec)
 {
@@ -193,14 +187,11 @@ static int nilfs_bmap_do_delete(struct nilfs_bmap *bmap, __u64 key)
  * Description: nilfs_bmap_seek_key() seeks a valid key on @bmap
  * starting from @start, and stores it to @keyp if found.
  *
- * Return Value: On success, 0 is returned. On error, one of the following
- * negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
- *
- * %-ENOENT - No valid entry was found
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOENT	- No valid entry was found.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_bmap_seek_key(struct nilfs_bmap *bmap, __u64 start, __u64 *keyp)
 {
@@ -236,14 +227,11 @@ int nilfs_bmap_last_key(struct nilfs_bmap *bmap, __u64 *keyp)
  * Description: nilfs_bmap_delete() deletes the key-record pair specified by
  * @key from @bmap.
  *
- * Return Value: On success, 0 is returned. On error, one of the following
- * negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
- *
- * %-ENOENT - A record associated with @key does not exist.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOENT	- A record associated with @key does not exist.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_bmap_delete(struct nilfs_bmap *bmap, __u64 key)
 {
@@ -290,12 +278,10 @@ static int nilfs_bmap_do_truncate(struct nilfs_bmap *bmap, __u64 key)
  * Description: nilfs_bmap_truncate() removes key-record pairs whose keys are
  * greater than or equal to @key from @bmap.
  *
- * Return Value: On success, 0 is returned. On error, one of the following
- * negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_bmap_truncate(struct nilfs_bmap *bmap, __u64 key)
 {
@@ -330,12 +316,10 @@ void nilfs_bmap_clear(struct nilfs_bmap *bmap)
  * Description: nilfs_bmap_propagate() marks the buffers that directly or
  * indirectly refer to the block specified by @bh dirty.
  *
- * Return Value: On success, 0 is returned. On error, one of the following
- * negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_bmap_propagate(struct nilfs_bmap *bmap, struct buffer_head *bh)
 {
@@ -362,22 +346,22 @@ void nilfs_bmap_lookup_dirty_buffers(struct nilfs_bmap *bmap,
 
 /**
  * nilfs_bmap_assign - assign a new block number to a block
- * @bmap: bmap
- * @bh: pointer to buffer head
+ * @bmap:    bmap
+ * @bh:      place to store a pointer to the buffer head to which a block
+ *           address is assigned (in/out)
  * @blocknr: block number
- * @binfo: block information
+ * @binfo:   block information
  *
  * Description: nilfs_bmap_assign() assigns the block number @blocknr to the
- * buffer specified by @bh.
- *
- * Return Value: On success, 0 is returned and the buffer head of a newly
- * create buffer and the block information associated with the buffer are
- * stored in the place pointed by @bh and @binfo, respectively. On error, one
- * of the following negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
+ * buffer specified by @bh.  The block information is stored in the memory
+ * pointed to by @binfo, and the buffer head may be replaced as a block
+ * address is assigned, in which case a pointer to the new buffer head is
+ * stored in the memory pointed to by @bh.
+ *
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_bmap_assign(struct nilfs_bmap *bmap,
 		      struct buffer_head **bh,
@@ -402,12 +386,10 @@ int nilfs_bmap_assign(struct nilfs_bmap *bmap,
  * Description: nilfs_bmap_mark() marks the block specified by @key and @level
  * as dirty.
  *
- * Return Value: On success, 0 is returned. On error, one of the following
- * negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_bmap_mark(struct nilfs_bmap *bmap, __u64 key, int level)
 {
@@ -430,7 +412,7 @@ int nilfs_bmap_mark(struct nilfs_bmap *bmap, __u64 key, int level)
  * Description: nilfs_test_and_clear() is the atomic operation to test and
  * clear the dirty state of @bmap.
  *
- * Return Value: 1 is returned if @bmap is dirty, or 0 if clear.
+ * Return: 1 if @bmap is dirty, or 0 if clear.
  */
 int nilfs_bmap_test_and_clear_dirty(struct nilfs_bmap *bmap)
 {
@@ -490,10 +472,10 @@ static struct lock_class_key nilfs_bmap_mdt_lock_key;
  *
  * Description: nilfs_bmap_read() initializes the bmap @bmap.
  *
- * Return Value: On success, 0 is returned. On error, the following negative
- * error code is returned.
- *
- * %-ENOMEM - Insufficient amount of memory available.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EIO	- I/O error (corrupted bmap).
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_bmap_read(struct nilfs_bmap *bmap, struct nilfs_inode *raw_inode)
 {
diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index ef5061bb56da..0d8f7fb15c2e 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -334,7 +334,7 @@ static int nilfs_btree_node_lookup(const struct nilfs_btree_node *node,
  * @inode: host inode of btree
  * @blocknr: block number
  *
- * Return Value: If node is broken, 1 is returned. Otherwise, 0 is returned.
+ * Return: 0 if normal, 1 if the node is broken.
  */
 static int nilfs_btree_node_broken(const struct nilfs_btree_node *node,
 				   size_t size, struct inode *inode,
@@ -366,7 +366,7 @@ static int nilfs_btree_node_broken(const struct nilfs_btree_node *node,
  * @node: btree root node to be examined
  * @inode: host inode of btree
  *
- * Return Value: If node is broken, 1 is returned. Otherwise, 0 is returned.
+ * Return: 0 if normal, 1 if the root node is broken.
  */
 static int nilfs_btree_root_broken(const struct nilfs_btree_node *node,
 				   struct inode *inode)
@@ -652,8 +652,7 @@ static int nilfs_btree_do_lookup_last(const struct nilfs_bmap *btree,
  * @minlevel: start level
  * @nextkey: place to store the next valid key
  *
- * Return Value: If a next key was found, 0 is returned. Otherwise,
- * -ENOENT is returned.
+ * Return: 0 if the next key was found, %-ENOENT if not found.
  */
 static int nilfs_btree_get_next_key(const struct nilfs_bmap *btree,
 				    const struct nilfs_btree_path *path,
-- 
2.43.0

