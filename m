From: Wol <antlists@youngman.org.uk>
Subject: Re: don't use ->bd_inode to access the block device size
Date: Thu, 14 Oct 2021 16:35:49 +0100
Message-ID: <e3d2f358-be1a-3413-fdb8-2e86718cde3e@youngman.org.uk>
References: <20211013051042.1065752-1-hch@lst.de>
 <20211014062844.GA25448@lst.de>
 <3AB8052D-DD45-478B-85F2-BFBEC1C7E9DF@tuxera.com>
 <a5eb3c18-deb2-6539-cc24-57e6d5d3500c@oracle.com>
 <202110140813.44C95229@keescook>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <202110140813.44C95229@keescook>
Content-Language: en-GB
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Kees Cook <keescook@chromium.org>, Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "jfs-discussion@lists.sourceforge.net" <jfs-discussion@lists.source>

On 14/10/2021 16:14, Kees Cook wrote:
>> I don't really mind bdev_size since it's analogous to i_size, but
>> bdev_nr_bytes seems good to me.

> I much prefer bdev_nr_bytes(), as "size" has no units.

Does it mean size IN bytes, or size OF A byte? :-)

Cheers,
Wol
