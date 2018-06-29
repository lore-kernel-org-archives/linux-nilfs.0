From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v14 68/74] dax: Convert dax_lock_page to XArray
Date: Fri, 29 Jun 2018 11:30:55 -0600
Message-ID: <20180629173055.GA2973@linux.intel.com>
References: <20180617020052.4759-1-willy@infradead.org>
 <20180617020052.4759-69-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180617020052.4759-69-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>, Nicholas Piggin <npiggin@gmail.com>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>, linux-f2fs-devel@lists.sourceforge.net

On Sat, Jun 16, 2018 at 07:00:46PM -0700, Matthew Wilcox wrote:
> Signed-off-by: Matthew Wilcox <willy@infradead.org>
> ---
<>
> +static void *dax_make_page_entry(struct page *page, void *entry)
> +{
> +	pfn_t pfn = page_to_pfn_t(page);
> +	return dax_make_entry(pfn, dax_is_pmd_entry(entry));
> +}

This function is defined and never used, so we get:

fs/dax.c:106:14: warning: ‘dax_make_page_entry’ defined but not used [-Wunused-function]
 static void *dax_make_page_entry(struct page *page, void *entry)
  ^~~~~~~~~~~~~~~~~~~
