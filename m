From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v6 0/2] blktrace: Fix deadlock problem
Date: Mon, 18 Sep 2017 17:14:47 -0400
Message-ID: <20170918171447.697d8659@gandalf.local.home>
References: <1505760831-7747-1-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1505760831-7747-1-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Waiman Long <longman@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-nilfs@vger.kernel.org, cluster-devel@redhat.com, Bart Van Assche <Bart.VanAssche@wdc.com>


Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

for the series.

Jens, feel free to take this in your tree.

-- Steve


On Mon, 18 Sep 2017 14:53:49 -0400
Waiman Long <longman@redhat.com> wrote:

>  v6:
>   - Add a second patch to rename the bd_fsfreeze_mutex to
>     bd_fsfreeze_blktrace_mutex.
> 
>  v5:
>   - Overload the bd_fsfreeze_mutex in block_device structure for
>     blktrace protection.
> 
>  v4:
>   - Use blktrace_mutex in blk_trace_ioctl() as well.
> 
>  v3:
>   - Use a global blktrace_mutex to serialize sysfs attribute accesses
>     instead of the bd_mutex.
> 
>  v2:
>   - Use READ_ONCE() and smp_store_mb() to read and write bd_deleting.
>   - Check for signal in the mutex_trylock loops.
>   - Use usleep() instead of schedule() for RT tasks.
> 
> This patchset fixes a potential blktrace deadlock problem between
> block device deletion and sysfs operations.
> 
> Waiman Long (2):
>   blktrace: Fix potentail deadlock between delete & sysfs ops
>   block_dev: Rename bd_fsfreeze_mutex
> 
>  fs/block_dev.c          | 14 +++++++-------
>  fs/gfs2/ops_fstype.c    |  6 +++---
>  fs/nilfs2/super.c       |  6 +++---
>  fs/super.c              |  6 +++---
>  include/linux/fs.h      |  5 +++--
>  kernel/trace/blktrace.c | 26 ++++++++++++++++++++------
>  6 files changed, 39 insertions(+), 24 deletions(-)
> 

