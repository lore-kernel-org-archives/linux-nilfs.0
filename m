From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v5 2/6] nilfs-utils: add NILFS_OPT_SET_SUINFO
Date: Fri, 07 Feb 2014 09:44:25 +0900 (JST)
Message-ID: <20140207.094425.204303460.konishi.ryusuke@lab.ntt.co.jp>
References: <cover.1391692941.git.andreas.rohner@gmx.net>
	<cover.1391692941.git.andreas.rohner@gmx.net>
	<8f8e0f20685c057505ef3150398de39c8427d1ea.1391692941.git.andreas.rohner@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8f8e0f20685c057505ef3150398de39c8427d1ea.1391692941.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu,  6 Feb 2014 15:17:22 +0100, Andreas Rohner wrote:
> This option for the nilfs object corresponds to the use_set_suinfo
> flag in the configuration file. This patch adds the flag itself
> plus some convenience functions.
> 
> The option is set after the configuration file was read in.
> 
> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
> ---
>  include/nilfs.h          |  7 ++++++-
>  lib/nilfs.c              | 28 ++++++++++++++++++++++++++++
>  sbin/cleanerd/cleanerd.c |  6 ++++++
>  3 files changed, 40 insertions(+), 1 deletion(-)
> 
> diff --git a/include/nilfs.h b/include/nilfs.h
> index 56286a9..b5f85d3 100644
> --- a/include/nilfs.h
> +++ b/include/nilfs.h
> @@ -128,7 +128,8 @@ struct nilfs {
>  #define NILFS_OPEN_RDWR		0x0008	/* Open NILFS API in read/write mode */
>  #define NILFS_OPEN_GCLK		0x1000	/* Open GC lock primitive */
>  
> -#define NILFS_OPT_MMAP	0x01
> +#define NILFS_OPT_MMAP		0x01
> +#define NILFS_OPT_SET_SUINFO	0x02
>  
>  
>  struct nilfs *nilfs_open(const char *, const char *, int);
> @@ -140,6 +141,10 @@ void nilfs_opt_clear_mmap(struct nilfs *);
>  int nilfs_opt_set_mmap(struct nilfs *);
>  int nilfs_opt_test_mmap(struct nilfs *);
>  
> +void nilfs_opt_clear_set_suinfo(struct nilfs *);
> +int nilfs_opt_set_set_suinfo(struct nilfs *);
> +int nilfs_opt_test_set_suinfo(struct nilfs *);
> +
>  nilfs_cno_t nilfs_get_oldest_cno(struct nilfs *);
>  
>  struct nilfs_super_block *nilfs_get_sb(struct nilfs *);
> diff --git a/lib/nilfs.c b/lib/nilfs.c
> index c1771e8..93822de 100644
> --- a/lib/nilfs.c
> +++ b/lib/nilfs.c
> @@ -288,6 +288,34 @@ int nilfs_opt_test_mmap(struct nilfs *nilfs)
>  	return !!(nilfs->n_opts & NILFS_OPT_MMAP);
>  }
>  
> +/**
> + * nilfs_opt_set_set_suinfo - set set_suinfo option
> + * @nilfs: nilfs object
> + */
> +int nilfs_opt_set_set_suinfo(struct nilfs *nilfs)
> +{
> +	nilfs->n_opts |= NILFS_OPT_SET_SUINFO;
> +	return 0;
> +}
> +
> +/**
> + * nilfs_opt_clear_set_suinfo - clear set_suinfo option
> + * @nilfs: nilfs object
> + */
> +void nilfs_opt_clear_set_suinfo(struct nilfs *nilfs)
> +{
> +	nilfs->n_opts &= ~NILFS_OPT_SET_SUINFO;
> +}
> +
> +/**
> + * nilfs_opt_test_set_suinfo - test whether set_suinfo option is set or not
> + * @nilfs: nilfs object
> + */
> +int nilfs_opt_test_set_suinfo(struct nilfs *nilfs)
> +{
> +	return !!(nilfs->n_opts & NILFS_OPT_SET_SUINFO);
> +}
> +
>  static int nilfs_open_sem(struct nilfs *nilfs)
>  {
>  	char semnambuf[NAME_MAX - 4];
> diff --git a/sbin/cleanerd/cleanerd.c b/sbin/cleanerd/cleanerd.c
> index c58a542..4624f92 100644
> --- a/sbin/cleanerd/cleanerd.c
> +++ b/sbin/cleanerd/cleanerd.c
> @@ -248,6 +248,12 @@ static int nilfs_cleanerd_config(struct nilfs_cleanerd *cleanerd,
>  	else
>  		nilfs_opt_clear_mmap(cleanerd->nilfs);
>  #endif	/* HAVE_MMAP */
> +
> +	if (cleanerd->config.cf_use_set_suinfo)
> +		nilfs_opt_set_set_suinfo(cleanerd->nilfs);
> +	else
> +		nilfs_opt_clear_set_suinfo(cleanerd->nilfs);
> +
>  	nilfs_cleanerd_set_log_priority(cleanerd);
>  
>  	if (protection_period != ULONG_MAX) {
> -- 
> 1.8.5.3
> 

Looks good to me.

Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
