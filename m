From: Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 10/31] block: remove the unused mode argument to ->release
Date: Wed, 7 Jun 2023 10:34:57 +0200
Message-ID: <20230607-inbetriebnahme-markieren-42711df12a4b@brauner>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-11-hch@lst.de>
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
	List-Owner; bh=oS3dFU6F9Xqdex+7itd3x0iYbz3yEyLAhKox4wvLb38=; b=02LujlWWcsjAWe
	nLWE1DAMYQoW5Ba0zmINsYjEevkZXYHm/uJ+UeNEgYhuk9ZLgZyPymIa4zmNtaQY0COJ9ajp2Fm9o
	JBLkN6SxnRRNTkbd2H0Xr6uU7EIgFk4+6JGcptCtyToQfnzCDE2UryEZIhroOM2wILl2tq+fqAEWr
	tzOynAYUhPqkCIYS2hjrkS9OgxSbeYl+txBmbo7Mja+3Og59C2/UHDsGB2vMrOlQ5gFV0pryqtn+y
	N5uznjZXm2TP7D0iLQjfLaUAV15rnlGtt5pzZN7e2r1Q7Q2uF/e36LSn71nfG86OujcystKMw000h
	TgtO8Y8oGvB9b41ihCeg==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686126906;
	bh=DEpqJ01874Wcf6flpWQL4l3j+OyeWJJ1wSvscW2ZsvE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i3CH5XZi7Ku/UmN1uNhGHrNxFPQhZ8efjNfiTbNsWjKI+qjrG2GJAlxpGl4WKzZoh
	 BUa3cIn0dVM3WafUAzzbH8uuNxyByYfP8H70QxdowRN6RCs5nrCwMqpAWtTtCtkrfA
	 UUoFuECYuwF6g6BZvtkz1yfF3SziUWNAxmfcDv+ZyAT15huu83Xslw1FDR3OSN3f7M
	 cxo76H7oplo9/nKa80/LLfizTzZ0Gzi/jSYy7ksr7BoXSBWk0n4y6gq2zZA1zoG10d
	 b82jMNFwK474uaEbmhI5IxsDz3/ABjdRxN6qmozleapT3Vy9qyc29Lz62fPrh+D/W5
	 4FkCLrnTGlquQ==
Content-Disposition: inline
In-Reply-To: <20230606073950.225178-11-hch@lst.de>
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

On Tue, Jun 06, 2023 at 09:39:29AM +0200, Christoph Hellwig wrote:
> The mode argument to the ->release block_device_operation is never used,
> so remove it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Good cleanup. Looks good to me,
Acked-by: Christian Brauner <brauner@kernel.org>
