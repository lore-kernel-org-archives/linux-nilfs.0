From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v11 53/63] dax: Rename some functions
Date: Sun, 20 May 2018 22:42:36 -0600
Message-ID: <20180521044236.GC27043@linux.intel.com>
References: <20180414141316.7167-1-willy@infradead.org>
 <20180414141316.7167-54-willy@infradead.org>
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
 bh=avNoE0AfdDtTvcykCSVCH23MeX2fcOY8+JT1bfkB+E0=; b=HXfiUu4220FZb99a5icLGU45Qo
 HV+mZEClzQ7a8P2Rgl5KRIJ2zzOz1kguMac5v01ce70YfU/f33F3rnbYz6D65FxFgV9WNMH83j6lm
 yGHKx+Ra9uZu6cJW5GsjmPZQJVL0XbKt6dIZ5jrgFLPzKlM7boAXCz8S95orOn6ZXDdc=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To
 :From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=avNoE0AfdDtTvcykCSVCH23MeX2fcOY8+JT1bfkB+E0=; b=JFau6YjMqTyPcIoHicEoHVfqCM
 MEfB6AtxtDaDKcxYXxTXb8cIEz5TQ7Oar1yXTXnXBQEKtS+7QjhUAM/qNqtW/V41o28Rfk3g+CFUz
 fxtMeSxxCxOCeCnAAs0tRq9v3z43W+CTu4ZJELNRXJtZB3RO4WpukN/28rz6FkGqM7Iw=;
Content-Disposition: inline
In-Reply-To: <20180414141316.7167-54-willy@infradead.org>
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
Cc: linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, James Simmons <jsimmons@infradead.org>, Jaegeuk Kim <jaegeuk@kernel.org>, Andreas Dilger <andreas.dilger@intel.com>, Nicholas Piggin <npiggin@gmail.com>, linux-f2fs-devel@lists.sourceforge.net, Oleg Drokin <oleg.drokin@intel.com>, linux-mm@kvack.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-fsdevel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>, Mike Kravetz <mike.kravetz@oracle.com>

On Sat, Apr 14, 2018 at 07:13:06AM -0700, Matthew Wilcox wrote:
> From: Matthew Wilcox <mawilcox@microsoft.com>
> 
> Remove mentions of 'radix' and 'radix tree'.  Simplify some names by
> dropping the word 'mapping'.
> 
> Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>


> @@ -74,18 +74,18 @@ fs_initcall(init_dax_wait_table);
>  #define DAX_ZERO_PAGE	(1UL << 2)
>  #define DAX_EMPTY	(1UL << 3)
>  
> -static unsigned long dax_radix_pfn(void *entry)
> +static unsigned long dax_to_pfn(void *entry)
>  {
>  	return xa_to_value(entry) >> DAX_SHIFT;
>  }
>  
> -static void *dax_radix_locked_entry(unsigned long pfn, unsigned long flags)
> +static void *dax_mk_locked(unsigned long pfn, unsigned long flags)

Let's continue to use whole words in function names instead of abbreviations
for readability.  Can you please s/dax_mk_locked/dax_make_locked/ ?

I do realize that the xarray function is xa_mk_value() (which I also think is
perhaps too brief for readability), but in the rest of DAX we use full words
everywhere.

> @@ -1519,15 +1517,14 @@ int dax_iomap_fault(struct vm_fault *vmf, enum page_entry_size pe_size,
>  }
>  EXPORT_SYMBOL_GPL(dax_iomap_fault);
>  
> -/**
> +/*

Let's leave the double ** so that the function is picked up properly by
the documentation system, and so it's consistent with the rest of the
functions.

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
