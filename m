From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC][PATCH v3 28/33] timers: fs/nilfs2: Use timer_shutdown_sync()
 before freeing timer
Date: Fri, 4 Nov 2022 15:57:04 +0900
Message-ID: <CAKFNMomoVn3Zj5xaH6hjXHO+KXj983yZEue5Jx4wH+_m5NiJjA@mail.gmail.com>
References: <20221104054053.431922658@goodmis.org> <20221104054917.009383303@goodmis.org>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QAu7avbRwIGd2fwGHCJmgmPKqmQjXHREloI21uMgOjM=;
        b=Votyuy76zN6cU4EntSX9bdqU4qeiY/VJDpt62DtPMUzaY+nmsxh8NwAGjuhmFEPt/o
         YBIeOcaTE2DGB8q4aSR5S9V6S7Dvo0IYm9gxkP0toA3APMQjHNb08KnpZgyoMRaXO31B
         BJzLY+kuqqDHSzyBXAQAPQN11Jdky0bZnu01f9DKjANFAxLtHIvCab0ucxHWHcrNtrBJ
         x0fP2Cg2nLNBLismWFQ/D2tfXw6tCgd2v4O9AXSk2MFjqU4OVFpgqBWimiVSPZq9w/Xg
         N90RiyN8cjkeczYVJ/WlZsDpj9BkBTKDFpakLPKqyIOXk5JcGqIk579wevtu5VJIWHjt
         wK6Q==
In-Reply-To: <20221104054917.009383303-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Stephen Boyd <sboyd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, Anna-Maria Gleixner <anna-maria-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Nov 4, 2022 at 2:48 PM Steven Rostedt wrote:
>
> From: "Steven Rostedt (Google)" <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
>
> Before a timer is freed, timer_shutdown_sync() must be called.
>
> Link: https://lore.kernel.org/all/20220407161745.7d6754b3-f9ZlEuEWxVcJvu8Pb33WZ0EMvNT87kid@public.gmane.org/
>
> Cc: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Signed-off-by: Steven Rostedt (Google) <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
> ---
>  fs/nilfs2/segment.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index b4cebad21b48..c50dc377da26 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -2752,7 +2752,7 @@ static void nilfs_segctor_destroy(struct nilfs_sc_info *sci)
>
>         down_write(&nilfs->ns_segctor_sem);
>
> -       del_timer_sync(&sci->sc_timer);
> +       timer_shutdown_sync(&sci->sc_timer);
>         kfree(sci);
>  }
>
> --
> 2.35.1

Acked-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

This is the second time, but my Ack is not tagged, so I'll reply again
just in case.

Thanks,
Ryusuke Konishi
