From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v6 1/2] blktrace: Fix potentail deadlock between delete &
 sysfs ops
Date: Tue, 19 Sep 2017 13:41:35 -0700
Message-ID: <20170919204135.GA7411@infradead.org>
References: <1505760831-7747-1-git-send-email-longman@redhat.com>
 <1505760831-7747-2-git-send-email-longman@redhat.com>
 <20170919000155.GA30806@infradead.org>
 <aaa854ce-3e87-2a71-5f12-08db9bfbe837@redhat.com>
 <20170919143811.GB15944@infradead.org>
 <a4934514-092b-f879-a9e7-ae7a2fd4198c@redhat.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=S18fwIP2LxOhbr6AdtlZMG4LcGKmE8w7W1TMj7iCQ9c=; b=qHecM26Lc685cA9EoQKhLCXu/
        PCB/b7KgN20eRb9Zj7Y65WomoTYCCMoLQrbu3SJXWi7uzpSwiHX35mOQM0OkwuCV3iPM57kb+VUQp
        +VU/7jT1nfUMVH8bVoqa8xOansd18L+XvcCbQh92Wd35jqAfAUxdpQ3Y2Ka5MTD1NKZhnw0uQOL+y
        Misa0uT4Dh3hSeVOmOk2KmMVftYXNWylNw5Koyh1D7fRKKofmJ/7y9fE+0nH7yM/WM9CYZbdr3x9a
        FbvFGRLa3b7bn5OKfw88UTdTsx4Q2ZDQ4m0a1+sKEc2s45NdO/w8yZ8p+Jy/o7x4RcRiH/KJlP64n
    
Content-Disposition: inline
In-Reply-To: <a4934514-092b-f879-a9e7-ae7a2fd4198c@redhat.com>
Sender: linux-block-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-nilfs@vger.kernel.org, cluster-devel@redhat.com, Bart Van Assche <Bart.VanAssche@wdc.com>

On Tue, Sep 19, 2017 at 11:58:34AM -0400, Waiman Long wrote:
> I was trying not to add a new mutex to a structure just for blktrace as
> it is an optional feature that is enabled only if the
> CONFIG_BLK_DEV_IO_TRACE config option is defined and it will only need
> to be taken occasionally.

So?  Make the lock optional, too.

> As filesystem freeze looks orthogonal to blktrace and the mutex also
> looks to be used sparingly, I think it is a good match to overload it to
> control blktrace as well.

If the functionally is orthogonal that is a reason not to share a lock,
not to the contrary.

> I could modify the patch to use a mutex in the request_queue structure.
> The current sysfs_lock mutex has about 74 references. So I am not
> totally sure if it is safe to reuse. So the only option is to add
> something like

> 
> #ifdef CONFIG_BLK_DEV_IO_TRACE
> struct mutex blktrace_mutex;
> #endif
> 
> to the request_queue structure. That structure is large enough that
> adding a mutex won't increase the size much percentage-wise.

Call it blk_trace mutex and move it right next to the blk_trace
structure:

ifdef CONFIG_BLK_DEV_IO_TRACE
        struct blk_trace        *blk_trace;
	struct mutex		blk_trace_mutex;
#endif

which makes it completely obvious to any read what you are protecting
with it.
