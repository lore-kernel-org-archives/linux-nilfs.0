From: Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 01/31] block: also call ->open for incremental partition
 opens
Date: Wed, 7 Jun 2023 10:14:22 +0200
Message-ID: <20230607-behelfen-abnormal-8ccf8e1e99c9@brauner>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-2-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686125670;
        bh=OikN0V0gAjgBP+HPzDoTzlQuNrCoReKL8FDM6o8SWL4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LoOtwMsbiODoiTDBOlhy9h+NcaXo/0ty0ho40m0mYf7Tqj+wr2dJZ7vUbOn0Kz7GP
         33AzVbFt/SH4ZtCqtGcyP4wx2pNr5qeOSz7n5llnvQzbkevHbUBwUChjs8tVFu+w+7
         9qFZdhkREWPfruOfyuYqVKvgknYU35bmYym5jzuvpMGmp93SMTqsZWFeVhyuiwJkrs
         LAwyIzU/+kVumnYrd9shzRES4ZrZYHJo9QZXt+wC4ujn3BMrp977Z7B0LOqc0LVlBz
         8OgzOnLLMWqPSlcCNiFoGKY+/fwNpasAfTm2ssRASquxyIwPgu3PSIm5oXJID8PKnw
         l3rqMIfCwdUgQ==
Content-Disposition: inline
In-Reply-To: <20230606073950.225178-2-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Richard Weinberger <richard@nod.at>, Josef Bacik <josef@toxicpanda.com>, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>, Phillip Potter <phil@philpotter.co.uk>, Coly Li <colyli@suse.de>, Miquel Raynal <miquel.raynal@bootlin.com>, Vignesh Raghavendra <vigneshr@ti.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@ucw.cz>, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-um@lists.infradead.org, linux-scsi@vger.kernel.org, linux-bcache@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org, linux-btrfs@vger.

On Tue, Jun 06, 2023 at 09:39:20AM +0200, Christoph Hellwig wrote:
> For whole devices ->open is called for each open, but for partitions it
> is only called on the first open of a partition.  This is problematic
> as various block drivers look at open flags and might not do all setup
> for ioctl only or NDELAY opens.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

This assumes that all drivers deal with additional ->open() calls for
each partition correctly which I assumed you checked so,
Acked-by: Christian Brauner <brauner@kernel.org>
