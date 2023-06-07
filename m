From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 15/31] btrfs: don't pass a holder for non-exclusive
 blkdev_get_by_path
Date: Wed, 7 Jun 2023 15:32:53 +0200
Message-ID: <20230607133253.GO25292@twin.jikos.cz>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-16-hch@lst.de>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Return-path: <linux-bcache-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1686145149;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kvX+K1GPLsIpoFmWJX2s5gmxPQdlBYXQkV75nn7bEZM=;
        b=QMstqGgedcYgY/d/rSGDFDlChRste65gtAtzSH+mlxXl5vEtulOq2TI/sCACizK7l4xAIA
        Zug8XKFA7SpEs+Tfusy0dW9TRY25HOfO+RBfFn6tbKVwi3s66msfhIUZOO9bDHcakuZnvK
        aOdFM2BAbO6jcrNhKt6b1QqrvqZHki4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1686145149;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kvX+K1GPLsIpoFmWJX2s5gmxPQdlBYXQkV75nn7bEZM=;
        b=wiFEvVZJSCbh6tVWyAuV/c0zFOWqBvdMPHB2HTHPCfNySm7jDxfJJMoNpYlbzC7zNnQARu
        aZxg6KqpACFRuUAg==
Content-Disposition: inline
In-Reply-To: <20230606073950.225178-16-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Richard Weinberger <richard@nod.at>, Josef Bacik <josef@toxicpanda.com>, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>, Phillip Potter <phil@philpotter.co.uk>, Coly Li <colyli@suse.de>, Miquel Raynal <miquel.raynal@bootlin.com>, Vignesh Raghavendra <vigneshr@ti.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@ucw.cz>, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-um@lists.infradead.org, linux-scsi@vger.kernel.org, linux-bcache@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvm

On Tue, Jun 06, 2023 at 09:39:34AM +0200, Christoph Hellwig wrote:
> Passing a holder to blkdev_get_by_path when FMODE_EXCL isn't set doesn't
> make sense, so pass NULL instead and remove the holder argument from the
> call chains the only end up in non-FMODE_EXCL blkdev_get_by_path calls.

Please add

"Exclusive mode for device scanning is not used since 50d281fc434c
 ("btrfs: scan device in non-exclusive mode")."

Acked-by: David Sterba <dsterba@suse.com>
