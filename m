From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v6 1/2] blktrace: Fix potentail deadlock between delete &
 sysfs ops
Date: Tue, 19 Sep 2017 08:49:12 -0400
Message-ID: <aaa854ce-3e87-2a71-5f12-08db9bfbe837@redhat.com>
References: <1505760831-7747-1-git-send-email-longman@redhat.com>
 <1505760831-7747-2-git-send-email-longman@redhat.com>
 <20170919000155.GA30806@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170919000155.GA30806@infradead.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-nilfs@vger.kernel.org, cluster-devel@redhat.com, Bart Van Assche <Bart.VanAssche@wdc.com>

On 09/18/2017 08:01 PM, Christoph Hellwig wrote:
> Taking a look at this it seems like using a lock in struct block_device
> isn't the right thing to do anyway - all the action is on fields in
> struct blk_trace, so having a lock inside that would make a lot more
> sense.
>
> It would also help to document what exactly we're actually protecting.

I think I documented in the patch that the lock has to protect changes
in the blktrace structure as well as the allocation and destruction of
it. Because of that, it can't be put inside the blktrace structure. The
original code use the bd_mutex of the block_device structure. I just
change the code to use another bd_fsfreeze_mutex in the same structure.

In an earlier patch version, I used a global blktrace mutex. This was
deemed to be not scalable enough and so I now use the bd_fsfreeze_mutex
instead.

Cheers,
Longman

