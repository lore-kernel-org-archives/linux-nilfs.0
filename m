Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gGQfITpu"
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36CFB10FB;
	Mon, 27 Nov 2023 06:30:49 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1cfa8f7c356so16970345ad.2;
        Mon, 27 Nov 2023 06:30:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701095448; x=1701700248; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=79oq+dAh3gxJRpbXVK4oY+eeQB5JyiO6FF7VLXAwv3Y=;
        b=gGQfITpu/0IEPQBSVWUfVKLM+qaUMf7s6Ux6aq8lIXab74oai3ZVJT2nUU1uXWIEB5
         Xb06vD9km71cQqzGE6OU+W5cOuLfMOU/B3X81ES7bYg4rlzV45uEGqMgeE83ShUVJABL
         evvEsO4/+B23bdFsUCoAzNwY6EdTd7Gl9lK5uIMQOhm3EFwQRQb35dWnwp6i5ej1+5HE
         EOhOcW6Da4wYF2bCqsv9svv7RA/f9pChmPgm7GndIBqsrZlJnq0xkduUAdl1vWaNexQw
         Gcs9+m7RJDFXBCGJpNPCnXK/lcpJdzG1ZEG5EfdKS8WQTjfE7idC/LRugik2oDmgNmoP
         gnVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701095448; x=1701700248;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=79oq+dAh3gxJRpbXVK4oY+eeQB5JyiO6FF7VLXAwv3Y=;
        b=R88hVyIIRcO1RKNvrabvKjN/JgFcKQgYSI7JTiWXdHlrWKJIO2ETdd+oAtaIjCBj6T
         QL+az+Wte0W2yxCnE6nMGs7yk3F63OVH9gTD5BXyWbdupFLSVwQCyfrSsV2XWEea2xJN
         D0PpMeWQUgbgWPnlWWo+2WqUZ9ecyOHhZ8vDWXdL7V2UFiFtJY4KcEYrcq58/QHNDzY8
         Y/NXe2BmOkxUUmjV3flsBspdFb9Y4Yu7DZUUOHNqxJkMPwPmBtSP+YB6Cx5Yv3P6Lt9H
         E1FYptpkO3WvlsRTzSQ+m+8jvZ6rRytkFAljK7JhWr2QN1IE1TppmXGJ+Hi9dyOUFByr
         9HjA==
X-Gm-Message-State: AOJu0YyMvf/z3GneU2pKRsFlI9jBmhu/MXztXcx84yvf2b3WhcHS46q2
	3Nyodr85UtK8/b8heRJIzjLhtlYsLT4=
X-Google-Smtp-Source: AGHT+IFCcGQTenNTKXAWPxXEVGofHh+r5H3pUIB/LHFak8FW5Q+MGjQ4jb9EIEow3dxg4VrJyStGBg==
X-Received: by 2002:a17:902:f541:b0:1cf:d648:31e3 with SMTP id h1-20020a170902f54100b001cfd64831e3mr2215302plf.65.1701095448328;
        Mon, 27 Nov 2023 06:30:48 -0800 (PST)
Received: from carrot.. (i60-34-119-11.s42.a014.ap.plala.or.jp. [60.34.119.11])
        by smtp.gmail.com with ESMTPSA id a5-20020a170902ee8500b001cf51972586sm8302784pld.292.2023.11.27.06.30.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Nov 2023 06:30:47 -0800 (PST)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 02/17] nilfs2: eliminate staggered calls to kunmap in nilfs_rename
Date: Mon, 27 Nov 2023 23:30:21 +0900
Message-Id: <20231127143036.2425-3-konishi.ryusuke@gmail.com>
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

In nilfs_rename(), calls to nilfs_put_page() to release pages obtained
with nilfs_find_entry() or nilfs_dotdot() are alternated in the normal
path.

When replacing the kernel memory mapping method from kmap to
kmap_local_{page,folio}, this violates the constraint on the calling
order of kunmap_local().

Swap the order of nilfs_put_page calls where the kmap sections of
multiple pages overlap so that they are nested, allowing direct
replacement of nilfs_put_page() -> unmap_and_put_page().

Without this reordering, that replacement will cause a kernel WARNING
in kunmap_local_indexed() on architectures with high memory mapping.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/nilfs2/namei.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index 99255694cbe9..d179db8074c2 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -411,13 +411,14 @@ static int nilfs_rename(struct mnt_idmap *idmap,
 	inode_set_ctime_current(old_inode);
 
 	nilfs_delete_entry(old_de, old_page);
-	nilfs_put_page(old_page);
 
 	if (dir_de) {
 		nilfs_set_link(old_inode, dir_de, dir_page, new_dir);
 		nilfs_put_page(dir_page);
 		drop_nlink(old_dir);
 	}
+	nilfs_put_page(old_page);
+
 	nilfs_mark_inode_dirty(old_dir);
 	nilfs_mark_inode_dirty(old_inode);
 
-- 
2.34.1

