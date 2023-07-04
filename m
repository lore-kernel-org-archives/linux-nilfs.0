From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 01/32] block: Provide blkdev_get_handle_* functions
Date: Tue, 4 Jul 2023 07:06:26 -0700
Message-ID: <bb91e76b-0bd8-a949-f8b9-868f919ebcb9@acm.org>
References: <20230629165206.383-1-jack@suse.cz>
 <20230704122224.16257-1-jack@suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Language: en-US
In-Reply-To: <20230704122224.16257-1-jack@suse.cz>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Jan Kara <jack@suse.cz>, linux-block@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Alasdair Kergon <agk@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Anna Schumaker <anna@kernel.org>, Chao Yu <chao@kernel.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, "Darrick J. Wong" <djwong@kernel.org>, Dave Kleikamp <shaggy@kernel.org>, David Sterba <dsterba@suse.com>, dm-devel@redhat.com, drbd-dev@lists.linbit.com, Gao Xiang <xiang@kernel.org>, Jack Wang <jinpu.wang@ionos.com>, Jaegeuk Kim <jaegeuk@kernel.org>, jfs-discussion@lists.sourceforge.net, Joern Engel <joern@lazybastard.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org, linux-btrfs@vger.kernel.org

On 7/4/23 05:21, Jan Kara wrote:
> +struct bdev_handle {
> +	struct block_device *bdev;
> +	void *holder;
> +};

Please explain in the patch description why a holder pointer is 
introduced in struct bdev_handle and how it relates to the bd_holder 
pointer in struct block_device. Is one of the purposes of this patch 
series perhaps to add support for multiple holders per block device?

Thanks,

Bart.

