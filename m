From: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Ocfs2-devel] [PATCH 13/27] block: add a
	bdev_stable_writes helper
Date: Wed, 06 Apr 2022 23:18:21 -0400
Message-ID: <yq1mtgxintf.fsf@ca-mkp.ca.oracle.com>
References: <20220406060516.409838-1-hch@lst.de>
	<20220406060516.409838-14-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
	h=to : cc : subject :
	from : message-id : references : date : in-reply-to : content-type :
	mime-version; s=corp-2021-07-09;
	bh=4R18pwpZs4MCAT1nUpfEebB1dGvjB+oR2X9XNPWO4p8=;
	b=K00aU85PLQqbvLtFWFoJrDU265LTE87Pk/HdBAP/k00+nUFnbt0HzC28qXULort8/5dT
	0MHpiTEsWCfgWIp/VfQe9wiWPEAirP8mYmfSrg47AbJZDmThd0V1PsvRsYi51NPFYNvr
	NP2yLcU3EOsB2gWzmVP8aRKlbSwElWU+lSbkDiCvniySQOstZ1VwrWhBJ4RcKNHPBxrF
	V58nasvrQdpQg2m7CndmhycOsf0q09wIS8eq6lycZSkVJxROXgRbjAvJF9JwSI0MotNd
	lbjdKIs09wAmCsCRIasNHrHq321KOUHGDNEJaaEZd2owY8TuK0k2deMmuCCqk82rG8Ea
	4w== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=4R18pwpZs4MCAT1nUpfEebB1dGvjB+oR2X9XNPWO4p8=;
	b=cxLXo3OvLrTa628//kIET7Ti0V6/UZFRGi9WHq1SXkLaJWXQcI3oYPMnBjQ7xLW0zTObAoEjQLfK43tQmNc6mLfp/lWYt8DWQCyoCc9Rnb//ecM/57CfmvxCySwNMe5n+PKd+Ig1TQXRcim1T4Kx5kFPFl088aE8yTpp0FEh3HM=
In-Reply-To: <20220406060516.409838-14-hch-jcswGhMUV9g@public.gmane.org> (Christoph Hellwig via
	Ocfs2-devel's message of "Wed, 6 Apr 2022 08:05:02 +0200")
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: Christoph Hellwig via Ocfs2-devel <ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org>
Cc: jfs-discussion-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, nbd-2H2hN8V1XRtuHlm7Suoebg@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mmc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ntfs3-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


Christoph,

> Add a helper to check the stable writes flag based on the block_device
> instead of having to poke into the block layer internal request_queue.

Reviewed-by: Martin K. Petersen <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

-- 
Martin K. Petersen	Oracle Linux Engineering
