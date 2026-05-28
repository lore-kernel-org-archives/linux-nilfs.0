Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893143FCB18;
	Thu, 28 May 2026 17:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779989522; cv=none; b=SKVfOpffOV/q7HQS//rzzICKqRmUwl5npVyWUXoAPKJkSHq/7MhxM5/UPbp4gf5uOpDsW271Qx719iLuGTGiCMy0zk67+IQTYZkjcTp8hfg9jNl/xlUsXeS/2zAenuPpa60+M4VALVXAIKL0TwuI8Bjy0FOPjAQbaAwpS8XCFdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779989522; c=relaxed/simple;
	bh=vP9EwVWYIIuzs+NH3xEx56Xey2XTjeGC7zdy4g9qwuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pazFv4JIv3TTeV7hqGKcHu5bf1tcMdMnJM/kg+fjQQsWPV3vGLehToamQLiO8VZUbfpb9jotPZ/zsAEhXcb9Z4oc0VWMRc/UZKmW+8oJvqvkalvZ0lLh0JW2PsgAdTmDDxvSeo+XIDzZlW8sM8GX5g7Af8A3UjbINswVuECVzvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RaND+TWS; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RaND+TWS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=aPMpsWOmgYhe9pRTVRWu4HfthKlhC1ELfG/XYmmYxKE=; b=RaND+TWSEyTuVATQc8S2CZZ5qi
	iAAf/bg7kc4SvFIpc4OBAQDeC5sFfR/fXXvixggyfaeqVdsK3sZHF0ruQq64tVFY+skE6mfhAHHbK
	fTwcKwHDK4wgBbqmu15a4/+An8IJGFHwMTr7Q+1sKdXYXFXi/8Iwk3wdTAhQr0Nk0jK1x4C4vCi6p
	k+5eR9bUXirj6jxMX4gW/FPaxKjXh81qGoEQSMdOZgI5KqESzVkewZfWzsXgI+dV0eKX9/u9NpF6t
	TOmUaJREAMeG4k+d25Xm/AnCGURzS8ARI6JQrdIvX4/wh4X8VQJojl/2PFq2kgJh3SOsx4KZliDVp
	xNvRbvyA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSeaL-00000004ab5-2XjC;
	Thu, 28 May 2026 17:31:57 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	linux-nilfs@vger.kernel.org
Subject: [PATCH v2 27/34] nilfs2: Convert nilfs_btnode_submit_block to bh_submit()
Date: Thu, 28 May 2026 18:31:40 +0100
Message-ID: <20260528173150.1093780-28-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528173150.1093780-1-willy@infradead.org>
References: <20260528173150.1093780-1-willy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Avoid an extra indirect function call and changing the buffer refcount
by using bh_submit() instead of submit_bh().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: linux-nilfs@vger.kernel.org
---
 fs/nilfs2/btnode.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
index 2e553d698d0f..680e4009a30d 100644
--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -134,9 +134,7 @@ int nilfs_btnode_submit_block(struct address_space *btnc, __u64 blocknr,
 	}
 	set_buffer_mapped(bh);
 	bh->b_blocknr = pblocknr; /* set block address for read */
-	bh->b_end_io = end_buffer_read_sync;
-	get_bh(bh);
-	submit_bh(opf, bh);
+	bh_submit(bh, opf, bh_end_read);
 	bh->b_blocknr = blocknr; /* set back to the given block address */
 	*submit_ptr = pblocknr;
 	err = 0;
-- 
2.47.3

