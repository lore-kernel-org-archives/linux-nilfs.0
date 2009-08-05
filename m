From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH] nilfs2: tune write performance
Date: Thu, 06 Aug 2009 06:19:55 +0900 (JST)
Message-ID: <20090806.061955.63823059.ryusuke@osrg.net>
References: <1249483023-21088-1-git-send-email-jir@unicus.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1249483023-21088-1-git-send-email-jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org

On Wed,  5 Aug 2009 23:37:03 +0900, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org> wrote:
> Hi,
> 
> This is a candidate patch to improve write performance.
> 
> When GC is runnning, GC moves live block to difference segments.
> Moving live blocks to different segment is done in a transaction,
> but it is not necessarily to be in the transaction.
> This patch will get the nilfs_ioctl_move_blocks() out from
> transaction lock and put it before the transaction.

Ah, this description may be misleading.
nilfs_ioctl_move_blocks() does not actually move blocks, it just reads
live blocks in the target segments into own caches (gc-cache).

The move operation is consisting of the read operation and a write
operation to new logs, which is carried out in nilfs_clean_segments().
The patch move the former out from the lock section, but it doesn't
for the latter.

I think the confusion is due to name of the function.  Maybe, it
should be named nilfs_ioctl_cache_copy_blocks() or something.  But, I
would like to separate it off as usual.
 
> Here are the bonnie++ bench mark results against rc5.
> I used sata disk so performace difference is not big.
> So I modified nilfs_cleanerd.conf to ensure lock will be long enough.
> 
> I ran "bonnie++ -b" three times in each environment.
> Create clean nilfs2 partition each time before test run.
> 
> Results
> - write performance of rc5
>  * Char|17472.333 K/sec
>  * Block|30748.000 K/sec
>  * Rewrite|18506.000 K/sec
> 
> - write performance of the patched rc5
>  * Char|17961.000 K/sec -> 102.700%
>  * Block|30987.666 K/sec -> 100.700%
>  * Rewrite|18775.666 K/sec -> 101.400%
<snip>
> 
>  fs/nilfs2/ioctl.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
> ---
>  fs/nilfs2/ioctl.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> index 6ea5f87..83a885c 100644
> --- a/fs/nilfs2/ioctl.c
> +++ b/fs/nilfs2/ioctl.c
> @@ -442,12 +442,6 @@ int nilfs_ioctl_prepare_clean_segments(struct the_nilfs *nilfs,
>  	const char *msg;
>  	int ret;
>  
> -	ret = nilfs_ioctl_move_blocks(nilfs, &argv[0], kbufs[0]);
> -	if (ret < 0) {
> -		msg = "cannot read source blocks";
> -		goto failed;
> -	}
> -
>  	ret = nilfs_ioctl_delete_checkpoints(nilfs, &argv[1], kbufs[1]);
>  	if (ret < 0) {
>  		/*
> @@ -548,6 +542,12 @@ static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
>  		}
>  	}
>  
> +	ret = nilfs_ioctl_move_blocks(nilfs, &argv[0], kbufs[0]);
> +	if (ret < 0) {
> +		printk(KERN_ERR "NILFS: GC failed during preparation: cannot read source blocks: err=%d\n", ret);

You should call nilfs_remove_all_gcinode() here before escaping from
the normal route.

And, break the line please.  You can do it for C-strings just as
follows:

    printk(KERN_ERR "NILFS: GC failed during preparation: "
           "cannot read source blocks: err=%d\n", ret);

> +		goto out_free;
> +	}
> +
>  	ret = nilfs_clean_segments(inode->i_sb, argv, kbufs);
>  
>   out_free:
> -- 
> 1.5.6.5

For the rest, it looks good to me.

Thanks,
Ryusuke Konishi
