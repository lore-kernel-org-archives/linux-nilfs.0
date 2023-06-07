From: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 04/31] cdrom: remove the unused cdrom_close_write release
 code
Date: Wed, 7 Jun 2023 10:17:38 +0200
Message-ID: <20230607-rappen-balken-59ec17f7f4be@brauner>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-5-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686125871;
        bh=FLHaJwurOdg3CBBPpURcf+GsCLNx/2nTjrvXvxslLqM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Dz/r7loUmnTb2g2EAC3T7ceavY7IwvhOHPGEEibcPUxsJY6KC2gmPe0xcRQR21aSh
         olNDRKGuFSzVioAzLk1NChq/3z0NHm7Vb8vDNkiK+B7kEoqXVHZwbQsQb9GUVyxUve
         RId/Cr+X/EOu48m38E7bB05/uF21WKLwVvjG/co6Q0PlSjZO+rmoiwML2uoHT9cxWD
         1OqT9nE1/AKE9YWl0HRujjE29nTi5g5d0aWLmzBEbBGhWdue4NjhPdeUakeYnOt+OC
         WcNS0IQ/wY/XXkxplaeUBP2bDHV6G7BmhuQEPFAa5t9BmeAND50lnrKW69F6SPoN06
         nNrInpX+dlUDQ==
Content-Disposition: inline
In-Reply-To: <20230606073950.225178-5-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, "Md. Haris Iqbal" <haris.iqbal-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>, Jack Wang <jinpu.wang-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>, Phillip Potter <phil-j1cSt2lHDeZzjhtm8Ag3mw@public.gmane.org>, Coly Li <colyli-l3A5Bk7waGM@public.gmane.org>, Miquel Raynal <miquel.raynal-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, Vignesh Raghavendra <vigneshr-l0cyMroinI0@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, David Sterba <dsterba-IBi9RG/b67k@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-btrfs@vger.

On Tue, Jun 06, 2023 at 09:39:23AM +0200, Christoph Hellwig wrote:
> cdrom_close_write is empty, and the for_data flag it is keyed off is
> never set.  Remove all this clutter.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---

Looks good to me,
Acked-by: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
