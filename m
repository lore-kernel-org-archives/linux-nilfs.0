From: Keith Busch <kbusch-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 21/30] nvme: replace the fmode_t argument to the nvme
 ioctl handlers with a simple bool
Date: Fri, 9 Jun 2023 09:49:53 -0600
Message-ID: <ZINKIQbBc0MB9wRz@kbusch-mbp>
References: <20230608110258.189493-1-hch@lst.de>
 <20230608110258.189493-22-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686325797;
        bh=0OnG4BzavkIkRsoSKPQtFcsTzHVmQDZ4N5dtwuYHgN0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NHtOuYp0TmsS9C41zBB8bRnNowLvmEqTLajK40KrGYXbNtm+pGnwaZIgRwj7VkfF6
         ToT8ZkmVhHIYZITuzZR8dQwIKnvzyfbSqu3MTnPYi2yHHrCzSD4+fIyFK5IRer3XSE
         XP1/X6pcw/4xghZaL8LBbcBoazv3n/axO9Egj4JkEQopsHm5F28FzihGpJtB/yUnWf
         u498nYtGJPusyoaO38WDi7BxJhU0L9Jzdyc15SGKMxUEIq6a91z46ZPKQW9cNiYeTw
         fctvLRTOSN3cJGWM77Zf1OWNHYkAvGdXMKCYo1D/Qj6F/3niSHHWcYC4L/fFNtQiR2
         L5jLwoeehBLHg==
Content-Disposition: inline
In-Reply-To: <20230608110258.189493-22-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, "Md. Haris Iqbal" <haris.iqbal-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>, Jack Wang <jinpu.wang-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>, Phillip Potter <phil-j1cSt2lHDeZzjhtm8Ag3mw@public.gmane.org>, Coly Li <colyli-l3A5Bk7waGM@public.gmane.org>, Miquel Raynal <miquel.raynal-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, Vignesh Raghavendra <vigneshr-l0cyMroinI0@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, David Sterba <dsterba-IBi9RG/b67k@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-nvm

Looks good.

Reviewed-by: Keith Busch <kbusch-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
