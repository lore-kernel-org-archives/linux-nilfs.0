From: Anand Jain <anand.jain@oracle.com>
Subject: Re: [PATCH 08/27] btrfs: use bdev_max_active_zones
 instead of open coding it
Date: Tue, 19 Apr 2022 20:02:18 +0800
Message-ID: <530b0d48-96fc-e157-38f5-a87d85c7d2c6@oracle.com>
References: <20220415045258.199825-1-hch@lst.de>
 <20220415045258.199825-9-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=MIME-Version:Content-Transfer-Encoding:Content-Type
 :In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Sender:Reply-To:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=QL9zAEXce69OmwiuUcwiOZYD9isqw84nxmQFM4fYLsk=; b=HCFNW/MNIDP9c8G83Qw4n06v2G
 zfwn/RIUUSbmLUiNTjQj7474mjY/oAcJifTTJaT8fORgqfg/WdCdo3EtV+7dRXQ9941zwY4cVidbN
 VRWLP+B0Z7XXHi6wx+IWLCxhqcjIaLJcDtuyb10XOhXygf5gSllVntE8Oezx4ZfRrI98=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=MIME-Version:Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
 References:Cc:To:Subject:Date:Message-ID:Sender:Reply-To:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=QL9zAEXce69OmwiuUcwiOZYD9isqw84nxmQFM4fYLsk=; b=V8VHep7Levjm18kiDiyptq16f1
 zacyTxbwXSDQEqIUVbyyziNc+2m8p+Z6NOyhccXp7ooxUhJ+eV8Eg/+cgyL934VbbCwcHTkF1ETvz
 1GhAcb3A6CbzJDMottXpqvNtiohagDm63oQfE3/LrRbvB4vP1WpIisuGXZGtBcA/xnqQ=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
 h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=QL9zAEXce69OmwiuUcwiOZYD9isqw84nxmQFM4fYLsk=;
 b=tYv38/gUZGvY8Q0ZcvGgatPdfoez9sVIV8bC4fBr8Pqf8t4feErmToGS0FLdSqUeRoFZ
 dBiAhV1/gugjQ8Q+GsESK60oyrqa6LpMRyFVZ9foHOnTx+t8V3gl8NfK3XoEdhPv17LF
 NweEH2a3vChBkZiccHaTLeqUvTpY03+bKMQGYaQ12ckgSWPl5pUK5KsWLgwqHSGUiDj2
 0kgG+neCjqWWbVTD18nHFSjJYAxyTXzkUPJntA58YhdwZcEb9ZlZVhpLHXxhY4djjEP6
 NfAyU8bpRJG2F7ix/eGzB+R25mqyYKtPHmV/fkjAj1cJnn9659Z2MswMUQT0Iqj3A/sc qw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QL9zAEXce69OmwiuUcwiOZYD9isqw84nxmQFM4fYLsk=;
 b=zxdzb2HTii8g58+L1L83JBE90J7uRfh1GJLoCuEJKgIdo1IdIl/XZ3aGP6rfcaeLftjVwst+5/ykLP4HQV1/EVBpngk/xCYcaMQoN/M+j/NYcPOVH32bkxdneSP2GzaxmQ02HpVRMbyiVw0uKPwpoIGMwDBIo2fixchDtRE2V1Y=
In-Reply-To: <20220415045258.199825-9-hch@lst.de>
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
Cc: jfs-discussion@lists.sourceforge.net, linux-nvme@lists.infradead.org, virtualization@lists.linux-foundation.org, linux-mm@kvack.org, dm-devel@redhat.com, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, drbd-dev@lists.linbit.com, linux-s390@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, cluster-devel@redhat.com, xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org, linux-um@lists.infradead.org, nbd@other.debian.org, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, David Sterba <dsterba@suse.com>, ceph-devel@vger.kernel.org, linux-raid@vger.kernel.org, Johannes Thumshirn <johannes.thumshirn@wdc.com>, linux-mmc@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, ntfs3@lists.linux.dev, linux-btrfs@vger.kernel.org

On 4/15/22 12:52, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Acked-by: David Sterba <dsterba@suse.com>

LGTM.

Reviewed-by: Anand Jain <anand.jain@oracle.com>


> ---
>   fs/btrfs/zoned.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index 1b1b310c3c510..f72cad7391a11 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -350,7 +350,6 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
>   	struct btrfs_fs_info *fs_info = device->fs_info;
>   	struct btrfs_zoned_device_info *zone_info = NULL;
>   	struct block_device *bdev = device->bdev;
> -	struct request_queue *queue = bdev_get_queue(bdev);
>   	unsigned int max_active_zones;
>   	unsigned int nactive;
>   	sector_t nr_sectors;
> @@ -410,7 +409,7 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
>   	if (!IS_ALIGNED(nr_sectors, zone_sectors))
>   		zone_info->nr_zones++;
>   
> -	max_active_zones = queue_max_active_zones(queue);
> +	max_active_zones = bdev_max_active_zones(bdev);
>   	if (max_active_zones && max_active_zones < BTRFS_MIN_ACTIVE_ZONES) {
>   		btrfs_err_in_rcu(fs_info,
>   "zoned: %s: max active zones %u is too small, need at least %u active zones",
