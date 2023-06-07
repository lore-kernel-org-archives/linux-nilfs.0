From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 06/31] cdrom: remove the unused mode argument to
 cdrom_release
Date: Wed, 7 Jun 2023 14:14:10 +0200
Message-ID: <e9817476-c4a4-daa3-5855-1cad65f34702@suse.de>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-7-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1686140051; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RbDdkBkAkihlvgimUEyqaDFQQ7hWsta3TpQfoTGouF4=;
        b=YcolPPrC7jE6w3Zyqtw/FMFFlvUTz+YgmXz15Y/Ja5pGbYcQOI2xWKpEk6rOkAGv4OEQOe
        GUHXGoC7dkbxH62fllqUSMkwEBzB9qfyJl+oVpr4TOfBAt0t4eLEElqNjd3xnhlOocxLsj
        cB70lchn4Bjk/oeQCWvsAfXocb0270I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1686140051;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RbDdkBkAkihlvgimUEyqaDFQQ7hWsta3TpQfoTGouF4=;
        b=u60i6Cv0BWCHzE4lMuQ5hya3mWAVv5LUT6kBJLXzktzjRnyf9Hn68uapE1JN/pfx1XLC7b
        BcGGQlzMBD2ak5AQ==
Content-Language: en-US
In-Reply-To: <20230606073950.225178-7-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Richard Weinberger <richard@nod.at>, Josef Bacik <josef@toxicpanda.com>, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>, Phillip Potter <phil@philpotter.co.uk>, Coly Li <colyli@suse.de>, Miquel Raynal <miquel.raynal@bootlin.com>, Vignesh Raghavendra <vigneshr@ti.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@ucw.cz>, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-um@lists.infradead.org, linux-scsi@vger.kernel.org, linux-bcache@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org

On 6/6/23 09:39, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/cdrom/cdrom.c | 2 +-
>   drivers/cdrom/gdrom.c | 2 +-
>   drivers/scsi/sr.c     | 2 +-
>   include/linux/cdrom.h | 2 +-
>   4 files changed, 4 insertions(+), 4 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes

