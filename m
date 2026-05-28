Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787BF400E1E;
	Thu, 28 May 2026 17:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779989525; cv=none; b=N6pdQM2nLryjWdUdvpy8vPpyM60QUdUDKCOv2kcSvzrOwyLtPdNEvzjzQNli1pb37nMQTsFPlBQ/QkAPLuN0i8uSF17+fPo3f0EaW6V2aPUtWRiFv/Qq8TFKSpn6J4zpXBy9Va7BhmZo0WFAgZqe8nbiKugc7bPEv/+ui5R9PNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779989525; c=relaxed/simple;
	bh=OHjokb/c6gjpSrGSG3dtxQ77F2kAIT8pa0Wh0Utp/rA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CxNi3MF9iNPoxLMwxU22Zqh/drVF6dYKrZQ3C6TJQo9SZwrnpXPwdZvuljV2rNyxMSJ8VPcxo+V7RaHhXY3MlBtDabKQnF41XM8Chhmz3YyML3j/JrzdmiTwznkpYC64o+btO2rXkZV4/HfrJw6e31v7W9CbfNwln8uqgSR5j8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SU1CecUG; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SU1CecUG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=KXFbcSbgnMghTDGAHJa+f87pRV3vkEI2ij7TKdp7UUI=; b=SU1CecUGS2reQ8qqq0AALuu7/T
	jGTDuIKhuQ+5UOpXwOjOOtbpO4sVEhrxhlKZ83lrFdOajZbaiizIT342PSNaCenSkr/0mKs0bjurK
	zWWWoO2jxtTAXw77REEcmP0trKV+TkY448EpYTfW8QCyxA/CdSvQu7ja5+tdHwqKScq5Kr49AH2O9
	QzrRt0z0ptHIZc8jsp2EF5gG1l+aufTsBhRJcPKf4Nv62XPgBX669JMQnsWfMLiCbQoh76qo2G7v3
	EmEUddH8SpZozVZeDHtmOKm0DwiiC1G407QIvdHBtAbqumMyGi1c1X6Huh+CfC1oodg0sJSGQAVC0
	/s7+8jIw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSeaL-00000004abD-3SvO;
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
Subject: [PATCH v2 28/34] nilfs2: Convert nilfs_gccache_submit_read_data to bh_submit()
Date: Thu, 28 May 2026 18:31:41 +0100
Message-ID: <20260528173150.1093780-29-willy@infradead.org>
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
 fs/nilfs2/gcinode.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/nilfs2/gcinode.c b/fs/nilfs2/gcinode.c
index 62d4c1b787e9..85379ac23ae2 100644
--- a/fs/nilfs2/gcinode.c
+++ b/fs/nilfs2/gcinode.c
@@ -83,9 +83,7 @@ int nilfs_gccache_submit_read_data(struct inode *inode, sector_t blkoff,
 	if (!buffer_mapped(bh))
 		set_buffer_mapped(bh);
 	bh->b_blocknr = pbn;
-	bh->b_end_io = end_buffer_read_sync;
-	get_bh(bh);
-	submit_bh(REQ_OP_READ, bh);
+	bh_submit(bh, REQ_OP_READ, bh_end_read);
 	if (vbn)
 		bh->b_blocknr = vbn;
  out:
-- 
2.47.3

