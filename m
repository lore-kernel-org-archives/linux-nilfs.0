From: Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 05/31] cdrom: track if a cdrom_device_info was opened for
 data
Date: Wed, 7 Jun 2023 10:19:42 +0200
Message-ID: <20230607-partner-reglos-2f455e85a92d@brauner>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-6-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686125990;
        bh=bhPEUNqU+a2RwajMYr10YcQod7uo6bRu9m8nbjZC/X8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T2/u0lK/T6IWNZ+74l+9xHgTu/SF71BRHS/uLEpwZBctcy5g8KGrH6gP/Ho0QQKln
         5qkVKhsk7HlZgAqdQwLM1MIiEl6T/QfH4Ibv/L9h2nM3uwvE54+8KmZ0oLxbsO91QN
         hJRwkk/SieajEKOPcGTHaPk2IFlWpwOa2o2z8DAbcDtcM0cAx07db21Whr6OXZ5ZV2
         j/A0q/XxqVSyk/ZxvJ6AiO8N7bjJJoxe6noi88aFL+OI6FYAwAx3O4cBH7LUNE3N9k
         tD6Zf/uIvK8Pey+p3eQ9mrIlH9DqCvuU78zpoxTca2sOrNt1KvG2oPvhygH2k33jwn
         T5lWAZbVwKRIQ==
Content-Disposition: inline
In-Reply-To: <20230606073950.225178-6-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Richard Weinberger <richard@nod.at>, Josef Bacik <josef@toxicpanda.com>, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>, Phillip Potter <phil@philpotter.co.uk>, Coly Li <colyli@suse.de>, Miquel Raynal <miquel.raynal@bootlin.com>, Vignesh Raghavendra <vigneshr@ti.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@ucw.cz>, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-um@lists.infradead.org, linux-scsi@vger.kernel.org, linux-bcache@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org, linux-btrfs@vger.

On Tue, Jun 06, 2023 at 09:39:24AM +0200, Christoph Hellwig wrote:
> Set a flag when a cdrom_device_info is opened for writing, instead of
> trying to figure out this at release time.  This will allow to eventually
> remove the mode argument to the ->release block_device_operation as
> nothing but the CDROM drivers uses that argument.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Looks good to me,
Acked-by: Christian Brauner <brauner@kernel.org>
