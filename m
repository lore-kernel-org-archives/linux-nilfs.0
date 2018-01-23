From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH] nilfs2: use time64_t internally
Date: Tue, 23 Jan 2018 09:31:09 +0900
Message-ID: <CAKFNMomACRQvA0Noo7gVESQu-oTpccfjXfqdYVD09hRt2hJWZQ@mail.gmail.com>
References: <20180122211050.1286441-1-arnd@arndb.de>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=ZlZBGK3eLhzoKnqz7gRVSZjTEo8iu447XS+OmPW7XM8=;
        b=KlMEMjwKtFW6fhDOwgvg9NeGhOiRY06b34AaytRigx5Yjbs43esn9OsOzDWAIy8FvB
         xmvmjn9JgzZ+4gYFqNiecz/rqQTrkxF3EcfVfMHoIoFwojqyj9ifTZWaYlyy1q6xopBe
         ZcpkjCoWl6y7mpdm6AFZS96N/G0/3CUc4hRcBQfxGUaBEw2nrowcPF04Hb2RUHelOX3U
         m58AJLcGCby9bxtI7rQxsh857qR/LqKmIm6l1639Ub03n6bpoDafl80ckwxRgLxikJbF
         LHUUFk8PHwltatA79IdCHn44y0hhmLRFjUwGT5JZuxf/4kh3ekC1SzfsSVzsCOtYwEHT
         nkHA==
In-Reply-To: <20180122211050.1286441-1-arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: y2038-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

2018-01-23 6:10 GMT+09:00 Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>:
> The superblock and segment timestamps are used only internally in nilfs2
> and can be read out using sysfs. Since we are using the old 'get_seconds()'
> interface and store the data as timestamps, the behavior differs slightly
> between 64-bit and 32-bit kernels, the latter will show incorrect timestamps
> after 2038 in sysfs, and presumably fail completely in 2106 as comparisons
> go wrong.
>
> This changes nilfs2 to use time64_t with ktime_get_real_seconds() to handle
> timestamps, making the behavior consistent and correct on both 32-bit
> and 64-bit machines.
>
> The on-disk format already uses 64-bit timestamps, so nothing changes
> there.
>
> Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>

Thank you for this patch.

Acked-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>


> ---
>  fs/nilfs2/segbuf.c    |  2 +-
>  fs/nilfs2/segbuf.h    |  4 ++--
>  fs/nilfs2/segment.c   |  2 +-
>  fs/nilfs2/segment.h   |  2 +-
>  fs/nilfs2/sufile.c    |  2 +-
>  fs/nilfs2/sufile.h    |  2 +-
>  fs/nilfs2/super.c     |  4 ++--
>  fs/nilfs2/sysfs.c     | 21 ++++++++++-----------
>  fs/nilfs2/the_nilfs.h |  8 ++++----
>  9 files changed, 23 insertions(+), 24 deletions(-)
>
> diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
> index 6c5009cc4e6f..68cb9e4740b4 100644
> --- a/fs/nilfs2/segbuf.c
> +++ b/fs/nilfs2/segbuf.c
> @@ -130,7 +130,7 @@ int nilfs_segbuf_extend_payload(struct nilfs_segment_buffer *segbuf,
>  }
>
>  int nilfs_segbuf_reset(struct nilfs_segment_buffer *segbuf, unsigned int flags,
> -                      time_t ctime, __u64 cno)
> +                      time64_t ctime, __u64 cno)
>  {
>         int err;
>
> diff --git a/fs/nilfs2/segbuf.h b/fs/nilfs2/segbuf.h
> index 7bbccc099709..10e16935fff6 100644
> --- a/fs/nilfs2/segbuf.h
> +++ b/fs/nilfs2/segbuf.h
> @@ -46,7 +46,7 @@ struct nilfs_segsum_info {
>         unsigned long           nfileblk;
>         u64                     seg_seq;
>         __u64                   cno;
> -       time_t                  ctime;
> +       time64_t                ctime;
>         sector_t                next;
>  };
>
> @@ -120,7 +120,7 @@ void nilfs_segbuf_map_cont(struct nilfs_segment_buffer *segbuf,
>                            struct nilfs_segment_buffer *prev);
>  void nilfs_segbuf_set_next_segnum(struct nilfs_segment_buffer *, __u64,
>                                   struct the_nilfs *);
> -int nilfs_segbuf_reset(struct nilfs_segment_buffer *, unsigned int, time_t,
> +int nilfs_segbuf_reset(struct nilfs_segment_buffer *, unsigned int, time64_t,
>                        __u64);
>  int nilfs_segbuf_extend_segsum(struct nilfs_segment_buffer *);
>  int nilfs_segbuf_extend_payload(struct nilfs_segment_buffer *,
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index 9f3ffba41533..0953635e7d48 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -2040,7 +2040,7 @@ static int nilfs_segctor_do_construct(struct nilfs_sc_info *sci, int mode)
>                         goto out;
>
>                 /* Update time stamp */
> -               sci->sc_seg_ctime = get_seconds();
> +               sci->sc_seg_ctime = ktime_get_real_seconds();
>
>                 err = nilfs_segctor_collect(sci, nilfs, mode);
>                 if (unlikely(err))
> diff --git a/fs/nilfs2/segment.h b/fs/nilfs2/segment.h
> index 84084a4d9b3e..04634e3e3d58 100644
> --- a/fs/nilfs2/segment.h
> +++ b/fs/nilfs2/segment.h
> @@ -157,7 +157,7 @@ struct nilfs_sc_info {
>         unsigned long           sc_blk_cnt;
>         unsigned long           sc_datablk_cnt;
>         unsigned long           sc_nblk_this_inc;
> -       time_t                  sc_seg_ctime;
> +       time64_t                sc_seg_ctime;
>         __u64                   sc_cno;
>         unsigned long           sc_flags;
>
> diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
> index 1341a41e7b43..c7fa139d50e8 100644
> --- a/fs/nilfs2/sufile.c
> +++ b/fs/nilfs2/sufile.c
> @@ -526,7 +526,7 @@ int nilfs_sufile_mark_dirty(struct inode *sufile, __u64 segnum)
>   * @modtime: modification time (option)
>   */
>  int nilfs_sufile_set_segment_usage(struct inode *sufile, __u64 segnum,
> -                                  unsigned long nblocks, time_t modtime)
> +                                  unsigned long nblocks, time64_t modtime)
>  {
>         struct buffer_head *bh;
>         struct nilfs_segment_usage *su;
> diff --git a/fs/nilfs2/sufile.h b/fs/nilfs2/sufile.h
> index 158a9190c8ec..673a891350f4 100644
> --- a/fs/nilfs2/sufile.h
> +++ b/fs/nilfs2/sufile.h
> @@ -35,7 +35,7 @@ int nilfs_sufile_set_alloc_range(struct inode *sufile, __u64 start, __u64 end);
>  int nilfs_sufile_alloc(struct inode *, __u64 *);
>  int nilfs_sufile_mark_dirty(struct inode *sufile, __u64 segnum);
>  int nilfs_sufile_set_segment_usage(struct inode *sufile, __u64 segnum,
> -                                  unsigned long nblocks, time_t modtime);
> +                                  unsigned long nblocks, time64_t modtime);
>  int nilfs_sufile_get_stat(struct inode *, struct nilfs_sustat *);
>  ssize_t nilfs_sufile_get_suinfo(struct inode *, __u64, void *, unsigned int,
>                                 size_t);
> diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> index 3073b646e1ba..6ffeca84d7c3 100644
> --- a/fs/nilfs2/super.c
> +++ b/fs/nilfs2/super.c
> @@ -283,10 +283,10 @@ int nilfs_commit_super(struct super_block *sb, int flag)
>  {
>         struct the_nilfs *nilfs = sb->s_fs_info;
>         struct nilfs_super_block **sbp = nilfs->ns_sbp;
> -       time_t t;
> +       time64_t t;
>
>         /* nilfs->ns_sem must be locked by the caller. */
> -       t = get_seconds();
> +       t = ktime_get_real_seconds();
>         nilfs->ns_sbwtime = t;
>         sbp[0]->s_wtime = cpu_to_le64(t);
>         sbp[0]->s_sum = 0;
> diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
> index 490303e3d517..4b25837e7724 100644
> --- a/fs/nilfs2/sysfs.c
> +++ b/fs/nilfs2/sysfs.c
> @@ -31,7 +31,7 @@ static struct kset *nilfs_kset;
>  #define NILFS_SHOW_TIME(time_t_val, buf) ({ \
>                 struct tm res; \
>                 int count = 0; \
> -               time_to_tm(time_t_val, 0, &res); \
> +               time64_to_tm(time_t_val, 0, &res); \
>                 res.tm_year += 1900; \
>                 res.tm_mon += 1; \
>                 count = scnprintf(buf, PAGE_SIZE, \
> @@ -579,7 +579,7 @@ nilfs_segctor_last_seg_write_time_show(struct nilfs_segctor_attr *attr,
>                                         struct the_nilfs *nilfs,
>                                         char *buf)
>  {
> -       time_t ctime;
> +       time64_t ctime;
>
>         down_read(&nilfs->ns_segctor_sem);
>         ctime = nilfs->ns_ctime;
> @@ -593,13 +593,13 @@ nilfs_segctor_last_seg_write_time_secs_show(struct nilfs_segctor_attr *attr,
>                                             struct the_nilfs *nilfs,
>                                             char *buf)
>  {
> -       time_t ctime;
> +       time64_t ctime;
>
>         down_read(&nilfs->ns_segctor_sem);
>         ctime = nilfs->ns_ctime;
>         up_read(&nilfs->ns_segctor_sem);
>
> -       return snprintf(buf, PAGE_SIZE, "%llu\n", (unsigned long long)ctime);
> +       return snprintf(buf, PAGE_SIZE, "%llu\n", ctime);
>  }
>
>  static ssize_t
> @@ -607,7 +607,7 @@ nilfs_segctor_last_nongc_write_time_show(struct nilfs_segctor_attr *attr,
>                                          struct the_nilfs *nilfs,
>                                          char *buf)
>  {
> -       time_t nongc_ctime;
> +       time64_t nongc_ctime;
>
>         down_read(&nilfs->ns_segctor_sem);
>         nongc_ctime = nilfs->ns_nongc_ctime;
> @@ -621,14 +621,13 @@ nilfs_segctor_last_nongc_write_time_secs_show(struct nilfs_segctor_attr *attr,
>                                                 struct the_nilfs *nilfs,
>                                                 char *buf)
>  {
> -       time_t nongc_ctime;
> +       time64_t nongc_ctime;
>
>         down_read(&nilfs->ns_segctor_sem);
>         nongc_ctime = nilfs->ns_nongc_ctime;
>         up_read(&nilfs->ns_segctor_sem);
>
> -       return snprintf(buf, PAGE_SIZE, "%llu\n",
> -                       (unsigned long long)nongc_ctime);
> +       return snprintf(buf, PAGE_SIZE, "%llu\n", nongc_ctime);
>  }
>
>  static ssize_t
> @@ -728,7 +727,7 @@ nilfs_superblock_sb_write_time_show(struct nilfs_superblock_attr *attr,
>                                      struct the_nilfs *nilfs,
>                                      char *buf)
>  {
> -       time_t sbwtime;
> +       time64_t sbwtime;
>
>         down_read(&nilfs->ns_sem);
>         sbwtime = nilfs->ns_sbwtime;
> @@ -742,13 +741,13 @@ nilfs_superblock_sb_write_time_secs_show(struct nilfs_superblock_attr *attr,
>                                          struct the_nilfs *nilfs,
>                                          char *buf)
>  {
> -       time_t sbwtime;
> +       time64_t sbwtime;
>
>         down_read(&nilfs->ns_sem);
>         sbwtime = nilfs->ns_sbwtime;
>         up_read(&nilfs->ns_sem);
>
> -       return snprintf(buf, PAGE_SIZE, "%llu\n", (unsigned long long)sbwtime);
> +       return snprintf(buf, PAGE_SIZE, "%llu\n", sbwtime);
>  }
>
>  static ssize_t
> diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
> index 883d732b0259..36da1779f976 100644
> --- a/fs/nilfs2/the_nilfs.h
> +++ b/fs/nilfs2/the_nilfs.h
> @@ -116,7 +116,7 @@ struct the_nilfs {
>          */
>         struct buffer_head     *ns_sbh[2];
>         struct nilfs_super_block *ns_sbp[2];
> -       time_t                  ns_sbwtime;
> +       time64_t                ns_sbwtime;
>         unsigned int            ns_sbwcount;
>         unsigned int            ns_sbsize;
>         unsigned int            ns_mount_state;
> @@ -131,8 +131,8 @@ struct the_nilfs {
>         __u64                   ns_nextnum;
>         unsigned long           ns_pseg_offset;
>         __u64                   ns_cno;
> -       time_t                  ns_ctime;
> -       time_t                  ns_nongc_ctime;
> +       time64_t                ns_ctime;
> +       time64_t                ns_nongc_ctime;
>         atomic_t                ns_ndirtyblks;
>
>         /*
> @@ -267,7 +267,7 @@ struct nilfs_root {
>
>  static inline int nilfs_sb_need_update(struct the_nilfs *nilfs)
>  {
> -       u64 t = get_seconds();
> +       u64 t = ktime_get_real_seconds();
>
>         return t < nilfs->ns_sbwtime ||
>                 t > nilfs->ns_sbwtime + nilfs->ns_sb_update_freq;
> --
> 2.9.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
