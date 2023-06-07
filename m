From: Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 15/31] btrfs: don't pass a holder for non-exclusive
 blkdev_get_by_path
Date: Wed, 7 Jun 2023 10:40:40 +0200
Message-ID: <20230607-dagegen-bandmitglieder-427b6130afcf@brauner>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-16-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686127249;
        bh=rzaXCmDshhO+LXHkp8rQmS2hilpXNGYeK30nLPS+yX4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fdSp6N+EchetyNQ9ELQAK0k0bpXVcnAL/B1ILfEopTiSUxSrqA68P9/6Fq9lp/rvs
         0PdaFTqQtL7hh+98jKmzKvAI22ckdJ6mpUM7tqdfwc59mGXZfc2UZr3+kEZoNF9iCd
         rNsY4NJ5wPvPPksQ43AYSH5CsJ9ZZPwPKOSRaPn/FQxz7WMErUvxKsWGr8EuIBUbUv
         GCwjEeBpBb8r5ert952BDHGVamNUJ1fc0KErTkK5SXMdqq0Lpyjam5mGL+HGGvKta5
         OZuoqYdC2LP3lItmJ9t7Vn/pgmrJbGFIX1uT/KEmFPNjK+eme8JXQdHwUEcehzKecl
         PsM6nqwDiF4Hg==
Content-Disposition: inline
In-Reply-To: <20230606073950.225178-16-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Richard Weinberger <richard@nod.at>, Josef Bacik <josef@toxicpanda.com>, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>, Phillip Potter <phil@philpotter.co.uk>, Coly Li <colyli@suse.de>, Miquel Raynal <miquel.raynal@bootlin.com>, Vignesh Raghavendra <vigneshr@ti.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@ucw.cz>, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-um@lists.infradead.org, linux-scsi@vger.kernel.org, linux-bcache@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org, linux-btrfs@vger.

On Tue, Jun 06, 2023 at 09:39:34AM +0200, Christoph Hellwig wrote:
> Passing a holder to blkdev_get_by_path when FMODE_EXCL isn't set doesn't
> make sense, so pass NULL instead and remove the holder argument from the
> call chains the only end up in non-FMODE_EXCL blkdev_get_by_path calls.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Looks good to me,
Acked-by: Christian Brauner <brauner@kernel.org>
