From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH tracepoints v3] nilfs2: add a tracepoint for
 transaction events
Date: Sat, 11 Oct 2014 15:14:41 +0900 (JST)
Message-ID: <20141011.151441.872905468760482082.konishi.ryusuke@lab.ntt.co.jp>
References: <1411899764-24270-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=c/lxlClReU8d7+Vx0dtAe52v/ZEF/aP/q41aySbXpcA=;
        b=xev+QAZRcogjOzoTNshSS+uFhgFkia36SGw9h4Jw+2QNa+OrysG5nz0vcdx49KplKM
         OskUuXvp7poyABrEyAIaKIyJuifcjSiRQ7fV7PmuAMUZvcSG5KkH0oRxXJ3JIbcxpFcG
         6mSr39Ti9BCioE+6aSOHZVm1iyKyvcvDqUH4CsigzneSG1x4D0h1SxGZ6p9by/BKkeSZ
         r5BkEurCMhyomOd1Xh/JfmDG+dnjmnnYs8VNd6PsZDCvIxvLD+WgSHWL5izNqU180kzU
         6uNGRsfwDkzFWKGD6v6vxfKB3JnCsw/ZUx9ccl7dGN2LR4J10HaFiNrbYyRSONBvAdf2
         Gt3Q==
In-Reply-To: <1411899764-24270-1-git-send-email-mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Mitake Hitoshi <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitake Hitoshi <mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Sun, 28 Sep 2014 19:22:44 +0900, Mitake Hitoshi wrote:
> This patch adds a tracepoint for transaction events of nilfs. With the
> tracepoint, these events can be tracked: begin, abort, commit,
> trylock, lock, and unlock. Basically, these events have corresponding
> functions e.g. begin event corresponds nilfs_transaction_begin(). The
> unlock event is an exception. It corresponds to the iteration in
> nilfs_transaction_lock().
> 
> Only one tracepoint is introcued: nilfs2_transaction_transition. The
> above events are distinguished with newly introduced enum. With this
> tracepoint, we can analyse a critical section of segment constructoin.
> 
> Sample output by tpoint of perf-tools:
>               cp-4457  [000] ...1    63.266220: nilfs2_transaction_transition: sb = ffff8802112b8800 ti = ffff8800bf5ccc58 count = 1 flags = 9 state = BEGIN
>               cp-4457  [000] ...1    63.266221: nilfs2_transaction_transition: sb = ffff8802112b8800 ti = ffff8800bf5ccc58 count = 0 flags = 9 state = COMMIT
>               cp-4457  [000] ...1    63.266221: nilfs2_transaction_transition: sb = ffff8802112b8800 ti = ffff8800bf5ccc58 count = 0 flags = 9 state = COMMIT
>         segctord-4371  [001] ...1    68.261196: nilfs2_transaction_transition: sb = ffff8802112b8800 ti = ffff8800b889bdf8 count = 0 flags = 10 state = TRYLOCK
>         segctord-4371  [001] ...1    68.261280: nilfs2_transaction_transition: sb = ffff8802112b8800 ti = ffff8800b889bdf8 count = 0 flags = 10 state = LOCK
>         segctord-4371  [001] ...1    68.261877: nilfs2_transaction_transition: sb = ffff8802112b8800 ti = ffff8800b889bdf8 count = 1 flags = 10 state = BEGIN
>         segctord-4371  [001] ...1    68.262116: nilfs2_transaction_transition: sb = ffff8802112b8800 ti = ffff8800b889bdf8 count = 0 flags = 18 state = COMMIT
>         segctord-4371  [001] ...1    68.265032: nilfs2_transaction_transition: sb = ffff8802112b8800 ti = ffff8800b889bdf8 count = 0 flags = 18 state = UNLOCK
>         segctord-4371  [001] ...1   132.376847: nilfs2_transaction_transition: sb = ffff8802112b8800 ti = ffff8800b889bdf8 count = 0 flags = 10 state = TRYLOCK
> 
> This patch also does trivial cleaning of comma usage in collection
> stage transition event for consistent coding style.
> 
> Signed-off-by: Hitoshi Mitake <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
<snip>
> -	    TP_printk("sci = %p, stage = %s",
> +	    TP_printk("sci = %p stage = %s",
>  		      __entry->sci,
>  		      show_collection_stage(__entry->stage))
<snip>
> +	    TP_printk("sb = %p ti = %p count = %d flags = %x state = %s",
> +		      __entry->sb,
> +		      __entry->ti,
> +		      __entry->count,
> +		      __entry->flags,
> +		      show_transaction_state(__entry->state))

May I change these as follows ?

	    TP_printk("sci=%p stage=%s",
		      __entry->sci,
		      show_collection_stage(__entry->stage))
	    TP_printk("sb=%p ti=%p count=%d flags=%x state=%s",
		      __entry->sb,
		      __entry->ti,
		      __entry->count,
		      __entry->flags,
		      show_transaction_state(__entry->state))

Or, is there a reason that you left space chars around "=" symbol ?

Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
