From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v4 06/27] fs: check for writeback errors after syncing
 out buffers in generic_file_fsync
Date: Wed, 10 May 2017 05:48:36 -0700
Message-ID: <20170510124836.GA1590@bombadil.infradead.org>
References: <20170509154930.29524-1-jlayton@redhat.com>
 <20170509154930.29524-7-jlayton@redhat.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	 bh=lTG5RPXuuwaFXoVRf37EADHHzZzDSYeysmlDbBwxle8=; b=GyJBaH2DWL4DhW0QzQA94b+DV
	0GFlRYgj+xtetDgsmsOZA7BgHX3tSk060sKkUZaHNTpZQqu/qfo6B7kLCh30IVu+4K7TsQcw1OStL
	ABm1oll305if4rodkeIw4yYfY4KvFbysVwdbWZV7Z9S8WkPG2Q+yelbak2KhO5uVAkzol+HVtZxJ6
	njjW9YfjkKUozcOmgfW29M1+cvZ6IFv6xTRYBOOvGWsQCTAtXPyWg4ypBNDaNCv24b08p/PVP38H6
	OnuVj8L2QVWYvPuGeKBPFruwUMpr7dzNt+nl1JnqwqH7pZm+65NfPfHlopjotEJ4sftHzqIODkbbx
	jUiOq4eag==;
Content-Disposition: inline
In-Reply-To: <20170509154930.29524-7-jlayton@redhat.com>
Sender: owner-linux-mm@kvack.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, linux-mm@kvack.org, jfs-discussion@lists.sourceforge.net, linux-xfs@vger.kernel.org, cluster-devel@redhat.com, linux-f2fs-devel@lists.sourceforge.net, v9fs-developer@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-block@vger.kernel.org, dhowells@redhat.com, akpm@linux-foundation.org, hch@infradead.org, ross.zwisler@linux.intel.com, mawilcox@microsoft.com, jack@suse.com, viro@zeniv.linux.org.uk, corbet@lwn.net, neilb@suse.de, clm@fb.com, tytso@mit.edu, axboe@kernel.dk, josef@toxicpanda.com, hubcap@omnibond.com, rpeterso@redhat.com, bo.li.liu@oracle.com

On Tue, May 09, 2017 at 11:49:09AM -0400, Jeff Layton wrote:
> ext2 currently does a test+clear of the AS_EIO flag, which is
> is problematic for some coming changes.
> 
> What we really need to do instead is call filemap_check_errors
> in __generic_file_fsync after syncing out the buffers. That
> will be sufficient for this case, and help other callers detect
> these errors properly as well.
> 
> With that, we don't need to twiddle it in ext2.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Jan Kara <jack@suse.cz>

Reviewed-by: Matthew Wilcox <mawilcox@microsoft.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
