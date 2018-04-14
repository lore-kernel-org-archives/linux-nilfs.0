From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v11 22/63] page cache: Remove stray radix comment
Date: Sat, 14 Apr 2018 07:12:35 -0700
Message-ID: <20180414141316.7167-23-willy@infradead.org>
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
 bh=EVeiB5+XPcbAUBKqzm51rCb/b4uGv4ov6b5nMhHHBTM=; b=UPlz3+mcvdSJ3odUegMS92wCf6
 EyJ3mi6sAi+LV5K+fum8+9w9A+bwxWL9u+jYUBX9MUQZY2sLGur2U+qhMQmE/GQR3FrH5srasLaef
 /lSp2Wsjri+6Xa6E+ltoXMr42so4xbfqmbWS4/aPTFrgKKwoY00U9c9M5OJZZfuqhnS4=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=EVeiB5+XPcbAUBKqzm51rCb/b4uGv4ov6b5nMhHHBTM=; b=M2gbfnUSxYXJkCUTuliWF+V01X
 PuvmUzviIFOz8lDT0HGHxLcRyfueqeD9/4P74VwvHWh+YpBLIkWO0Zin5Nd4rPWPao25tM7HYswKz
 iytKy1vV1KUExs2iUg5g/wuuSI0qI10bYpbiV4ZuZD9L+3KyFEV1qqZz6MkpwI9bR0bc=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=EVeiB5+XPcbAUBKqzm51rCb/b4uGv4ov6b5nMhHHBTM=; b=llcDvmsVQLRGatDFGNGwplFAm
 0C3vzwOZaadrXWtW8TCyE3qJT3RgFjV4DGMDtbgHLUUhz8NO8Tj79kYguw6wcjy2W0l4Gj5bLV0Lh
 0oinRTDQv3++SJao+pe4I7PWtue9hXGi8QliBaSYDhNsWJQiFo1k9g8DHJZmGbUocnsZ0vRtDv0Yn
 7PpfnyhWYZBnxir6CXxZUq4Q/XH7HQxI7KM1ZbQ7j7ziFoIj7nNWlEWS8PUJm0qtlF96BpA2Oq5eR
 VwARR9npQDLvLq61+lgWIpqvYTW390l+PtjkMR01aTpGb+AbnltfTvBLOIMEN7HPfFDZZpd09a4vN
 4smtAzjow==;
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

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/filemap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index f85cdda6744f..bf231ebadb86 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2583,7 +2583,7 @@ static struct page *do_read_cache_page(struct address_space *mapping,
 			put_page(page);
 			if (err == -EEXIST)
 				goto repeat;
-			/* Presumably ENOMEM for radix tree node */
+			/* Presumably ENOMEM for xarray node */
 			return ERR_PTR(err);
 		}
 
-- 
2.17.0


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
