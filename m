From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH] nilfs2: add tracepoints for analyzing reading and
 writing metadata files
Date: Sun, 04 Oct 2015 22:33:43 +0900 (JST)
Message-ID: <20151004.223343.974065670664209746.konishi.ryusuke@lab.ntt.co.jp>
References: <1443888162-14884-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=Exc9Zuq92mKzQPd/t7v+MEX0+N6YfGs0TJHQfE/8QqE=;
        b=fwsN+uVER5jLuYytmeC6K7tpn9g3bPuCGWjqiQjo5AYE4t75AZ+pgFLqJoPVPrVkJK
         hlekXKl3tMo9iq9PmKn7rloc5tlH/eS/2ei0AUN2c8JRnF5DRBHz82TAJcZ7lZSLchXI
         AgvHoqQcRIJ8YVgngdCWh+0R2j6YeU45+sRXyllb2tYtsDq5WhwJnq7ZhwT8S1QLLfMS
         jm1wIc2g0Fiogt3ZrGOXN7pt5Bmxt51TcwGelmJUeGFMb+EpwTQ6bqExxJWrO7rGdA4b
         B1IKor8QLyisRCsFzodk5BOaJZSMSaWtsPhwniZceqMlNyEymEu8LCAPM7NfAs6BbjjY
         CBpQ==
In-Reply-To: <1443888162-14884-1-git-send-email-mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Mitake Hitoshi <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, TK Kato <TK.Kato-Sjgp3cTcYWE@public.gmane.org>

On Sun,  4 Oct 2015 01:02:42 +0900, Mitake Hitoshi wrote:
> This patch adds tracepoints for analyzing requests of reading and
> writing metadata files. The tracepoints cover every in-place mdt files
> (cpfile, sufile, and datfile).
> 
> Example of tracing mdt_insert_new_block():
>               cp-14635 [000] ...1 30598.199309: nilfs2_mdt_insert_new_block: inode = ffff88022a8d0178 ino = 3 block = 155
>               cp-14635 [000] ...1 30598.199520: nilfs2_mdt_insert_new_block: inode = ffff88022a8d0178 ino = 3 block = 5
>               cp-14635 [000] ...1 30598.200828: nilfs2_mdt_insert_new_block: inode = ffff88022a8d0178 ino = 3 block = 253
> 
> Cc: TK Kato <TK.Kato-Sjgp3cTcYWE@public.gmane.org>
> Signed-off-by: Hitoshi Mitake <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Applied to the tracepoints branch.  Thanks.

Ryusuke Konishi

> ---
>  fs/nilfs2/mdt.c               |  6 +++++
>  include/trace/events/nilfs2.h | 54 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 60 insertions(+)
> 
> diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
> index dee34d9..1125f40 100644
> --- a/fs/nilfs2/mdt.c
> +++ b/fs/nilfs2/mdt.c
> @@ -33,6 +33,7 @@
>  #include "page.h"
>  #include "mdt.h"
>  
> +#include <trace/events/nilfs2.h>
>  
>  #define NILFS_MDT_MAX_RA_BLOCKS		(16 - 1)
>  
> @@ -68,6 +69,9 @@ nilfs_mdt_insert_new_block(struct inode *inode, unsigned long block,
>  	set_buffer_uptodate(bh);
>  	mark_buffer_dirty(bh);
>  	nilfs_mdt_mark_dirty(inode);
> +
> +	trace_nilfs2_mdt_insert_new_block(inode, inode->i_ino, block);
> +
>  	return 0;
>  }
>  
> @@ -158,6 +162,8 @@ nilfs_mdt_submit_block(struct inode *inode, unsigned long blkoff,
>  	get_bh(bh);
>  	submit_bh(mode, bh);
>  	ret = 0;
> +
> +	trace_nilfs2_mdt_submit_block(inode, inode->i_ino, blkoff, mode);
>   out:
>  	get_bh(bh);
>  	*out_bh = bh;
> diff --git a/include/trace/events/nilfs2.h b/include/trace/events/nilfs2.h
> index 1b65ba6..c780581 100644
> --- a/include/trace/events/nilfs2.h
> +++ b/include/trace/events/nilfs2.h
> @@ -162,6 +162,60 @@ TRACE_EVENT(nilfs2_segment_usage_freed,
>  		      __entry->segnum)
>  );
>  
> +TRACE_EVENT(nilfs2_mdt_insert_new_block,
> +	    TP_PROTO(struct inode *inode,
> +		     unsigned long ino,
> +		     unsigned long block),
> +
> +	    TP_ARGS(inode, ino, block),
> +
> +	    TP_STRUCT__entry(
> +		    __field(struct inode *, inode)
> +		    __field(unsigned long, ino)
> +		    __field(unsigned long, block)
> +	    ),
> +
> +	    TP_fast_assign(
> +		    __entry->inode = inode;
> +		    __entry->ino = ino;
> +		    __entry->block = block;
> +		    ),
> +
> +	    TP_printk("inode = %p ino = %lu block = %lu",
> +		      __entry->inode,
> +		      __entry->ino,
> +		      __entry->block)
> +);
> +
> +TRACE_EVENT(nilfs2_mdt_submit_block,
> +	    TP_PROTO(struct inode *inode,
> +		     unsigned long ino,
> +		     unsigned long blkoff,
> +		     int mode),
> +
> +	    TP_ARGS(inode, ino, blkoff, mode),
> +
> +	    TP_STRUCT__entry(
> +		    __field(struct inode *, inode)
> +		    __field(unsigned long, ino)
> +		    __field(unsigned long, blkoff)
> +		    __field(int, mode)
> +	    ),
> +
> +	    TP_fast_assign(
> +		    __entry->inode = inode;
> +		    __entry->ino = ino;
> +		    __entry->blkoff = blkoff;
> +		    __entry->mode = mode;
> +		    ),
> +
> +	    TP_printk("inode = %p ino = %lu blkoff = %lu mode = %x",
> +		      __entry->inode,
> +		      __entry->ino,
> +		      __entry->blkoff,
> +		      __entry->mode)
> +);
> +
>  #endif /* _TRACE_NILFS2_H */
>  
>  /* This part must be outside protection */
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
