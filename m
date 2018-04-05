From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v10 00/62] Convert page cache to XArray
Date: Wed, 4 Apr 2018 20:52:00 -0700
Message-ID: <20180405035200.GE9301@bombadil.infradead.org>
References: <20180330034245.10462-1-willy@infradead.org>
 <ff6a317f-920b-62c7-9a7a-9bf235371d41@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:
 Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=7CFwtTndwa6sIw7bZexW6UUaaOXWcsHJZSsiM2kz8BM=; b=fq6XEa/DDbvmcK2aREupY73VwT
 Lm/1uiix+bMoBu31pXoJeqouI0tOc17h9nAUky0BPcTjh2/f+5Z0wljxNUMHGkktE+JaAjFuRJMuW
 O6ySSYJb6TEdWgFZaKg+/naDA8lo/zvVOb1LqDgcIX1MwCWCzS1n7I8zji4s+olJuK8g=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To
 :From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=7CFwtTndwa6sIw7bZexW6UUaaOXWcsHJZSsiM2kz8BM=; b=FDfzgj1mTQa5ASjGswk9o8K+5h
 +UFYffyAGonbSsZRWviayNc+16BRKOcGBGGzQ0oXwuBiM8i3WZSnPoAi4d5wnAQXAE0J4n6lVZRU3
 HRq3jBL83s+cfYbpMHYtMEliDc+a4IbU/O1r8Pbt5SN3oQOBSdBV+qgJMjrTeAqy+oUs=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=7CFwtTndwa6sIw7bZexW6UUaaOXWcsHJZSsiM2kz8BM=; b=X19KgfzTLMq4fYhCpdANnkM/o
 P7Ugg+kzf6DDlgUqhu3VKXFdYGuzi22ZNCrGLfgDBoSwZ3NKWevUl/L+y/0XLkb7ib4+sZwmR5S+J
 PqS6m7/wWE/i8S1onEYY8y17wNbquQiOafcmieBGTHh7ROQYe2Z5jaMWfoVdd58BIdBy8f0LqiPfq
 M9xtlgPvxNJ/HQa7Y1PRM7IUf33Y1WzIwZwYih2wtd52ytAd1bSXqa7eL3nls47Yi/YfjQKdpN/Hg
 x6fLsTDUnGVHXsX86UYXheOumfE5yduWIGbNe03cwEubzYlt4g/Bno+PipnI9d9uQcT7L+xasJEtI
 g7899L04g==;
Content-Disposition: inline
In-Reply-To: <ff6a317f-920b-62c7-9a7a-9bf235371d41@oracle.com>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Mike Kravetz <mike.kravetz@oracle.com>
Cc: linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, James Simmons <jsimmons@infradead.org>, Jaegeuk Kim <jaegeuk@kernel.org>, Andreas Dilger <andreas.dilger@intel.com>, Nicholas Piggin <npiggin@gmail.com>, linux-f2fs-devel@lists.sourceforge.net, Oleg Drokin <oleg.drokin@intel.com>, linux-mm@kvack.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-fsdevel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>

On Wed, Apr 04, 2018 at 09:35:46AM -0700, Mike Kravetz wrote:
> Running with this XArray series on top of next-20180329 consistently 'hangs'
> on shutdown looping (?forever?) in tag_pages_for_writeback/xas_for_each_tag.
> All I have to do is make sure there is some activity on the ext4 fs before
> shutdown.  Not sure if this is a 'next-20180329' issue or XArray issue.
> But the fact that we are looping in xas_for_each_tag looks suspicious.

Thanks for your help debugging this!  Particularly collecting the xa_dump.
I got bit by the undefined behaviour of shifting by BITS_PER_LONG,
but of course it was subtle.

The userspace testing framework wasn't catching this for a couple of
reasons; I'll work on making sure it catches this kind of thing in
the future.

I'll fold this in and post a v11 later this week or early next week.

diff --git a/include/linux/xarray.h b/include/linux/xarray.h
index eac04922eba2..f5b7e507a86f 100644
--- a/include/linux/xarray.h
+++ b/include/linux/xarray.h
@@ -904,9 +929,12 @@ static inline unsigned int xas_find_chunk(struct xa_state *xas, bool advance,
 	if (advance)
 		offset++;
 	if (XA_CHUNK_SIZE == BITS_PER_LONG) {
-		unsigned long data = *addr & (~0UL << offset);
-		if (data)
-			return __ffs(data);
+		if (offset < XA_CHUNK_SIZE) {
+			unsigned long data = *addr & (~0UL << offset);
+
+			if (data)
+				return __ffs(data);
+		}
 		return XA_CHUNK_SIZE;
 	}
 

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
