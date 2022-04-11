From: David Sterba <dsterba-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 08/27] btrfs: use bdev_max_active_zones
 instead of open coding it
Date: Mon, 11 Apr 2022 19:22:18 +0200
Message-ID: <20220411172218.GT15609@twin.jikos.cz>
References: <20220409045043.23593-1-hch@lst.de>
	<20220409045043.23593-9-hch@lst.de>
Reply-To: dsterba-AlSwsSmVLrQ@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1649697983;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	cc:cc:mime-version:mime-version:content-type:content-type:
	in-reply-to:in-reply-to:references:references;
	bh=ojOMmoWG3Vi82iwkKmDthce/DTUxrqsrVMcEPPdM3So=;
	b=QZwWZVQwC0bnchneRkqJ/+jzsU6T9BsE/QwjE1iflJ8e+QPH7qzL+AxcI+atiGlV8qm9Lo
	u8oIaWSdY7hbFlYvzT8ENcrgX9LIGNQj4Ik1HCmhtpjbfJ75vgExpzBPpp974aNYAtu6v8
	bf5VKoGfQqIUb3Ou/OOGio4KxiUFZwg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1649697983;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	cc:cc:mime-version:mime-version:content-type:content-type:
	in-reply-to:in-reply-to:references:references;
	bh=ojOMmoWG3Vi82iwkKmDthce/DTUxrqsrVMcEPPdM3So=;
	b=98et+OqtZl3DiPU61ep6rcrI2VbwKFWZL1iuQ8dNt7YkOb55uCdVju/GMJmDyvRi7cAHwR
	HPLi3jycKdDWeJCw==
Content-Disposition: inline
In-Reply-To: <20220409045043.23593-9-hch-jcswGhMUV9g@public.gmane.org>
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
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: jfs-discussion-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, nbd-2H2hN8V1XRtuHlm7Suoebg@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Thumshirn <johannes.thumshirn-Sjgp3cTcYWE@public.gmane.org>, linux-mmc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ntfs3-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Apr 09, 2022 at 06:50:24AM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn-Sjgp3cTcYWE@public.gmane.org>

Acked-by: David Sterba <dsterba-IBi9RG/b67k@public.gmane.org>
