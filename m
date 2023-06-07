From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 08/31] block: share code between disk_check_media_change
 and disk_force_media_change
Date: Wed, 7 Jun 2023 14:19:00 +0200
Message-ID: <30183892-dce6-6946-2f7a-1bc693a657a2@suse.de>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-9-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1686140340; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B3Xg67NbOS5YKdaySGyicbSsoGzlBjyHFHEFD4Mj8fk=;
        b=Zf8A5Tyivs1LBVr9z9fcut+KsQs3kcPY5GvqULx5P0MxaNd5oWQGh+1UzbHH7L+ejvrrTh
        JDmnIQJNe0G+Z00BxJB1bq4IRuImozBYRQpd4LwynxswtstxT9j1wT23SZh+ZR9kxi9nY9
        fU/9FYrR7hcLl9YyuWLg9NqNhV/Ku4o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1686140340;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B3Xg67NbOS5YKdaySGyicbSsoGzlBjyHFHEFD4Mj8fk=;
        b=eV5SDjF+54GbLqg30Fap2sfm11c6Xv616rnS3/fxtHlHOpZy29z55XNlWk4So5K2w2nPsG
        Z+0rka3GXG+V67DA==
Content-Language: en-US
In-Reply-To: <20230606073950.225178-9-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Richard Weinberger <richard@nod.at>, Josef Bacik <josef@toxicpanda.com>, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>, Phillip Potter <phil@philpotter.co.uk>, Coly Li <colyli@suse.de>, Miquel Raynal <miquel.raynal@bootlin.com>, Vignesh Raghavendra <vigneshr@ti.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@ucw.cz>, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-um@lists.infradead.org, linux-scsi@vger.kernel.org, linux-bcache@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org

On 6/6/23 09:39, Christoph Hellwig wrote:
> Factor the common logic between disk_check_media_change and
> disk_force_media_change into a helper.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   block/disk-events.c | 37 ++++++++++++++++---------------------
>   1 file changed, 16 insertions(+), 21 deletions(-)
> 
> diff --git a/block/disk-events.c b/block/disk-events.c
> index 8b1b63225738f8..06f325662b3494 100644
> --- a/block/disk-events.c
> +++ b/block/disk-events.c
> @@ -262,6 +262,18 @@ static unsigned int disk_clear_events(struct gendisk *disk, unsigned int mask)
>   	return pending;
>   }
>   
> +static bool __disk_check_media_change(struct gendisk *disk, unsigned int events)
> +{
> +	if (!(events & DISK_EVENT_MEDIA_CHANGE))
> +		return false;
> +
> +	if (__invalidate_device(disk->part0, true))
> +		pr_warn("VFS: busy inodes on changed media %s\n",
> +			disk->disk_name);
> +	set_bit(GD_NEED_PART_SCAN, &disk->state);
> +	return true;
> +}
> +
>   /**
>    * disk_check_media_change - check if a removable media has been changed
>    * @disk: gendisk to check
> @@ -274,18 +286,9 @@ static unsigned int disk_clear_events(struct gendisk *disk, unsigned int mask)
>    */
>   bool disk_check_media_change(struct gendisk *disk)
>   {
> -	unsigned int events;
> -
> -	events = disk_clear_events(disk, DISK_EVENT_MEDIA_CHANGE |
> -				   DISK_EVENT_EJECT_REQUEST);
> -	if (!(events & DISK_EVENT_MEDIA_CHANGE))
> -		return false;
> -
> -	if (__invalidate_device(disk->part0, true))
> -		pr_warn("VFS: busy inodes on changed media %s\n",
> -			disk->disk_name);
> -	set_bit(GD_NEED_PART_SCAN, &disk->state);
> -	return true;
> +	return __disk_check_media_change(disk,
> +			disk_clear_events(disk, DISK_EVENT_MEDIA_CHANGE |
> +						DISK_EVENT_EJECT_REQUEST));

Can you move the call to disk_clear_events() out of the call to 
__disk_check_media_change()?
I find this pattern hard to read.

Cheers,

Hannes

