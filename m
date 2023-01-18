From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 1/9] mm: don't look at xarray value
 entries in split_huge_pages_in_file
Date: Wed, 18 Jan 2023 13:47:52 +0000
Message-ID: <Y8f4iFGIaWz1bLWz@casper.infradead.org>
References: <20230118094329.9553-1-hch@lst.de>
 <20230118094329.9553-2-hch@lst.de>
Mime-Version: 1.0
Return-path: <cluster-devel-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1674049789;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=lxqHwE5NZsGY13fEvGCTQSPxat0iv3XloE5VpZBExhE=;
	b=SXXXdlNfVwdCpZpY4DEEWks+ElLd5AQ4iRO2lMkjzsdFcgncJEJdgB2w+t+mAnGCgavDPL
	MPoTZTpv3G+h35ZIemuHA6UwIGO2/1ND8P0/EBSh59R6r3SUc/jwpQeJILccJahFGfpO1t
	qyUge66vBiXOztlnmdxglq+7b8wwY1A=
In-Reply-To: <20230118094329.9553-2-hch@lst.de>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/cluster-devel>, 
 <mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/cluster-devel/>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/cluster-devel>,
 <mailto:cluster-devel-request@redhat.com?subject=subscribe>
Errors-To: cluster-devel-bounces@redhat.com
Sender: "Cluster-devel" <cluster-devel-bounces@redhat.com>
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-nilfs@vger.kernel.org, Hugh Dickins <hughd@google.com>, cluster-devel@redhat.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org

On Wed, Jan 18, 2023 at 10:43:21AM +0100, Christoph Hellwig wrote:
> split_huge_pages_in_file never wants to do anything with the special
> value enties.  Switch to using filemap_get_folio to not even see them.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

