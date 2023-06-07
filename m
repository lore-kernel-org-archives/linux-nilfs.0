From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 01/31] block: also call ->open for incremental partition
 opens
Date: Wed, 7 Jun 2023 14:10:27 +0200
Message-ID: <1b1e8640-7bc8-a213-9b6c-2eb0b843ece6@suse.de>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-2-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-um-bounces+glud-user-mode-linux-devel=m.gmane-mx.org@lists.infradead.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=lists.infradead.org; s=bombadil.20210309; h=Sender:Content-Type:
	Content-Transfer-Encoding:List-Subscribe:List-Help:List-Post:List-Archive:
	List-Unsubscribe:List-Id:In-Reply-To:From:References:Cc:To:Subject:
	MIME-Version:Date:Message-ID:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Owner; bh=26DD1JNriB3BllT89heIQseAjvU6ADgNs3dbfBkHYXQ=; b=vToDxCn/Jag1Px
	UMm8aa/P9Q0UDXb2MMNNdvjp0pMfdY1yPxRol5u3E9XmVmfI4GHwAfCe8QmfRtaljRdoQfLMzj0vW
	QkYlU349ItjTdbFaFXi9zs57gyTxuFRVLsh7YUXqZ69nHZVvTp6QshiMChA4lGJGMGMI0ut4FbBV4
	mgLHfC24+3GeWS6T8naMyeuVKsB9q19bcBOMV1hMsxTL/jE7YTXLkYhsnHcaU9B5dWoRz0qGOUVt1
	nbVi+OHiHQ/Mi+Knf5+hzdFv1vEuQ+Ed+jU1+ExEzYUoYHbND01CfoB4ElrhKhYUPwYfKCYhjGXTu
	4wmd3ebzN7T/ctO8SYLg==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1686139831; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VqcjXu0CZTTpOZmrsxN0Wk6sBEC02dewC7QyNvd2soI=;
	b=IHfmh7S/uiagddCbXIRJmosPllrO40PYEOdRWLxIJcakAcNIU++BrgHVQz0wc7LcQAKKzC
	PPRnjWo+UKOWnOBcyWCCyUZkDBITx9Cp6jogvlX5nqnl/7EZ1E52mDDTaguTf4aV9jJ4YH
	Y0E8fz71thAZEe372iOj6DPRk6Att+g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1686139831;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VqcjXu0CZTTpOZmrsxN0Wk6sBEC02dewC7QyNvd2soI=;
	b=MkcUMKJtjBchJhTKblNCrLqdAmaj8HslDTq0hIfVSuBi5J7Ox9FYzyAcm0vHDIQaJJ1iFw
	8q1qSbcsmckQBWBA==
Content-Language: en-US
In-Reply-To: <20230606073950.225178-2-hch@lst.de>
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
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Richard Weinberger <richard@nod.at>, Josef Bacik <josef@toxicpanda.com>, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>, Phillip Potter <phil@philpotter.co.uk>, Coly Li <colyli@suse.de>, Miquel Raynal <miquel.raynal@bootlin.com>, Vignesh Raghavendra <vigneshr@ti.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@ucw.cz>, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-um@lists.infradead.org, linux-scsi@vger.kernel.org, linux-bcache@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org, linux-btrfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kerne

On 6/6/23 09:39, Christoph Hellwig wrote:
> For whole devices ->open is called for each open, but for partitions it
> is only called on the first open of a partition.  This is problematic
> as various block drivers look at open flags and might not do all setup
> for ioctl only or NDELAY opens.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   block/bdev.c | 18 ++++++++----------
>   1 file changed, 8 insertions(+), 10 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
