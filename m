Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36EC3F7AAB;
	Mon, 25 May 2026 17:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779729589; cv=none; b=SJebE13/7Gu8NmbLlIYgKu1hnwCDefNkkdBDyJbSGQJp81Sc4S75subfHliM833QTw+xw9JuGlJVdaTwg0AHu/pXs0SgohbTkCruUS70k3L6fjwNQ/Mt6HRAr6hFi8rDORTYqEp44T1D3gNeCbWqSIvGHzfhQGHbCquvqtW/AKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779729589; c=relaxed/simple;
	bh=FbKUnFmDLbpGYgPKUj70kKk7vCZv8rSkLK2Uy/TW/kQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PD6vj+BPugy+017yE3vNN3Dao/4b8I6iasKNcrcqO0JA5liC7dgKBeqycOk2BXfa4AX/x5Vg2LnE8b7DBdn+32UJe7vDFBVLlGzOqJEP30FQUnnRhjxbJV/Uz2fQ3mZgODqIQ1nCr9X2XkXDA4jPZ4lj6ZXg7HwnSBnk1VhVfHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ul0I+RrQ; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ul0I+RrQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=AEnuyBNBfASXDvhXIrlDm93v7rbW9fNZ6/eavru0o+o=; b=ul0I+RrQ8mZj0tMDd8fOmOvZCQ
	lfhNZsPmM2fprfwhAIXuRgCfw91VN7R3HIkddAscfNIJVHLKCkM3qJbPhOBnCqXP+yKJIe+j+5foU
	G+WRcrjBechWuDXSCDrrF2Wbr7zhiWebZmxYeTrTaQVzFpkcOIg5aG61WcOIS3enidLBemEJGkShO
	OcQQqRNX7a5L6GMROONgLbKRTP/gQ1w4VDiqtpO1mCU2N4bMD9sxf2n6kRADqJhnjd0iEkcAmOdhU
	OgSB5YDRa8DecRVZh5YigmikxZkwa47KO3F8tovxa38O8eJ3xcoxaY+ParIfjRIghG8U7jWpD3Anj
	/u4h++tg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRYxt-0000000HOCv-06xN;
	Mon, 25 May 2026 17:19:45 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org,
	linux-nilfs@vger.kernel.org
Subject: [PATCH 27/34] nilfs2: Convert nilfs_btnode_submit_block to bh_submit()
Date: Mon, 25 May 2026 18:19:20 +0100
Message-ID: <20260525171931.4144395-28-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260525171931.4144395-1-willy@infradead.org>
References: <20260525171931.4144395-1-willy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Avoid an extra indirect function call by using bh_submit() instead of
submit_bh().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: linux-nilfs@vger.kernel.org
---
 fs/nilfs2/btnode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
index 2e553d698d0f..0a4b61498eff 100644
--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -134,9 +134,8 @@ int nilfs_btnode_submit_block(struct address_space *btnc, __u64 blocknr,
 	}
 	set_buffer_mapped(bh);
 	bh->b_blocknr = pblocknr; /* set block address for read */
-	bh->b_end_io = end_buffer_read_sync;
 	get_bh(bh);
-	submit_bh(opf, bh);
+	bh_submit(bh, opf, bh_end_read);
 	bh->b_blocknr = blocknr; /* set back to the given block address */
 	*submit_ptr = pblocknr;
 	err = 0;
-- 
2.47.3

