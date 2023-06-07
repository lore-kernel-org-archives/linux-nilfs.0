From: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 14/31] rnbd-srv: don't pass a holder for non-exclusive
 blkdev_get_by_path
Date: Wed, 7 Jun 2023 10:39:10 +0200
Message-ID: <20230607-deckname-gewettert-cf7a2bce127f@brauner>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-15-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686127163;
        bh=KpWcSBDck/xwxFkd8Vk7fAgf7Ve8mFKgiGPrEW6K2Q0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uA7EJ9P/L5+3z/cwnQO3ez6heNBOh2ztm0tByBVVVWSG+Ty9bViARmYghliiiTOjF
         zfyDKZ/WVZKnKqb27eoLFNy9Gp4VWJLbdFkpxtUdjTW1ihovnzx9mCqpvHlcVKl0Th
         Rf10QupAAvqzcAYZp+8tXsnFlejznxrDCiS1fwCDYebGVZXivhfNLwt2PfA+VtSam8
         pCcZzAUeaQGLwZNEeJwBUOIWm8QeGe+wPLl1Arn+PXC4T9/q84iyVBg8Og8sHsu9AC
         ymPxr4yq3cRtmcaUpMPCw2/GSyLHKDd4l8T1R7oWgm4TKIqgSNoA6xqMxcENCVvjqq
         jYZClevsYWR4w==
Content-Disposition: inline
In-Reply-To: <20230606073950.225178-15-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, "Md. Haris Iqbal" <haris.iqbal-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>, Jack Wang <jinpu.wang-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>, Phillip Potter <phil-j1cSt2lHDeZzjhtm8Ag3mw@public.gmane.org>, Coly Li <colyli-l3A5Bk7waGM@public.gmane.org>, Miquel Raynal <miquel.raynal-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, Vignesh Raghavendra <vigneshr-l0cyMroinI0@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, David Sterba <dsterba-IBi9RG/b67k@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-btrfs@vger.

On Tue, Jun 06, 2023 at 09:39:33AM +0200, Christoph Hellwig wrote:
> Passing a holder to blkdev_get_by_path when FMODE_EXCL isn't set doesn't
> make sense, so pass NULL instead.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---

Looks good to me,
Acked-by: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
