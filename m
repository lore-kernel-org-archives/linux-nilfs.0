From: Sumanth Korikkar <sumanthk@linux.ibm.com>
Subject: Re: [PATCH 06/10] hugetlbfs: Convert
 remove_inode_hugepages() to use filemap_get_folios()
Date: Mon, 13 Jun 2022 08:56:22 +0200
Message-ID: <YqbflvrB9oEZ1whX@localhost.localdomain>
References: <20220605193854.2371230-7-willy@infradead.org>
 <20220610155205.3111213-1-sumanthk@linux.ibm.com>
 <YqO08Dsq8ZcAcWDQ@casper.infradead.org>
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
 bh=sg4r/3HlNtUZCzfEQKxVVhzIMzc01uTkxBUOjFJpuKA=; b=jVF6fGM8lE89F9x1CwR2bomNbO
 6rbhfOQiTQ08WOxoWBmHnARLM4qsBkvVfFthc7GKQ+H7R/NfFHsmtfjvcf4ETc6XrwmJlOLM723Q1
 cOtu911R8dpxjn9KP4osC1qe/KdvpYZaT5GQhKHIqZ+x8R/po8ZtCdF3wZJxwbLCrCHk=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To
 :From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=sg4r/3HlNtUZCzfEQKxVVhzIMzc01uTkxBUOjFJpuKA=; b=CMtiGuSNyJF5eehOXxCsgacwGH
 O2jxaenWICV/927tK5c/+6iXEh9ZMFRXXvRJDceJ+7/5lHdf/kv3iQA4bflSQgN2l68rTluDubUdL
 jC2aogwzbimCNpjyqk/hTKE4cYyeYhp4AhzANp25MerTeCGcvlT9JbfWCZj9Ug3raESY=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com;
 h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=sg4r/3HlNtUZCzfEQKxVVhzIMzc01uTkxBUOjFJpuKA=;
 b=NTLr3Rw9NouBrw7ClKulUEjebkO6A5itEqempmqPPPMIe5WxzTU1RSeuSNqgfcQn+Qel
 mpyWvvRoLkX7BBylqpkYunkyAsl/lIGSSHiWYnubBtx0gSiorItaeUnSnErhVKh1TYVb
 G6DM9VtcvymwPUdxADeoOwB370fMvCzk3ag/yA/bfNUIAGHLBm5gy/BIuEuLSd+rfBFo
 ScYM+CzYJZsSDOfTyT1jJMuHuhBoFfgAdXkwemiKCqxo5iqi4dpnLscBe+et+zL7PfDK
 I9Adon6TD+u/6m2HYQfxfvzeSbDXAYku8Dd0+d8W7hGVcYHuGVi7UIhMuQ6Gzx7IjLiC uQ== 
Content-Disposition: inline
In-Reply-To: <YqO08Dsq8ZcAcWDQ@casper.infradead.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-nilfs@vger.kernel.org, gor@linux.ibm.com, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, gerald.schaefer@linux.ibm.com, linux-ext4@vger.kernel.org, agordeev@linux.ibm.com

On Fri, Jun 10, 2022 at 10:17:36PM +0100, Matthew Wilcox wrote:
> On Fri, Jun 10, 2022 at 05:52:05PM +0200, Sumanth Korikkar wrote:
> > To reproduce:
> > * clone libhugetlbfs:
> > * Execute, PATH=$PATH:"obj64/" LD_LIBRARY_PATH=../obj64/ alloc-instantiate-race shared
> 
> ... it's a lot harder to set up hugetlb than that ...
> 
> anyway, i figured it out without being able to run the reproducer.
> 
> Can you try this?
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index a30587f2e598..8ef861297ffb 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2160,7 +2160,11 @@ unsigned filemap_get_folios(struct address_space *mapping, pgoff_t *start,
>  		if (xa_is_value(folio))
>  			continue;
>  		if (!folio_batch_add(fbatch, folio)) {
> -			*start = folio->index + folio_nr_pages(folio);
> +			unsigned long nr = folio_nr_pages(folio);
> +
> +			if (folio_test_hugetlb(folio))
> +				nr = 1;
> +			*start = folio->index + nr;
>  			goto out;
>  		}
>  	}

Yes, With the patch, The above tests works fine. 

--
Thanks,
Sumanth
