From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v2 1/9] nilfs2: copy file system feature flags to the
 nilfs object
Date: Sat, 09 May 2015 10:54:45 +0900 (JST)
Message-ID: <20150509.105445.1816655707671265145.konishi.ryusuke@lab.ntt.co.jp>
References: <1430647522-14304-1-git-send-email-andreas.rohner@gmx.net>
	<1430647522-14304-2-git-send-email-andreas.rohner@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=pYQJA2lXCZrniUUM/GW9cjrJyTZ1afSjvw7AnVA8Mjg=;
        b=hBd7zKeVJqybwYnoXDERqzkeEYeFy8CYE8+zek1yeOXxh2Z6rqDH3C1+AM61uL7c7F
         p+UsQASeB3D3OOxM7e3uJ6EbKN3bcTfHrwn6PEwPSAzfTCVzmqhSuh6OKr2ZWSoeMNJf
         VzJRRiiZ4bKh7q8vALV44F1GyOe/3k7UI/mJMT4T+zguD/0AAVQcvDsHT5ULd6Zh1UTH
         eYF/hm9izEOdgiyTeLSS0+1S14g+xNQt/R7HtX+kw9wcH+jh0r/nuKUpOXFUiV3wHqOR
         tythBu0caT8xcZRmu/d+wz5a5EJXQPk1hHBPRg4Jfc4ubM0LW49OmOqMJ3KdF4+SCe1o
         3Xtw==
In-Reply-To: <1430647522-14304-2-git-send-email-andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun,  3 May 2015 12:05:14 +0200, Andreas Rohner wrote:
> This patch adds three new attributes to the nilfs object, which contain
> a copy of the feature flags from the super block. This can be used, to
> efficiently test whether file system feature flags are set or not.
> 
> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
> ---
>  fs/nilfs2/the_nilfs.c | 4 ++++
>  fs/nilfs2/the_nilfs.h | 8 ++++++++
>  2 files changed, 12 insertions(+)
> 
> diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
> index 69bd801..606fdfc 100644
> --- a/fs/nilfs2/the_nilfs.c
> +++ b/fs/nilfs2/the_nilfs.c
> @@ -630,6 +630,10 @@ int init_nilfs(struct the_nilfs *nilfs, struct super_block *sb, char *data)
>  	get_random_bytes(&nilfs->ns_next_generation,
>  			 sizeof(nilfs->ns_next_generation));
>  
> +	nilfs->ns_feature_compat = le64_to_cpu(sbp->s_feature_compat);
> +	nilfs->ns_feature_compat_ro = le64_to_cpu(sbp->s_feature_compat_ro);
> +	nilfs->ns_feature_incompat = le64_to_cpu(sbp->s_feature_incompat);

Consider moving these initialization to just before calling
nilfs_check_feature_compatibility().

It uses compat flags, and I'd like to unfold the function using these
internal variables sometime.

> +
>  	err = nilfs_store_disk_layout(nilfs, sbp);
>  	if (err)
>  		goto failed_sbh;
> diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
> index 23778d3..12cd91d 100644
> --- a/fs/nilfs2/the_nilfs.h
> +++ b/fs/nilfs2/the_nilfs.h
> @@ -101,6 +101,9 @@ enum {
>   * @ns_dev_kobj: /sys/fs/<nilfs>/<device>
>   * @ns_dev_kobj_unregister: completion state
>   * @ns_dev_subgroups: <device> subgroups pointer
> + * @ns_feature_compat: Compatible feature set
> + * @ns_feature_compat_ro: Read-only compatible feature set
> + * @ns_feature_incompat: Incompatible feature set
>   */
>  struct the_nilfs {
>  	unsigned long		ns_flags;
> @@ -201,6 +204,11 @@ struct the_nilfs {
>  	struct kobject ns_dev_kobj;
>  	struct completion ns_dev_kobj_unregister;
>  	struct nilfs_sysfs_dev_subgroups *ns_dev_subgroups;
> +
> +	/* Features */
> +	__u64                   ns_feature_compat;
> +	__u64                   ns_feature_compat_ro;
> +	__u64                   ns_feature_incompat;
>  };
>  
>  #define THE_NILFS_FNS(bit, name)					\
> -- 
> 2.3.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
