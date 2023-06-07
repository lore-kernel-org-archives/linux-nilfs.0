From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 27/31] block: remove unused fmode_t arguments
 from ioctl handlers
Date: Wed, 7 Jun 2023 15:10:29 +0200
Message-ID: <0cf31385-9b66-0b6b-bedf-bf83655f0535@suse.de>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-28-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
 From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=rZWSU5Z9qMHt0/gyIKUgr9UMvvpARxR+YB/aXbP2Iyk=; b=LWkgxnGTmn/fNyx8f804lFlMZD
 sFr7fINrImX1YYA2XnPPfPBk+m/lkCq6gGSqZegJTBvAgR9QX4A4/viiSmvY9vrwjbNHZyAraZ+XU
 03BhOkD/az/FT83Kiv1CoxVUJzfonssXp7undJxPKD9280xc+iZ1wXlljwIoCs4E0+9o=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:Cc:To:
 Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=rZWSU5Z9qMHt0/gyIKUgr9UMvvpARxR+YB/aXbP2Iyk=; b=OANJjzBZXI/EpksEQe8BOXU31K
 MZ2XIn65gwi6Q6RrK80d9yOa1mQO3gpMqfaEo3wyaWaL1pqgyNiFjURRzp+cT04Cn3jbzTxkgGLGk
 hu465tPeSNXF2joYUHA+Ws3l9CV1RKeBeb5Z9mAJFpoRwtilvcgXoDA9sLc0HUkkkNXg=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
 t=1686143429; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=rZWSU5Z9qMHt0/gyIKUgr9UMvvpARxR+YB/aXbP2Iyk=;
 b=SzVw5pIVskoOEcU+T6fSHN+tUWP8ala8evhn0s22EOIjNMtaz0NcYkSyRTpgx722yW0fl+
 elufGzpxdZjg/AzNdYwWg1bNyBWiPwpxdA9kLMW9WhSMVfwCWeXWc1PS4WbMT2CTP5qJ2U
 ricxZuh65D7Cafko7GHcNbwFqtI8DaE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
 s=susede2_ed25519; t=1686143429;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=rZWSU5Z9qMHt0/gyIKUgr9UMvvpARxR+YB/aXbP2Iyk=;
 b=yNAGgVRyMi0iZgOx+8DHCUDWiGOQrqvQzBZGU9FhvSd5P2WPLlOs9HTY4eBbWshtapSfSM
 x0i+NBgn0iRi3pDQ==
Content-Language: en-US
In-Reply-To: <20230606073950.225178-28-hch@lst.de>
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
> A few ioctl handlers have fmode_t arguments that are entirely unused,
> remove them.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   block/blk-zoned.c |  4 ++--
>   block/blk.h       |  6 +++---
>   block/ioctl.c     | 14 +++++++-------
>   3 files changed, 12 insertions(+), 12 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
