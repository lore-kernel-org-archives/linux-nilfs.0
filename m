From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC][PATCH v2 28/31] timers: fs/nilfs2: Use del_timer_shutdown()
 before freeing timer
Date: Fri, 28 Oct 2022 14:12:48 +0900
Message-ID: <CAKFNMok3sM7ytwCDQZjug2BLHDW9-g2aeBoV-jAMmanRLXQddQ@mail.gmail.com>
References: <20221027150525.753064657@goodmis.org> <20221027150930.513327801@goodmis.org>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Dm82la1bhnQQM/NPgA4OJFAqxsf61ZI1OYbb+W3nkWY=;
        b=NlsL0Zi0pgj3t8+As3JBuxUt9yjd9FG5XBdHyyHuGDonR6ULDq7sjSU7DfozcU3+MM
         8nJ0gjGRbYUBivKZIs593V5vcMn9bUi6756hdDOxepQjJPRNRWM10JhjEHuRp2PslnAR
         ExZoY3I7oEcS1L0SQG7zH6bNH7Pfq7YFywqYJpa6EeasnNOsYCSUVrQQzhORq2p65I9X
         uQJoVW60B54zO46gTkDv999aa/XKe1PzwiZvMJXgPn7labYPGhkMub6sFeX/OX+uzX93
         PBQ5BzClTxUBiVgsPi1u7ggg5OPXMcYk66+O/+8imZjc06mHNq3t3T7X2/MIqDKh8uGE
         GErA==
In-Reply-To: <20221027150930.513327801-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Stephen Boyd <sboyd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Oct 28, 2022 at 12:09 AM Steven Rostedt wrote:
>
> From: "Steven Rostedt (Google)" <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
>
> Before a timer is freed, del_timer_shutdown() must be called.
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
> index b4cebad21b48..1d3f89de1cd2 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -2752,7 +2752,7 @@ static void nilfs_segctor_destroy(struct nilfs_sc_info *sci)
>
>         down_write(&nilfs->ns_segctor_sem);
>
> -       del_timer_sync(&sci->sc_timer);
> +       del_timer_shutdown(&sci->sc_timer);
>         kfree(sci);
>  }
>
> --
> 2.35.1

del_timer_shutdown()  is not yet in the mainline, so I reply with:

Acked-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

in the sense that I agree with the purpose of introducing the new
function and the place to apply it is correct in nilfs2.

Thanks,
Ryusuke Konishi
