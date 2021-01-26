From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Subject: Re: [PATCH 02/17] btrfs: use bio_kmalloc in
 __alloc_device
Date: Tue, 26 Jan 2021 19:11:18 +0000
Message-ID: <BYAPR04MB4965808085867317CEDE615186BC9@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210126145247.1964410-1-hch@lst.de>
 <20210126145247.1964410-3-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=MIME-Version:Content-Transfer-Encoding:Content-Type
 :References:Message-ID:Date:Subject:CC:To:From:Sender:Reply-To:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:In-Reply-To:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=qycwswdKEkfSrfBGHipxmgVrIyfCcU42WNDTcdPx4d0=; b=FoP05sCVLRx5OM3u60mossDcH9
 Vd7IM2PjX3oYt/IqL4tIT1hfLxNMweVZ68R+zzBDjgjdmPeRhMsNd6jLUEaISRiTDMdKaLkqWzCh5
 NlLiIJZgcR28+r9M937WemDcaBef3nTNKT83uZIeWp3JZr55iTA2FXgGmIGybT2wey6c=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:Message-ID
 :Date:Subject:CC:To:From:Sender:Reply-To:Content-ID:Content-Description:
 Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
 In-Reply-To:List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:
 List-Owner:List-Archive; bh=qycwswdKEkfSrfBGHipxmgVrIyfCcU42WNDTcdPx4d0=; b=a
 aJQatxRI1jqepW4MlpodnSfib0h5fpE/yfGXdQYnAbP9BGilq98KLoW/fDFQK9zJn2CG96v7b5vox
 o3eHpiXmsjCu9j8Vh3Jd5jyqZoPJFjVIiFh2ZEwVQvoDyJpc3YSQmiuxt3g4tdCRZ89U+k1OZRv+e
 vgEByY6QbVIVm12A=;
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
 d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
 t=1611688293; x=1643224293;
 h=from:to:cc:subject:date:message-id:references:
 content-transfer-encoding:mime-version;
 bh=qycwswdKEkfSrfBGHipxmgVrIyfCcU42WNDTcdPx4d0=;
 b=nv381jdnD5PVXteNA1pnmlTphGQP4HlBwOcS3R1zIiv3MqMZ6+ZrmLSt
 1kLYJzvEKZoJOr3su9MDUNp8YrMm+RKCWI8qpdL9Q25vbaDq7RnmDRjCW
 XeJOwFuQQ3cvzff/dZdcINzxt6BVBAhyWmSLayM8y4rXHmc+J2viLQNEr
 I+Vz9MtvXbI7BAU25kYh81MpS1CVKCNtr26caYLjUdWAGtOOt+X4LlErX
 Cd/hm1eFyvrxgqxZ7C/PXryAI0FikELbpQKFPiK3YhxmGSDUmn33B7juq
 9Y1qeFEMOBNKQuSxzUTNe+DUpEgDVFAA9wT0qUpieZNaoi59KsW5hjRdM A==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qycwswdKEkfSrfBGHipxmgVrIyfCcU42WNDTcdPx4d0=;
 b=PrVh+41fYjjTea3vPDoMebpSZh/LOBX+Wy5D7i2YyXFwnEktcnu04SFNCPZgwromMFrPzERw99RGdu2i3N+UOCF33YF6Gnm289xkUWn7uihL6uhwqUolBOdp661zHcnM7MY+4INjSee6xVFJa4rizpquDOZIx8NDnbSCYPpAdfs=
Content-Language: en-US
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>
Cc: Mike Snitzer <snitzer@redhat.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, Naohiro Aota <Naohiro.Aota@wdc.com>, "linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>, Josef Bacik <josef@toxicpanda.com>, "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>, Coly Li <colyli@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, David Sterba <dsterba@suse.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, Andrew Morton <akpm@linux-foundation.org>, Philipp Reisner <philipp.reisner@linbit.com>, "linux-f2fs-devel@lists.sourceforge.net" <linux-f2fs-deve>

On 1/26/21 7:04 AM, Christoph Hellwig wrote:
> Use bio_kmalloc instead of open coding it.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
Looks good.

Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
