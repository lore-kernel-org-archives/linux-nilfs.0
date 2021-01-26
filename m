From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Subject: Re: [PATCH 01/17] zonefs: use bio_alloc in
	zonefs_file_dio_append
Date: Tue, 26 Jan 2021 15:08:12 +0000
Message-ID: <SN4PR0401MB359852658B9D8F386CC7C76A9BBC9@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20210126145247.1964410-1-hch@lst.de>
	<20210126145247.1964410-2-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>
Cc: Mike Snitzer <snitzer@redhat.com>, David Sterba <dsterba@suse.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Naohiro Aota <Naohiro.Aota@wdc.com>, "linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>, Ryusuke, Chao Yu <chao@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "drbd-dev@lists.linbit.com" <drbd-dev@tron.linbit.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Konishi <konishi.ryusuke@gmail.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, Philipp, Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Reisner <philipp.reisner@linbit.com>, "linux-f2fs-devel@lists.sourceforge.net" <linux-f2fs-devel@lists.sourceforge.net>, lin

On 26/01/2021 16:01, Christoph Hellwig wrote:
> Use bio_alloc instead of open coding it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/zonefs/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
> index bec47f2d074beb..faea2ed34b4a37 100644
> --- a/fs/zonefs/super.c
> +++ b/fs/zonefs/super.c
> @@ -678,7 +678,7 @@ static ssize_t zonefs_file_dio_append(struct kiocb *iocb, struct iov_iter *from)
>  	if (!nr_pages)
>  		return 0;
>  
> -	bio = bio_alloc_bioset(GFP_NOFS, nr_pages, &fs_bio_set);
> +	bio = bio_alloc(GFP_NOFS, nr_pages);
>  	if (!bio)
>  		return -ENOMEM;
>  
> 

Whoopsie my bad,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>


