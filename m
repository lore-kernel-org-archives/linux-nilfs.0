Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0FA21474BF;
	Fri, 16 Aug 2024 07:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723794221; cv=none; b=VnG1azXAHg2e4cU5kXJD7zrY30gxc+WSUoDwzoyijpYo2WGovzze2xX5+4rHcsZLUkFO3HokCL+n0y+lymA22+M1kZ+wf7QEribo4liyhJsmBDJD8I04zYxN17jWMHNeOJXAwsZb6ta3tcyFKDvm5Hnn3PXHXkrUHUhiKxPSFA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723794221; c=relaxed/simple;
	bh=xvXyKWVZ+d9kg2SSupKpqjfvyUo8DmAwO6aYVXqoCnE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=exy/FzLgrCoPCGVv5XdS6OBeRmv6sDDMzm76D6zmGbWXGdLgG1ZUfKU+uroKLy2P6SYeZRXVUKzxS5QFzJMB+hHJu6aFzhJtf4T0OIZH9WSlVZPxLyTGvozDTLJs+KVb81CKzcYy+VQGXK5c71wgHeBxFakieAMMc9SQJ/Hs2DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b0Ik7EdR; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b0Ik7EdR"
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-3db23a60850so1112842b6e.0;
        Fri, 16 Aug 2024 00:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723794219; x=1724399019; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hqvvbDmipCYRQJs4dUhqHplYgkK+QiaGsdcJMKDqZW8=;
        b=b0Ik7EdRfrizwDN1RJNMXH+hjib3WHnILX/s0WXXAneSBSUp/jEBBIYODdCrfn1gPL
         c027CBYYiSYrVFqaju4tbOfvCmPjMyv1fF1/xPA+E6t0o7XLaz4ABHKKUtEz5upfDwR6
         6zis2O6+Eit8U1yeHduo7NTcY9s1rxooKYM1HPamewtM1ojFmgs3ZBcarBaE1u9mBRQW
         v+EqKRJBC7BiacNeK+McIqVS+8LWmy8QldFJwQOBv+Rvg+xYuo9IrK+QdpCsNxRWA6Br
         ojRf/y2Yyl7wP1f9RPpL7veNS+q1aFYqS0pD9u4LKB+hKywRomN7swHqF7kGVqaZ8I30
         ctZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723794219; x=1724399019;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hqvvbDmipCYRQJs4dUhqHplYgkK+QiaGsdcJMKDqZW8=;
        b=Jlo8RmQKF/ae9fwcmExiez0IJFxmDG3Sb6pLInl+yQ+yO1aOZFYMkwdFIBULbe+Nch
         AywCk8yzToCcCVlZOdaNYB/c5D6OPGixxbr3FRlzbF8VclRV7UD5NA2Subfz0QG2I7Fg
         FvWiA5KUKs+nsDQkJ+GKmEDi6NZfQbpywgYgJTRJub8BK251KjOgNci0tUrulyEXakq7
         YZjaYXv5w+e+YeAtFXfmpjfeXqguESxyO2cHf4UIoMRJ7bfsRjN6MHdMGa7rZx5otVU1
         bWlyAO4j0ZfjQ+G0AZ3q56gU9gPOLvuxFk+3/Eo61yadoi4sE6p/WTXHTYESjHs45kvJ
         RO6w==
X-Forwarded-Encrypted: i=1; AJvYcCUTztxIXk+SXXkCuEZZ1w+jMeiCWQw/F5sofQKQXs4WX1SqzU/k6/eHz3GQ4EAEzObnzkDSwP7/CH0TdLd4imn70sSuWU+SN50t9YYC
X-Gm-Message-State: AOJu0YwixrSAHIgSJSZ2gOpKUOhxKOoT3CVBpU24kU09qHthAQy7oCDn
	HQf4ycfRcbdQJSznRJ4ysLBhVEcyRhCw8nwf6Jw187H36ITtu/qv
X-Google-Smtp-Source: AGHT+IEa0L0dIkPYFZco5UgxCnU+zGCuUsA7F4ELG7r0fVIpfddVG8AN2auYz2TwDKW+XxB86Ahfmw==
X-Received: by 2002:a05:6808:1b1f:b0:3da:a16e:1759 with SMTP id 5614622812f47-3dd3ae45c95mr1843917b6e.48.1723794218777;
        Fri, 16 Aug 2024 00:43:38 -0700 (PDT)
Received: from carrot.. (i222-151-34-139.s42.a014.ap.plala.or.jp. [222.151.34.139])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7c6b61e7c7asm2365971a12.45.2024.08.16.00.43.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2024 00:43:38 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] nilfs2: fix incorrect kernel-doc declaration of nilfs_palloc_req structure
Date: Fri, 16 Aug 2024 16:43:15 +0900
Message-Id: <20240816074319.3253-5-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240816074319.3253-1-konishi.ryusuke@gmail.com>
References: <20240816074319.3253-1-konishi.ryusuke@gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The "struct" keyword is missing from the kernel-doc comment of the
nilfs_palloc_req structure, so add it to eliminate the following warning
output by the kernel-doc script:

 fs/nilfs2/alloc.h:46: warning: cannot understand function prototype:
  'struct nilfs_palloc_req '

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/alloc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/alloc.h b/fs/nilfs2/alloc.h
index d825a9faca6d..e19d7eb10084 100644
--- a/fs/nilfs2/alloc.h
+++ b/fs/nilfs2/alloc.h
@@ -37,7 +37,7 @@ void *nilfs_palloc_block_get_entry(const struct inode *, __u64,
 int nilfs_palloc_count_max_entries(struct inode *, u64, u64 *);
 
 /**
- * nilfs_palloc_req - persistent allocator request and reply
+ * struct nilfs_palloc_req - persistent allocator request and reply
  * @pr_entry_nr: entry number (vblocknr or inode number)
  * @pr_desc_bh: buffer head of the buffer containing block group descriptors
  * @pr_bitmap_bh: buffer head of the buffer containing a block group bitmap
-- 
2.34.1

