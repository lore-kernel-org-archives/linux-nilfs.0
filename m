From: Anand Jain <anand.jain@oracle.com>
Subject: Re: [PATCH 11/29] btrfs: use bdev_nr_sectors instead of open coding
 it
Date: Wed, 13 Oct 2021 15:08:48 +0800
Message-ID: <91d3eb0f-95a6-a528-9445-da5b32b69cba@oracle.com>
References: <20211013051042.1065752-1-hch@lst.de>
 <20211013051042.1065752-12-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=4vPw9esYsMhmGTAnbV2TWoXhae2EVnyJ3dvHTRJV4T4=;
 b=FLTau0vjP0PBTD6CJAHg93E9eAPYfUL4uFbAR2ILfaHvxLr7wJ+k1gNNR7/Ys+tGump2
 T4uAV5ngGYZ2viQgZ06YP12iQ9Hp2349AZxvBAq4dgE/fltGhQDq6A51Jvf+j+EStEU4
 zGKKDeiOJaoPB+/rQDStYpcAM2fcku1WwwpsuxKambV2VFojtxZcvLtiE0ZpBw6v/CBs
 6PU2GwfGZ/31Nd10/bWcIveCZWTfsE3o6NRHgcGfem1LwWLFrn3uhr1yPEBX5EKWECZH
 D6YkK5TH6q4FjhUbRw1WGINqAV6S5J9WZEpLvRrj4OT0tZ6nXxqWzPI0DiPRDe/tlihl ug== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4vPw9esYsMhmGTAnbV2TWoXhae2EVnyJ3dvHTRJV4T4=;
 b=lMz37S6BAZY0rBWKSibK/2RyTBHIR+FAP970lzK6zr+GzVtcaRxekXKuulUzRMWH93XyoE2Up/V4yQYNkQJq8tm7jRrNESoVxR3w8L9v1kaT8k8TzglCGEJpgpecPHieKdQDeEly5IkuNlwmUSjhVs1ARTAnV4ESZkyr/0YCgWs=
In-Reply-To: <20211013051042.1065752-12-hch@lst.de>
Content-Language: en-US
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 13/10/2021 13:10, Christoph Hellwig wrote:
> Use the proper helper to read the block device size.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Anand Jain <anand.jain@oracle.com>

