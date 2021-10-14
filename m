From: Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: Re: don't use ->bd_inode to access the block device size
Date: Thu, 14 Oct 2021 08:13:59 -0500
Message-ID: <a5eb3c18-deb2-6539-cc24-57e6d5d3500c@oracle.com>
References: <20211013051042.1065752-1-hch@lst.de>
 <20211014062844.GA25448@lst.de>
 <3AB8052D-DD45-478B-85F2-BFBEC1C7E9DF@tuxera.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=WA9dPYQG8XodQsN6AxhCZzi1FymMbZ+cF5Pbu5cQGxE=;
 b=aQwVrcWkif5jb2ZiD3rT6+Je6xlLFjuBbn0K/wAffBPS+Yv/wlXEEv6IFjTnLCh5/qIj
 5AZJmH7y07UtY3kTz+Q1Mu3COvh4cqZsVCRXpPv/sHE/q6EFFHIiTI/4iyBJYu1X8vi+
 xwNw6oyH3gq6mwraB/ynZ3MJ03vkNxjUEjnm8iokMRzULxcfSM2pfBiz5R2cB1DnQVbE
 6QXxrbgI9t5IK3iQnyiM817xzoyd7lw5beI6grwnOaHY9j0vdkbO5VDY/iY5J50OD5aT
 Z0tif8LaGlqDjUbmTKuikbG64MlQqRBGAICcsTH4z3sTK9bbHthdVPBLHHsyYMIWyPTk Cg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WA9dPYQG8XodQsN6AxhCZzi1FymMbZ+cF5Pbu5cQGxE=;
 b=XF2DrYmhBtGjCdgULmLifr+75bQfEMthquYtUPhUProRAV2rMJyObHOhb91HwOIii30paAQFs9Q2PJJohwmpHaL4xJf1pkClCXLX+jPIOTvpqp4srEGcdpxx7nCvmYgSjTh+XaYNmh0IlyCP/b7M6Bp8ke7ILAOTpmwabvt6RCI=
Content-Language: en-US
In-Reply-To: <3AB8052D-DD45-478B-85F2-BFBEC1C7E9DF@tuxera.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Anton Altaparmakov <anton@tuxera.com>, Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, linux

On 10/14/21 4:32AM, Anton Altaparmakov wrote:
> Hi Christoph,
> 
>> On 14 Oct 2021, at 07:28, Christoph Hellwig <hch@lst.de> wrote:
>>
>> On Wed, Oct 13, 2021 at 07:10:13AM +0200, Christoph Hellwig wrote:
>>> I wondered about adding a helper for looking at the size in byte units
>>> to avoid the SECTOR_SHIFT shifts in various places.  But given that
>>> I could not come up with a good name and block devices fundamentally
>>> work in sector size granularity I decided against that.
>>
>> So it seems like the biggest review feedback is that we should have
>> such a helper.  I think the bdev_size name is the worst as size does
>> not imply a particular unit.  bdev_nr_bytes is a little better but I'm
>> not too happy.  Any other suggestions or strong opinions?
> 
> bdev_byte_size() would seem to address your concerns?
> 
> bdev_nr_bytes() would work though - it is analogous to bdev_nr_sectors() after all.
> 
> No strong opinion here but I do agree with you that bdev_size() is a bad choice for sure.  It is bound to cause bugs down the line when people forget what unit it is in.

I don't really mind bdev_size since it's analogous to i_size, but 
bdev_nr_bytes seems good to me.

Shaggy

> Best regards,
> 
> 	Anton
> 
