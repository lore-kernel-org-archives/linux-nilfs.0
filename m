Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TpoRDYsQ"
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DBF710EC;
	Mon, 27 Nov 2023 06:30:58 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1cfc2d03b3aso8079815ad.1;
        Mon, 27 Nov 2023 06:30:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701095457; x=1701700257; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TtusoM3dpH6zj86rZ9DcGWfb2vtJ7UeLgS5shm5pfGs=;
        b=TpoRDYsQk+HkejkDtsfCnnX2/Y57W4+bi3HBYG7762HYYwi7NP1TQNQlkqvWW6OS02
         gMdAXtMDAY6irCSAoeIpRnNxRb98ykmlUd8do/WfqD1j2kgNavHL53mC93v8BVvALCVw
         WUPlHS/MQpGfA8XxATi2HVjXx/qYQ7ka87HqIy7bbENUVeDPHPCabd146GOdarrsZhOe
         xTlWC5S8oFxNfHO3z11KuB+WAgu49rZFgUxAlkIQj5uQZUaYQ4hEJuBUx6v1e4iXfFIW
         ppDwWpyaBOVXzzK2HkGzfBKZeYM/EzTgzLSFby1UWLSEOopw6UGFYGIE7VO26KlivQ1z
         Xikw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701095457; x=1701700257;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TtusoM3dpH6zj86rZ9DcGWfb2vtJ7UeLgS5shm5pfGs=;
        b=qjsLhpcuZlJ+v3N0RoGnJuOMiKrsigW3H39rr98O5oncj4jxOZkNZH2SulAPd4guSw
         fP2EcL8DrbJHsa7UsEUjiKv/TnuO9Xa8H+LXLC9/C0i+qE0mNZr9NZU8muE2jwJstrPN
         jyZZMzFC3m+Qm5MYHVRmAgJfYVY88seas7qkXvgUvZKEjSrxFWo+hKLmextq8zveQEy1
         5ojA9P2Qkx33Skrk69UyGN1IaY0Y0zeo4FeL0dD7dEHTyzle6DIrlGxL3FlpbwEZ/lCI
         /RgfR8gsHIIq0zimPSxyWY1y+NpVYjkR2QeTC/ZVooFFc6GjugtH1y80tOipGBs2f+Uq
         NfoA==
X-Gm-Message-State: AOJu0YxtVRqCstcwWGfNRLpkbMTa6NI4gwbfnbkQeXhA2fqhqCQSCx6h
	dPNMZrtqsorzHC8NROHz+2D2gM6VBVE=
X-Google-Smtp-Source: AGHT+IE5lM6J+NZSydRaySA557HC3cJyq5847etNUFGAlE9tx4q0L/cSdLamUjeGFIshgx1ecCrTZw==
X-Received: by 2002:a17:903:11c8:b0:1cf:5760:43f9 with SMTP id q8-20020a17090311c800b001cf576043f9mr12554020plh.64.1701095457548;
        Mon, 27 Nov 2023 06:30:57 -0800 (PST)
Received: from carrot.. (i60-34-119-11.s42.a014.ap.plala.or.jp. [60.34.119.11])
        by smtp.gmail.com with ESMTPSA id a5-20020a170902ee8500b001cf51972586sm8302784pld.292.2023.11.27.06.30.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Nov 2023 06:30:56 -0800 (PST)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 05/17] nilfs2: Remove page_address() from nilfs_delete_entry
Date: Mon, 27 Nov 2023 23:30:24 +0900
Message-Id: <20231127143036.2425-6-konishi.ryusuke@gmail.com>
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

In preparation for removing kmap from directory handling, mask
the directory entry pointer to discover the start address of the
page.  Matches ext2.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/dir.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index 73f135290288..385e47eda99f 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -531,7 +531,7 @@ int nilfs_delete_entry(struct nilfs_dir_entry *dir, struct page *page)
 {
 	struct address_space *mapping = page->mapping;
 	struct inode *inode = mapping->host;
-	char *kaddr = page_address(page);
+	char *kaddr = (char *)((unsigned long)dir & PAGE_MASK);
 	unsigned int from, to;
 	struct nilfs_dir_entry *de, *pde = NULL;
 	int err;
@@ -551,7 +551,7 @@ int nilfs_delete_entry(struct nilfs_dir_entry *dir, struct page *page)
 		de = nilfs_next_entry(de);
 	}
 	if (pde)
-		from = (char *)pde - (char *)page_address(page);
+		from = (char *)pde - kaddr;
 	lock_page(page);
 	err = nilfs_prepare_chunk(page, from, to);
 	BUG_ON(err);
-- 
2.34.1

