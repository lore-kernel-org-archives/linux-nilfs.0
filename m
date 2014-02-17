From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH 1/2] nilfs2: add nilfs_sufile_trim_fs to trim clean segs
Date: Mon, 17 Feb 2014 19:42:00 +0900 (JST)
Message-ID: <20140217.194200.431478798.konishi.ryusuke@lab.ntt.co.jp>
References: <02d463460388a9bdc1413aa4d6fdfa5a402b9452.1392470644.git.andreas.rohner@gmx.net>
	<20140217.120000.397306175.konishi.ryusuke@lab.ntt.co.jp>
	<5301D130.9050000@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5301D130.9050000-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 17 Feb 2014 10:06:56 +0100, Andreas Rohner wrote:
> Hi Ryusuke,
> 
> On 2014-02-17 04:00, Ryusuke Konishi wrote:
>>> +	    segnum >= nilfs->ns_nsegments ||
>> 
>> This is bad too, because userland programs usually don't know the
>> segment structure of NILFS.  When we specify the partition size to
>> range->len, FITRIM can fail due to this check.
>> 
>> The upper limit of (range->start + range->len) should be
>> the block device size.
> 
> ext4 also checks the range structure like that. Besides couldn't it be
> possible, that the block device is bigger than the file system?

As I mentioned in my second mail, I misunderstood the meaning of this
check at first.

As you pointed out, the block device size may be bigger than the file
system size after shrinking the file system.  So, sbp->s_dev_size
should be used for for this check.  But it is a bit complicated since
the current nilfs object doesn't have on-memory copy of it.

It is OK to use nilfs->ns_nsegments as its alternative.


>>> +				ret = blkdev_issue_discard(nilfs->ns_bdev,
>>> +						start * sects_per_block,
>>> +						nblocks * sects_per_block,
>>> +						GFP_NOFS, 0);
>>> +				if (ret < 0) {
>>> +					kunmap(kaddr);
>>> +					put_bh(su_bh);
>>> +					goto out_sem;
>>> +				}
>>> +
>>> +				trimmed += nblocks;
>>> +				nblocks = 0;
> 
> This should be:
> 
> +				start = seg_start;
> +				nblocks = seg_end - seg_start + 1;

Yes, that's right.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
