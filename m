Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47AD51684AE;
	Thu,  9 Jan 2025 03:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736393301; cv=none; b=msKTARsmKECNYYnu9ctydI07mpr2eHDl3nH7sTV42ChyambW2olextgPgmVqxxDw2wiP5QpXVFBJR9yYjxj9/G4o8Nkf2tDdwgAy1MNjaJGblJhGMhl2ty+qtjtqKVkXSHh+XKiXdpdczoxDFkoF+VCQpBF+d1MzYGLpnKd57Vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736393301; c=relaxed/simple;
	bh=umj6CQIVsXyZT+uwsppRIYh41lv+WfbNlsR7/+2LrM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vEa9jEeJ16hWC5HCUpk/TXIWUnhUWhHZ/tnufoEdQuIwjc1yyp3h5pqdu/Dr7O4ko9+ugRM5jg0QPMHTBcsqFumxWsQGZahwZZzE4zEqgW7X4581AVdbc5Px7l8llRfa9nomCWq9+JL4Lz+woUUHkIngrqPuUNVKXlg3U1m1Q5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c9NvGndb; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c9NvGndb"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2ee786b3277so623958a91.1;
        Wed, 08 Jan 2025 19:28:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736393298; x=1736998098; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y7JxCEda9M0WZjHMO8mQopXCuOQme8n8+3GrvRENd5Q=;
        b=c9NvGndbQHJh/aOFLdfHQJWL3WiiFcLEPmr+FWA23qCFvjPLvKwqrECpZ0ZKswyVCz
         aZ5LwN+6TqhFMI3iG+b0Kja3Cmr8cl/5qphb5ElFLTEnM1Oyum2tp+3chmeKDezoaAx2
         dWrW4urJb3ANZbAUsSnwjpZsW6eCNxcyVN0tYr4KbkLnCSWBUKDa5ulQ5Kz03s7+exju
         Pmx5WI8A7wFX1fq+0ZGNKossIzXvXsyEAspDMNvnobjLyGDpNWXF6T3kXjgUvZ8Yt365
         SYq6soEWgDi33ZGW96QyCZNW+DTOmyoBBE0asPesB7HsgdYsWUCyQC5APU227Hqr8zyz
         jQLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736393298; x=1736998098;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y7JxCEda9M0WZjHMO8mQopXCuOQme8n8+3GrvRENd5Q=;
        b=IB8IBFt483/PUZ2TzBvf9cESELtTvgBHxSwyOg/Bf89oeY+NOhnWzzQkpapnw8O8ZQ
         h16JASCheNvRkViacRyi0NkvhNBQDNx5Qo+CRGip4uVSoVXOtoqc4hyW7X1SPt5Q0RtW
         70AvSZRFNc1mPmtyr0XR/+r7MWGZYZSXzzQTivl2gXj5Ls6Bk6ZrgmZTebUybcYyHrg4
         I7cnAhImxyNAZ3K8Jc1IRZoJqLLt96Ev8scTpITyWURLqeyfHHjaNGbXQpH8RFQ9l+5t
         uXhLpXVr3QyipjFnRJYvU9X/3Km+iUi2KAdB9hLGFERVMFwd8pq5kGSMt98wwJCkxXyq
         NqlA==
X-Forwarded-Encrypted: i=1; AJvYcCXvLYFuYNWgqjte2BtGsXanGJ9p414j7HICSlb7yjvaqsYUD69jiyHU1HqP0teyAQaFxc/l9L6Q7ekHEiU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5PZ7y82BpQIQPkfJuJNLeIGKWum3BpAXzzJp7POJhafHmhgdH
	12Bq2UoyB2riak/JTgi/9KfAyP/fzMDXZfo04UzW4eo4LBndJrYfWJ+kbA==
X-Gm-Gg: ASbGncugfUIbroG1WPNPcRH0E3HzuvNr/AARueVioQHiCgYiSSeXKURWiECZqfpR8k0
	TYRO3bo30dR8UfrBUEWLCBSVXI+2Bhh6gZM/ORu9/dGDWi8s5VZNHz6sXcOEEIWxT0S4NsSUS/d
	JN5Tb+G3GzIBvVcLpp6ltgrmwtYHeCn/AxuUgW6auWiBbpW5/1PDIS83aXJoy1o6cztwLNHydMQ
	vQCNGJiTR4lK0rBLpG4t0IHz+XRB6Dt3i3H1Hj/nOpKNgA6KMX+3UxEpb6hAohqbiYV7CLiWpm7
	GgzpBmKhzo+a0X6lghKMp5hX0NS6
X-Google-Smtp-Source: AGHT+IEiC67o7UiF+pQM3vda/jEfMXgoG2yq+aAY/sImLPzO09yPTnFHuaMi2gIC/gaSK/TjkI0OBQ==
X-Received: by 2002:a17:90b:3a46:b0:2ee:af31:a7b3 with SMTP id 98e67ed59e1d1-2f548ea664fmr7937675a91.7.1736393298447;
        Wed, 08 Jan 2025 19:28:18 -0800 (PST)
Received: from carrot.. (i114-186-237-30.s41.a014.ap.plala.or.jp. [114.186.237.30])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f55942eed5sm194963a91.27.2025.01.08.19.28.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2025 19:28:17 -0800 (PST)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] nilfs2: correct return value kernel-doc descriptions for bmap functions
Date: Thu,  9 Jan 2025 12:23:21 +0900
Message-ID: <20250109032846.10147-3-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250109032846.10147-1-konishi.ryusuke@gmail.com>
References: <20250109032846.10147-1-konishi.ryusuke@gmail.com>
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
 fs/nilfs2/bmap.c  | 113 ++++++++++++++++++----------------------------
 fs/nilfs2/btree.c |   7 ++-
 2 files changed, 46 insertions(+), 74 deletions(-)

diff --git a/fs/nilfs2/bmap.c b/fs/nilfs2/bmap.c
index c9e8d9a7d820..63516dfac692 100644
--- a/fs/nilfs2/bmap.c
+++ b/fs/nilfs2/bmap.c
@@ -47,17 +47,13 @@ static int nilfs_bmap_convert_error(struct nilfs_bmap *bmap,
  * @ptrp: place to store the value associated to @key
  *
  * Description: nilfs_bmap_lookup_at_level() finds a record whose key
- * matches @key in the block at @level of the bmap.
+ * matches @key in the block at @level of the bmap.  The record associated
+ * with @key is stored in the place pointed to by @ptrp.
  *
- * Return Value: On success, 0 is returned and the record associated with @key
- * is stored in the place pointed by @ptrp. On error, one of the following
- * negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
- *
- * %-ENOENT - A record associated with @key does not exist.
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOENT	- A record associated with @key does not exist.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_bmap_lookup_at_level(struct nilfs_bmap *bmap, __u64 key, int level,
 			       __u64 *ptrp)
@@ -138,14 +134,10 @@ static int nilfs_bmap_do_insert(struct nilfs_bmap *bmap, __u64 key, __u64 ptr)
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
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EEXIST	- A record associated with @key already exist.
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_bmap_insert(struct nilfs_bmap *bmap, __u64 key, unsigned long rec)
 {
@@ -193,14 +185,10 @@ static int nilfs_bmap_do_delete(struct nilfs_bmap *bmap, __u64 key)
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
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOENT	- No valid entry was found.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_bmap_seek_key(struct nilfs_bmap *bmap, __u64 start, __u64 *keyp)
 {
@@ -236,14 +224,10 @@ int nilfs_bmap_last_key(struct nilfs_bmap *bmap, __u64 *keyp)
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
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOENT	- A record associated with @key does not exist.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_bmap_delete(struct nilfs_bmap *bmap, __u64 key)
 {
@@ -290,12 +274,9 @@ static int nilfs_bmap_do_truncate(struct nilfs_bmap *bmap, __u64 key)
  * Description: nilfs_bmap_truncate() removes key-record pairs whose keys are
  * greater than or equal to @key from @bmap.
  *
- * Return Value: On success, 0 is returned. On error, one of the following
- * negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_bmap_truncate(struct nilfs_bmap *bmap, __u64 key)
 {
@@ -330,12 +311,9 @@ void nilfs_bmap_clear(struct nilfs_bmap *bmap)
  * Description: nilfs_bmap_propagate() marks the buffers that directly or
  * indirectly refer to the block specified by @bh dirty.
  *
- * Return Value: On success, 0 is returned. On error, one of the following
- * negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_bmap_propagate(struct nilfs_bmap *bmap, struct buffer_head *bh)
 {
@@ -362,22 +340,21 @@ void nilfs_bmap_lookup_dirty_buffers(struct nilfs_bmap *bmap,
 
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
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_bmap_assign(struct nilfs_bmap *bmap,
 		      struct buffer_head **bh,
@@ -402,12 +379,9 @@ int nilfs_bmap_assign(struct nilfs_bmap *bmap,
  * Description: nilfs_bmap_mark() marks the block specified by @key and @level
  * as dirty.
  *
- * Return Value: On success, 0 is returned. On error, one of the following
- * negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_bmap_mark(struct nilfs_bmap *bmap, __u64 key, int level)
 {
@@ -430,7 +404,7 @@ int nilfs_bmap_mark(struct nilfs_bmap *bmap, __u64 key, int level)
  * Description: nilfs_test_and_clear() is the atomic operation to test and
  * clear the dirty state of @bmap.
  *
- * Return Value: 1 is returned if @bmap is dirty, or 0 if clear.
+ * Return: 1 if @bmap is dirty, or 0 if clear.
  */
 int nilfs_bmap_test_and_clear_dirty(struct nilfs_bmap *bmap)
 {
@@ -490,10 +464,9 @@ static struct lock_class_key nilfs_bmap_mdt_lock_key;
  *
  * Description: nilfs_bmap_read() initializes the bmap @bmap.
  *
- * Return Value: On success, 0 is returned. On error, the following negative
- * error code is returned.
- *
- * %-ENOMEM - Insufficient amount of memory available.
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EIO	- I/O error (corrupted bmap).
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_bmap_read(struct nilfs_bmap *bmap, struct nilfs_inode *raw_inode)
 {
diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index ef5061bb56da..9dd131cb2a1c 100644
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
+ * Return: 0 if next key found, %-ENOENT if not.
  */
 static int nilfs_btree_get_next_key(const struct nilfs_bmap *btree,
 				    const struct nilfs_btree_path *path,
-- 
2.43.0

