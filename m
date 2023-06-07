From: Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 31/31] fs: remove the now unused FMODE_* flags
Date: Wed, 7 Jun 2023 11:25:59 +0200
Message-ID: <20230607-lehne-marken-17b031dd9165@brauner>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-32-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-um-bounces+glud-user-mode-linux-devel=m.gmane-mx.org@lists.infradead.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=lists.infradead.org; s=bombadil.20210309; h=Sender:
	Content-Transfer-Encoding:Content-Type:List-Subscribe:List-Help:List-Post:
	List-Archive:List-Unsubscribe:List-Id:In-Reply-To:MIME-Version:References:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Owner; bh=hT9TDJqn40OEugAbtD9GQup3/odOC1jKURX4Di31i64=; b=Kc5Wn+/ltOp0ov
	oRyNK7lEtBzVh0SnGQ6cedZE5TIbPngOuhKAwPomxM7dHeFeo9icjELuAy7ot2yWEmZ2X4LGNOWWt
	hSYUJcs3Avd80pTBHLER4zcDT23nm+VopqQOJwzH42CXbg8ritned5Gig3ZVRW3lJEhZnrZqgayJz
	6pj0YopdPPR5bIYAA6tyc03nIPH/tSJmPSD8N4hXmtdZRVTwL7CceEWm0LZ82uOAdTFYcYDDGu+9l
	XOy/u43oA/oXrDphipyHQx9Oo2I5J2BN6T+q/w6HnkFTJRxQkgDI3rg0qLJCrdTZW6N/0Qe2YTqbd
	lF4DvncwszqLly/oeLLw==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686129968;
	bh=90WN1yUXLJUe3ExTCrm+9/jICeRfh1xqidoess9eZgI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G11EvijrXOft/4fKmPbcLsj96l6rzLAMnuaIxMBioke+aBkOZjX0wCH/9fvhIEjex
	 bWiAASMid1pQ95ExZeH4vBW5SM8ilf/NZQVWxNMB0WOYPM9glBZMCr5Ac+of7EpC67
	 IUolHFn7wPq/SIHTgNke/TvkzfU5n52aulKZAQmc9SU6wqZjH3wTf5zcRlPc+Be0ZI
	 tjYNjFG0WWy5oyTijsqkj/wvHS1IkYB4WeHa/KebFhUJ8MLJna0IALZB24dyM/p5Fl
	 3AtWIIUlxdg9dCBor+iOy3BYRPzpRSoLmgc+mM3rrS6ylvh7XsRdf+ZYu3eLpchVoc
	 BEZRzrMhzDVIg==
Content-Disposition: inline
In-Reply-To: <20230606073950.225178-32-hch@lst.de>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-um>,
 <mailto:linux-um-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-um/>
List-Post: <mailto:linux-um@lists.infradead.org>
List-Help: <mailto:linux-um-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-um>,
 <mailto:linux-um-request@lists.infradead.org?subject=subscribe>
Sender: "linux-um" <linux-um-bounces@lists.infradead.org>
Errors-To: linux-um-bounces+glud-user-mode-linux-devel=m.gmane-mx.org@lists.infradead.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Richard Weinberger <richard@nod.at>, Josef Bacik <josef@toxicpanda.com>, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>, Phillip Potter <phil@philpotter.co.uk>, Coly Li <colyli@suse.de>, Miquel Raynal <miquel.raynal@bootlin.com>, Vignesh Raghavendra <vigneshr@ti.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@ucw.cz>, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-um@lists.infradead.org, linux-scsi@vger.kernel.org, linux-bcache@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org, linux-btrfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Tue, Jun 06, 2023 at 09:39:50AM +0200, Christoph Hellwig wrote:
> FMODE_NDELAY, FMODE_EXCL and FMODE_WRITE_IOCTL were only used for
> block internal purposed and are now entirely unused, so remove them.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Love it,
Reviewed-by: Christian Brauner <brauner@kernel.org>
