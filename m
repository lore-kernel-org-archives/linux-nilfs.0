Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8505D145B23;
	Fri, 16 Aug 2024 07:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723794219; cv=none; b=hYkFL3G9bEJ/AyuJgeTF7qaaZSZ+KUf160jPJp5a8yY1i6bBsv4K9YMMQXKNICdn1I7L7PTMhwYKhoCzCbgIvdfK1SKnYsAFgNtEdCJOIZioAUnhC4FpGx/VPiwa+Th4dEta6thv70bLHb0cN69zoVEUnaibw2nSHoEwjY5bSPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723794219; c=relaxed/simple;
	bh=ZxrL3hH0pVt0JDnnRDdHkN81lAhlOawK6z//FKuUrhk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dUJ9P1gXNY56TFMsi18jdTaxy4150zIvM90FFN/PiEEN6hmrnvIYdMUyG7oDSxZZuWHP+jQuE+3Qdmt1MX6uAEEG2IHzytExMU7G2V+3xPZz0g3Ukvh3J/FbUSyBJ1PWmjaL1/c8BemzwX44IJf26eQdviLamOK6UpLvNhShvlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nmtX/Hzh; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nmtX/Hzh"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-710e39961f4so1286305b3a.3;
        Fri, 16 Aug 2024 00:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723794217; x=1724399017; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DZqnDzdx2eoVGdt+SqB5/B/a67w1gWDZf/LKp/84mBQ=;
        b=nmtX/HzhcYOTi96H335bE98aczTj62oc4H7iElYxCZaqXCuoa5ecaMhf8iGm1tEAS/
         leCxZX2TjWFMjQRKk97HUf7HaikxiODjNKNtqf7XDXI34bCwHoFqeE/hSBH6mk2hoxvw
         zRdgI8ojBkaaQ6SInJptKHYOcFzD98mAGUkHw0lhvUS7JfStwR8S5VsHYl1hYb6k0IES
         HT1zjGCt3KDIvLupyasap2j409waqzYLlQY0IDiaMYKmSpAaFeuD9+EfZt8bSqAH1Pd7
         y4rliY+LzwE+6SbecI5xvJFZ3xUDNRPoRdUeeXI2THsw4tENjKiVFYZvs1ODF6jsq0aK
         gQkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723794217; x=1724399017;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DZqnDzdx2eoVGdt+SqB5/B/a67w1gWDZf/LKp/84mBQ=;
        b=sxZqcLoO6FR2eLU78Urw/ADrBbn/UyFr/AzgIlX78w2AQlfcHSRMYuM7uVldLAnYXL
         rRWLxUIuypl0xa5iTjr5yIuSrPhSlfRl3BxGqLTxI9K5MxlxRBSEcwFfG0rlGf1yoPM3
         8AU+vueKm4mQ8HuppCG/HQWq0CQw7wJTkBYnZLXvg1+ZN6HASUwm6lPnt7Dfl3rdWwQ4
         ASm2k/Lw9VvwXOtmCzog0bOg5OMHei3HNTigdzdJzzY6/Jnvp7enxYl89n0mbKqse/6E
         ZBWJ0I/Y1CMa8+yi7TlWlqtE2tIi8SnomlXL1OzWa5j37+Q0r+vDgrRa0kB/mosH2ANs
         ZXIA==
X-Forwarded-Encrypted: i=1; AJvYcCUkaRNO8FzLnvZkQxTJKFyeO2vuLzzoFyFkvrVMhfkvjasWMQXGQTqWmIuHESyq+fBfNkNu05zI0Y4cgyFNKBe/i9svsPBqFiALoCL6
X-Gm-Message-State: AOJu0Yzka+OEsokAO0bcE6m+5L9K7Fm4MtsPvyHBL0sMRbNPu2/t51Ab
	NHu1AW8XXG3HoKAdlAmtwGSIAOYHvV/767OtFarfVUGgVqYP1VErwnjP2Q==
X-Google-Smtp-Source: AGHT+IFcPmiaqxUeM6ecOB7FlhpSq6a7w5AoF224U1Ll5V6tbIDfFQ/MFE1GDCDOXahUqCfjj9wrnw==
X-Received: by 2002:a05:6a00:1409:b0:712:7319:6f53 with SMTP id d2e1a72fcca58-713c5296aa8mr2150046b3a.30.1723794216617;
        Fri, 16 Aug 2024 00:43:36 -0700 (PDT)
Received: from carrot.. (i222-151-34-139.s42.a014.ap.plala.or.jp. [222.151.34.139])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7c6b61e7c7asm2365971a12.45.2024.08.16.00.43.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2024 00:43:35 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] nilfs2: improve kernel-doc comments for b-tree node helpers
Date: Fri, 16 Aug 2024 16:43:14 +0900
Message-Id: <20240816074319.3253-4-konishi.ryusuke@gmail.com>
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

Revise kernel-doc comments for helper functions related to changing the
search key for b-tree node blocks, and eliminate the following warnings
output by the kernel-doc script:

 fs/nilfs2/btnode.c:175: warning: Function parameter or struct member 'btnc'
  not described in 'nilfs_btnode_prepare_change_key'
 fs/nilfs2/btnode.c:175: warning: Function parameter or struct member 'ctxt'
  not described in 'nilfs_btnode_prepare_change_key'
 fs/nilfs2/btnode.c:238: warning: Function parameter or struct member 'btnc'
  not described in 'nilfs_btnode_commit_change_key'
 fs/nilfs2/btnode.c:238: warning: Function parameter or struct member 'ctxt'
  not described in 'nilfs_btnode_commit_change_key'
 fs/nilfs2/btnode.c:278: warning: Function parameter or struct member 'btnc'
  not described in 'nilfs_btnode_abort_change_key'
 fs/nilfs2/btnode.c:278: warning: Function parameter or struct member 'ctxt'
  not described in 'nilfs_btnode_abort_change_key'

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/btnode.c | 63 +++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 54 insertions(+), 9 deletions(-)

diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
index c034080c334b..57b4af5ad646 100644
--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -179,11 +179,32 @@ void nilfs_btnode_delete(struct buffer_head *bh)
 }
 
 /**
- * nilfs_btnode_prepare_change_key
- *  prepare to move contents of the block for old key to one of new key.
- *  the old buffer will not be removed, but might be reused for new buffer.
- *  it might return -ENOMEM because of memory allocation errors,
- *  and might return -EIO because of disk read errors.
+ * nilfs_btnode_prepare_change_key - prepare to change the search key of a
+ *                                   b-tree node block
+ * @btnc: page cache in which the b-tree node block is buffered
+ * @ctxt: structure for exchanging context information for key change
+ *
+ * nilfs_btnode_prepare_change_key() prepares to move the contents of the
+ * b-tree node block of the old key given in the "oldkey" member of @ctxt to
+ * the position of the new key given in the "newkey" member of @ctxt in the
+ * page cache @btnc.  Here, the key of the block is an index in units of
+ * blocks, and if the page and block sizes match, it matches the page index
+ * in the page cache.
+ *
+ * If the page size and block size match, this function attempts to move the
+ * entire folio, and in preparation for this, inserts the original folio into
+ * the new index of the cache.  If this insertion fails or if the page size
+ * and block size are different, it falls back to a copy preparation using
+ * nilfs_btnode_create_block(), inserts a new block at the position
+ * corresponding to "newkey", and stores the buffer head pointer in the
+ * "newbh" member of @ctxt.
+ *
+ * Note that the current implementation does not support folio sizes larger
+ * than the page size.
+ *
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EIO	- I/O error (metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_btnode_prepare_change_key(struct address_space *btnc,
 				    struct nilfs_btnode_chkey_ctxt *ctxt)
@@ -245,8 +266,21 @@ int nilfs_btnode_prepare_change_key(struct address_space *btnc,
 }
 
 /**
- * nilfs_btnode_commit_change_key
- *  commit the change_key operation prepared by prepare_change_key().
+ * nilfs_btnode_commit_change_key - commit the change of the search key of
+ *                                  a b-tree node block
+ * @btnc: page cache in which the b-tree node block is buffered
+ * @ctxt: structure for exchanging context information for key change
+ *
+ * nilfs_btnode_commit_change_key() executes the key change based on the
+ * context @ctxt prepared by nilfs_btnode_prepare_change_key().  If no valid
+ * block buffer is prepared in "newbh" of @ctxt (i.e., a full folio move),
+ * this function removes the folio from the old index and completes the move.
+ * Otherwise, it copies the block data and inherited flag states of "oldbh"
+ * to "newbh" and clears the "oldbh" from the cache.  In either case, the
+ * relocated buffer is marked as dirty.
+ *
+ * As with nilfs_btnode_prepare_change_key(), the current implementation does
+ * not support folio sizes larger than the page size.
  */
 void nilfs_btnode_commit_change_key(struct address_space *btnc,
 				    struct nilfs_btnode_chkey_ctxt *ctxt)
@@ -285,8 +319,19 @@ void nilfs_btnode_commit_change_key(struct address_space *btnc,
 }
 
 /**
- * nilfs_btnode_abort_change_key
- *  abort the change_key operation prepared by prepare_change_key().
+ * nilfs_btnode_abort_change_key - abort the change of the search key of a
+ *                                 b-tree node block
+ * @btnc: page cache in which the b-tree node block is buffered
+ * @ctxt: structure for exchanging context information for key change
+ *
+ * nilfs_btnode_abort_change_key() cancels the key change associated with the
+ * context @ctxt prepared via nilfs_btnode_prepare_change_key() and performs
+ * any necessary cleanup.  If no valid block buffer is prepared in "newbh" of
+ * @ctxt, this function removes the folio from the destination index and aborts
+ * the move.  Otherwise, it clears "newbh" from the cache.
+ *
+ * As with nilfs_btnode_prepare_change_key(), the current implementation does
+ * not support folio sizes larger than the page size.
  */
 void nilfs_btnode_abort_change_key(struct address_space *btnc,
 				   struct nilfs_btnode_chkey_ctxt *ctxt)
-- 
2.34.1

