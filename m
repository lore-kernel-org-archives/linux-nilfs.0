From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 11/20] cifs: set mapping error when page writeback
 fails in writepage or launder_pages
Date: Mon, 24 Apr 2017 08:27:08 -0700
Message-ID: <20170424152708.GK9112@infradead.org>
References: <20170424132259.8680-1-jlayton@redhat.com>
 <20170424132259.8680-12-jlayton@redhat.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	 bh=k0m4YfimpXG5Swxql8BgmUfpXMg96SOForWGukJtBiY=; b=nVbk0jMnxzRmsyV+K+0UL0WNF
	wbunaEms9BCf3IW0g+rFon3ETxH4QOFy6bwhimPK+HztgLex/yMfwwPlY0D3ImksJIKSXTUxVxqhN
	7Ab3PVerSibTNuNtIXN9Q694kODd6AzLftShZeHFGWEdNXHT/yxdqWoJBnKCD7l/qtV5zU31wwK1i
	aYLLSKnuLsK0nJz8WxyoM1t5cKlV3DxVKYF+CWSZ+SWfCgHExETRr3mBzEC6SDtFxJrtrGAi0eVog
	RZfK5OvYEki4n8zpvcGK8oyH9yOIKbeXKkuVJOtAHyCpD2i6RsdZnRdI0Da+urzFCzTTKXWOHBiRt
	XdFLUiyWQ==;
Content-Disposition: inline
In-Reply-To: <20170424132259.8680-12-jlayton@redhat.com>
Sender: owner-linux-mm@kvack.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-cifs@vger.kernel.org, linux-mm@kvack.org, jfs-discussion@lists.sourceforge.net, linux-xfs@vger.kernel.org, cluster-devel@redhat.com, linux-f2fs-devel@lists.sourceforge.net, v9fs-developer@lists.sourceforge.net, osd-dev@open-osd.org, linux-nilfs@vger.kernel.org, linux-block@vger.kernel.org, dhowells@redhat.com, akpm@linux-foundation.org, hch@infradead.org, ross.zwisler@linux.intel.com, mawilcox@microsoft.com, jack@suse.com, viro@zeniv.linux.org.uk, corbet@lwn.net, neilb@suse.de, clm@fb.com, tytso@mit.edu, axboe@kernel.dk

On Mon, Apr 24, 2017 at 09:22:50AM -0400, Jeff Layton wrote:
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---
>  fs/cifs/file.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 21d404535739..4b696a23b0b1 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -2234,14 +2234,16 @@ cifs_writepage_locked(struct page *page, struct writeback_control *wbc)
>  	set_page_writeback(page);
>  retry_write:
>  	rc = cifs_partialpagewrite(page, 0, PAGE_SIZE);
> +	if (rc == -EAGAIN && wbc->sync_mode == WB_SYNC_ALL) {
>  		goto retry_write;
> +	} else if (rc == -EAGAIN) {
>  		redirty_page_for_writepage(wbc, page);
> +	} else if (rc != 0) {
>  		SetPageError(page);
> +		mapping_set_error(page->mapping, rc);
> +	} else {
>  		SetPageUptodate(page);
> +	}

Hmmm.  I might be a little too nitpicky, but I hate having the same
partial condition duplicated if possible.  Why not:

	if (rc == -EAGAIN) {
		if (wbc->sync_mode == WB_SYNC_ALL)
			goto retry_write;
		redirty_page_for_writepage(wbc, page);
	} else if (rc) {
		SetPageError(page);
		mapping_set_error(page->mapping, rc);
	} else {
		SetPageUptodate(page);
	}

Otherwise this looks fine to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
