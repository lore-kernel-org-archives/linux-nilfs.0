From: Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 06/31] cdrom: remove the unused mode argument to
 cdrom_release
Date: Wed, 7 Jun 2023 10:20:08 +0200
Message-ID: <20230607-beulen-infiltrieren-4cacf9083274@brauner>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-7-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686126016;
        bh=JsXN/EIW6Kqwigw4wGGVknucfkdIsZm79w1pPIMczSI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hPo1mXkKxFqrFJbgKtNEIt5ZHiTabb37wMXxLRAIeNRno5DR3AAGuKjp93g16mzBl
         /3CNbG6uWs3WhElMnvwbqhmSsjjMwZfwrvzM8T673tQGiHisyduOo/76UvFPx8vWHx
         9lzYUK3IeThBOk9/FedNGybyiwR4Gdt72t9wwPv9e2CIKHXV4qq0pTv7B7QX81SLyf
         Iw3ISSaMn4rNIW1sjHFDtLvoDLYD8pYgZXmzPWirpoHmn5112xh4jwvgTxtmQ6Wuk2
         8Bh4MVxCgMvJMsNDaUbaU0No+32RJCdez5rEuCBZAIC/6oUb+6u9qKz1t5j/Vvz6mQ
         GPTyAfGP21eBA==
Content-Disposition: inline
In-Reply-To: <20230606073950.225178-7-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Richard Weinberger <richard@nod.at>, Josef Bacik <josef@toxicpanda.com>, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>, Phillip Potter <phil@philpotter.co.uk>, Coly Li <colyli@suse.de>, Miquel Raynal <miquel.raynal@bootlin.com>, Vignesh Raghavendra <vigneshr@ti.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@ucw.cz>, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-um@lists.infradead.org, linux-scsi@vger.kernel.org, linux-bcache@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org, linux-btrfs@vger.

On Tue, Jun 06, 2023 at 09:39:25AM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Looks good to me,
Acked-by: Christian Brauner <brauner@kernel.org>
