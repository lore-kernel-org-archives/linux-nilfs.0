Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D261B21A0B;
	Sat, 10 Aug 2024 06:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723272769; cv=none; b=GPTgOlnNGyUPYjyIyFPpvVjABnphLzU23i4aLHOzKLLeC4XKKTYjrasSzab7qDyN45VqIZ8R8pBRqR+yk/+lp+/YdqRwjGKt2X2o2+hQHGyP4vmRMH247KsoKpEnyWYe7H4zUKu0cA6CIE7AI+eOLrQ7XlPZUYH0dPxWpI9l8x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723272769; c=relaxed/simple;
	bh=FudGx2PxtWdv1Ey9bknRFbztOC+S9px4S1BtXbCAxoA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IDKq+Z6IiJqSC3lGIqgcOQZZxSv6dnP93aYWZg3kHgP9I7ZVgmnzjtz1h/YAbBTbRrPMJz8umB/1xSo5fy9k2qBEd5yDUmuIEGAdl1PvMxFV1s0EAPqNu7+IjEsCOzasXoygHDPGDf/Q/5D8nGbed9YI14mMqSRJIHOj9ba0Apw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XBvigmjH; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XBvigmjH"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-7b594936e9bso1961433a12.1;
        Fri, 09 Aug 2024 23:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723272767; x=1723877567; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HxgVMOpRDF5vpjeN8YLiua76dTY/jjl6Cq5qYi3DIs4=;
        b=XBvigmjHkQJiaan6EOdvktOjrQV6b/OrKiBoGTeilzoe9lum8rY1rx6hz7mkX1g57G
         T3uKIBS8ITVyG/Gwj8Rj3T6KZtdlWHTZBL1E74naH1DiICQ4uwZHgndYHh581X7cwUs+
         jWoBRive1jhZR/gPXO7aNicQDR9kDhk78g7/gMD6SCBTfNJCIa1ExCznQLNzdyyqFnZg
         QhGLB2fqy07pub0npxfwu+lnGlk60jVRHGdEH9lsxZJczNqK0HLKndNz8HsYSH+ghjoD
         Gap6uJGlyBb0KVcXu/IZ5xGb3JFVH2JrniX44kLKlbSK9clJ7qezOzF0sQ+LlW+3rfdR
         IVBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723272767; x=1723877567;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HxgVMOpRDF5vpjeN8YLiua76dTY/jjl6Cq5qYi3DIs4=;
        b=ifxBQuZCX7OWHDrCEScSsOfeDohhj4OIZKKYXKUs9q83D3LUFaHTfxrroSYqOG/OEH
         AC6EWMnFBnihU83axumY8h54HvLQfpq0/i+CjUEJaAeFmydguj/jfT/A+2ef+w3VZBgS
         JbIO5pvgaazEv01C+YAGTX6uSUuTz0u623eYLL0F28KmLew3dMCzIRZeQODO8XgLPLee
         8wKI9FLiUKhAl6TbnSA85yFrcmwg1Hdz/sm6HYDZxEOh15cK/pgoh7vv3BM7jEJJuBNJ
         HCmFTe7aZoUHo5TEIDzU1yCDtlOoXyunAQjo4yaJfWBtFpCJfyBnxCQMjYTcHY5+4ba0
         E/xg==
X-Forwarded-Encrypted: i=1; AJvYcCUwmfHYbUilDciUDd5dpAmr/yN/k7oNtaxESjIPd9Q9+YOPvXEZVHmYKUyH7G8i6nJNk8PmsC6L+iQT403Ln/8Aj05MEkvv4sWq0mSy
X-Gm-Message-State: AOJu0Yzinak873TvhdRaxexye2iUBOATMx5gKrgz7/2mZZdxVjVlJdVb
	cuou1ewIdMX4RPpKjMES2zHJpd7K4lCwQJ1X1+PXTqAl1cCLAkNg1d8AWA==
X-Google-Smtp-Source: AGHT+IFkEJeQJF3PLn1zazXFMXbKgsFiU7lFDe7Yoq3f2s8oZB9b7Wz3ghCtOXaMyCaK/tragUJ8Lw==
X-Received: by 2002:a05:6a20:e68e:b0:1c2:8cf4:766c with SMTP id adf61e73a8af0-1c8a00bbdd1mr4639753637.33.1723272766822;
        Fri, 09 Aug 2024 23:52:46 -0700 (PDT)
Received: from carrot.. (i222-151-34-139.s42.a014.ap.plala.or.jp. [222.151.34.139])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d1c9c7becasm4123166a91.18.2024.08.09.23.52.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 23:52:45 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] nilfs2: fix missing cleanup on rollforward recovery error
Date: Sat, 10 Aug 2024 15:52:42 +0900
Message-Id: <20240810065242.3701-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In an error injection test of a routine for mount-time recovery, KASAN
found a use-after-free bug.

It turned out that if data recovery was performed using partial logs
created by dsync writes, but an error occurred before starting the log
writer to create a recovered checkpoint, the inodes whose data had
been recovered were left in the ns_dirty_files list of the nilfs
object and were not freed.

Fix this issue by cleaning up inodes that have read the recovery data
if the recovery routine fails midway before the log writer starts.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Fixes: 0f3e1c7f23f8 ("nilfs2: recovery functions")
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: stable@vger.kernel.org
---
Andrew, please apply this as a bug fix.

This fixes missing cleanup on error that KASAN detected during an
error injection test of recovery on mount.

Thanks,
Ryusuke Konishi

 fs/nilfs2/recovery.c | 35 +++++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index b638dc06df2f..61e25a980f73 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -715,6 +715,33 @@ static void nilfs_finish_roll_forward(struct the_nilfs *nilfs,
 	brelse(bh);
 }
 
+/**
+ * nilfs_abort_roll_forward - cleaning up after a failed rollforward recovery
+ * @nilfs: nilfs object
+ */
+static void nilfs_abort_roll_forward(struct the_nilfs *nilfs)
+{
+	struct nilfs_inode_info *ii, *n;
+	LIST_HEAD(head);
+
+	/* Abandon inodes that have read recovery data */
+	spin_lock(&nilfs->ns_inode_lock);
+	list_splice_init(&nilfs->ns_dirty_files, &head);
+	spin_unlock(&nilfs->ns_inode_lock);
+	if (list_empty(&head))
+		return;
+
+	set_nilfs_purging(nilfs);
+	list_for_each_entry_safe(ii, n, &head, i_dirty) {
+		spin_lock(&nilfs->ns_inode_lock);
+		list_del_init(&ii->i_dirty);
+		spin_unlock(&nilfs->ns_inode_lock);
+
+		iput(&ii->vfs_inode);
+	}
+	clear_nilfs_purging(nilfs);
+}
+
 /**
  * nilfs_salvage_orphan_logs - salvage logs written after the latest checkpoint
  * @nilfs: nilfs object
@@ -773,15 +800,19 @@ int nilfs_salvage_orphan_logs(struct the_nilfs *nilfs,
 		if (unlikely(err)) {
 			nilfs_err(sb, "error %d writing segment for recovery",
 				  err);
-			goto failed;
+			goto put_root;
 		}
 
 		nilfs_finish_roll_forward(nilfs, ri);
 	}
 
- failed:
+put_root:
 	nilfs_put_root(root);
 	return err;
+
+failed:
+	nilfs_abort_roll_forward(nilfs);
+	goto put_root;
 }
 
 /**
-- 
2.34.1

