From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH nilfs-utils v2 4/4] man: remove a description of -n
 option
Date: Mon, 06 Jan 2014 02:22:51 +0900 (JST)
Message-ID: <20140106.022251.402431718.konishi.ryusuke@lab.ntt.co.jp>
References: <1388937165-32692-1-git-send-email-mitake.hitoshi@gmail.com>
	<1388937165-32692-5-git-send-email-mitake.hitoshi@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1388937165-32692-5-git-send-email-mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Hitoshi Mitake <mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hitoshi Mitake <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

On Mon,  6 Jan 2014 00:52:45 +0900, Hitoshi Mitake wrote:
> Signed-off-by: Hitoshi Mitake <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
> ---
>  man/nilfs_cleanerd.8 | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/man/nilfs_cleanerd.8 b/man/nilfs_cleanerd.8
> index ad6d188..46caef2 100644
> --- a/man/nilfs_cleanerd.8
> +++ b/man/nilfs_cleanerd.8
> @@ -35,10 +35,6 @@ Display help message and exit.
>  \fB\-c \fIfile\fR, \fB\-\-conf\fR=\fIfile\fR
>  Specify configuration file.
>  .TP
> -\fB\-n\fR, \fB\-\-nofork\fR
> -invoke cleanerd without forking process. This option is intended for
> -internal use from \fBmount.nilfs2\fP(8).
> -.TP
>  \fB\-p \fIinterval\fR, \fB\-\-protection-period\fR=\fIinterval\fR
>  Override protection period with the specified number of seconds.
>  .SH SIGNALS
> -- 
> 1.8.1.2

Applied, thank you.

Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
