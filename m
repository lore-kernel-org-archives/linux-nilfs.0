From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v7] blktrace: Fix potentail deadlock between delete &
 sysfs ops
Date: Wed, 20 Sep 2017 13:32:38 -0400
Message-ID: <20170920133238.6d48fb93@gandalf.local.home>
References: <1505928371-27829-1-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1505928371-27829-1-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Waiman Long <longman@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-nilfs@vger.kernel.org, cluster-devel@redhat.com, Bart Van Assche <Bart.VanAssche@wdc.com>, Christoph Hellwig <hch@infradead.org>


Christoph,

Can you give an acked-by for this patch?

Jens,

You want to take this through your tree, or do you want me to?

If you want it, here's my:

Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

-- Steve


On Wed, 20 Sep 2017 13:26:11 -0400
Waiman Long <longman@redhat.com> wrote:

> The lockdep code had reported the following unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(s_active#228);
>                                lock(&bdev->bd_mutex/1);
>                                lock(s_active#228);
>   lock(&bdev->bd_mutex);
> 
>  *** DEADLOCK ***
> 
> The deadlock may happen when one task (CPU1) is trying to delete a
> partition in a block device and another task (CPU0) is accessing
> tracing sysfs file (e.g. /sys/block/dm-1/trace/act_mask) in that
> partition.
> 
> The s_active isn't an actual lock. It is a reference count (kn->count)
> on the sysfs (kernfs) file. Removal of a sysfs file, however, require
> a wait until all the references are gone. The reference count is
> treated like a rwsem using lockdep instrumentation code.
> 
> The fact that a thread is in the sysfs callback method or in the
> ioctl call means there is a reference to the opended sysfs or device
> file. That should prevent the underlying block structure from being
> removed.
> 
> Instead of using bd_mutex in the block_device structure, a new
> blk_trace_mutex is now added to the request_queue structure to protect
> access to the blk_trace structure.
> 
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  v7:
>   - Add a new blk_trace_mutex in request_queue structure for blk_trace
>     protection.
> 
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
>  block/blk-core.c        |  3 +++
>  include/linux/blkdev.h  |  1 +
>  kernel/trace/blktrace.c | 24 ++++++++++++++++++------
>  3 files changed, 22 insertions(+), 6 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index aebe676..048be4a 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -854,6 +854,9 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
>  
>  	kobject_init(&q->kobj, &blk_queue_ktype);
>  
> +#ifdef CONFIG_BLK_DEV_IO_TRACE
> +	mutex_init(&q->blk_trace_mutex);
> +#endif
>  	mutex_init(&q->sysfs_lock);
>  	spin_lock_init(&q->__queue_lock);
>  
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 460294b..02fa42d 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -551,6 +551,7 @@ struct request_queue {
>  	int			node;
>  #ifdef CONFIG_BLK_DEV_IO_TRACE
>  	struct blk_trace	*blk_trace;
> +	struct mutex		blk_trace_mutex;
>  #endif
>  	/*
>  	 * for flush operations
> diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
> index 2a685b4..d5cef05 100644
> --- a/kernel/trace/blktrace.c
> +++ b/kernel/trace/blktrace.c
> @@ -648,6 +648,18 @@ int blk_trace_startstop(struct request_queue *q, int start)
>  }
>  EXPORT_SYMBOL_GPL(blk_trace_startstop);
>  
> +/*
> + * When reading or writing the blktrace sysfs files, the references to the
> + * opened sysfs or device files should prevent the underlying block device
> + * from being removed. So no further delete protection is really needed.
> + *
> + * Protection from multiple readers and writers accessing blktrace data
> + * concurrently is still required. The bd_mutex was used for this purpose.
> + * That could lead to deadlock with concurrent block device deletion and
> + * sysfs access. As a result, a new blk_trace_mutex is now added to be
> + * used solely by the blktrace code.
> + */
> +
>  /**
>   * blk_trace_ioctl: - handle the ioctls associated with tracing
>   * @bdev:	the block device
> @@ -665,7 +677,7 @@ int blk_trace_ioctl(struct block_device *bdev, unsigned cmd, char __user *arg)
>  	if (!q)
>  		return -ENXIO;
>  
> -	mutex_lock(&bdev->bd_mutex);
> +	mutex_lock(&q->blk_trace_mutex);
>  
>  	switch (cmd) {
>  	case BLKTRACESETUP:
> @@ -691,7 +703,7 @@ int blk_trace_ioctl(struct block_device *bdev, unsigned cmd, char __user *arg)
>  		break;
>  	}
>  
> -	mutex_unlock(&bdev->bd_mutex);
> +	mutex_unlock(&q->blk_trace_mutex);
>  	return ret;
>  }
>  
> @@ -1727,7 +1739,7 @@ static ssize_t sysfs_blk_trace_attr_show(struct device *dev,
>  	if (q == NULL)
>  		goto out_bdput;
>  
> -	mutex_lock(&bdev->bd_mutex);
> +	mutex_lock(&q->blk_trace_mutex);
>  
>  	if (attr == &dev_attr_enable) {
>  		ret = sprintf(buf, "%u\n", !!q->blk_trace);
> @@ -1746,7 +1758,7 @@ static ssize_t sysfs_blk_trace_attr_show(struct device *dev,
>  		ret = sprintf(buf, "%llu\n", q->blk_trace->end_lba);
>  
>  out_unlock_bdev:
> -	mutex_unlock(&bdev->bd_mutex);
> +	mutex_unlock(&q->blk_trace_mutex);
>  out_bdput:
>  	bdput(bdev);
>  out:
> @@ -1788,7 +1800,7 @@ static ssize_t sysfs_blk_trace_attr_store(struct device *dev,
>  	if (q == NULL)
>  		goto out_bdput;
>  
> -	mutex_lock(&bdev->bd_mutex);
> +	mutex_lock(&q->blk_trace_mutex);
>  
>  	if (attr == &dev_attr_enable) {
>  		if (value)
> @@ -1814,7 +1826,7 @@ static ssize_t sysfs_blk_trace_attr_store(struct device *dev,
>  	}
>  
>  out_unlock_bdev:
> -	mutex_unlock(&bdev->bd_mutex);
> +	mutex_unlock(&q->blk_trace_mutex);
>  out_bdput:
>  	bdput(bdev);
>  out:

