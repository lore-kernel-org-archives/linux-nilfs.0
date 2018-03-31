From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [PATCH v10 44/62] memfd: Convert shmem_wait_for_pins
 to XArray
Date: Fri, 30 Mar 2018 17:07:34 -0700
Message-ID: <4b70ad17-a176-9510-5525-30da01eba18e@oracle.com>
References: <20180330034245.10462-1-willy@infradead.org>
 <20180330034245.10462-45-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
 MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=gWt3RxM+zzPZA4msqcuJgOEhDkvVMMvKDUheO/QelKA=; b=jwbAy1t5cv/zKAvRDgTSNtENz3
 TJUGxco4ONP1YUAUIcy7KKUEL4wSS+mYrsK4xg4XTPu6qw+FyeaLQZ8BbLEL8pqZnKoev82c3oJvk
 Rax0W3KEWn83v71O+aZbS5VtDPTFsyxdXJIphFXWq8GjQ3ohw2LsD3iFbw/4Oda3VZj8=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:
 Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=gWt3RxM+zzPZA4msqcuJgOEhDkvVMMvKDUheO/QelKA=; b=IYN8McvR+I8Yyn7rjQCmZ+APpe
 0ZNg67BdvMzi27avLwF//2J48Q/85HOro8NPOMx3cRUWdqkfOdP0w+/24/o5pnKHsKCSfIuXBUapK
 c501a9db0pFJ9f9cBYtsADq47XjJg/iOdpS0Nk+7GK3G1S+L4j6RlgrI4L4JJNBN1mHk=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
 h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2017-10-26;
 bh=gWt3RxM+zzPZA4msqcuJgOEhDkvVMMvKDUheO/QelKA=;
 b=PpfonO86zMUy/9EKmHJ9OzUXpnjS2T8795YmRXhCDkeCm/ol8w+FpkM7XQbGnQJlQeK4
 PNgKo+id8JQNZpt+2XNEA4poFVv4/86K6HqC9g1yj5zizEtg9FtXkasE0j69tlcxwz+q
 Ds6ek+yJ6pgxD9niet+uv/WT1aLMa1PbFBueARiSJcIuE6DI9oyFP8959WWkdSdVxVP0
 y9t3+s2nIvT2X8YmSMpDOnEnKlff/qO532QbNG2g8IY2erYbE/jHiXCvSkkFD1cIC/H/
 jaJ6Y4FzRbbzicK0edP1Mm4HLbGyUSufJRDjSVtrPGnsH7/w0SujU7J8/3uKKnoGMbOw oQ== 
In-Reply-To: <20180330034245.10462-45-willy@infradead.org>
Content-Language: en-US
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Cc: linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, James Simmons <jsimmons@infradead.org>, Jaegeuk Kim <jaegeuk@kernel.org>, Andreas Dilger <andreas.dilger@intel.com>, Nicholas Piggin <npiggin@gmail.com>, linux-f2fs-devel@lists.sourceforge.net, Oleg Drokin <oleg.drokin@intel.com>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>

On 03/29/2018 08:42 PM, Matthew Wilcox wrote:
> From: Matthew Wilcox <mawilcox@microsoft.com>
> 
> As with shmem_tag_pins(), hold the lock around the entire loop instead
> of acquiring & dropping it for each entry we're going to untag.
> 
> Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>

Same comments as with with the previous shmem_tag_pins patch.

Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
-- 
Mike Kravetz

> ---
>  mm/memfd.c | 61 +++++++++++++++++++++++++------------------------------------
>  1 file changed, 25 insertions(+), 36 deletions(-)
> 
> diff --git a/mm/memfd.c b/mm/memfd.c
> index 3b299d72df78..0e0835e63af2 100644
> --- a/mm/memfd.c
> +++ b/mm/memfd.c
> @@ -64,9 +64,7 @@ static void shmem_tag_pins(struct address_space *mapping)
>   */
>  static int shmem_wait_for_pins(struct address_space *mapping)
>  {
> -	struct radix_tree_iter iter;
> -	void __rcu **slot;
> -	pgoff_t start;
> +	XA_STATE(xas, &mapping->i_pages, 0);
>  	struct page *page;
>  	int error, scan;
>  
> @@ -74,7 +72,9 @@ static int shmem_wait_for_pins(struct address_space *mapping)
>  
>  	error = 0;
>  	for (scan = 0; scan <= LAST_SCAN; scan++) {
> -		if (!radix_tree_tagged(&mapping->i_pages, SHMEM_TAG_PINNED))
> +		unsigned int tagged = 0;
> +
> +		if (!xas_tagged(&xas, SHMEM_TAG_PINNED))
>  			break;
>  
>  		if (!scan)
> @@ -82,45 +82,34 @@ static int shmem_wait_for_pins(struct address_space *mapping)
>  		else if (schedule_timeout_killable((HZ << scan) / 200))
>  			scan = LAST_SCAN;
>  
> -		start = 0;
> -		rcu_read_lock();
> -		radix_tree_for_each_tagged(slot, &mapping->i_pages, &iter,
> -					   start, SHMEM_TAG_PINNED) {
> -
> -			page = radix_tree_deref_slot(slot);
> -			if (radix_tree_exception(page)) {
> -				if (radix_tree_deref_retry(page)) {
> -					slot = radix_tree_iter_retry(&iter);
> -					continue;
> -				}
> -
> -				page = NULL;
> -			}
> -
> -			if (page &&
> -			    page_count(page) - page_mapcount(page) != 1) {
> -				if (scan < LAST_SCAN)
> -					goto continue_resched;
> -
> +		xas_set(&xas, 0);
> +		xas_lock_irq(&xas);
> +		xas_for_each_tag(&xas, page, ULONG_MAX, SHMEM_TAG_PINNED) {
> +			bool clear = true;
> +			if (xa_is_value(page))
> +				continue;
> +			if (page_count(page) - page_mapcount(page) != 1) {
>  				/*
>  				 * On the last scan, we clean up all those tags
>  				 * we inserted; but make a note that we still
>  				 * found pages pinned.
>  				 */
> -				error = -EBUSY;
> -			}
> -
> -			xa_lock_irq(&mapping->i_pages);
> -			radix_tree_tag_clear(&mapping->i_pages,
> -					     iter.index, SHMEM_TAG_PINNED);
> -			xa_unlock_irq(&mapping->i_pages);
> -continue_resched:
> -			if (need_resched()) {
> -				slot = radix_tree_iter_resume(slot, &iter);
> -				cond_resched_rcu();
> +				if (scan == LAST_SCAN)
> +					error = -EBUSY;
> +				else
> +					clear = false;
>  			}
> +			if (clear)
> +				xas_clear_tag(&xas, SHMEM_TAG_PINNED);
> +			if (++tagged % XA_CHECK_SCHED)
> +				continue;
> +
> +			xas_pause(&xas);
> +			xas_unlock_irq(&xas);
> +			cond_resched();
> +			xas_lock_irq(&xas);
>  		}
> -		rcu_read_unlock();
> +		xas_unlock_irq(&xas);
>  	}
>  
>  	return error;
> 

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
