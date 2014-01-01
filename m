From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH nilfs-utils 1/2] cleanerd: call _exit(2) twice for
 ensuring not being a session leader
Date: Wed, 01 Jan 2014 18:30:18 +0900 (JST)
Message-ID: <20140101.183018.491730600.konishi.ryusuke@lab.ntt.co.jp>
References: <1388561449-13980-1-git-send-email-mitake.hitoshi@gmail.com>
	<1388561449-13980-2-git-send-email-mitake.hitoshi@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1388561449-13980-2-git-send-email-mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

On Wed,  1 Jan 2014 16:30:48 +0900, Hitoshi Mitake wrote:
> Current daemonize() function of cleanerd call _exit(2) only once during its
> process of becoming a daemon process. But in the linux environment, a daemon
> process should call _exit(2) twice for ensuring not being a session leader. If a
> process don't do that, unexpected SIGHUP can be sent to the process (though it
> happens rarely). The signal would be confusing event for cleanerd of nilfs. This
> patch removes this potential problem.
> 
> Signed-off-by: Hitoshi Mitake <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
> ---
>  sbin/cleanerd/cleanerd.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/sbin/cleanerd/cleanerd.c b/sbin/cleanerd/cleanerd.c
> index 26067bd..edfa083 100644
> --- a/sbin/cleanerd/cleanerd.c
> +++ b/sbin/cleanerd/cleanerd.c
> @@ -676,6 +676,16 @@ static int daemonize(int nochdir, int noclose, int nofork)
>  
>  	/* umask(0); */
>  
> +	/* for ensuring I'm not a session leader */
> +	if (!nofork) {
> +		pid = fork();
> +		if (pid < 0)
> +			return -1;
> +		else if (pid != 0)
> +			/* parent */
> +			_exit(0);
> +	}
> +

I tried your patch, but the cleaner daemon still was a session leader.

This turned out because nilfs_cleanerd is usually executed by
mount.nilfs2 program with the nofork option (-n).

To fix this problem, it looks like the above !nofork check of the
second fork() should be removed even though it becomes confusing.  In
that case, we may need to add some explanation why fork() should be
called even if nofork is specified.


Regards,
Ryusuke Konishi


>  	if (!nochdir && (chdir(ROOTDIR) < 0))
>  		return -1;
>  
> -- 
> 1.8.1.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
