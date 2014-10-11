From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH tracepoints v3] nilfs2: add a tracepoint for
 transaction events
Date: Sat, 11 Oct 2014 16:18:22 +0900 (JST)
Message-ID: <20141011.161822.2224973311585624339.konishi.ryusuke@lab.ntt.co.jp>
References: <1411899764-24270-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
	<20141011.151441.872905468760482082.konishi.ryusuke@lab.ntt.co.jp>
	<CAE1WaKL9fnFi9zSmD026OJqnrGyFYdfjPUr=s3iniezyOrm7KQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=9Y/FibVH1YO9GhGa0x8We65/kgc4XumOpj6ctoRg8J4=;
        b=VRgH8v6XUz9/8udpNmxsSCJWxhnzQXAoDrQ7kqJu3idJ/YVwoe0rOAHxswAtB13MdT
         KywtHOvV3XPFu6WQStOvFHYTTKUJsTwyObZ6pJ+jlcwAOBrGauGTfc8fwbqaXHdWU9/V
         btfWTkusoA14qMd1l7zz3AuM9UAQCri1a5wnVKzwXj6gGVc3BtpcnhiwnnazGCWcJG1r
         EAZHgqcc3TYQPvk+t97kuIjUWmpxjFzxGYV/s/0zGqTVoHIcQNRyOmejybwGIV+8N/kQ
         61tLJFwvE0K5mKjm8sgvu079HYyu7q2W0MrXrx8x2N67+n8eFDUC43FwX+48KL8Cs8ys
         a3hQ==
In-Reply-To: <CAE1WaKL9fnFi9zSmD026OJqnrGyFYdfjPUr=s3iniezyOrm7KQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Mitake Hitoshi <mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, 11 Oct 2014 15:40:53 +0900, Mitake Hitoshi wrote:
> On Sat, Oct 11, 2014 at 3:14 PM, Ryusuke Konishi
> <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org> wrote:
>> On Sun, 28 Sep 2014 19:22:44 +0900, Mitake Hitoshi wrote:
>>> This patch adds a tracepoint for transaction events of nilfs. With the
>>> tracepoint, these events can be tracked: begin, abort, commit,
>>> trylock, lock, and unlock. Basically, these events have corresponding
>>> functions e.g. begin event corresponds nilfs_transaction_begin(). The
>>> unlock event is an exception. It corresponds to the iteration in
>>> nilfs_transaction_lock().
>>>
>>> Only one tracepoint is introcued: nilfs2_transaction_transition. The
>>> above events are distinguished with newly introduced enum. With this
>>> tracepoint, we can analyse a critical section of segment constructoin.
>>>
>>> Sample output by tpoint of perf-tools:
>>>               cp-4457  [000] ...1    63.266220: nilfs2_transaction_transition: sb = ffff8802112b8800 ti = ffff8800bf5ccc58 count = 1 flags = 9 state = BEGIN
>>>               cp-4457  [000] ...1    63.266221: nilfs2_transaction_transition: sb = ffff8802112b8800 ti = ffff8800bf5ccc58 count = 0 flags = 9 state = COMMIT
>>>               cp-4457  [000] ...1    63.266221: nilfs2_transaction_transition: sb = ffff8802112b8800 ti = ffff8800bf5ccc58 count = 0 flags = 9 state = COMMIT
>>>         segctord-4371  [001] ...1    68.261196: nilfs2_transaction_transition: sb = ffff8802112b8800 ti = ffff8800b889bdf8 count = 0 flags = 10 state = TRYLOCK
>>>         segctord-4371  [001] ...1    68.261280: nilfs2_transaction_transition: sb = ffff8802112b8800 ti = ffff8800b889bdf8 count = 0 flags = 10 state = LOCK
>>>         segctord-4371  [001] ...1    68.261877: nilfs2_transaction_transition: sb = ffff8802112b8800 ti = ffff8800b889bdf8 count = 1 flags = 10 state = BEGIN
>>>         segctord-4371  [001] ...1    68.262116: nilfs2_transaction_transition: sb = ffff8802112b8800 ti = ffff8800b889bdf8 count = 0 flags = 18 state = COMMIT
>>>         segctord-4371  [001] ...1    68.265032: nilfs2_transaction_transition: sb = ffff8802112b8800 ti = ffff8800b889bdf8 count = 0 flags = 18 state = UNLOCK
>>>         segctord-4371  [001] ...1   132.376847: nilfs2_transaction_transition: sb = ffff8802112b8800 ti = ffff8800b889bdf8 count = 0 flags = 10 state = TRYLOCK
>>>
>>> This patch also does trivial cleaning of comma usage in collection
>>> stage transition event for consistent coding style.
>>>
>>> Signed-off-by: Hitoshi Mitake <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
>> <snip>
>>> -         TP_printk("sci = %p, stage = %s",
>>> +         TP_printk("sci = %p stage = %s",
>>>                     __entry->sci,
>>>                     show_collection_stage(__entry->stage))
>> <snip>
>>> +         TP_printk("sb = %p ti = %p count = %d flags = %x state = %s",
>>> +                   __entry->sb,
>>> +                   __entry->ti,
>>> +                   __entry->count,
>>> +                   __entry->flags,
>>> +                   show_transaction_state(__entry->state))
>>
>> May I change these as follows ?
>>
>>             TP_printk("sci=%p stage=%s",
>>                       __entry->sci,
>>                       show_collection_stage(__entry->stage))
>>             TP_printk("sb=%p ti=%p count=%d flags=%x state=%s",
>>                       __entry->sb,
>>                       __entry->ti,
>>                       __entry->count,
>>                       __entry->flags,
>>                       show_transaction_state(__entry->state))
> 
> Sure, should I send v4?

Please do because the commit log also should be changed.

>>
>> Or, is there a reason that you left space chars around "=" symbol ?
> 
> The TP_printk() just follows btrfs's style. Seems that there's no
> strict guide line about the style.

You're right.  Sorry to bother you with minutiae.

Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
