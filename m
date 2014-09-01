From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH v2 1/1] nilfs2: add missing blkdev_issue_flush() to nilfs_sync_fs()
Date: Mon, 01 Sep 2014 20:43:40 +0200
Message-ID: <5404BE5C.9080302@gmx.net>
References: <1409500033-30791-1-git-send-email-andreas.rohner@gmx.net>	<1409500033-30791-2-git-send-email-andreas.rohner@gmx.net> <20140902.025939.1812841141168890644.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140902.025939.1812841141168890644.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Ryusuke,
On 2014-09-01 19:59, Ryusuke Konishi wrote:
> On Sun, 31 Aug 2014 17:47:13 +0200, Andreas Rohner wrote:
>> Under normal circumstances nilfs_sync_fs() writes out the super block,
>> which causes a flush of the underlying block device. But this depends on
>> the THE_NILFS_SB_DIRTY flag, which is only set if the pointer to the
>> last segment crosses a segment boundary. So if only a small amount of
>> data is written before the call to nilfs_sync_fs(), no flush of the
>> block device occurs.
>>
>> In the above case an additional call to blkdev_issue_flush() is needed.
>> To prevent unnecessary overhead, the new flag THE_NILFS_FLUSHED is
>> introduced, which is cleared whenever new logs are written and set
>> whenever the block device is flushed.
>>
>> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
> 
> The patch looks good to me except that I feel the use of atomic
> test-and-set bitwise operations something unfavorable (though it's
> logically correct).  I will try to send this to upstream as is unless
> a comment comes to mind.

I originally thought, that it is necessary to do it atomically to avoid
a race condition, but I am not so sure about that any more. I think the
only case we have to avoid is, to call set_nilfs_flushed() after
blkdev_issue_flush(), because this could race with the
clear_nilfs_flushed() from the segment construction. So this should also
work:

 +	if (wait && !err && nilfs_test_opt(nilfs, BARRIER) &&
 +	    !nilfs_flushed(nilfs)) {
 +              set_nilfs_flushed(nilfs);
 +		err = blkdev_issue_flush(sb->s_bdev, GFP_KERNEL, NULL);
 +		if (err != -EIO)
 +			err = 0;
 +	}
 +

What do you think?

br,
Andreas Rohner

> Thanks,
> Ryusuke Konishi

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
