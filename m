From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH 1/2] nilfs2: add nilfs_sufile_trim_fs to trim clean segs
Date: Mon, 17 Feb 2014 12:04:52 +0100
Message-ID: <5301ECD4.5070200@gmx.net>
References: <02d463460388a9bdc1413aa4d6fdfa5a402b9452.1392470644.git.andreas.rohner@gmx.net>	<20140217.120000.397306175.konishi.ryusuke@lab.ntt.co.jp>	<5301D130.9050000@gmx.net> <20140217.194200.431478798.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140217.194200.431478798.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2014-02-17 11:42, Ryusuke Konishi wrote:
> On Mon, 17 Feb 2014 10:06:56 +0100, Andreas Rohner wrote:
>> Hi Ryusuke,
>>
>> On 2014-02-17 04:00, Ryusuke Konishi wrote:
>>>> +	    segnum >= nilfs->ns_nsegments ||
>>>
>>> This is bad too, because userland programs usually don't know the
>>> segment structure of NILFS.  When we specify the partition size to
>>> range->len, FITRIM can fail due to this check.
>>>
>>> The upper limit of (range->start + range->len) should be
>>> the block device size.
>>
>> ext4 also checks the range structure like that. Besides couldn't it be
>> possible, that the block device is bigger than the file system?
> 
> As I mentioned in my second mail, I misunderstood the meaning of this
> check at first.
> 
> As you pointed out, the block device size may be bigger than the file
> system size after shrinking the file system.  So, sbp->s_dev_size
> should be used for for this check.  But it is a bit complicated since
> the current nilfs object doesn't have on-memory copy of it.
> 
> It is OK to use nilfs->ns_nsegments as its alternative.

Ok, just to be clear. According to your second mail it should look
something like this in nilfs_sufile_trim_fs():

	if (segnum >= nilfs->ns_nsegments)
		goto out;

And in nilfs_ioctl_trim_fs():

	if (range.len < nilfs->ns_blocksize ||
		range.start >= (nilfs->ns_nsegments *
			nilfs->ns_blocks_per_segment) <<
			nilfs->ns_blocksize_bits)
		return -EINVAL;	


Is that correct?

Regards,
Andreas Rohner
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
