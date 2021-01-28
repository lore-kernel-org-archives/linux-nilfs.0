From: Joseph Qi <joseph.qi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [RFC PATCH 25/34] ocfs/cluster: use bio_new in dm-log-writes
Date: Thu, 28 Jan 2021 20:13:28 +0800
Message-ID: <8ba2c461-6042-757d-a3c1-0490932e749e@linux.alibaba.com>
References: <20210128071133.60335-1-chaitanya.kulkarni@wdc.com>
 <20210128071133.60335-26-chaitanya.kulkarni@wdc.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20210128071133.60335-26-chaitanya.kulkarni-Sjgp3cTcYWE@public.gmane.org>
Content-Language: en-US
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Chaitanya Kulkarni <chaitanya.kulkarni-Sjgp3cTcYWE@public.gmane.org>, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fscrypt-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jfs-discussion-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org, lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org, konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, roger.pau-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, ngupta-KNmc09w0p+Ednm+yROfE0A@public.gmane.org, sergey.senozhatsky.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, ebiggers-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, djwong-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shaggy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mark-qFb/fKtWg+rQT0dZR+AlfA@public.gmane.org, jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org, damien.lemoal-Sjgp3cTcYWE@public.gmane.org, naohiro.aota-Sjgp3cTcYWE@public.gmane.org, jth-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, pavel-+ZI9xUNit7I@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hare-l3A5Bk7waGM@public.gmane.org, gustavoars-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tiwai-l3A5Bk7waGM@public.gmane.org, alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, osandov-b10kYP2dOMg@public.gmane.org, bvanassche-HInyCGIudOg@public.gmane.org, jeffl

I think you send a wrong subject by mistake.

Thanks,
Joseph

On 1/28/21 3:11 PM, Chaitanya Kulkarni wrote:
> Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni-Sjgp3cTcYWE@public.gmane.org>
> ---
>  fs/ocfs2/cluster/heartbeat.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
> index 0179a73a3fa2..b34518036446 100644
> --- a/fs/ocfs2/cluster/heartbeat.c
> +++ b/fs/ocfs2/cluster/heartbeat.c
> @@ -515,12 +515,13 @@ static struct bio *o2hb_setup_one_bio(struct o2hb_region *reg,
>  	unsigned int cs = *current_slot;
>  	struct bio *bio;
>  	struct page *page;
> +	sector_t sect = (reg->hr_start_block + cs) << (bits - 9);
>  
>  	/* Testing has shown this allocation to take long enough under
>  	 * GFP_KERNEL that the local node can get fenced. It would be
>  	 * nicest if we could pre-allocate these bios and avoid this
>  	 * all together. */
> -	bio = bio_alloc(GFP_ATOMIC, 16);
> +	bio = bio_new(reg->hr_bdev, sect, op, op_flags, 16, GFP_ATOMIC);
>  	if (!bio) {
>  		mlog(ML_ERROR, "Could not alloc slots BIO!\n");
>  		bio = ERR_PTR(-ENOMEM);
> @@ -528,11 +529,8 @@ static struct bio *o2hb_setup_one_bio(struct o2hb_region *reg,
>  	}
>  
>  	/* Must put everything in 512 byte sectors for the bio... */
> -	bio->bi_iter.bi_sector = (reg->hr_start_block + cs) << (bits - 9);
> -	bio_set_dev(bio, reg->hr_bdev);
>  	bio->bi_private = wc;
>  	bio->bi_end_io = o2hb_bio_end_io;
> -	bio_set_op_attrs(bio, op, op_flags);
>  
>  	vec_start = (cs << bits) % PAGE_SIZE;
>  	while(cs < max_slots) {
> 
