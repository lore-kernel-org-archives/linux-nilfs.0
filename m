From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 21/31] scsi: replace the fmode_t argument to ->sg_io_fn
 with a simple bool
Date: Wed, 7 Jun 2023 15:05:44 +0200
Message-ID: <99fc97ec-45ed-7dcf-e53f-e14c8831e678@suse.de>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-22-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1686143144; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u6+vpKfau0iKqyo79MzZYvFgo2CWRimrv/MEFMfrr24=;
        b=fpyIDozRfR7Cw5m06Ago2OaY4vdqSadihaZ5yyCOf6Kte48Hg2kKTnOyYPGeQZe44HLFDq
        s6HTof/SA8wZCUu9OFNTDHJFXBqLWBL4GN/FCRwcp4Jn7Mdc0a0G5cBqpsPjqNn7SV3BhS
        bX1WwtlSqwCJfLNgkkDWf1hnAp4Acrs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1686143144;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u6+vpKfau0iKqyo79MzZYvFgo2CWRimrv/MEFMfrr24=;
        b=469Bq6Wif5eIWsabvA+s5g95VvmQctUcubNCWgwGeYHM4htPaM0E32GlVKkGZ0MPLthDEA
        VCex8psY6mgl5jCg==
Content-Language: en-US
In-Reply-To: <20230606073950.225178-22-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Richard Weinberger <richard@nod.at>, Josef Bacik <josef@toxicpanda.com>, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>, Phillip Potter <phil@philpotter.co.uk>, Coly Li <colyli@suse.de>, Miquel Raynal <miquel.raynal@bootlin.com>, Vignesh Raghavendra <vigneshr@ti.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@ucw.cz>, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-um@lists.infradead.org, linux-scsi@vger.kernel.org, linux-bcache@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org

On 6/6/23 09:39, Christoph Hellwig wrote:
> Instead of passing a fmode_t and only checking it for FMODE_WRITE, pass
> a bool open_for_write to prepare for callers that won't have the fmode_t.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   block/bsg-lib.c         | 2 +-
>   block/bsg.c             | 8 +++++---
>   drivers/scsi/scsi_bsg.c | 4 ++--
>   include/linux/bsg.h     | 2 +-
>   4 files changed, 9 insertions(+), 7 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes

