From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 06/10] hugetlbfs: Convert remove_inode_hugepages() to use
 filemap_get_folios()
Date: Fri, 10 Jun 2022 22:17:36 +0100
Message-ID: <YqO08Dsq8ZcAcWDQ@casper.infradead.org>
References: <20220605193854.2371230-7-willy@infradead.org>
 <20220610155205.3111213-1-sumanthk@linux.ibm.com>
Mime-Version: 1.0
Return-path: <linux-ext4-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=dPCOWM5CyDEIdIuBSxjePp4f8SSu/SKCJnmsXTUdDp0=; b=H/uguj+Wl5DQo9Vix4WTb9P9Qz
        L3+C24pFO0kvbIu1KKcP4oVLAW0MPkjH36cSK+5oKXA61lH8Ik4WuTBYal6HxocDDl+IvIKG4CCwL
        qMYlFEtD8mXy6yOt5Sgb3+UVlhpMqyWoPpvjDn3H3qAjkbV7cG6coeM3c8vmcNboFD8Xoap0GQfCH
        198oRccDnDnojUeQZLgFD8CTZuFsqMSEqnlQmY48fZ9D/l9Bs8bop7G9eLDZqxL2TbtpRPL1eiwtg
        Fc6e9lthrSLvnei2DS7h37o1aENF/y3X0CXCwJvu6vkLxR7ewRCMntvOhjp1rS4ybHxIfs6En+aMm
        PTXk3bZQ==;
Content-Disposition: inline
In-Reply-To: <20220610155205.3111213-1-sumanthk@linux.ibm.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc: linux-ext4@vger.kernel.org, gerald.schaefer@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-nilfs@vger.kernel.org

On Fri, Jun 10, 2022 at 05:52:05PM +0200, Sumanth Korikkar wrote:
> To reproduce:
> * clone libhugetlbfs:
> * Execute, PATH=$PATH:"obj64/" LD_LIBRARY_PATH=../obj64/ alloc-instantiate-race shared

... it's a lot harder to set up hugetlb than that ...

anyway, i figured it out without being able to run the reproducer.

Can you try this?

diff --git a/mm/filemap.c b/mm/filemap.c
index a30587f2e598..8ef861297ffb 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2160,7 +2160,11 @@ unsigned filemap_get_folios(struct address_space *mapping, pgoff_t *start,
 		if (xa_is_value(folio))
 			continue;
 		if (!folio_batch_add(fbatch, folio)) {
-			*start = folio->index + folio_nr_pages(folio);
+			unsigned long nr = folio_nr_pages(folio);
+
+			if (folio_test_hugetlb(folio))
+				nr = 1;
+			*start = folio->index + nr;
 			goto out;
 		}
 	}
