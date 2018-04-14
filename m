From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v11 36/63] shmem: Convert shmem_confirm_swap to
 XArray
Date: Sat, 14 Apr 2018 07:12:49 -0700
Message-ID: <20180414141316.7167-37-willy@infradead.org>
References: <20180414141316.7167-1-willy@infradead.org>
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
 bh=8l3beMAsjLYABdZ9B8801cxeVmbjtSS6inrc+sVBqC4=; b=jafIQrC2sspETu8EIZjfZkqWHh
 wpRy96hyKXvtBzI/W3wA2fkgrXSWuPRSG+tzcaMm3jZLSb70jEsxx/++XcHHhiy6VXBPjU+j2I55Z
 Iiku/NHAFFXwf4So2LFeEYX1y1E77VjfaEU3QfFdX6cHpMOAxhZMxP5QJS6UnhKwAJRY=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=8l3beMAsjLYABdZ9B8801cxeVmbjtSS6inrc+sVBqC4=; b=QCc4fiuRIqpyMZjHTE+uW8OLVC
 rQBSWTGqlYvnRikmq22O1ZmwrBC4MLxmbMQDTjRFi1ViPFaFRFFnbB4K6BBMU2LgwfcC4nyyGz3Nb
 FVFurPfZDzePLwV/fsOUN/RGSeAv5qEFhdBXtaXWakWWmcbr7SJog9gakDHHU72M8cpg=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=8l3beMAsjLYABdZ9B8801cxeVmbjtSS6inrc+sVBqC4=; b=kH6WIsAuGvNqODeS3K159Dg10
 C3VwsXNnCQxCQC4Sobli4NuR6ZqXMyI0EjVlQnuX7z6a6T5dR5tzLGPB2tvL4+Urh6Sf7DMza/K05
 e+izKfBe4AqS9hhXRH+t4iPf9i5TXcrt83ow19cbMSyKUHAxvUX0DwqF025r9/ezsUM2A9ORcZRES
 xEB+TdJyTo9NlBRoIfm/fBhaCotu2fHyn/Flwf58QuiWmuzuLinbo5lgfLme3mwDFAq2fZcHu0llm
 np0VsTWb0YxBDsOM9vMd8adkuV4RyNWEJcdadHdGt256aTHGx3YgAmgbd4YVjPUIQZ8hRcR5brTZa
 x8tCdOpsw==;
In-Reply-To: <20180414141316.7167-1-willy@infradead.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Cc: linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, James Simmons <jsimmons@infradead.org>, Jaegeuk Kim <jaegeuk@kernel.org>, Andreas Dilger <andreas.dilger@intel.com>, Nicholas Piggin <npiggin@gmail.com>, linux-f2fs-devel@lists.sourceforge.net, Oleg Drokin <oleg.drokin@intel.com>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>, Mike Kravetz <mike.kravetz@oracle.com>

From: Matthew Wilcox <mawilcox@microsoft.com>

xa_load has its own RCU locking, so we can eliminate it here.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/shmem.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index b538cd71f772..5b8a2d944a0c 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -348,12 +348,7 @@ static int shmem_xa_replace(struct address_space *mapping,
 static bool shmem_confirm_swap(struct address_space *mapping,
 			       pgoff_t index, swp_entry_t swap)
 {
-	void *item;
-
-	rcu_read_lock();
-	item = radix_tree_lookup(&mapping->i_pages, index);
-	rcu_read_unlock();
-	return item == swp_to_radix_entry(swap);
+	return xa_load(&mapping->i_pages, index) == swp_to_radix_entry(swap);
 }
 
 /*
-- 
2.17.0


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
