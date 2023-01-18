From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 3/9] mm: use filemap_get_entry in
 filemap_get_incore_folio
Date: Wed, 18 Jan 2023 13:49:51 +0000
Message-ID: <Y8f4/41eK0KQSRpI@casper.infradead.org>
References: <20230118094329.9553-1-hch@lst.de>
 <20230118094329.9553-4-hch@lst.de>
Mime-Version: 1.0
Return-path: <cluster-devel-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1674049886;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=R+y1aRAi1Q5p2FWSqw26xsXrVejTThXr1WM2j+n/J8o=;
	b=WCMvRMqrR7n0E6EbIz+bChOjU0g9nKEt9yrPhLcP+45v+vrPgdmxuMmTPZRpIzEve1k6mU
	/WVEt2JjcfRQi3nTglUl2n2piCgpbetsmvxobhUzB36om36rTFf9CaxQm6t5ud234VvXu0
	k+b5Q7hEtDUE+3dR+X/iC34vvvqHpEw=
In-Reply-To: <20230118094329.9553-4-hch@lst.de>
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

On Wed, Jan 18, 2023 at 10:43:23AM +0100, Christoph Hellwig wrote:
> filemap_get_incore_folio wants to look at the details of xa_is_value
> entries, but doesn't need any of the other logic in filemap_get_folio.
> Switch it to use the lower-level filemap_get_entry interface.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

