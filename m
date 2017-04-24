From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 09/20] 9p: set mapping error when writeback fails in
 launder_page
Date: Mon, 24 Apr 2017 08:24:55 -0700
Message-ID: <20170424152455.GI9112@infradead.org>
References: <20170424132259.8680-1-jlayton@redhat.com>
 <20170424132259.8680-10-jlayton@redhat.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	 bh=VLom2muJkYgpQ615VgOhvYB3zxzUDEUcWc6xLRmE2KE=; b=t2DTw9j0mz3IBYTEo1A/dRHhv
	JjY81pm7kZNTgtTxnbNKc/6fOYDMYdHIV5Fuv2NFKV+vqNIXaAwIZIy1ZVfV8BCg3oa/C9xmNLrXK
	bwCLscnmPgO6zxzSVNqP5yYWEKAU7uDWS2xj+pO+OpyODj3IqyzF7ZUAc8HsA2RTw9uawAQY1KbqF
	gVQzZLun46T4B37ARXRadVriM1TJ+U4abPI4WoNtgw3BId02CcB2F8iFCVL8b42h3mAH3MaeeRgyQ
	wMt5sWNgKbDPV3d9ez5w7AXSKGvYVXtWgSytskLzNYg8/5e6pKkduzpqYRNYP7sbto9YQmzts0cM8
	fdG/j792w==;
Content-Disposition: inline
In-Reply-To: <20170424132259.8680-10-jlayton@redhat.com>
Sender: owner-linux-mm@kvack.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-cifs@vger.kernel.org, linux-mm@kvack.org, jfs-discussion@lists.sourceforge.net, linux-xfs@vger.kernel.org, cluster-devel@redhat.com, linux-f2fs-devel@lists.sourceforge.net, v9fs-developer@lists.sourceforge.net, osd-dev@open-osd.org, linux-nilfs@vger.kernel.org, linux-block@vger.kernel.org, dhowells@redhat.com, akpm@linux-foundation.org, hch@infradead.org, ross.zwisler@linux.intel.com, mawilcox@microsoft.com, jack@suse.com, viro@zeniv.linux.org.uk, corbet@lwn.net, neilb@suse.de, clm@fb.com, tytso@mit.edu, axboe@kernel.dk

On Mon, Apr 24, 2017 at 09:22:48AM -0400, Jeff Layton wrote:
> launder_page is just writeback under the page lock. We still need to
> mark the mapping for errors there when they occur.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
