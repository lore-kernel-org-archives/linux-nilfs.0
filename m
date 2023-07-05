From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 01/32] block: Provide blkdev_get_handle_* functions
Date: Wed, 5 Jul 2023 08:19:16 -0700
Message-ID: <1ea08f84-f900-92f2-e32b-2db242a74559@acm.org>
References: <20230629165206.383-1-jack@suse.cz>
 <20230704122224.16257-1-jack@suse.cz>
 <bb91e76b-0bd8-a949-f8b9-868f919ebcb9@acm.org>
 <ZKRFSZQglwCba9/i@casper.infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Language: en-US
In-Reply-To: <ZKRFSZQglwCba9/i@casper.infradead.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Alasdair Kergon <agk@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Anna Schumaker <anna@kernel.org>, Chao Yu <chao@kernel.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, "Darrick J. Wong" <djwong@kernel.org>, Dave Kleikamp <shaggy@kernel.org>, David Sterba <dsterba@suse.com>, dm-devel@redhat.com, drbd-dev@lists.linbit.com, Gao Xiang <xiang@kernel.org>, Jack Wang <jinpu.wang@ionos.com>, Jaegeuk Kim <jaegeuk@kernel.org>, jfs-discussion@lists.sourceforge.net, Joern Engel <joern@lazybastard.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, Kent Overstreet <kent.overstreet@gmail.com>, lin

On 7/4/23 09:14, Matthew Wilcox wrote:
> On Tue, Jul 04, 2023 at 07:06:26AM -0700, Bart Van Assche wrote:
>> On 7/4/23 05:21, Jan Kara wrote:
>>> +struct bdev_handle {
>>> +	struct block_device *bdev;
>>> +	void *holder;
>>> +};
>>
>> Please explain in the patch description why a holder pointer is introduced
>> in struct bdev_handle and how it relates to the bd_holder pointer in struct
>> block_device. Is one of the purposes of this patch series perhaps to add
>> support for multiple holders per block device?
> 
> That is all in patch 0/32.  Why repeat it?

This cover letter: https://lore.kernel.org/linux-block/20230629165206.383-1-jack@suse.cz/T/#t?

The word "holder" doesn't even occur in that cover letter so how could the
answer to my question be present in the cover letter?

Bart.

