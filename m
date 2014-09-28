From: Hitoshi Mitake <mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH tracepoints v2] nilfs2: add a tracepoint for transaction events
Date: Sun, 28 Sep 2014 19:18:45 +0900
Message-ID: <CAE1WaKL0nAs-3XxJYPbg-ZLJybmyHg0nJ6R_PFzLRPZp97dDkw@mail.gmail.com>
References: <1411651232-11244-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
	<20140926.005513.1587577331345482265.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=Cf8+wI1ezUNmgrNVNZVb9a+h2f/ec6Q71NqqlfbteV4=;
        b=SP3RJvk0nYAuXBbUC7slH1Xn+vkrGB7+hQARPIW2oWeIPzdyFL/G4dzNi2S8WaHsLe
         VnF+AnvXqfovlV2t44lqWpl70vkXjPTj8Xyw7B1AXXGAaELzSByd/Kl5obnTuv6/QGjU
         ejWLBoU89803DR68kI3TJzDm/q8lA4CJofzYyP1XkBajoTOYE8a5q+N449WFZnRILZwZ
         Xlmn4c+tm5Vpw1XzK+puIg6Qv9NCc/DWpAXGL5zp7RWFNHzpvzHPwKqja1L1RnRrdhQP
         ek/ZuZh0MLVr2DKACz56EkOnC30aG2eYg9ElTkdzz8YYPBTGFx7lqHGvzXiljKg6KcWr
         6Qlw==
In-Reply-To: <20140926.005513.1587577331345482265.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Sep 26, 2014 at 12:55 AM, Ryusuke Konishi
<konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org> wrote:
> Hi,
> On Thu, 25 Sep 2014 22:20:32 +0900, Mitake Hitoshi wrote:
>> This patch adds a tracepoint for transaction events of nilfs. With the
>> tracepoint, these events can be tracked: begin, abort, commit,
>> trylock, lock, and unlock. Basically, these events have corresponding
>> functions e.g. begin event corresponds nilfs_transaction_begin(). The
>> unlock event is an exception. It corresponds to the iteration in
>> nilfs_transaction_lock().
>>
>> Only one tracepoint is introcued: nilfs2_transaction_transition. The
>> above events are distinguished with newly introduced enum. With this
>> tracepoint, we can analyse a critical section of segment constructoin.
>>
>> Sample output by tpoint of perf-tools:
>>               cp-4457  [000] ...1    63.266220: nilfs2_transaction_transition: sb = ffff8802112b8800, ti = ffff8800bf5ccc58, count = 1, flags = 9 state = BEGIN
>>               cp-4457  [000] ...1    63.266221: nilfs2_transaction_transition: sb = ffff8802112b8800, ti = ffff8800bf5ccc58, count = 0, flags = 9 state = COMMIT
>>               cp-4457  [000] ...1    63.266221: nilfs2_transaction_transition: sb = ffff8802112b8800, ti = ffff8800bf5ccc58, count = 0, flags = 9 state = COMMIT
>>         segctord-4371  [001] ...1    68.261196: nilfs2_transaction_transition: sb = ffff8802112b8800, ti = ffff8800b889bdf8, count = 0, flags = 10 state = TRYLOCK
>>         segctord-4371  [001] ...1    68.261280: nilfs2_transaction_transition: sb = ffff8802112b8800, ti = ffff8800b889bdf8, count = 0, flags = 10 state = LOCK
>>         segctord-4371  [001] ...1    68.261877: nilfs2_transaction_transition: sb = ffff8802112b8800, ti = ffff8800b889bdf8, count = 1, flags = 10 state = BEGIN
>>         segctord-4371  [001] ...1    68.262116: nilfs2_transaction_transition: sb = ffff8802112b8800, ti = ffff8800b889bdf8, count = 0, flags = 18 state = COMMIT
>>         segctord-4371  [001] ...1    68.265032: nilfs2_transaction_transition: sb = ffff8802112b8800, ti = ffff8800b889bdf8, count = 0, flags = 18 state = UNLOCK
>>         segctord-4371  [001] ...1   132.376847: nilfs2_transaction_transition: sb = ffff8802112b8800, ti = ffff8800b889bdf8, count = 0, flags = 10 state = TRYLOCK
>>
>> Signed-off-by: Hitoshi Mitake <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
>> ---
>>  fs/nilfs2/segment.c           | 33 ++++++++++++++++++++++++++-
>>  include/trace/events/nilfs2.h | 53 +++++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 85 insertions(+), 1 deletion(-)
>>
>> v2: fix a style problem
>>
>> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
>> index 0fcf8e7..1dd9330 100644
>> --- a/fs/nilfs2/segment.c
>> +++ b/fs/nilfs2/segment.c
>> @@ -213,11 +213,18 @@ int nilfs_transaction_begin(struct super_block *sb,
>>  {
>>       struct the_nilfs *nilfs;
>>       int ret = nilfs_prepare_segment_lock(ti);
>> +     struct nilfs_transaction_info *trace_ti;
>>
>>       if (unlikely(ret < 0))
>>               return ret;
>> -     if (ret > 0)
>> +     if (ret > 0) {
>> +             trace_ti = current->journal_info;
>> +
>> +             trace_nilfs2_transaction_transition(sb, trace_ti,
>> +                                 trace_ti->ti_count, trace_ti->ti_flags,
>> +                                 TRACE_NILFS2_TRANSACTION_BEGIN);
>>               return 0;
>> +     }
>>
>>       sb_start_intwrite(sb);
>>
>> @@ -228,6 +235,11 @@ int nilfs_transaction_begin(struct super_block *sb,
>>               ret = -ENOSPC;
>>               goto failed;
>>       }
>> +
>> +     trace_ti = current->journal_info;
>> +     trace_nilfs2_transaction_transition(sb, trace_ti, trace_ti->ti_count,
>> +                                         trace_ti->ti_flags,
>> +                                         TRACE_NILFS2_TRANSACTION_BEGIN);
>>       return 0;
>>
>>   failed:
>> @@ -260,6 +272,8 @@ int nilfs_transaction_commit(struct super_block *sb)
>>       ti->ti_flags |= NILFS_TI_COMMIT;
>>       if (ti->ti_count > 0) {
>>               ti->ti_count--;
>> +             trace_nilfs2_transaction_transition(sb, ti, ti->ti_count,
>> +                         ti->ti_flags, TRACE_NILFS2_TRANSACTION_COMMIT);
>>               return 0;
>>       }
>>       if (nilfs->ns_writer) {
>> @@ -271,6 +285,9 @@ int nilfs_transaction_commit(struct super_block *sb)
>>                       nilfs_segctor_do_flush(sci, 0);
>>       }
>>       up_read(&nilfs->ns_segctor_sem);
>> +     trace_nilfs2_transaction_transition(sb, ti, ti->ti_count,
>> +                         ti->ti_flags, TRACE_NILFS2_TRANSACTION_COMMIT);
>> +
>>       current->journal_info = ti->ti_save;
>>
>>       if (ti->ti_flags & NILFS_TI_SYNC)
>> @@ -289,10 +306,15 @@ void nilfs_transaction_abort(struct super_block *sb)
>>       BUG_ON(ti == NULL || ti->ti_magic != NILFS_TI_MAGIC);
>>       if (ti->ti_count > 0) {
>>               ti->ti_count--;
>> +             trace_nilfs2_transaction_transition(sb, ti, ti->ti_count,
>> +                         ti->ti_flags, TRACE_NILFS2_TRANSACTION_ABORT);
>>               return;
>>       }
>>       up_read(&nilfs->ns_segctor_sem);
>>
>> +     trace_nilfs2_transaction_transition(sb, ti, ti->ti_count,
>> +                 ti->ti_flags, TRACE_NILFS2_TRANSACTION_ABORT);
>> +
>>       current->journal_info = ti->ti_save;
>>       if (ti->ti_flags & NILFS_TI_DYNAMIC_ALLOC)
>>               kmem_cache_free(nilfs_transaction_cachep, ti);
>> @@ -339,6 +361,9 @@ static void nilfs_transaction_lock(struct super_block *sb,
>>       current->journal_info = ti;
>>
>>       for (;;) {
>> +             trace_nilfs2_transaction_transition(sb, ti, ti->ti_count,
>> +                         ti->ti_flags, TRACE_NILFS2_TRANSACTION_TRYLOCK);
>> +
>>               down_write(&nilfs->ns_segctor_sem);
>>               if (!test_bit(NILFS_SC_PRIOR_FLUSH, &sci->sc_flags))
>>                       break;
>> @@ -350,6 +375,9 @@ static void nilfs_transaction_lock(struct super_block *sb,
>>       }
>>       if (gcflag)
>>               ti->ti_flags |= NILFS_TI_GC;
>> +
>> +     trace_nilfs2_transaction_transition(sb, ti, ti->ti_count,
>> +                         ti->ti_flags, TRACE_NILFS2_TRANSACTION_LOCK);
>>  }
>>
>>  static void nilfs_transaction_unlock(struct super_block *sb)
>> @@ -364,6 +392,9 @@ static void nilfs_transaction_unlock(struct super_block *sb)
>>       current->journal_info = ti->ti_save;
>>       if (!list_empty(&ti->ti_garbage))
>>               nilfs_dispose_list(nilfs, &ti->ti_garbage, 0);
>> +
>> +     trace_nilfs2_transaction_transition(sb, ti, ti->ti_count,
>> +                         ti->ti_flags, TRACE_NILFS2_TRANSACTION_UNLOCK);
>>  }
>>
>>  static void *nilfs_segctor_map_segsum_entry(struct nilfs_sc_info *sci,
>> diff --git a/include/trace/events/nilfs2.h b/include/trace/events/nilfs2.h
>> index 285d5f3..1c71093 100644
>> --- a/include/trace/events/nilfs2.h
>> +++ b/include/trace/events/nilfs2.h
>> @@ -42,6 +42,59 @@ TRACE_EVENT(nilfs2_collection_stage_transition,
>>                     show_collection_stage(__entry->stage))
>>  );
>>
>> +#ifndef TRACE_HEADER_MULTI_READ
>> +enum nilfs2_transaction_transition_state {
>> +     TRACE_NILFS2_TRANSACTION_BEGIN,
>> +     TRACE_NILFS2_TRANSACTION_COMMIT,
>> +     TRACE_NILFS2_TRANSACTION_ABORT,
>> +     TRACE_NILFS2_TRANSACTION_TRYLOCK,
>> +     TRACE_NILFS2_TRANSACTION_LOCK,
>> +     TRACE_NILFS2_TRANSACTION_UNLOCK,
>> +};
>> +#endif
>> +
>> +#define show_transaction_state(type)                                 \
>> +     __print_symbolic(type,                                          \
>> +                      { TRACE_NILFS2_TRANSACTION_BEGIN, "BEGIN" },   \
>> +                      { TRACE_NILFS2_TRANSACTION_COMMIT, "COMMIT" }, \
>> +                      { TRACE_NILFS2_TRANSACTION_ABORT, "ABORT" },   \
>> +                      { TRACE_NILFS2_TRANSACTION_TRYLOCK, "TRYLOCK" }, \
>> +                      { TRACE_NILFS2_TRANSACTION_LOCK, "LOCK" },     \
>> +                      { TRACE_NILFS2_TRANSACTION_UNLOCK, "UNLOCK" })
>> +
>> +TRACE_EVENT(nilfs2_transaction_transition,
>> +         TP_PROTO(struct super_block *sb,
>> +                  struct nilfs_transaction_info *ti,
>> +                  int count,
>> +                  unsigned int flags,
>> +                  enum nilfs2_transaction_transition_state state),
>> +
>> +         TP_ARGS(sb, ti, count, flags, state),
>> +
>> +         TP_STRUCT__entry(
>> +                 __field(void *, sb)
>> +                 __field(void *, ti)
>> +                 __field(int, count)
>> +                 __field(unsigned int, flags)
>> +                 __field(int, state)
>> +         ),
>> +
>> +         TP_fast_assign(
>> +                 __entry->sb = sb;
>> +                 __entry->ti = ti;
>> +                 __entry->count = count;
>> +                 __entry->flags = flags;
>> +                 __entry->state = state;
>> +                 ),
>> +
>> +         TP_printk("sb = %p, ti = %p, count = %d, flags = %x state = %s",
>
> The use of commas in this format looks inconsistent.  It looks like
> most tracepoint messages skip commas and extra space chars around
> equal symbols as follows:
>
>   TP_printk("sb=%p ti=%p count=%d flags=%x state=%s",
>
> Seem that it's preferable to follow such practice.

Sorry for that. I'll make the style consistent in v3.

Thanks,
Hitoshi

>
> Regards,
> Ryusuke Konishi
>
>> +                   __entry->sb,
>> +                   __entry->ti,
>> +                   __entry->count,
>> +                   __entry->flags,
>> +                   show_transaction_state(__entry->state))
>> +);
>> +
>>  #endif /* _TRACE_NILFS2_H */
>>
>>  /* This part must be outside protection */
>> --
>> 1.9.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
