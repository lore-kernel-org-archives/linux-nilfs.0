From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v5 19/78] xarray: Add xas_create_range
Date: Fri, 15 Dec 2017 14:03:51 -0800
Message-ID: <20171215220450.7899-20-willy@infradead.org>
References: <20171215220450.7899-1-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:
 To:From:Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=VsNQh1fdv8Focxwh2MU+9hBSKnRZnr4VFPK+a5By27U=; b=LUltApZq/5vislDcUJmJCRC8jj
 OIBFL70hglt7dZMFxwJarlCM8QUJ43RO+77GeMKMFmH+aIgMHlEWsuzEsCP34ph1DhoEoY+5V/vvg
 K+M9Ko4tjCYAO/+aimev+uJQ0kSuN96zBZu3aqtMcHCi5BLo/opYhErly7feicLbJk+o=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=VsNQh1fdv8Focxwh2MU+9hBSKnRZnr4VFPK+a5By27U=; b=B2bERL4yvOwQGiuJCStfBj/+It
 3JVFGT0QFs1N9uDQy4DoRchLpTfUZObLjcPLwDVLV3oO404SxuPV1sisR1JYdyjE5Pr0BRwEaYxek
 fAeNIgs0N2omol44y6x9OfCexWnZmzRlDsfQnoOvm2tIsCOBaU6hJxe4iZRJgA6m+8ZY=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=VsNQh1fdv8Focxwh2MU+9hBSKnRZnr4VFPK+a5By27U=; b=G6ld/bF56TIvV1hoh+dXoY6ZO
 nUG3TdyV6Xs/LyPJt2avcmOacbqOZtbkHhCzsnd4QJRblb3RWYVkKyqz/2PouZLht9e5wI+v35hNi
 PkgpsWZeY4XQvsYFlhS3aLfjViv0BvB2oQRNF6Ji2yWPSCuHAvkQRk/hpijSIfWRHR1Z9/BAhpEfa
 QYh/DJJvV7/LQ+6b30CYINFzIVQvhXsGf7n8DE73rWQLDHdrLgU6+uKUfEbYvAyxb7Jj44Ffe6+WB
 d+hsek4zu+oR4w4Ijj/gztvpob3epS7OCRw0uA5ifV0IehDZldQ/FZsVCEEJOJW3sxhYK+Dc/oyci
 Bt9+BZO1A==;
In-Reply-To: <20171215220450.7899-1-willy@infradead.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, linux-xfs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-raid@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, Marc Zyngier <marc.zyngier@arm.com>, linux-usb@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, David Howells <dhowells@redhat.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Rehas Sachdeva <aquannie@gmail.com>, Shaohua Li <shli@kernel.org>, linux-btrfs@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

This hopefully temporary function is useful for users who have not yet
been converted to multi-index entries.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 include/linux/xarray.h |  2 ++
 lib/xarray.c           | 22 ++++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/include/linux/xarray.h b/include/linux/xarray.h
index 2d889208b68d..bcc321fb280f 100644
--- a/include/linux/xarray.h
+++ b/include/linux/xarray.h
@@ -685,6 +685,8 @@ void xas_init_tags(const struct xa_state *);
 bool xas_nomem(struct xa_state *, gfp_t);
 void xas_pause(struct xa_state *);
 
+void xas_create_range(struct xa_state *, unsigned long max);
+
 /**
  * xas_reload() - Refetch an entry from the xarray.
  * @xas: XArray operation state.
diff --git a/lib/xarray.c b/lib/xarray.c
index a4975aeedf6b..e3be7c0c2e35 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -605,6 +605,28 @@ void *xas_create(struct xa_state *xas)
 }
 EXPORT_SYMBOL_GPL(xas_create);
 
+/**
+ * xas_create_range() - Ensure that stores to this range will succeed
+ * @xas: XArray operation state.
+ * @max: The highest index to create a slot for.
+ *
+ * Creates all of the slots in the range between the current position of
+ * @xas and @max.  This is for the benefit of users who have not yet been
+ * converted to multi-index entries.
+ *
+ * The implementation is naive.
+ */
+void xas_create_range(struct xa_state *xas, unsigned long max)
+{
+	XA_STATE(tmp, xas->xa, xas->xa_index);
+
+	do {
+		xas_create(&tmp);
+		xas_set(&tmp, tmp.xa_index + XA_CHUNK_SIZE);
+	} while (tmp.xa_index < max);
+}
+EXPORT_SYMBOL_GPL(xas_create_range);
+
 static void store_siblings(struct xa_state *xas,
 				void *entry, int *countp, int *valuesp)
 {
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
