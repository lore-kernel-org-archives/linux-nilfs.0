From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v2 1/1] nilfs2: add missing blkdev_issue_flush() to
 nilfs_sync_fs()
Date: Wed, 03 Sep 2014 09:35:25 +0900 (JST)
Message-ID: <20140903.093525.810247375407684014.konishi.ryusuke@lab.ntt.co.jp>
References: <20140902.025939.1812841141168890644.konishi.ryusuke@lab.ntt.co.jp>
	<5404BE5C.9080302@gmx.net>
	<5404C686.4070800@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=fv0OM5gmC1kQ5+CUzYB6Wfne/nmrBSmatSIL+2EHuaU=;
        b=ix1GJSnsLkEP71+69YReoTh8lvE0K3xeSfncFC7TEBFCKRzep+xAuqo8SsW7y8LpQI
         tg0KD5aNEG1eQP8JYzzJHHvA6B1en56ArLHbP0HZ8vtvEe7a8Hlk8nZ5phpGT/Kqb23X
         BDRT5oZeABSsW/z9QmbWbkoSJfZqsltU9L59JhGqMHLch6EK2SKZ9tbc4Oi6AJD6IQEb
         8cWw7yGJWdgji/QcXAN6wb7hlIYBFIIZ6Q+MeM7vkDf0uMkRlgBjR99pbhEBxxz3p1/j
         B4ylJTI1PgZY6pfTcTUBBKjEhTgyYLTSlpUjD+ub72DGpz2b490N5NVq0J+/4yCS3E0P
         UX3Q==
In-Reply-To: <5404C686.4070800-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: andreas.rohner-hi6Y0CQ0nG0@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 01 Sep 2014 21:18:30 +0200, Andreas Rohner wrote:
> On 2014-09-01 20:43, Andreas Rohner wrote:
>> Hi Ryusuke,
>> On 2014-09-01 19:59, Ryusuke Konishi wrote:
>>> On Sun, 31 Aug 2014 17:47:13 +0200, Andreas Rohner wrote:
>>>> Under normal circumstances nilfs_sync_fs() writes out the super block,
>>>> which causes a flush of the underlying block device. But this depends on
>>>> the THE_NILFS_SB_DIRTY flag, which is only set if the pointer to the
>>>> last segment crosses a segment boundary. So if only a small amount of
>>>> data is written before the call to nilfs_sync_fs(), no flush of the
>>>> block device occurs.
>>>>
>>>> In the above case an additional call to blkdev_issue_flush() is needed.
>>>> To prevent unnecessary overhead, the new flag THE_NILFS_FLUSHED is
>>>> introduced, which is cleared whenever new logs are written and set
>>>> whenever the block device is flushed.
>>>>
>>>> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
>>>
>>> The patch looks good to me except that I feel the use of atomic
>>> test-and-set bitwise operations something unfavorable (though it's
>>> logically correct).  I will try to send this to upstream as is unless
>>> a comment comes to mind.
>> 
>> I originally thought, that it is necessary to do it atomically to avoid
>> a race condition, but I am not so sure about that any more. I think the
>> only case we have to avoid is, to call set_nilfs_flushed() after
>> blkdev_issue_flush(), because this could race with the
>> clear_nilfs_flushed() from the segment construction. So this should also
>> work:
>> 
>>  +	if (wait && !err && nilfs_test_opt(nilfs, BARRIER) &&
>>  +	    !nilfs_flushed(nilfs)) {
>>  +              set_nilfs_flushed(nilfs);
>>  +		err = blkdev_issue_flush(sb->s_bdev, GFP_KERNEL, NULL);
>>  +		if (err != -EIO)
>>  +			err = 0;
>>  +	}
>>  +
> 
> On the other hand, it says in the comments to set_bit(), that it can be
> reordered on architectures other than x86. test_and_set_bit() implies a
> memory barrier on all architectures. But I don't think the processor
> would reorder set_nilfs_flushed() after the external function call to
> blkdev_issue_flush(), would it?

I believe compiler doesn't reorder set_bit() operation after an
external function call unless it knows the content of the function and
the function can be optimized.  But, yes, set_bit() doesn't imply
memory barrier unlike test_and_set_bit().  As for
blkdev_issue_flush(), it would imply memory barrier by some lock
functions or other primitive used inside it.  (I haven't actually
confirmed that the premise is true)

On the other hand, we need explicit barrier operation like
smp_mb__after_atomic() if a certain operation is performed after
set_bit() and the changed bit should be visible to other processors
before the operation.

Regards,
Ryusuke Konishi


> 
> /**
>  * set_bit - Atomically set a bit in memory
>  * @nr: the bit to set
>  * @addr: the address to start counting from
>  *
>  * This function is atomic and may not be reordered.  See __set_bit()
>  * if you do not require the atomic guarantees.
>  *
>  * Note: there are no guarantees that this function will not be reordered
>  * on non x86 architectures, so if you are writing portable code,
>  * make sure not to rely on its reordering guarantees.
>  */
> 
> br,
> Andreas Rohner
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
