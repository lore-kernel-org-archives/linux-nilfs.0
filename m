From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v14 68/74] dax: Convert dax_lock_page to XArray
Date: Fri, 6 Jul 2018 06:04:07 -0700
Message-ID: <20180706130407.GA18395@bombadil.infradead.org>
References: <20180617020052.4759-1-willy@infradead.org>
 <20180617020052.4759-69-willy@infradead.org>
 <20180629173055.GA2973@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:To:From:Date:Sender:
        Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=DIy5riyuC6FHTd+mNWhWkHIvvp8JSbIhQcxe1m8l9g0=; b=AVXrlqWKy1GYe3ywKyrxMjaHiY
        86hxPKrdKgOHFVrvsbsppHMBhB0Ov+a6EzjUW9Cl3U7h+MqZQ7ec42R7AUQh+hcqByVlTa305N/B8
        KTZ2UVlfkDp64gHazPbThqXc7s/9B9UwbZpt+UILN5oF2TJCnkp154Ry+UdXDenYxE1XpXiQxG+I2
        PT8NoD6KvD/K3kAfmFHvcUybPJcigRoY9kUHw3G/e33OfFl8Jlsv+flLlE5Ks0hJnWq5lxNdhYT02
        n+UvXRPXDVnhop3piDUz+89eUukoJBv+3oEuFYMgLoYjiWS8wy9pnVkdFHCHlCG062093Nr0afQIq
    
Content-Disposition: inline
In-Reply-To: <20180629173055.GA2973@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Lukas Czerner <lczerner@redhat.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>, Nicholas Piggin <npiggin@gmail.com>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>, linux-f2fs-devel@lists.sourceforge.net

On Fri, Jun 29, 2018 at 11:30:55AM -0600, Ross Zwisler wrote:
> On Sat, Jun 16, 2018 at 07:00:46PM -0700, Matthew Wilcox wrote:
> > Signed-off-by: Matthew Wilcox <willy@infradead.org>
> > ---
> <>
> > +static void *dax_make_page_entry(struct page *page, void *entry)
> > +{
> > +	pfn_t pfn = page_to_pfn_t(page);
> > +	return dax_make_entry(pfn, dax_is_pmd_entry(entry));
> > +}
> 
> This function is defined and never used, so we get:
> 
> fs/dax.c:106:14: warning: ‘dax_make_page_entry’ defined but not used [-Wunused-function]
>  static void *dax_make_page_entry(struct page *page, void *entry)
>   ^~~~~~~~~~~~~~~~~~~

Yeah, it was used in one of the functions Dan added, then removed.
I understand he's planning on bringing that back before 4.19 and I'm
going to rebase on top of that, so I've left it there for now.

