From: Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 11/31] block: rename blkdev_close to blkdev_release
Date: Wed, 7 Jun 2023 10:35:22 +0200
Message-ID: <20230607-renovieren-getier-8fba2cb1185d@brauner>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-12-hch@lst.de>
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
	List-Owner; bh=hEXkq4nxXbw8K2HLRH7smEMUJvgw78uMXHWncbKQgtw=; b=GDbSMPFqXiV7Mo
	wuT1zZ7K0qTyX8PErlijFVxQExaLWltLxW2fW8HBtEtXasTvmJZRpfm0w+uvt2eP3qSQiBO2m/Fk9
	jtL/1OI1iw4I5pMz9h6tcdqr4zfLWfON3SC9qGaOMZJsqnOP1XnrjeqmlrSvJQKXPsDiWMkYW0WeD
	JMor2kNNKMujN7rdS0V+V2RlmxXHR0glXgrv3n124S9UhBkRkoV1edOdcHLgo6UkWtRukg9Pt8I4e
	caIDPjT5FAKf5qGce/KXdIsZiNfnRfdw9BoCB+AoZMby/hqHFrPntTq0QR/LCu3ugmTXh5e9KQjAx
	urGyPJZuHZu1xiYfNl4Q==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686126931;
	bh=OMT81Nj+03/UUqXvR/WATI3J1MFOVo+i3KL8UfpdkEc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cXORTW2prZhLBaGAe7/mLRmhhTZvaBHSnzVd0HFARKJDQ62eKOG4Kzb7xZlfPL9nO
	 97zwfyA/DQztpsvm9grNPGz7haRUOQZrQturaW0SFSa0uosZB40SJST0dXmizK2H91
	 Vrg9ubXMdO+Gt6gYl3oFWyWVhTdUtfr7NIIdvz5ZfTiIhubmxyIDaIzXV3KgUyxjww
	 GcTRPH6U8lSPzfLUWbreqgZvDgNSFImMLsmVidpwIncpJKPPhhlshVQd4J7rrP6eJV
	 7nFr4sqb1S0ehPF5Xwg1baPwzoSZ6HowqC26ZK1aX2UPURtsR/Sx1T5MKoxTEoav5Y
	 AB2Mai1SAj/KQ==
Content-Disposition: inline
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
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Richard Weinberger <richard@nod.at>, Josef Bacik <josef@toxicpanda.com>, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>, Phillip Potter <phil@philpotter.co.uk>, Coly Li <colyli@suse.de>, Miquel Raynal <miquel.raynal@bootlin.com>, Vignesh Raghavendra <vigneshr@ti.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@ucw.cz>, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-um@lists.infradead.org, linux-scsi@vger.kernel.org, linux-bcache@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org, linux-btrfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Tue, Jun 06, 2023 at 09:39:30AM +0200, Christoph Hellwig wrote:
> Make the function name match the method name.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Looks good to me,
Acked-by: Christian Brauner <brauner@kernel.org>
