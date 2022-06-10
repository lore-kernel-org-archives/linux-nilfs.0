From: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 06/10] hugetlbfs: Convert remove_inode_hugepages() to use
 filemap_get_folios()
Date: Fri, 10 Jun 2022 14:56:05 -0700
Message-ID: <6fc6e9de-39c2-3244-ef92-a1de0d390889@oracle.com>
References: <20220605193854.2371230-7-willy@infradead.org>
 <20220610155205.3111213-1-sumanthk@linux.ibm.com>
 <YqO08Dsq8ZcAcWDQ@casper.infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=cig8b+8Fcts7tPleLoHcBBCVvhjVSl8maOTJHh2wqmM=;
 b=rtue346rIjgYL8zwsPFXQ/v/JyxBkXc7lyalPS/zw2F6ZcTNDBE8g/NGov4dcMgjEW7L
 qL1ryvK+1cvjGjwMhL7vLlSaNqxjROiIcrL+NgLlWlSWfn/MGpDNc9K5V48AigSVCCPy
 KhO1w+RCiCgXoiQ3TEOt50uYVvhbwa3URUro8F6wVGuvAAo87JX8oJ4IvJPKkUJQ6bLI
 Wnnvzh2gZNKh4ydWq0fbM0iuzEN1lDkhelSHX9GwzyUMKtu2PN4SxTg3bwUEeKNFGNSX
 ke/pIXbLVe9Rm2E3j6534CfN6YjUE3sfXxabzgKSaIzfswmjCHB8200GZ7DCXPOm3a9u 1g== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cig8b+8Fcts7tPleLoHcBBCVvhjVSl8maOTJHh2wqmM=;
 b=T8CH7oX/j0AaYvjDSqCgciSkT6W5MunMYiX31kg/2DRYpAvhYS+cnOUuevh+ArAIsVpgSFA4gBB/xN3AK5elY3Yd7wyEPoIPPAduCfE8zVoOEXIFf1jZxcOy1cK5anmOL0DJvb6rJs4A6x57pT1UoX8+jumFvVtIXlzJM6QOFW4=
Content-Language: en-US
In-Reply-To: <YqO08Dsq8ZcAcWDQ-FZi0V3Vbi30CUdFEqe4BF2D2FQJk+8+b@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sumanth Korikkar <sumanthk-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Cc: linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gerald.schaefer-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 6/10/22 14:17, Matthew Wilcox wrote:
> On Fri, Jun 10, 2022 at 05:52:05PM +0200, Sumanth Korikkar wrote:
>> To reproduce:
>> * clone libhugetlbfs:
>> * Execute, PATH=$PATH:"obj64/" LD_LIBRARY_PATH=../obj64/ alloc-instantiate-race shared
> 
> ... it's a lot harder to set up hugetlb than that ...
> 
> anyway, i figured it out without being able to run the reproducer.
> 
> Can you try this?

I can confirm that libhugetlbfs tests do not trigger the BUG with the
below change.
-- 
Mike Kravetz

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
> 
