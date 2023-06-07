From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 08/31] block: share code between
 disk_check_media_change and disk_force_media_change
Date: Wed, 7 Jun 2023 14:21:31 +0200
Message-ID: <20230607122131.GB14579@lst.de>
References: <20230606073950.225178-1-hch@lst.de> <20230606073950.225178-9-hch@lst.de> <30183892-dce6-6946-2f7a-1bc693a657a2@suse.de>
Mime-Version: 1.0
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <30183892-dce6-6946-2f7a-1bc693a657a2@suse.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Richard Weinberger <richard@nod.at>, Josef Bacik <josef@toxicpanda.com>, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>, Phillip Potter <phil@philpotter.co.uk>, Coly Li <colyli@suse.de>, Miquel Raynal <miquel.raynal@bootlin.com>, Vignesh Raghavendra <vigneshr@ti.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@ucw.cz>, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-um@lists.infradead.org, linux-scsi@vger.kernel.org, linux-bcache@vger.kernel.org

On Wed, Jun 07, 2023 at 02:19:00PM +0200, Hannes Reinecke wrote:
>> -	return true;
>> +	return __disk_check_media_change(disk,
>> +			disk_clear_events(disk, DISK_EVENT_MEDIA_CHANGE |
>> +						DISK_EVENT_EJECT_REQUEST));
>
> Can you move the call to disk_clear_events() out of the call to 
> __disk_check_media_change()?
> I find this pattern hard to read.

I suspect you've not done enough functional programming in your youth :)
