From: Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: Re: [RFC PATCH 19/34] fs/jfs/jfs_logmgr.c: use bio_new in lbmRead
Date: Thu, 28 Jan 2021 06:43:03 -0600
Message-ID: <8d3f7e70-1c7a-567a-0e60-97bac846bf13@oracle.com>
References: <20210128071133.60335-1-chaitanya.kulkarni@wdc.com>
 <20210128071133.60335-20-chaitanya.kulkarni@wdc.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=4s6f1Z4X6xFsF2Ee1gAGevBW8HhU6VhaeckNt9jWQHc=;
 b=kX6Rlr0au8sY4I6yUJwn2LXmhSeVCZE3jKgLuqO1QhpGfaIM4g2+Ig07nc+VWL7SzJVg
 Bj72iFAcU9Za8alm5F6IopQUt9S9FRLVjgKOzpkdupcC+hpfJjJHBLB/bmz88hbIhmKm
 R5V6ChjnvtAW/+gc2yOzLGfoJTVsrsbY+kr8JgLDbWqNF4+R6cbKMt3a3s7X48K4271x
 CDkPKyy97rdwx0sWjQDA2+7KudY+HrQldnAORaUtHWSSe5HKI9gYe3WuYasENMKo4H26
 YZHYf/IJQe1vowSGdXaismmdrzSvukfzxgZgsVxZUPtuzVPDomuh8lDLOEXGRn0omBFg Fg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4s6f1Z4X6xFsF2Ee1gAGevBW8HhU6VhaeckNt9jWQHc=;
 b=Mr0nOt0UdZbc4cbI+3mzml8n5Q2KLA4MNetq2+yWthAXAn2HGggfFVZFDPIA5a75lWpBuhsz6jb+7Hv4R+QLC6SnfehG7z67W5eJYq42XFUyMZ/Wqub2sQs6r+KdZ2HwpgSqYLe4paKq0Af/xnNbc+FBBI7IKZugdF6TcuEkdt4=
In-Reply-To: <20210128071133.60335-20-chaitanya.kulkarni@wdc.com>
Content-Language: en-US
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com, xen-devel@lists.xenproject.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-fscrypt@vger.kernel.org, jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-pm@vger.kernel.org, linux-mm@kvack.org
Cc: axboe@kernel.dk, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, konrad.wilk@oracle.com, roger.pau@citrix.com, minchan@kernel.org, ngupta@vflare.org, sergey.senozhatsky.work@gmail.com, agk@redhat.com, snitzer@redhat.com, hch@lst.de, sagi@grimberg.me, martin.petersen@oracle.com, viro@zeniv.linux.org.uk, tytso@mit.edu, jaegeuk@kernel.org, ebiggers@kernel.org, djwong@kernel.org, shaggy@kernel.org, konishi.ryusuke@gmail.com, mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, damien.lemoal@wdc.com, naohiro.aota@wdc.com, jth@kernel.org, rjw@rjwysocki.net, len.brown@intel.com, pavel@ucw.cz, akpm@linux-foundation.org, hare@suse.de, gustavoars@kernel.org, tiwai@suse.de, alex.shi@linux.alibaba.com, asml.silence@gmail.com, ming.lei@redhat.com, tj@kernel.org, osandov@fb.c

You probably don't need 4 patches to fs/jfs/. These can be combined into 
a single patch.

Dave

On 1/28/21 1:11 AM, Chaitanya Kulkarni wrote:
> Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
> ---
>   fs/jfs/jfs_logmgr.c | 7 ++-----
>   1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
> index 9330eff210e0..4481f3e33a3f 100644
> --- a/fs/jfs/jfs_logmgr.c
> +++ b/fs/jfs/jfs_logmgr.c
> @@ -1979,17 +1979,14 @@ static int lbmRead(struct jfs_log * log, int pn, struct lbuf ** bpp)
>   
>   	bp->l_flag |= lbmREAD;
>   
> -	bio = bio_alloc(GFP_NOFS, 1);
> -
> -	bio->bi_iter.bi_sector = bp->l_blkno << (log->l2bsize - 9);
> -	bio_set_dev(bio, log->bdev);
> +	bio = bio_new(log->bdev, bp->l_blkno << (log->l2bsize - 9),
> +			REQ_OP_READ, 0, 1, GFP_NOFS);
>   
>   	bio_add_page(bio, bp->l_page, LOGPSIZE, bp->l_offset);
>   	BUG_ON(bio->bi_iter.bi_size != LOGPSIZE);
>   
>   	bio->bi_end_io = lbmIODone;
>   	bio->bi_private = bp;
> -	bio->bi_opf = REQ_OP_READ;
>   	/*check if journaling to disk has been disabled*/
>   	if (log->no_integrity) {
>   		bio->bi_iter.bi_size = 0;
> 
