Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RdivvAYF"
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81687C0;
	Mon, 27 Nov 2023 06:31:27 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1cfbce92362so10659765ad.1;
        Mon, 27 Nov 2023 06:31:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701095487; x=1701700287; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fUxnds+HPQEGrIJRV5viCfLrna/cjmgtYIVib94o7Eo=;
        b=RdivvAYF6eVZLGArJIlnuuoF0pUYPM9OlLjbM4qrsAKAPIXYjfXqM5ghNnG2vb3Pzw
         LPsY4RKvQJ+bvFT2Of0zQ946I1gD9DktveSyBD0Z31l8Kh4KuwJwovLZlKETeeauP2rp
         K9OhMy0w1No0B0xbDCucDS+e8Ooptsz38qxxoCF+TBLr5iNgLHgOH266Wx/wdgWfscoi
         CZYSrclNcNNhBBEGFtI7rLxdgRwe7k5c+tR8NITJZHdLUlzZI3JiAkpWKMAnC2QbSOrh
         1k/VRJVEgO9JLNd4QaGU0svDJKyKIWvv//+hpdypeWz8OVdgCwsgmhVvUUD7go99Ximu
         Lg8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701095487; x=1701700287;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fUxnds+HPQEGrIJRV5viCfLrna/cjmgtYIVib94o7Eo=;
        b=F2Z6KJidmnrLtW1YRpGiaYylkMaQ72cbmjR0u3EGMNNRYDwYT6w6qQ1OCx6nfFmgDO
         AG92lOUDFEKtXTj+59F2tj9RJIF/Bw22WoyUpJ/yKm6k8o4BFSoK74aPSr8CXmwEUeva
         RFdoZd/a5mSVI42t95mnRTpmHvEj7jqfu0xykrg0KIt3w5aw8HAQpr9zcc3W2eBGjUbz
         0gwD5Qi+XDn0Ap4UgtJl/3R7TDbgIhcoHWZZlkn34YNwunZT1GGT1RIVg1pQJ1RM4d1j
         dcMY4OLrXyT3zGGJ86iIlleA/v6gIybh/uAB55c215oCHUUYxDqKiUiNhblxB8MCJkTP
         ppug==
X-Gm-Message-State: AOJu0YwDkJLEVtfSk4fgdn+7ReOqBg3wW2aHpZ6LkLoqG2GgaMHajLXN
	7Aw8+7ELbXQi/GJsB6WP6qA=
X-Google-Smtp-Source: AGHT+IGHFOd7bkC9a/RJlftGaScnufs5iWcmZxUJy8v4aDrD5/NusvSFtuGBLdVVyQMFR2YKEOy64w==
X-Received: by 2002:a17:902:f544:b0:1cf:ca7b:8ef3 with SMTP id h4-20020a170902f54400b001cfca7b8ef3mr5192081plf.11.1701095486878;
        Mon, 27 Nov 2023 06:31:26 -0800 (PST)
Received: from carrot.. (i60-34-119-11.s42.a014.ap.plala.or.jp. [60.34.119.11])
        by smtp.gmail.com with ESMTPSA id a5-20020a170902ee8500b001cf51972586sm8302784pld.292.2023.11.27.06.31.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Nov 2023 06:31:26 -0800 (PST)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 15/17] nilfs2: Convert nilfs_make_empty() to use a folio
Date: Mon, 27 Nov 2023 23:30:34 +0900
Message-Id: <20231127143036.2425-16-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231127143036.2425-1-konishi.ryusuke@gmail.com>
References: <20231127143036.2425-1-konishi.ryusuke@gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

Remove two calls to compound_head() and switch from kmap_atomic to
kmap_local.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/dir.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index 919936d9ec27..ff0a009a292f 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -559,21 +559,21 @@ int nilfs_delete_entry(struct nilfs_dir_entry *dir, struct folio *folio)
 int nilfs_make_empty(struct inode *inode, struct inode *parent)
 {
 	struct address_space *mapping = inode->i_mapping;
-	struct page *page = grab_cache_page(mapping, 0);
+	struct folio *folio = filemap_grab_folio(mapping, 0);
 	unsigned int chunk_size = nilfs_chunk_size(inode);
 	struct nilfs_dir_entry *de;
 	int err;
 	void *kaddr;
 
-	if (!page)
-		return -ENOMEM;
+	if (IS_ERR(folio))
+		return PTR_ERR(folio);
 
-	err = nilfs_prepare_chunk(page, 0, chunk_size);
+	err = nilfs_prepare_chunk(&folio->page, 0, chunk_size);
 	if (unlikely(err)) {
-		unlock_page(page);
+		folio_unlock(folio);
 		goto fail;
 	}
-	kaddr = kmap_atomic(page);
+	kaddr = kmap_local_folio(folio, 0);
 	memset(kaddr, 0, chunk_size);
 	de = (struct nilfs_dir_entry *)kaddr;
 	de->name_len = 1;
@@ -588,10 +588,10 @@ int nilfs_make_empty(struct inode *inode, struct inode *parent)
 	de->inode = cpu_to_le64(parent->i_ino);
 	memcpy(de->name, "..\0", 4);
 	nilfs_set_de_type(de, inode);
-	kunmap_atomic(kaddr);
-	nilfs_commit_chunk(page, mapping, 0, chunk_size);
+	kunmap_local(kaddr);
+	nilfs_commit_chunk(&folio->page, mapping, 0, chunk_size);
 fail:
-	put_page(page);
+	folio_put(folio);
 	return err;
 }
 
-- 
2.34.1

