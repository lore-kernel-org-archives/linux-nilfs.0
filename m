From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH linux-next] nilfs2: Remove the unneeded result variable
Date: Wed, 31 Aug 2022 14:00:34 +0900
Message-ID: <CAKFNMokS2zV5hJsBkcj=wiSkOkVHiqT_jFi18aBFW_gbNHnP5w@mail.gmail.com>
References: <20220831033403.302184-1-ye.xingchen@zte.com.cn>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=hP8w1oBDqJGAsXujKb/CVqCqGWT4GD4/gS/Uk4niIUc=;
        b=U2sDz1rAezdP1Sj5bHvd6szx1iNoBX0K5Wbnu3cW5OoN0uwMug+oJaS1qFsfwIj27Y
         9QnA5WX5EmaF5C4S9DZClPg090f0Q4WB7oj/zql033FyPO64hgVcJmz82ha61HGB9ui+
         pGGZAhhCdk1aMih0sPm6heP7qBleYkX9JUALM3LCooawCjqTyHM6KSfN+uCFf9/+Y465
         ZgsTK2945Bki0iqTqVbCdht/My8a+3lppMb9V5gHT6aZXzkymempomdgy715W+3ILsq0
         s29UshM1/lOqLLXHhw15oCDzWvyVsiIV5PBYqvseqX5FI0QHzWwc5apZf7BgELpJ53hR
         uwyg==
In-Reply-To: <20220831033403.302184-1-ye.xingchen-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ye xingchen <ye.xingchen-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>, Zeal Robot <zealci-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>

On Wed, Aug 31, 2022 at 12:34 PM wrote:
>
> From: ye xingchen <ye.xingchen-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
>
> Return the value nilfs_segctor_sync() directly instead of storing it in
> another redundant variable.
>
> Reported-by: Zeal Robot <zealci-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
> Signed-off-by: ye xingchen <ye.xingchen-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
> ---
>  fs/nilfs2/segment.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index 0afe0832c754..9abae2c9120e 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -2235,7 +2235,6 @@ int nilfs_construct_segment(struct super_block *sb)
>         struct the_nilfs *nilfs = sb->s_fs_info;
>         struct nilfs_sc_info *sci = nilfs->ns_writer;
>         struct nilfs_transaction_info *ti;
> -       int err;
>
>         if (!sci)
>                 return -EROFS;
> @@ -2243,8 +2242,7 @@ int nilfs_construct_segment(struct super_block *sb)
>         /* A call inside transactions causes a deadlock. */
>         BUG_ON((ti = current->journal_info) && ti->ti_magic == NILFS_TI_MAGIC);
>
> -       err = nilfs_segctor_sync(sci);
> -       return err;
> +       return nilfs_segctor_sync(sci);
>  }
>
>  /**
> --
> 2.25.1

The patch is not wrong though this kind of minor rewrite seems endless.
Anyway, I would like to queue this unless there is an objection.

Thanks,
Ryusuke Konishi
