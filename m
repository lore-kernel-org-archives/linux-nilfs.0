From: Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 22/31] nvme: replace the fmode_t argument to the nvme
 ioctl handlers with a simple bool
Date: Wed, 7 Jun 2023 10:59:48 +0200
Message-ID: <20230607-pechvogel-monument-a22bf628a09c@brauner>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-23-hch@lst.de>
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
	List-Owner; bh=yEROveKcgip04za0kpR2cEig8ZSd5tWGTlFeinYmEuY=; b=P0s4h5b/1VE2WX
	J0IWIOV+ATxEFgeXixYXPzwZI6+Aiz2XQ9B03M3Hr4rtZBmd+3uRvDwwAx5LXDVNuKT11Pj27nquZ
	BbRgaodNOjV/dSHAnpehLVlkmzjQkl/hQJR1guRrljt/T4s2CA1vpDiE3iXp8i+84ypvk/PgI7obc
	vyyt8MzNDyNNfkZvepWt8zSX3wAFMzz3QMUUj864pPTBTGtBUWaZRYMf2xSsuUexBgnp2bNukBhWN
	yPT/aqLngxEDMGaE37pavxzH2hP0PhHaH3hu+kaESS+GqKZwxW4eZL7IYv9tUsrLChnYDQc9qkQvz
	aoXMJT2T92+L9THVwT8A==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686128396;
	bh=dWWAX+xiOcKgosI96OuwvEEnQrX5qRsaWpXnfV3wzsE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Rwe2e1Ca9g5PndSdWAR4ZxhkRR64XFN5oQuwRMk1FjfKraaCfNVTxn+BRhKyU+j/u
	 jg5JQ/jKXtDHzI9Uwmc7YThBmkwPCntyA1Nizp191gMau+kmlELxOjWKjvxjAc9JC2
	 RzBDL0p3j0FOCM7TOYUceH21NOI4PozRLAB2K3uQBAYBUemNsIy2dYg//LtIYEwErf
	 BV8xPRNRnufBYP0cou5VW32ptS1X7HphuSax6//1cqt1yDk43UFdKboMkPJBkTDSpW
	 GYhjav9dOdhYt8kknuatTMef0vgcOMh+q/hcr0bQH+Xq3sSPWUNEM6OXHtet+bxkeT
	 12uBxWHxB1Ryw==
Content-Disposition: inline
In-Reply-To: <20230606073950.225178-23-hch@lst.de>
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

On Tue, Jun 06, 2023 at 09:39:41AM +0200, Christoph Hellwig wrote:
> Instead of passing a fmode_t and only checking it fo0r FMODE_WRITE, pass
> a bool open_for_write to prepare for callers that won't have the fmode_t.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Looks good to me,
Acked-by: Christian Brauner <brauner@kernel.org>
