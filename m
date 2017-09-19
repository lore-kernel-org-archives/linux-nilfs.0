From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v6 1/2] blktrace: Fix potentail deadlock between delete &
 sysfs ops
Date: Tue, 19 Sep 2017 07:38:11 -0700
Message-ID: <20170919143811.GB15944@infradead.org>
References: <1505760831-7747-1-git-send-email-longman@redhat.com>
 <1505760831-7747-2-git-send-email-longman@redhat.com>
 <20170919000155.GA30806@infradead.org>
 <aaa854ce-3e87-2a71-5f12-08db9bfbe837@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=RBA40U9YUwL7OdVEvoFygt0jq+NvL99LIYUxYOKLZiE=; b=D1mIpBbIDSkAJbvMyyzm8n03h
        vhLF+7x3hJqnKlbkNbCUXYo3UIbWzxU0Dwz73Xxv4wA8/sIiP0ckKaPoE8vP0PIuigJr2XB6mu4WQ
        bbdX8hb4cFmdIoOwLMeLFWzjlAN5Ys+NkOHJsnwF4tGEaa7JA0bLZkd7T9J8R6CTarTYWlPUShIOO
        eyTn6A9dObpEwF39fqJeG8aCmwIK7mKsUuoH8uBQAy4v5ogH2huI4iYAzKeAJxZn2d0AN9VcEKnAw
        qSNboR/QBWXJL2irheKR8KD3fEvYcJSTtgXRapXHuQTyRh57oc6PexXNug3OpjrkuGUEOt5Ojpu8X
    
Content-Disposition: inline
In-Reply-To: <aaa854ce-3e87-2a71-5f12-08db9bfbe837@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-nilfs@vger.kernel.org, cluster-devel@redhat.com, Bart Van Assche <Bart.VanAssche@wdc.com>

On Tue, Sep 19, 2017 at 08:49:12AM -0400, Waiman Long wrote:
> On 09/18/2017 08:01 PM, Christoph Hellwig wrote:
> > Taking a look at this it seems like using a lock in struct block_device
> > isn't the right thing to do anyway - all the action is on fields in
> > struct blk_trace, so having a lock inside that would make a lot more
> > sense.
> >
> > It would also help to document what exactly we're actually protecting.
> 
> I think I documented in the patch that the lock has to protect changes
> in the blktrace structure as well as the allocation and destruction of
> it. Because of that, it can't be put inside the blktrace structure. The
> original code use the bd_mutex of the block_device structure. I just
> change the code to use another bd_fsfreeze_mutex in the same structure.

Either way it has absolutely nothing to do with struct block_device,
given that struct blk_trace hangs off the request_queue.

Reusing a mutex just because it happens to live in a structure also
generally is a bad idea if the protected data is in no way related.
