From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v6 1/2] blktrace: Fix potentail deadlock between delete &
 sysfs ops
Date: Tue, 19 Sep 2017 11:58:34 -0400
Message-ID: <a4934514-092b-f879-a9e7-ae7a2fd4198c@redhat.com>
References: <1505760831-7747-1-git-send-email-longman@redhat.com>
 <1505760831-7747-2-git-send-email-longman@redhat.com>
 <20170919000155.GA30806@infradead.org>
 <aaa854ce-3e87-2a71-5f12-08db9bfbe837@redhat.com>
 <20170919143811.GB15944@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170919143811.GB15944@infradead.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-nilfs@vger.kernel.org, cluster-devel@redhat.com, Bart Van Assche <Bart.VanAssche@wdc.com>

On 09/19/2017 10:38 AM, Christoph Hellwig wrote:
> On Tue, Sep 19, 2017 at 08:49:12AM -0400, Waiman Long wrote:
>> On 09/18/2017 08:01 PM, Christoph Hellwig wrote:
>>> Taking a look at this it seems like using a lock in struct block_device
>>> isn't the right thing to do anyway - all the action is on fields in
>>> struct blk_trace, so having a lock inside that would make a lot more
>>> sense.
>>>
>>> It would also help to document what exactly we're actually protecting.
>> I think I documented in the patch that the lock has to protect changes
>> in the blktrace structure as well as the allocation and destruction of
>> it. Because of that, it can't be put inside the blktrace structure. The
>> original code use the bd_mutex of the block_device structure. I just
>> change the code to use another bd_fsfreeze_mutex in the same structure.
> Either way it has absolutely nothing to do with struct block_device,
> given that struct blk_trace hangs off the request_queue.
>
> Reusing a mutex just because it happens to live in a structure also
> generally is a bad idea if the protected data is in no way related.

I was trying not to add a new mutex to a structure just for blktrace as
it is an optional feature that is enabled only if the
CONFIG_BLK_DEV_IO_TRACE config option is defined and it will only need
to be taken occasionally.

As filesystem freeze looks orthogonal to blktrace and the mutex also
looks to be used sparingly, I think it is a good match to overload it to
control blktrace as well.

I could modify the patch to use a mutex in the request_queue structure.
The current sysfs_lock mutex has about 74 references. So I am not
totally sure if it is safe to reuse. So the only option is to add
something like

#ifdef CONFIG_BLK_DEV_IO_TRACE
struct mutex blktrace_mutex;
#endif

to the request_queue structure. That structure is large enough that
adding a mutex won't increase the size much percentage-wise.

I would like to keep the current patch as is as I don't see any problem
with it. However, I can revise the patch as discussed above if you guys
prefer that alternative.

Cheers,
Longman



