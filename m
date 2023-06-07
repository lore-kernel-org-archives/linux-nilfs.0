From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 11/31] block: rename blkdev_close to blkdev_release
Date: Wed, 7 Jun 2023 14:21:23 +0200
Message-ID: <6e9b787a-816f-26cd-bccb-a8423978838d@suse.de>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-12-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-um-bounces+glud-user-mode-linux-devel=m.gmane-mx.org@lists.infradead.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=lists.infradead.org; s=bombadil.20210309; h=Sender:Content-Type:
	Content-Transfer-Encoding:List-Subscribe:List-Help:List-Post:List-Archive:
	List-Unsubscribe:List-Id:In-Reply-To:From:References:Cc:To:Subject:
	MIME-Version:Date:Message-ID:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Owner; bh=GGV8gUoYV1RqIRKcNsNUkghbfIpuLt4OblWmZv3/ENY=; b=IlBiRWRl3XS7Ad
	kscpdpn6eZ+KlQiq5kStvZ16W6FMZ45UaprAQILU2uz2zBjBQ5yzr4NTINNC72iF3uS4RoICLVT6C
	5UUAfejkb+WzP7nKzzQc69kq8rnV2dlUW+xDQltY9/Q5ZZ9geSBzZkpOTA2VFhFu6YbYYKaIgxTu0
	hh0Zu67EE/aWMqFP+LV03rx0B2otQRfcFXmqKV4A/OtNsvoLMQg8308gC6RpVzOK/s2qTnHHSC7hw
	wXN5QabeuAC9RUy/OKcDgDg8oD+PV+M+ISDKQJaIR3DOUEkQyqG8jFr7YSqi29PTOV3Ljfgz7VlV1
	5WI2KcKBMPel+uEubt6Q==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1686140484; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gCMA5z4sRgsG9hLtpAqxq7hMHYSi+TMBSBzzC1xgW7g=;
	b=iWRM/YZh4dJcdckBvkZT7rZG0nzzsZWrckumfKjXh6sQeqPalBid8M6uXsooYobwztGnaB
	SjEMuc9GtSrlCE9kW2OzLLl2u5sJOa4+n/dCq8Eori3ggWWXFxd9woLytJN6t265W9j/vW
	GuEIKWlbOIcE2XOZMA4y1n/uHLzFvQs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1686140484;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gCMA5z4sRgsG9hLtpAqxq7hMHYSi+TMBSBzzC1xgW7g=;
	b=toYIpEOFscYMVfaZGlEe+8lCgCOysUx/FGpsJnDwZ8bc4ySdYTv/zp1yG1kYOmCCVRKn5i
	s48brrau9MKQlEAg==
Content-Language: en-US
In-Reply-To: <20230606073950.225178-12-hch@lst.de>
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
> Make the function name match the method name.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   block/fops.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
