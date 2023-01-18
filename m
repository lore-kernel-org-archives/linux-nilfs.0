From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 7/9] gfs2: handle a NULL folio in
 gfs2_jhead_process_page
Date: Wed, 18 Jan 2023 10:43:27 +0100
Message-ID: <20230118094329.9553-8-hch@lst.de>
References: <20230118094329.9553-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cluster-devel-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1674035067;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=4WwjtPTvg3dbfLBE9vX5iRJAtphGCEZEkdJLVGyAJuo=;
	b=Vmh8Ita+QU457lWQb7uvaxjzP/1kxpVRB06jqqoqdAmgV+pmgEI35pxlOQZ/v4HqZle4ws
	DyACxXPwoNPIjDpHJ1ih9VCKak6vijpEXtL2qZ7BVYBR1FMm/AANwxv9jUirePrJNoNIRe
	nlkaIAxLfQ+2yAufXMShulz7PeSjoRY=
In-Reply-To: <20230118094329.9553-1-hch@lst.de>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/cluster-devel>, 
 <mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/cluster-devel/>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/cluster-devel>,
 <mailto:cluster-devel-request@redhat.com?subject=subscribe>
Errors-To: cluster-devel-bounces@redhat.com
Sender: "Cluster-devel" <cluster-devel-bounces@redhat.com>
Content-Type: text/plain; charset="us-ascii"; x-default="true"
To: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>
Cc: linux-xfs@vger.kernel.org, linux-nilfs@vger.kernel.org, cluster-devel@redhat.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org

filemap_get_folio can return NULL, so exit early for that case.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/gfs2/lops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 1902413d5d123e..51d4b610127cdb 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -472,6 +472,8 @@ static void gfs2_jhead_process_page(struct gfs2_jdesc *jd, unsigned long index,
 	struct folio *folio;
 
 	folio = filemap_get_folio(jd->jd_inode->i_mapping, index);
+	if (!folio)
+		return;
 
 	folio_wait_locked(folio);
 	if (folio_test_error(folio))
-- 
2.39.0

