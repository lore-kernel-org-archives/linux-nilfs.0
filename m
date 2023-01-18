From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 8/9] btrfs: handle a NULL folio in
 extent_range_redirty_for_io
Date: Wed, 18 Jan 2023 10:43:28 +0100
Message-ID: <20230118094329.9553-9-hch@lst.de>
References: <20230118094329.9553-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cluster-devel-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1674035082;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ewY31mbHxOfBtCPdgdKzYjQ0wPkqac5AmSjDkb40tFw=;
	b=SJ/dqckx6OAh048oUTAM7+JFXz9jqPF0H56MuIr37nBkAbGhqUMM9xSABBlxd9hYHxfqEV
	anE3/6b31FDszsnXvlWBUZfmOq40nQ6eJwor/rB/e9X7XMDZk3UUWd+hTramgIYgPDKOnh
	Dz2iUWiuV8QJGUfZzVtKMk5NEUuMNYc=
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

filemap_get_folio can return NULL, skip those cases.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/btrfs/extent_io.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d55e4531ffd212..a54d2cf74ba020 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -230,6 +230,8 @@ void extent_range_redirty_for_io(struct inode *inode, u64 start, u64 end)
 
 	while (index <= end_index) {
 		folio = filemap_get_folio(mapping, index);
+		if (!folio)
+			continue;
 		filemap_dirty_folio(mapping, folio);
 		folio_account_redirty(folio);
 		index += folio_nr_pages(folio);
-- 
2.39.0

