From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v7] blktrace: Fix potentail deadlock between delete &
 sysfs ops
Date: Wed, 20 Sep 2017 15:27:33 -0400
Message-ID: <20170920152733.0e8290e1@gandalf.local.home>
References: <1505928371-27829-1-git-send-email-longman@redhat.com>
        <20170920133238.6d48fb93@gandalf.local.home>
        <eb3069f4-7803-32a0-0503-4258d47bb54d@kernel.dk>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <eb3069f4-7803-32a0-0503-4258d47bb54d@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: Waiman Long <longman@redhat.com>, Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-nilfs@vger.kernel.org, cluster-devel@redhat.com, Bart Van Assche <Bart.VanAssche@wdc.com>, Christoph Hellwig <hch@infradead.org>

On Wed, 20 Sep 2017 13:09:31 -0600
Jens Axboe <axboe@kernel.dk> wrote:
> 
> I'll take it through my tree, and I'll prune some of that comment
> as well (which should be a commit message thing, not a code comment).
> 

Agreed, and thanks.

-- Steve


