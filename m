From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCHv2] nilfs2: eliminate sparse warning - "context
 imbalance"
Date: Thu, 14 Oct 2010 01:29:44 +0900 (JST)
Message-ID: <20101014.012944.163237161.ryusuke@osrg.net>
References: <87r5fug3op.wl%jir@sekiba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87r5fug3op.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

On Wed, 13 Oct 2010 12:41:10 +0900, Jiro SEKIBA wrote:
> 
> insert sparse annotations to fix following sparse warning.
> 
> fs/nilfs2/segment.c:2681:3: warning: context imbalance in 'nilfs_segctor_kill_thread' - unexpected unlock
> 
> Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
> ---
>  fs/nilfs2/segment.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index 172ad42..6494e9d 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -2673,7 +2673,14 @@ static int nilfs_segctor_start_thread(struct nilfs_sc_info *sci)
>  	return 0;
>  }
>  
> +/*
> + * nilfs_segctor_kill_thread is only called inside sc_state_lock lock.
> + * sparse doesn't detect the context and warn "unexpected unlock".
> + * __acquires/__releases pretend to lock/unlockk the sc_state_lock for sparse.
> + */

s/unlockk/unlock/

Well, I think this comment should be included in the changelog.  It's
a common manner in kernel, and the comment adds a note on the sparse
tool.  Describing it in the implementation seems verbose.

Ryusuke Konishi

>  static void nilfs_segctor_kill_thread(struct nilfs_sc_info *sci)
> +	__acquires(&sci->sc_state_lock)
> +	__releases(&sci->sc_state_lock)
>  {
>  	sci->sc_state |= NILFS_SEGCTOR_QUIT;
>  
> -- 
> 1.5.6.5
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
