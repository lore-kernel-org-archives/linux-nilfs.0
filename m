From: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 07/31] block: pass a gendisk on bdev_check_media_change
Date: Wed, 7 Jun 2023 10:25:14 +0200
Message-ID: <20230607-chefsessel-angeordnet-269f0596f9b3@brauner>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-8-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686126322;
        bh=MlK8ImDSCelGPFiPL92Uyz1xTZjxqRsNNJXefAB4RxA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RJVQ7IElXButGpfihgaGTsX+x2U783OB0x7LjcjEuzbvCprkRssPlCqitXbv2qS80
         7bXHij0rDiyQmVWntSpVgswo1pyplWiVLnxddjl4YEuW7xtVVHP1gtfSYDSzKshjbd
         cg5VxGDoq3Sq//o6lEqRihRJL3wnpkC2VFrT+3tRPyfE8Rm3QEIGgrc8Zst/2xza1A
         1dLzlcWhE45pPOZvKsENsCth7zzXVyiw7PbzjT4UN+wZmWKKt2oJ6bg8vrxwu+KR+0
         hQ+ZzeZhWReHgfkAb9X57t7f3jFG0+rfua8y05NfHnXWIf5wyGJUIy3C7/vBVqlnz+
         EWD5OnJTGdrhQ==
Content-Disposition: inline
In-Reply-To: <20230606073950.225178-8-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, "Md. Haris Iqbal" <haris.iqbal-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>, Jack Wang <jinpu.wang-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>, Phillip Potter <phil-j1cSt2lHDeZzjhtm8Ag3mw@public.gmane.org>, Coly Li <colyli-l3A5Bk7waGM@public.gmane.org>, Miquel Raynal <miquel.raynal-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, Vignesh Raghavendra <vigneshr-l0cyMroinI0@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, David Sterba <dsterba-IBi9RG/b67k@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-btrfs@vger.

On Tue, Jun 06, 2023 at 09:39:26AM +0200, Christoph Hellwig wrote:
> bdev_check_media_change should only ever be called for the whole device.
> Pass a gendisk to make that explicit and rename the function to
> disk_check_media_change.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---

Under the assumption it did only in fact ever only get called on the
whole device so far,
Acked-by: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
