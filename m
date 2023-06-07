From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 03/31] cdrom: remove the unused mode argument
 to cdrom_ioctl
Date: Wed, 7 Jun 2023 14:11:34 +0200
Message-ID: <9012d5ed-efdd-d815-9639-399a94d82e47@suse.de>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-4-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
 From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=ln4uPJZZYujUTuPYse+Ci58P2Zbqby7FQD2rrhzzqiA=; b=evYVc7yOTJq2ZsmOonPt6mk17Y
 qx2Uy91w+Bs+nhrEH5Czs9OyKqcejoSnuGx2NYTi1lf66O1Z+tjuFfNJhf0SlQrDn1utNHJIAeEP+
 hWiqucukD2cdngGA+dCVXKzeD7vJM9spgWl17pItL91BquxBBs/GE2+qHJQll04IkfnM=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:Cc:To:
 Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=ln4uPJZZYujUTuPYse+Ci58P2Zbqby7FQD2rrhzzqiA=; b=g7rLmIUE7kOQfyrfSsQz8Bm24t
 vhdsUEPLuFyBmkGlU9dmKiznJIxxocZsLJ4nDZ94dMErkI92cdOseiCw68h9MTpk9Oll8tbV/kf0r
 uJO7tlMnwYyENGhxRPq0mrZNTN7SXMzhRmjXLfKGv2GCnnCRGqVeY21z+Cxs1C+LSZ64=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
 t=1686139894; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=ln4uPJZZYujUTuPYse+Ci58P2Zbqby7FQD2rrhzzqiA=;
 b=gRj7eFQi64+1VPXFyF+L9JnvIFbsTk9fHtA6QKF5ZyirxRt3g8vglcjJaF15rWbQsoeDmq
 zQ51Luk+ad/my7thjjoGvOMUyor7edJAkZl8Db81G1zCIcMCzwzNAx78UJ33Q5RjKw+yim
 DzzHK13ZqzKhfqc8r6AdWD/OdQgDXaU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
 s=susede2_ed25519; t=1686139894;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=ln4uPJZZYujUTuPYse+Ci58P2Zbqby7FQD2rrhzzqiA=;
 b=HVXnk9KoUSNBLys1M+OgZDBIwXMEkWpBJH3bsWQS7u3TmkvpIOszbyVJ0IB1Nu76jyoSlA
 kJCbmnNR6u/DzeAw==
Content-Language: en-US
In-Reply-To: <20230606073950.225178-4-hch@lst.de>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Vignesh Raghavendra <vigneshr@ti.com>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-nvme@lists.infradead.org, Phillip Potter <phil@philpotter.co.uk>, Chris Mason <clm@fb.com>, dm-devel@redhat.com, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>, Jack Wang <jinpu.wang@ionos.com>, linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, Richard Weinberger <richard@nod.at>, linux-pm@vger.kernel.org, linux-um@lists.infradead.org, Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, Christian Brauner <brauner@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.

On 6/6/23 09:39, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/cdrom/cdrom.c | 2 +-
>   drivers/cdrom/gdrom.c | 2 +-
>   drivers/scsi/sr.c     | 2 +-
>   include/linux/cdrom.h | 4 ++--
>   4 files changed, 5 insertions(+), 5 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
