From: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 29/31] block: always use I_BDEV on file->f_mapping->host
 to find the bdev
Date: Wed, 7 Jun 2023 15:11:34 +0200
Message-ID: <0ef858ca-47ab-f87d-5d0e-a4aba8175500@suse.de>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-30-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1686143498; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e0cFxh1b0vPfL/rSzMj9DwQLiKhQENV1tRoKyRIEveo=;
        b=nwo9UT6C59YRGHr90piEQwfLycTSG2Q6lo5CAcAMlT4us8gW9pJwdSVOHGuX7EeXDCGys1
        /mkYwE4HAwADtH8CTrqyTvQ6jRIZ1aUVuiUi7hsbWRiv7EnKe1h58wp2dSxHrEBHZwsv4z
        kS6kJA68/D1RCXRYDj0kbtxLmuYq0hM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1686143498;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e0cFxh1b0vPfL/rSzMj9DwQLiKhQENV1tRoKyRIEveo=;
        b=DBKoPEarqt2dV7eJVJ7UZXeXIzMiKgUhj68udOgVVvFiO46cfK8CxabeXlK6HYRl77NZGq
        myCjmvQZP/1XYzAw==
Content-Language: en-US
In-Reply-To: <20230606073950.225178-30-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, "Md. Haris Iqbal" <haris.iqbal-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>, Jack Wang <jinpu.wang-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>, Phillip Potter <phil-j1cSt2lHDeZzjhtm8Ag3mw@public.gmane.org>, Coly Li <colyli-l3A5Bk7waGM@public.gmane.org>, Miquel Raynal <miquel.raynal-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, Vignesh Raghavendra <vigneshr-l0cyMroinI0@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, David Sterba <dsterba-IBi9RG/b67k@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org

On 6/6/23 09:39, Christoph Hellwig wrote:
> Always use I_BDEV(file->f_mapping->host) to find the bdev for a file to
> free up file->private_data for other uses.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---
>   block/fops.c | 18 ++++++++----------
>   1 file changed, 8 insertions(+), 10 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>

Cheers,

Hannes

