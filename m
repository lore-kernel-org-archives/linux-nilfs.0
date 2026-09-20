Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3AE43DB964
	for <linux-nilfs@vger.kernel.org>; Sun, 20 Sep 2026 20:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789937748; cv=none; b=lsvbqk5YTu1ZNaft2jZxdRIXrUa73donDYyr1V/WUwuS9+RJ0luncpfff1baL6NTJBZEgPCJQUxnAIkz8fWNq1wYn9u1p+8XY7uN900P93dEl6hle63P8FPhw/Jo5EsLiv+0zvczlA0gvOzyfw3Ow7v7D5t9+/AxYY+uMVt0COk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789937748; c=relaxed/simple;
	bh=XnEPbFDOeIMRiC2mGM8dgn8RjLp33yZyAGck6wqopQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bSty4gdKDIBg40Q0U9QRNJDmG0xEth6TkBNEiEK85i3b+WFdkDyhQhBvzEjW+fL8OPVjVGF1qZmWtJDvmUv7sLfV6TH8fkYjsy0zSaiBYmZJ/vtlhujDaOwEwHR8VYpwGKVIbVXxghUonFZsCioEt4DD6PWblk3qtpU8fhqQqmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=tKpx6ZOz; arc=none smtp.client-ip=74.125.230.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tKpx6ZOz"
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-52fb76ef19aso25536151cf.2
        for <linux-nilfs@vger.kernel.org>; Sun, 20 Sep 2026 13:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789937746; x=1790542546; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QTwgpOe6YBb5elfhiyEG5XKY2bTbrodAgTbYn3/5luY=;
        b=tKpx6ZOzl4sBM13gRd2x6emKNeYNU7Kvs/ghdxKgc4zGepSZR4b8xAv/YKLKTtMqWz
         5OqdwgaED2NhpWRbZ50aPCb/ogKDsN190E0ZUnKy78DAJtFlzsVP98RyzvJ6WLboi8yl
         7vk2SoaCAh7dy5Yg17pSjPUWRWgF9qaeEd++r+JTePsYKR8bw+ISJORrS17A/IyxestC
         o+AKVlJsoGsSqbrikP8kNny1ymT9iTgm/lNLOvwgsJit+DZ0Ch6yRCJOnYg5uAImmqRG
         sMH2GbGDrAQ++Rj98o8Dv6cyhzXmUderF09mVel5FRcI+QmOXfF1q+Sl4rBgNaB/fvwR
         rDyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789937746; x=1790542546;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QTwgpOe6YBb5elfhiyEG5XKY2bTbrodAgTbYn3/5luY=;
        b=byCog9ZQpRDDmVZ7QiwSaYJyRmmbjzb23rCbGWcRS7ER0NsXy6opI4/z5sSe1hzRdK
         i/C/BqDjqHKrdssepPlWApDFsiP+/Eci6VLrCUekoHgQgr+dHeT3E0nNJjSZkY3TKWPV
         fwCWC97VIivvvby0D7kn4bOi4YeLeIsB7C1196bJb2mZc0XWYr3cl0rFVRYiIM72dI4M
         7TfFJkD44sgY9Tqdkjke4Z2Qu2DUBsnVaJsSFHWm2SYMG3bksNrniHRJVmUBWWC10cnT
         loGeVc9la3598BrCKprT4sVOSEEkr+CIsfhG9a/fxEjwciWKkCzN2h6jYX85rW5awOM3
         V0kA==
X-Gm-Message-State: AFuF++mJjOxkDpWqtjkeYnnJXDCVbiMMrBsT7Y//6dLCUjhZgzgT7Upv
	PoRUm10me1HZR3uSv58h9OuFHAHy+aaVDn59DrQmYulFDQWLp3kJZ7Az3mrW1Q==
X-Gm-Gg: AYBFou2w7mPIEi50PZo8LK/BykU38iVQ5w8key/xzMWZcwYD5tpKbv0M3lmyAEupiRu
	s0C0Cf9cRCFwaUOOFz7ip9dFzcagdCHrVDvrtOVvm5ZmHa4jPFGWDWLaCVBLlKY9D+DIOWawfDs
	GjXySO1Qa1ILJ13eOpcZNCBcn3YPYTJfhYe/QiKpldOq95l7L4yXJoT9+DMINDo3MzNX4W7izEh
	EA4h63rDPguitvfGqaTetO2vCx+NgIu/666/VyDUhQff8H0GJvpAvPcP1e0bNMeBTyQlWUq3nI0
	Ol+8LHJrZgUcSe0bmNJlymSKTzaACM5xYjHemDxDkd+MkgYyy/nB8wMS5wBNAONP+xY1jrjK99K
	BS03cmMrkLYgGYIbCU/+KcOHaVq7tjcTF/7m6dZOp8EzK1IFm/2QLCYYsjx2zE4iAozYFMXZTZJ
	aRtVHA5KlixtmcF6jNyudL+mgQqPVZr0I92I/94LuHEo6/NzDpM0XbQRAeW3l43rs6Wia7xOqQr
	1tNCoEYIT8DN+eokOC0CN/d7OkR9ADaa2Io6czCbg==
X-Received: by 2002:a05:622a:1b8e:b0:532:9add:50af with SMTP id d75a77b69052e-532b739bf4emr65327591cf.63.1789937745860;
        Sun, 20 Sep 2026 13:55:45 -0700 (PDT)
Received: from jake-B450-I-AORUS-PRO-WIFI ([2601:84:8f81:33f0:4668:3d1a:1c3d:3767])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532ae511d1fsm48075091cf.3.2026.09.20.13.55.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 13:55:45 -0700 (PDT)
From: Jake Labelle <southampton.jake.labelle@gmail.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs@vger.kernel.org
Subject: [PATCH 2/2] nilfs2: validate directory position after llseek in readdir
Date: Sun, 20 Sep 2026 16:55:32 -0400
Message-ID: <20260920205533.426028-3-southampton.jake.labelle@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260920205533.426028-1-southampton.jake.labelle@gmail.com>
References: <20260920205533.426028-1-southampton.jake.labelle@gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 fs/nilfs2/dir.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index 8b53802b6..bc8cb21c7 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -231,6 +231,21 @@ static struct nilfs_dir_entry *nilfs_next_entry(struct nilfs_dir_entry *p)
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
@@ -254,6 +269,18 @@ static int nilfs_readdir(struct file *file, struct dir_context *ctx)
 			ctx->pos += PAGE_SIZE - offset;
 			return -EIO;
 		}
+		/*
+		 * ctx->pos comes from userspace via llseek and may point
+		 * into the middle of an entry — or at unvalidated bytes of
+		 * a crafted image. Snap it onto a real entry boundary
+		 * before parsing, as ext2 does; otherwise dir_emit() copies
+		 * name_len bytes from a fake entry, reading past the folio.
+		 */
+		if (offset & (nilfs_chunk_size(inode) - 1)) {
+			offset = nilfs_validate_entry(kaddr, offset,
+					~(nilfs_chunk_size(inode) - 1));
+			ctx->pos = ((loff_t)n << PAGE_SHIFT) + offset;
+		}
 		de = (struct nilfs_dir_entry *)(kaddr + offset);
 		limit = kaddr + nilfs_last_byte(inode, n) -
 			NILFS_DIR_REC_LEN(1);
-- 
2.43.0

