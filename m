From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 01/20] mm: drop "wait" parameter from write_one_page
Date: Mon, 24 Apr 2017 08:22:23 -0700
Message-ID: <20170424152223.GA9112@infradead.org>
References: <20170424132259.8680-1-jlayton@redhat.com>
 <20170424132259.8680-2-jlayton@redhat.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	 bh=yhVxFenIgPub/w/35qpJsH+EleYVEBaF1uzR5/OHDEM=; b=ET8bUB75XuVpvg3P6KAiU5zWe
	aGa5XhGJTlPiVveyzarusG8n79UBhSNKyDmsmF1xI28ncLCch/pOuDX0eZTB3LiVW84sCWl3Nh2zf
	Ehmb0VKtydtzyefsvqOcLFGShF/rOdzHFSfleTIwz4Suaen9PtClrckr/Tndi21721JdI/zosOkFM
	4/lwvvexCOKZwIcxb44613C6Hw9hEfOK848HVbF6IMD929u+FBxPIpG52GQqIiYMzZmWIHKPWkYC0
	IUM3g2aaaryvVqIDW8khN70CrZPwt1IFHefmJfZ1OoG3lfL0NzIa/XCGLn2Zxwx+rv/Yu1vzqaMvl
	hNov4seuA==;
Content-Disposition: inline
In-Reply-To: <20170424132259.8680-2-jlayton@redhat.com>
Sender: owner-linux-mm@kvack.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-cifs@vger.kernel.org, linux-mm@kvack.org, jfs-discussion@lists.sourceforge.net, linux-xfs@vger.kernel.org, cluster-devel@redhat.com, linux-f2fs-devel@lists.sourceforge.net, v9fs-developer@lists.sourceforge.net, osd-dev@open-osd.org, linux-nilfs@vger.kernel.org, linux-block@vger.kernel.org, dhowells@redhat.com, akpm@linux-foundation.org, hch@infradead.org, ross.zwisler@linux.intel.com, mawilcox@microsoft.com, jack@suse.com, viro@zeniv.linux.org.uk, corbet@lwn.net, neilb@suse.de, clm@fb.com, tytso@mit.edu, axboe@kernel.dk

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
