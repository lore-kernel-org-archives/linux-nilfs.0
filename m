From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v6 1/2] blktrace: Fix potentail deadlock between delete
 & sysfs ops
Date: Tue, 19 Sep 2017 17:58:23 -0400
Message-ID: <20170919175823.51e3413d@gandalf.local.home>
References: <1505760831-7747-1-git-send-email-longman@redhat.com>
        <1505760831-7747-2-git-send-email-longman@redhat.com>
        <20170919000155.GA30806@infradead.org>
        <aaa854ce-3e87-2a71-5f12-08db9bfbe837@redhat.com>
        <20170919143811.GB15944@infradead.org>
        <a4934514-092b-f879-a9e7-ae7a2fd4198c@redhat.com>
        <20170919204135.GA7411@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170919204135.GA7411@infradead.org>
Sender: linux-block-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch@infradead.org>
Cc: Waiman Long <longman@redhat.com>, Jens Axboe <axboe@kernel.dk>, Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-nilfs@vger.kernel.org, cluster-devel@redhat.com, Bart Van Assche <Bart.VanAssche@wdc.com>

On Tue, 19 Sep 2017 13:41:35 -0700
Christoph Hellwig <hch@infradead.org> wrote:

> Call it blk_trace mutex and move it right next to the blk_trace
> structure:
> 
> ifdef CONFIG_BLK_DEV_IO_TRACE
>         struct blk_trace        *blk_trace;
> 	struct mutex		blk_trace_mutex;
> #endif
> 
> which makes it completely obvious to any read what you are protecting
> with it.

As a 1000ft away bystander, this appears to be the most logical
solution.

-- Steve
