From: Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 02/31] cdrom: remove the unused bdev argument to
 cdrom_open
Date: Wed, 7 Jun 2023 10:16:19 +0200
Message-ID: <20230607-fahrdienst-leidwesen-f4192e429765@brauner>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-3-hch@lst.de>
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
	List-Owner; bh=HspEnUAF/vz8HJg7BQ7fV11TLbjySCQ9On5VarfpeZA=; b=BgeO3rXDrRcqzt
	Vf3mbCtOKnlVSKQF3K4RMbbTqwMD/O616K93hL128kqzuIhU+SgLppe2YxiINGEBZQMLULpGDI2mx
	P/B91YAuizoqU9CR4j8wIt/5ssFHQwJVB/iwGlkthpv049yLvUlQu+Ta2RNPWWskzMXC/Fa8/dzxm
	wxKGpYMlNPH4GRBLYGuP+6Obo/QsdFu3uw82kQmQTRzreYCQgvouXjDVs3F8l4j3B7vWiIPdbPEaf
	DGt4EcZflfyw4VwvB6AuAN8f5Wg4C87wzgraZimIlCF2hKHAkBQdavddvVcV78zZzkckS4BImaoP3
	T3uS98Fc8IoiJwDMUJkA==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686125788;
	bh=RXb/uaqR0x5/NbgjksTcXwSkQHw+GeMJrx4xaN4v7MY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D7HLq/BSC9BMU8P4kJMjo5MRJvyXbwS4/2PvvwAgM8ZW1dL92Hwr6Zk7SS4cudd43
	 YqaP0WroUvYa+J2A0NcRIinvLRsnSH3+zo1FaTyPgQ4GnhYB7qgc3d/Go72HNsVxQF
	 2VnZeMObpLaXQgi8iTif/MccBCn6vLk1nxwqHzPzuxFsvOp3CDpoMGoMBUNPzKqJ+9
	 MDPrw2poPrPBCR3aAKE82p3/3e6I3qqlouz4S7jup9ehDAbiUr/4WJT37Mf7snmVlY
	 xWYx9JWoneLZBkWhVBZeWvh/L+gD953X7yEXsyewcrazZ0kGnjene02lhM27pPq0WM
	 4vEu4pR4sz/Jw==
Content-Disposition: inline
In-Reply-To: <20230606073950.225178-3-hch@lst.de>
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

On Tue, Jun 06, 2023 at 09:39:21AM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

lgtm,
Acked-by: Christian Brauner <brauner@kernel.org>
