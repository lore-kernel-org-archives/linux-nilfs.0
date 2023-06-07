From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 26/31] block: move a few internal definitions
 out of blkdev.h
Date: Wed, 7 Jun 2023 15:09:51 +0200
Message-ID: <7814a706-3f16-42c7-75ce-c926e274fe98@suse.de>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-27-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686143407;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=BjKVG3yRTw7S43lXY07reW4hCQmiXLAA+dj0hqxuCt8=;
	b=LdVkyuZ48NaEETtas+e3nfMfB2w673iRht6/GNfSmDdPKU0UD3CvdartqEDlYSM6Zurcut
	wQOj0xq5cwYVObE4gBF4zvDUyk678nuBW2jksQqBg5602cVkEdQqZh/SeZGLD9CpPOFOeq
	G5Mle2+tVqb+d+XSog5Thb76LsHT4iM=
In-Reply-To: <20230606073950.225178-27-hch@lst.de>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Vignesh Raghavendra <vigneshr@ti.com>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-nvme@lists.infradead.org, Phillip Potter <phil@philpotter.co.uk>, Chris Mason <clm@fb.com>, dm-devel@redhat.com, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>, Jack Wang <jinpu.wang@ionos.com>, linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, Richard Weinberger <richard@nod.at>, linux-pm@vger.kernel.org, linux-um@lists.infradead.org, Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, Christian Brauner <brauner@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.

On 6/6/23 09:39, Christoph Hellwig wrote:
> All these helpers are only used in core block code, so move them out of
> the public header.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   block/blk.h            | 23 +++++++++++++++++++++--
>   include/linux/blkdev.h | 27 ---------------------------
>   2 files changed, 21 insertions(+), 29 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
