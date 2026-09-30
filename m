Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC3881ACD
	for <linux-nilfs@vger.kernel.org>; Wed, 30 Sep 2026 00:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790727060; cv=none; b=kIwYjY2ERyJoVy+IMuw3ve0Oaqhw1boRvY0Bj7uitKLgIlIbL6QwXuOGJ3c2ISYIi0Z9W0ilhvbfeN3U/R64Yq7BrBdAyP7USEHub7jtoZ9d/LzbgY9sC285cu3J5W0NAR/13xGCKKFEaLnzMcuQQCJxdI3aAbsrkOxWAlT7v6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790727060; c=relaxed/simple;
	bh=A0vWtRFSAR/WeiwhE66ziw7fitXK+I3qI9eV5TITlB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e/sHFupGe6/lcGG++B5z2XtULK8pnDEjVY4peAsoz+FrpC87Yal2KeC60NLheXdFHpwTyKMFAO8FcdCn43v+ZywN2uErMIIZVtjVUwbikA4VRpGO9pTkVcYRc5DLgwHC9I0ASg9VZSg6O2zpP/gr0U65VGaEfpkVH4Sy8tefWJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UvXabkus; arc=none smtp.client-ip=74.125.230.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UvXabkus"
Received: by mail-qk2-f13.google.com with SMTP id d75a77b69052e-52fb766bfd3so42065091cf.0
        for <linux-nilfs@vger.kernel.org>; Tue, 29 Sep 2026 17:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790727058; x=1791331858; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=m5lq1/zsch83Vj1jZPD+5fvsLO0Q7TqbCppV8Kw0m7w=;
        b=UvXabkusOiuE7yZzLQP6Y+XwTdFQJMadQoT4Yd/FyLeh2BrfoC7HLSJqwa0tROn6ZW
         SpQOKWYrfLBbU/u7rHZVeR2plkK6/70NvaH77KmT2HxuHFAu/NoYryHFnj8ZROY5i8mZ
         sKqxpGtiP75xYbMGbLWot4rt8FKTiGABXI0+9dOdaWs/D9AULK7oXZhkFT0FWkeh1Cu9
         QJhUoQ2DXIYBzPqNgqPiFin/wHK7p0LGGB/RRR0r+hNZuIp62z/sWNAkDLpOdCMP9C9L
         AIIq2AUQ0YsYH49oTyOeh27EGEV46jpgK24JLShG/sQsgVWhkvaDg7LhnV1a9ur4lxy1
         Tgvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790727058; x=1791331858;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=m5lq1/zsch83Vj1jZPD+5fvsLO0Q7TqbCppV8Kw0m7w=;
        b=F3R3MfCSr7UIgoNjnMiUGW3BDFSh0wGdby2CZ2Pg5LuVTcX6Yhjqe9yDOfc8FP+e3j
         us8y9QP8gFAL7PmpC5zeFWlSXhAJ7gqXpCnwPPTqHXoJfw5Uh05NuoELf6G+3DnDya/P
         mLlGwj1X3A8SJjF5pNLvb1S7FzvzF/SkCdkIrgQU/AY2hNTTFHlBcNWdNtZ/qcPKonIe
         eVoWZJ0y2rvEOnREmEbtIizlhhb/riGYTg0Nq/3+WaXp5wld9uS1wf5fWQGdXtYiWo37
         y0xc9fV89VsOq4ZVu7g58TF1UVk5x+ps0xrxTzYDWTPD8X30e1aqBrF/ObrfbhoTrx72
         /WLg==
X-Gm-Message-State: AFuF++l2wu0wMuwThoGdQCs2XpxrSgPPNgdd4nvVTj6XQzH0cvgG93w6
	qaYgOBozzKGxUJVj6aC1Yzaef4sAhRVL1RVKcON/1iIs+jXwfCCcCfgDG15Teg==
X-Gm-Gg: AYBFou26RoKraFG/y2MqFyw6OafR2g7n08cglQvsqKY+cI0f9uRY8ok9oZFaimq0MsW
	wWQjippKsBDhIEzkswEd2EEI1foFLhQayKF+37O+JkBZC5rpnVY+EM7FXvkoVKGzVRJ0AhPjYVq
	n9VeiXO2Ag73Ucuou6USonx/oR4CYWpc6wQuAkr8CN8QvMtFTsR2FOg0a/wDHlH2mNupilXq03r
	Dk+OfOP8SATbUvso43TJtJ30ZQwVAKpgpwX74/3SfsEhZW3U+ghx4cUoz08+ZAzkZVHc8QNQJhK
	zMV1XJqcr3Pb+9KLMR66NNewQEYFjCL/ctMX7FiyB2JAe+HatONiohtgBQDA5uo7L+5X/s0zgkF
	qPzXte6egHrmvOchr25v+iRlUTyyNfucJUnvvcJ56nHhVXJJMMdRZTXStw4pqb5PL3X3cFnx/tV
	jNJ0sFd28EtpTCQAQM7zcwujbmmc6S8u61O/37zvhHs5YToOzqoC4HSpCf4KmHpITeYFq9zvlzv
	F73j8owmlKxwELphswDDrqFKEyymmmJguc9kQ==
X-Received: by 2002:ac8:5986:0:b0:532:d18f:bd57 with SMTP id d75a77b69052e-5336a4d622emr18641261cf.18.1790727058280;
        Tue, 29 Sep 2026 17:10:58 -0700 (PDT)
Received: from jake-B450-I-AORUS-PRO-WIFI ([73.194.254.128])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53369b9f477sm7175391cf.19.2026.09.29.17.10.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 17:10:58 -0700 (PDT)
From: Jake Labelle <southampton.jake.labelle@gmail.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs@vger.kernel.org
Subject: [PATCH v2 2/2] nilfs2: validate directory position after llseek in readdir
Date: Tue, 29 Sep 2026 20:09:52 -0400
Message-ID: <20260930000954.371774-3-southampton.jake.labelle@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260930000954.371774-1-southampton.jake.labelle@gmail.com>
References: <20260920205533.426028-1-southampton.jake.labelle@gmail.com>
 <20260930000954.371774-1-southampton.jake.labelle@gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nilfs_readdir() uses ctx->pos, which userspace can set to an arbitrary
value via llseek, as an offset into the directory folio and parses
whatever bytes sit there as a directory entry.  A position pointing
into the middle of an entry -- or at unused bytes of a corrupted image
that the page validator never inspected -- makes dir_emit() copy up to
255 (name_len) bytes from a bogus entry, possibly reading past the end
of the folio and returning unrelated memory contents to userspace.

Snap unaligned positions onto a valid entry boundary by walking the
rec_len chain from the chunk start before parsing, as ext2 does in
ext2_validate_entry().

Fixes: 2ba466d74ed7 ("nilfs2: directory entry operations")
Co-Authored-By: Claude Mythos 5 <noreply@anthropic.com>
Signed-off-by: Jake Labelle <southampton.jake.labelle@gmail.com>
---
v2:
- Hoist the repeated nilfs_chunk_size(inode) calls into a local
  chunk_size variable, matching the existing style elsewhere in
  dir.c (Ryusuke Konishi).
- Expanded the comment to explain why re-validation is only ever
  reachable on the first page of the loop, and why any chunk-aligned
  offset -- not just offset 0 -- is already a trustworthy entry
  boundary: no on-disk rec_len chain crosses a chunk boundary, so
  chunk alignment alone (regardless of the variable-length entries
  within a chunk) is sufficient without a chain walk; a walk is only
  needed to recover from a non-chunk-aligned offset (Ryusuke
  Konishi's question, answered on-list rather than in code).

 fs/nilfs2/dir.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index 8b53802b6..bc8cb21c7 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -231,11 +231,27 @@ static struct nilfs_dir_entry *nilfs_next_entry(struct nilfs_dir_entry *p)
 					  nilfs_rec_len_from_disk(p->rec_len));
 }

+static inline unsigned int
+nilfs_validate_entry(char *base, unsigned int offset, unsigned int mask)
+{
+	struct nilfs_dir_entry *de = (struct nilfs_dir_entry *)(base + offset);
+	struct nilfs_dir_entry *p =
+		(struct nilfs_dir_entry *)(base + (offset & mask));
+
+	while ((char *)p < (char *)de) {
+		if (p->rec_len == 0)
+			break;
+		p = nilfs_next_entry(p);
+	}
+	return offset_in_page(p);
+}
+
 static int nilfs_readdir(struct file *file, struct dir_context *ctx)
 {
 	loff_t pos = ctx->pos;
 	struct inode *inode = file_inode(file);
 	struct super_block *sb = inode->i_sb;
+	unsigned int chunk_size = nilfs_chunk_size(inode);
 	unsigned int offset = pos & ~PAGE_MASK;
 	unsigned long n = pos >> PAGE_SHIFT;
 	unsigned long npages = dir_pages(inode);
@@ -254,6 +270,24 @@ static int nilfs_readdir(struct file *file, struct dir_context *ctx)
 			ctx->pos += PAGE_SIZE - offset;
 			return -EIO;
 		}
+		/*
+		 * ctx->pos comes from userspace via llseek and may point
+		 * into the middle of an entry -- or at unvalidated bytes
+		 * of a crafted image. offset is only nonzero here on the
+		 * very first iteration (subsequent pages always start at
+		 * offset 0, which -- like any chunk boundary -- is always
+		 * a legitimate entry start, since no rec_len chain crosses
+		 * a chunk boundary). Snap a non-chunk-aligned offset onto
+		 * a real entry boundary by walking the chain from the
+		 * enclosing chunk's start, as ext2 does; otherwise
+		 * dir_emit() copies name_len bytes from a fake entry,
+		 * reading past the end of the folio.
+		 */
+		if (offset & (chunk_size - 1)) {
+			offset = nilfs_validate_entry(kaddr, offset,
+					~(chunk_size - 1));
+			ctx->pos = ((loff_t)n << PAGE_SHIFT) + offset;
+		}
 		de = (struct nilfs_dir_entry *)(kaddr + offset);
 		limit = kaddr + nilfs_last_byte(inode, n) -
 			NILFS_DIR_REC_LEN(1);
-- 
2.43.0

