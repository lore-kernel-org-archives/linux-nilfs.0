From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH tracepoints] nilfs2: add tracepoints for analyzing sufile manipulation
Date: Thu, 1 Oct 2015 00:06:21 +0900
Message-ID: <CAKFNMomvgAFukQ+NH_Js9ayQva1orp_GO0ONmaYvKgqnQCtoGw@mail.gmail.com>
References: <1443533856-18827-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=y3+2k8Q2B3PBbjjhp9TSkCl62gnzOJRDCmX/xUeeBaU=;
        b=qK7FfqPFwOo7GLKklxx5fH2o4iqjaQgodKE6JiJOtaVWgZpXm2XgKJRkEChMc9ebjw
         +nKehUCy45kgvZYxonAlXuBBOMk3w5KWn8gXq0/fcWVxy596Tub+kB4CMh4V1L61V3Mg
         ICTr9XaXn9w5KMxTtLWWTmQF819IXIHklFlheW5BicJppUtO+Ya7V8CsCJRuvmMrZOUe
         2AhGMzWXe1rqYz1gjVUeBuh585dIUUF6iM8NoGGkMjXT8cWu8qYdgyCWkM4WxmbEGwMs
         32sBgVuwBFR7mVAdoLdoAXOd+IDo2h/USftNqPVmV5yJHVmqO1fyuLnlhVM7bpHjvUUe
         ytEw==
In-Reply-To: <1443533856-18827-1-git-send-email-mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hitoshi Mitake <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hitoshi Mitake <mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Benixon Dhas <benixon.dhas-Sjgp3cTcYWE@public.gmane.org>, TK Kato <TK.Kato-Sjgp3cTcYWE@public.gmane.org>

2015-09-29 22:37 GMT+09:00 Hitoshi Mitake <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>:
> This patch adds tracepoints which would be useful for analyzing
> segment usage from a perspective of high level sufile manipulation
> (check, alloc, free). sufile is an important in-place updated metadata
> file, so analyzing the behavior would be useful for performance
> turning.
>
> example of usage (a case of allocation):
>
> $ sudo bin/tpoint nilfs2:nilfs2_segment_usage_allocated
> Tracing nilfs2:nilfs2_segment_usage_allocated. Ctrl-C to end.
>         segctord-17800 [002] ...1 10671.867294: nilfs2_segment_usage_allocated: sufile = ffff880054f908a8 segnum = 2
>         segctord-17800 [002] ...1 10675.073477: nilfs2_segment_usage_allocated: sufile = ffff880054f908a8 segnum = 3
>
> Cc: Benixon Dhas <benixon.dhas-Sjgp3cTcYWE@public.gmane.org>
> Cc: TK Kato <TK.Kato-Sjgp3cTcYWE@public.gmane.org>
> Signed-off-by: Hitoshi Mitake <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Applied to the tracepoints branch.

Thanks,
Ryusuke Konishi

> ---
>  fs/nilfs2/sufile.c            |  8 ++++++
>  include/trace/events/nilfs2.h | 67 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 75 insertions(+)
>
> diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
> index 2a869c3..7ff8f15 100644
> --- a/fs/nilfs2/sufile.c
> +++ b/fs/nilfs2/sufile.c
> @@ -30,6 +30,8 @@
>  #include "mdt.h"
>  #include "sufile.h"
>
> +#include <trace/events/nilfs2.h>
> +
>  /**
>   * struct nilfs_sufile_info - on-memory private data of sufile
>   * @mi: on-memory private data of metadata file
> @@ -358,6 +360,7 @@ int nilfs_sufile_alloc(struct inode *sufile, __u64 *segnump)
>                                 break; /* never happens */
>                         }
>                 }
> +               trace_nilfs2_segment_usage_check(sufile, segnum, cnt);
>                 ret = nilfs_sufile_get_segment_usage_block(sufile, segnum, 1,
>                                                            &su_bh);
>                 if (ret < 0)
> @@ -388,6 +391,9 @@ int nilfs_sufile_alloc(struct inode *sufile, __u64 *segnump)
>                         nilfs_mdt_mark_dirty(sufile);
>                         brelse(su_bh);
>                         *segnump = segnum;
> +
> +                       trace_nilfs2_segment_usage_allocated(sufile, segnum);
> +
>                         goto out_header;
>                 }
>
> @@ -490,6 +496,8 @@ void nilfs_sufile_do_free(struct inode *sufile, __u64 segnum,
>         NILFS_SUI(sufile)->ncleansegs++;
>
>         nilfs_mdt_mark_dirty(sufile);
> +
> +       trace_nilfs2_segment_usage_freed(sufile, segnum);
>  }
>
>  /**
> diff --git a/include/trace/events/nilfs2.h b/include/trace/events/nilfs2.h
> index e5649ac..1b65ba6 100644
> --- a/include/trace/events/nilfs2.h
> +++ b/include/trace/events/nilfs2.h
> @@ -95,6 +95,73 @@ TRACE_EVENT(nilfs2_transaction_transition,
>                       show_transaction_state(__entry->state))
>  );
>
> +TRACE_EVENT(nilfs2_segment_usage_check,
> +           TP_PROTO(struct inode *sufile,
> +                    __u64 segnum,
> +                    unsigned long cnt),
> +
> +           TP_ARGS(sufile, segnum, cnt),
> +
> +           TP_STRUCT__entry(
> +                   __field(struct inode *, sufile)
> +                   __field(__u64, segnum)
> +                   __field(unsigned long, cnt)
> +           ),
> +
> +           TP_fast_assign(
> +                   __entry->sufile = sufile;
> +                   __entry->segnum = segnum;
> +                   __entry->cnt = cnt;
> +                   ),
> +
> +           TP_printk("sufile = %p segnum = %llu cnt = %lu",
> +                     __entry->sufile,
> +                     __entry->segnum,
> +                     __entry->cnt)
> +);
> +
> +TRACE_EVENT(nilfs2_segment_usage_allocated,
> +           TP_PROTO(struct inode *sufile,
> +                    __u64 segnum),
> +
> +           TP_ARGS(sufile, segnum),
> +
> +           TP_STRUCT__entry(
> +                   __field(struct inode *, sufile)
> +                   __field(__u64, segnum)
> +           ),
> +
> +           TP_fast_assign(
> +                   __entry->sufile = sufile;
> +                   __entry->segnum = segnum;
> +                   ),
> +
> +           TP_printk("sufile = %p segnum = %llu",
> +                     __entry->sufile,
> +                     __entry->segnum)
> +);
> +
> +TRACE_EVENT(nilfs2_segment_usage_freed,
> +           TP_PROTO(struct inode *sufile,
> +                    __u64 segnum),
> +
> +           TP_ARGS(sufile, segnum),
> +
> +           TP_STRUCT__entry(
> +                   __field(struct inode *, sufile)
> +                   __field(__u64, segnum)
> +           ),
> +
> +           TP_fast_assign(
> +                   __entry->sufile = sufile;
> +                   __entry->segnum = segnum;
> +                   ),
> +
> +           TP_printk("sufile = %p segnum = %llu",
> +                     __entry->sufile,
> +                     __entry->segnum)
> +);
> +
>  #endif /* _TRACE_NILFS2_H */
>
>  /* This part must be outside protection */
> --
> 1.9.1
>
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
