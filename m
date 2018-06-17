From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v14 40/74] mm: Convert __do_page_cache_readahead
 to XArray
Date: Sat, 16 Jun 2018 19:00:18 -0700
Message-ID: <20180617020052.4759-41-willy@infradead.org>
References: <20180617020052.4759-1-willy@infradead.org>
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
 bh=PPn74mhV70oPoatuIlaMZkLUpkiAiM3ua7sFtxxKpV4=; b=PvDAHwkKjGUDWTmgZZQaW0qyIC
 kBxV+08SQwnN0jalI43VGiI25iaVN2oQJR6J2KjU/sFk8WLMezxJUXTgPa7r//nZRVqVKHW1kqaGN
 lAQZUTkw/2o6DydkWZxphB+EB7Bn2ONrDdiEuBhAQgI18U6X60TWGwmRFCS4RJKvtNRE=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=PPn74mhV70oPoatuIlaMZkLUpkiAiM3ua7sFtxxKpV4=; b=YR6WZwDYLHKQkDEMIhiThzzeA1
 3PaNh5jimZdK4jUPjhIaMqeTk/Pz96jQ6QxrRe3VHT/Jiloa/Qv17Yaxlamk9lSzAXmkFZLT4bSWS
 IqLWgECKZr/B8k/yR9o4Bi7Q4vtGIZ72yq82I/kRK5Nc5Nxafls38sP2Ekczz+tm7cKQ=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=PPn74mhV70oPoatuIlaMZkLUpkiAiM3ua7sFtxxKpV4=; b=dc1EhxasV30JXYH6J85PDGaDH
 yCaqwipkdMFlNT/3Tnp+fNPSDZiyExxP1AGtAfrzHOSAXJreM1wwqqURgoX5jrrbsddaa6CyGqALM
 R3jb9jNSN1qpNgofiLNxYBvtehy4KztaHopCzT0f3r+HUlHmV0jFh9K0nyXg7NWoV5K40QNQk2yNZ
 go3lHdPkhhGNmYi5pNW74Ni6xtsqGazE2tQsN52wJpedf2PPMbCBEykr9ghnuunYRqjxP8aCvgspB
 RzNKpohRKVwmiL9lztrlmtJnWY1W7iUfuNoXqCCeOmZA5oxBwZXA8FLd/5QyxyzxZ2wx8T+gm75Sf
 yPEmokAqA==;
In-Reply-To: <20180617020052.4759-1-willy@infradead.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Matthew Wilcox <willy@infradead.org>, linux-f2fs-devel@lists.sourceforge.net, Nicholas Piggin <npiggin@gmail.com>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>

This one is trivial.

Signed-off-by: Matthew Wilcox <willy@infradead.org>
---
 mm/readahead.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index 59998ca31f2a..07f9734dc79f 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -174,9 +174,7 @@ unsigned int __do_page_cache_readahead(struct address_space *mapping,
 		if (page_offset > end_index)
 			break;
 
-		rcu_read_lock();
-		page = radix_tree_lookup(&mapping->i_pages, page_offset);
-		rcu_read_unlock();
+		page = xa_load(&mapping->i_pages, page_offset);
 		if (page && !xa_is_value(page)) {
 			/*
 			 * Page already present?  Kick off the current batch of
-- 
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
