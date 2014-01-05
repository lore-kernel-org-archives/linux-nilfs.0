From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH nilfs-utils v2 2/4] cleanerd: call _exit(2) twice for
 ensuring not being a session leader
Date: Mon, 06 Jan 2014 02:20:42 +0900 (JST)
Message-ID: <20140106.022042.112826181.konishi.ryusuke@lab.ntt.co.jp>
References: <1388937165-32692-1-git-send-email-mitake.hitoshi@gmail.com>
	<1388937165-32692-3-git-send-email-mitake.hitoshi@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1388937165-32692-3-git-send-email-mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Hitoshi Mitake <mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hitoshi Mitake <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

On Mon,  6 Jan 2014 00:52:43 +0900, Hitoshi Mitake wrote:
> Current daemonize() function of cleanerd call _exit(2) only once during its
> process of becoming a daemon process. But in the linux environment, a daemon
> should call _exit(2) twice for ensuring not being a session leader. If a
> process don't do that, unexpected SIGHUP can be sent to the process (though it
> happens rarely). The signal would be confusing event for cleanerd of nilfs. This
> patch removes this potential problem.
> 
> Signed-off-by: Hitoshi Mitake <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
> ---
>  sbin/cleanerd/cleanerd.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/sbin/cleanerd/cleanerd.c b/sbin/cleanerd/cleanerd.c
> index 0b5bb70..86dfcf7 100644
> --- a/sbin/cleanerd/cleanerd.c
> +++ b/sbin/cleanerd/cleanerd.c
> @@ -708,6 +708,14 @@ static int daemonize(int nochdir, int noclose)
>  
>  	/* umask(0); */
>  
> +	/* for ensuring I'm not a session leader */
> +	pid = fork();
> +	if (pid < 0)
> +		return -1;
> +	else if (pid != 0)
> +		/* parent */
> +		_exit(0);
> +
>  	if (!nochdir && (chdir(ROOTDIR) < 0))
>  		return -1;
>  
> -- 
> 1.8.1.2

Looks good.

Applied, thank you.

Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
