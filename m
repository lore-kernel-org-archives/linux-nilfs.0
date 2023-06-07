From: Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 20/31] scsi: replace the fmode_t argument to scsi_ioctl
 with a simple bool
Date: Wed, 7 Jun 2023 10:58:24 +0200
Message-ID: <20230607-dates-innenansicht-78e76eea7347@brauner>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-21-hch@lst.de>
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
	List-Owner; bh=7H8wJcS9UmWa01z8Vm+epkztvtnjAODCMw8QlSgYXMA=; b=S3ktKWzIngRLgO
	X55GWC+VwflA3Bz75ad7Mlvs36ulbdxkOJcMXas4tvmcLGQx1XEUVm5KmLh3pBRB7YtPqcKaVxFvQ
	zk1HTUBaIUKQtuSnXpUTqpJlvyhgVB2wSv/LReKFOEiHS4liPG2vMv9VRxYPvkxQDfRmPUzURZFKJ
	i/LUNDAqD6UrnALx+7z70JUZzYOtHf9lUdA6Jjqqs+lRT45tvBZjxPlQu/zlkh0ilSOABolkrQsHS
	A369dzqgKTZOV9JR4bELYdiDln34PMnKYzWZvvudtWI3vNQISlgcMHdu9dY0mmVoZeXKpSdyYwsAE
	T32g8YsPyncIUvIhCewA==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686128312;
	bh=ULzdhbcJeHPqQXgxbjAFPajJp4EhMC2K+LFc4KO7vAA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QDgpcas10bhc6n+3tq+Tww3RU/1erBcAFvLdGNqmlHFWLpUff8UGptsIZjNJ5w8gT
	 KYA7ed+ki78rGbhq5L/pIz6djcKUzIgFySOylESb78Bo6dP+lYa+WimjJyqZa15c3b
	 1a4lMbl2TA4crdhAnzslPR1Iz130r59S9JasIE6AZsdKPxJjYPbAxErnPuZ4MNQ2GS
	 KGvt5cBHh6T/W5itlNub0ikJLxBe6iyEJiSqAGXrX+LiQTSGUC5G+HFALEh7g1JEED
	 Ql69+otxwsCqAC05NjZF31NRBQV7RRI+/YZWHju6mtccLdXuvkjFbYs/ytHfl1KO7w
	 qd67klAruXQuw==
Content-Disposition: inline
In-Reply-To: <20230606073950.225178-21-hch@lst.de>
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

On Tue, Jun 06, 2023 at 09:39:39AM +0200, Christoph Hellwig wrote:
> Instead of passing a fmode_t and only checking it for FMODE_WRITE, pass
> a bool open_for_write to prepare for callers that won't have the fmode_t.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Looks good to me,
Acked-by: Christian Brauner <brauner@kernel.org>
