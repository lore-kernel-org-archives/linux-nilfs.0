Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793983732;
	b=SatV5B9yKtXYrx5hGLFZbUYAwbPQdvclTdDzSUK5pvwYuU0Kwj4xmBUFt9gZ6qT73cgm
	 qAg9dmtPgmI6hy8dy0YVSxBsQ38mi/n8DDEptpMOR5CHNJHOJW4EgiZt5De0rIjfywWSW
	 MW0emixEFZjSe5fsNNTnMkTdSSb7628Kvl4bghzfB95xsBfno51K4Pjs+byzXpkBSVDEe
	 H9HG3FaSueLDXjJCwlIo7ryr7W9DxAyxFcfOPbgXoQx6sK/roxQIVU4llUgNFNrEYp8vl
	 kQV4JzSh5uYy15Y4P3+3Cyz/VQQAYPHR6f0/GCxFkpVVC1IKK4RieithChzR7Qe19yQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793983732;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=H4V6yx9D+6KQk63XzZHkpPjJ39CmO85EbWoBfoCbemY=;
	b=HdGiigG5OFAEG6UU5WAa1kTs+UoI2AFwcBIKzlItq/Va7VosBzAWTS/s/EJ1C1gOZImF
	 TYyZ3bJbpGikUFzYsa8HTVASQxRefRgS2Vcqv1ZWw4U/+288PnpAppxVIBeMTc90CJ1gS
	 atsFEVwiGbkJaQf8t3sSVW5DFpOshFRNbaXkU3K7itnUQ6N22p0QCT9xiXoY9xOMLaF+2
	 fROM5GqUI4X2cwXlgsQrAsomlh80W0PGk3BIJk554sILgtK9PXaoBLjewfLfvlCYKxhte
	 JHQNh7u2VOJqkvVZ4vT9ALh+kqXRQxIodL1VaEsmIWRfEaKMSqOesEu2/DXy4YgMrlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Cq71bCcK;
	arc=none smtp.remote-ip=74.125.82.54
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18C3606A326
	for <linux-nilfs@vger.kernel.org>; Fri,  6 Nov 2026 16:48:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E18C3606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Cq71bCcK
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-1ae58d17cd9so400618c88.1
        for <linux-nilfs@vger.kernel.org>; Fri, 06 Nov 2026 08:48:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793983731; x=1794588531; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=H4V6yx9D+6KQk63XzZHkpPjJ39CmO85EbWoBfoCbemY=;
        b=Cq71bCcKhrXmI8XPfIuOPFx0+SViitkkZn/7AFYdYosNKSIpLcuNf/0TIIZvJdFuUJ
         /XKmHpeKL0hklpMC9BdkpHyes7e3S4+GV9w2MEPoF5JJH8JyO/Ntd+1TqC6K7zkn4une
         nf22NAapAwmuYW03AbeeYURQ0WHIHTRfZAbxs+70UvoDexw1KDufehYNdF3JdMxQbzae
         XW1NzlLj+E91pk6uQecH+qL8l1Uw+0xZ3+gkIMUpaD6X9bpJ3l/SKY+zVRYLQ/Wsyhy9
         nwUESwsGdVcMBtCH4vvJ6OKqaiB6toUe+wwvzmTRnqlYMGSNluIWGbNY+uZx4JUBWpjL
         ZK7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793983731; x=1794588531;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=H4V6yx9D+6KQk63XzZHkpPjJ39CmO85EbWoBfoCbemY=;
        b=tWfIlxlNyUlFAKaE+K/DbjHBJQdmr22HFU4gK9X5UMRPWCZdxgem0ZuVPEOcwK/anU
         2EvtaUsKy07m3YdaTfDDno6APfrNSG/c3FIgWoZGjimPaLhj3m7gFqAQLn0GJMLH7k81
         Jupeb6TPn7izaMRULule6A3c0wNBKj7aHQJPmuSZ3bqjmeKVnf94sFikSz1obz8m0CJ3
         98tlMCnnz1rqIL7YJ08UsGRphPW+E4bpnL+YeuyIx0e1K3pPTfyVvvvEa48K7mhRZp/X
         xoh0VjZjKsmdkiHMBFKDCn0DIBijSxkuDZ0cEWHNfrTjyHBV6QUXWFIwBdlOVvOhgTK0
         Y2nA==
X-Gm-Message-State: APuU4Z86sWpZ7EpkLyNV2RTN+io3nvzDFBlBVUKlcpp7aiqtkd3jC6T1
	IDUEhuZVlKP2liif5czt7tTAaBrx13kNqF9oAAYzYm1AAFOi3LJLSywa
X-Gm-Gg: AYBFou2e9LIh00N/F5APVl1/8nClko9bmMEQdNIbGoRIB/FqdZqm/KVHDw8h18vAXdG
	OiRHaZqOp1z+fVIMPz3UuJxhNBrfpQAUWolaiiXy5rLnahTpdJY1kh+JJM7dJegkZGFWhaUR33p
	wBLiHP2T+Zkb5EIVPGVrs0Ban4obxvU9ngi/TXhP2BdTyl0VbkSYoPMhA14ZMtTeRIFEstqxUoj
	B60231Chi2E1MMUqj+QoxbDVfYRwWoJfKhIWvr6D+ox+SGv9Gc6QdQoRMBow3NY+789RxSRJb+p
	IBPFCaln0RXR9iPRQGhinbX+NLjnY7+Wc1ZXHdVTVnFcLqjFcXlfS7fVJYa0eX1uFrFkZQzt2qR
	mPGXRI56a0dZdOo8ZrUbdhBW/VoXNwm07teliky/2fxNJ9Vh5NN4NgxlDR3gAU3Mqrn9X2Uhpoe
	oS8C/njGvN9P7e7P8jyTnIlBFS3bM0eL7Y25gZwn5QIRXz7vKZ9zWcwOe0X0m4x5NRhPlJYORsa
	wIR4nl+JZDEkm0oeosbmTf9n3k6tIbyx3i1elBWYGTReCjv5rxUc0zb/P9oJ5Px3WjYyxqE2G6Q
	xOMzsjxW7i4gJfVcWLofin0T5S76FnjZMpgNwrSi2cys/DIsTMyWX65EKP300YsT
X-Received: by 2002:a05:7022:4585:b0:154:fa0b:6df1 with SMTP id a92af1059eb24-1b25d392837mr4962081c88.37.1793983730762;
        Fri, 06 Nov 2026 08:48:50 -0800 (PST)
Received: from carrot.devel.local (madb688455.ap.nuro.jp. [219.104.132.85])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b26294289dsm6996808c88.4.2026.11.06.08.48.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 08:48:49 -0800 (PST)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Vyacheslav Kovalevsky <slava.kovalevskiy.2014@gmail.com>
Subject: [PATCH] nilfs2: zero-fill post-EOF data on mmap write and size extension
Date: Sat,  7 Nov 2026 01:45:28 +0900
Message-ID: <20261106164847.71814-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Post: <mailto:linux-nilfs@vger.kernel.org>
List-Help: <mailto:linux-nilfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-nilfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a file is mapped via mmap, writes beyond the EOF within the same
page are permitted in memory.  However, POSIX requires that these
modified portions beyond EOF must never be written to disk and must be
zeroed if the file size is subsequently extended.

In nilfs_setattr(), size changes trigger truncate_setsize(), which calls
pagecache_isize_extended() upon size extension.  However, this VFS helper
does nothing when the page size is equal to the block size, when the
extension stays within the same block, or when no block exists beyond the
old EOF within the page, skipping the zeroing of the post-EOF region.
The filesystem is therefore responsible for zeroing the post-EOF range in
such cases.  However, the current implementation of nilfs_truncate()
operates based on the updated i_size, leaving the post-EOF region of the
mapped page unzeroed.

Fix this issue by handling size extension and contraction separately in
nilfs_setattr().  When expanding a file, call block_truncate_page() with
the old EOF position to zero the boundary block data beyond the original
EOF, unless the old size is aligned to a block boundary, without
truncating the bmap.  When shrinking a file, invoke nilfs_truncate() as
before to release blocks beyond the new EOF and zero the boundary block.
Propagate the error code from block_truncate_page() or nilfs_truncate()
to nilfs_setattr() for proper error handling.

Additionally, move operations specific to explicit size modifications
(permission and file type checks, timestamp updates, and sync flag
handling) from nilfs_truncate() to nilfs_setattr().  This avoids
executing them in the error recovery path of nilfs_write_failed() and
ensures invalid size changes are rejected prior to calling
truncate_setsize().

Reported-by: Vyacheslav Kovalevsky <slava.kovalevskiy.2014@gmail.com>
Closes: https://lore.kernel.org/all/47d7da4a-5029-4c56-a5ac-3e4c526cc569@gmail.com
Fixes: 05fe58fdc10d ("nilfs2: inode operations")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
Hi Viacheslav,

Please apply this fix for the next cycle.

This addresses a POSIX compliance issue with mmap where extending a
file leaves dirty data written beyond the original EOF unzeroed in the
boundary block.

Thanks,
Ryusuke Konishi

 fs/nilfs2/inode.c | 78 ++++++++++++++++++++++++++++++++++++++---------
 fs/nilfs2/nilfs.h |  1 -
 2 files changed, 63 insertions(+), 16 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index a99a69e9f91b..6ddef3ab0c19 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -39,6 +39,7 @@ struct nilfs_iget_args {
 };
 
 static int nilfs_iget_test(struct inode *inode, void *opaque);
+static int nilfs_truncate(struct inode *inode);
 
 void nilfs_inode_add_blocks(struct inode *inode, int n)
 {
@@ -771,38 +772,35 @@ static void nilfs_truncate_bmap(struct nilfs_inode_info *ii,
 		   ret, ii->vfs_inode.i_ino);
 }
 
-void nilfs_truncate(struct inode *inode)
+static int nilfs_truncate(struct inode *inode)
 {
 	unsigned long blkoff;
 	unsigned int blocksize;
 	struct nilfs_transaction_info ti;
 	struct super_block *sb = inode->i_sb;
 	struct nilfs_inode_info *ii = NILFS_I(inode);
+	int err;
 
 	if (!test_bit(NILFS_I_BMAP, &ii->i_state))
-		return;
-	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
-		return;
+		return -EINVAL;
 
 	blocksize = sb->s_blocksize;
 	blkoff = (inode->i_size + blocksize - 1) >> sb->s_blocksize_bits;
 	nilfs_transaction_begin(sb, &ti, 0); /* never fails */
 
-	block_truncate_page(inode->i_mapping, inode->i_size, nilfs_get_block);
+	err = block_truncate_page(inode->i_mapping, inode->i_size,
+				nilfs_get_block);
+	if (unlikely(err)) {
+		nilfs_transaction_abort(sb);
+		return err;
+	}
 
 	nilfs_truncate_bmap(ii, blkoff);
 
-	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
-	if (IS_SYNC(inode))
-		nilfs_set_transaction_flag(NILFS_TI_SYNC);
-
 	nilfs_mark_inode_dirty(inode);
 	nilfs_set_file_dirty(inode, 0);
 	nilfs_transaction_commit(sb);
-	/*
-	 * May construct a logical segment and may fail in sync mode.
-	 * But truncate has no return value.
-	 */
+	return 0;
 }
 
 static void nilfs_clear_inode(struct inode *inode)
@@ -884,6 +882,7 @@ int nilfs_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
 	struct nilfs_transaction_info ti;
 	struct inode *inode = d_inode(dentry);
 	struct super_block *sb = inode->i_sb;
+	loff_t oldsize;
 	int err;
 
 	err = setattr_prepare(&nop_mnt_idmap, dentry, iattr);
@@ -895,10 +894,59 @@ int nilfs_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
 		return err;
 
 	if ((iattr->ia_valid & ATTR_SIZE) &&
-	    iattr->ia_size != i_size_read(inode)) {
+		iattr->ia_size != (oldsize = i_size_read(inode))) {
+
+		if (IS_APPEND(inode) || IS_IMMUTABLE(inode)) {
+			err = -EPERM;
+			goto out_err;
+		}
+
+		/*
+		 * Reject non-regular files explicitly.  While standard VFS
+		 * entry points (e.g. vfs_truncate) enforce S_ISREG, the caller
+		 * notify_change() can be invoked directly by stackable
+		 * filesystems, etc.
+		 */
+		if (!likely(S_ISREG(inode->i_mode))) {
+			err = -EINVAL;
+			goto out_err;
+		}
+
 		inode_dio_wait(inode);
+
+		/*
+		 * truncate_setsize() updates i_size and, upon size extension,
+		 * zero-fills post-EOF page data if a block exists beyond the
+		 * old EOF in the page.
+		 */
 		truncate_setsize(inode, iattr->ia_size);
-		nilfs_truncate(inode);
+
+		if (iattr->ia_size < oldsize) {
+			/*
+			 * Zero the post-EOF portion of the boundary block
+			 * (if exists) and truncate blocks beyond the new EOF.
+			 */
+			err = nilfs_truncate(inode);
+		} else if (oldsize & (sb->s_blocksize - 1)) {
+			/*
+			 * Zero the unaligned post-EOF portion of the boundary
+			 * block, which VFS skips when the extension stays
+			 * within the same block or no block exists beyond
+			 * the old EOF in the page.
+			 */
+			err = block_truncate_page(inode->i_mapping, oldsize,
+						nilfs_get_block);
+			if (likely(!err))
+				nilfs_set_file_dirty(inode, 1);
+		}
+		if (unlikely(err)) {
+			i_size_write(inode, oldsize);
+			goto out_err;
+		}
+
+		inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
+		if (IS_SYNC(inode))
+			nilfs_set_transaction_flag(NILFS_TI_SYNC);
 	}
 
 	setattr_copy(&nop_mnt_idmap, inode, iattr);
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 28d35b2fa7f7..40dd42133dc6 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -297,7 +297,6 @@ int nilfs_attach_btree_node_cache(struct inode *inode);
 void nilfs_detach_btree_node_cache(struct inode *inode);
 struct inode *nilfs_iget_for_shadow(struct inode *inode);
 extern void nilfs_update_inode(struct inode *, struct buffer_head *, int);
-extern void nilfs_truncate(struct inode *);
 extern void nilfs_evict_inode(struct inode *);
 extern int nilfs_setattr(const struct mnt_idmap *, struct dentry *,
 			 struct iattr *);
-- 
2.53.0

