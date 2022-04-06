From: Alan.Robinson@fujitsu.com (Alan Robinson)
Subject: Re: [PATCH 15/27] block: use bdev_alignment_offset in
 part_alignment_offset_show
Date: Wed, 6 Apr 2022 09:04:46 +0200
Message-ID: <20220406070446.GA1722@ts.fujitsu.com>
References: <20220406060516.409838-1-hch@lst.de>
 <0b7ae3df301c4fdd8d37f773d8d1eb93@FR3P281MB0843.DEUP281.PROD.OUTLOOK.COM>
Reply-To: Alan.Robinson@fujitsu.com
Mime-Version: 1.0
Return-path: <xen-devel-bounces@lists.xenproject.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.xenproject.org/mailman/options/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xenproject.org>
List-Help: <mailto:xen-devel-request@lists.xenproject.org?subject=help>
List-Subscribe: <https://lists.xenproject.org/mailman/listinfo/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=subscribe>
Errors-To: xen-devel-bounces@lists.xenproject.org
Sender: "Xen-devel" <xen-devel-bounces@lists.xenproject.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
	s=170520fj; t=1649228714; i=@fujitsu.com;
	bh=05cGtA6yxrBEXr8TsKfNblRw+Bdby9YhP92PsT290U4=;
	h=Date:To:Cc:Subject:Message-ID:Reply-To:References:MIME-Version:
	 Content-Type:In-Reply-To:From;
	b=BJDFFQHg7gw8WYACPIsS5IO7QZ2Et0/snRy0O1P7sPcx3klPBjnAcFB0x5vQmkc7B
	 wdj7sgZsarcq07EkkN9Uk7cWaXRM4BHIkDNaIuDnoDW/xdWPN+yfeRQ0VLd0GPd0XX
	 YqbordNSTrdttI2gAjHO+G0BfdXM58RE64W8BbUe7mviFWROX5XjUVwj2GTsNCRtCK
	 2WJ4V8hKwe8nmUuYA+n39zIapfnu0J3NGApl7UCEEBLyvU7tS2BrmjwMlFpa9b2hDX
	 gUaY7GvBudukN14SBUkBadO1YF+sMHYk2wGdlkRTCLILZZ+pMjV2no6kK1JlP7i/NG
	 hrGSl+X1ARJQg==
Content-Disposition: inline
In-Reply-To: <0b7ae3df301c4fdd8d37f773d8d1eb93@FR3P281MB0843.DEUP281.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, "jfs-discussion@lists.sourceforge.net" <jfs-discussion@lists.sourceforge.net>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, "linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "cluster-devel@redhat.com" <cluster-devel@redhat.com>, "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vg>

Hi Christoph,

On Wed, Apr 06, 2022 at 06:05:04AM +0000, Christoph Hellwig wrote:
> From: Christoph Hellwig <hch@lst.de>
> Subject: [PATCH 15/27] block: use bdev_alignment_offset in
>  part_alignment_offset_show
> 
> Replace the open coded offset calculation with the proper helper.
> This is an ABI change in that the -1 for a misaligned partition is
> properly propagated, which can be considered a bug fix and maches

s/maches/matches/

> what is done on the whole device.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/partitions/core.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/block/partitions/core.c b/block/partitions/core.c
> index 2ef8dfa1e5c85..240b3fff521e4 100644
> --- a/block/partitions/core.c
> +++ b/block/partitions/core.c
> @@ -200,11 +200,7 @@ static ssize_t part_ro_show(struct device *dev,
>  static ssize_t part_alignment_offset_show(struct device *dev,
>  					  struct device_attribute *attr, char *buf)
>  {
> -	struct block_device *bdev = dev_to_bdev(dev);
> -
> -	return sprintf(buf, "%u\n",
> -		queue_limit_alignment_offset(&bdev_get_queue(bdev)->limits,
> -				bdev->bd_start_sect));
> +	return sprintf(buf, "%u\n", bdev_alignment_offset(dev_to_bdev(dev)));

Should this now be %d instead of %u, there are one or two examples of
both in the rest of the patch series.

Alan


