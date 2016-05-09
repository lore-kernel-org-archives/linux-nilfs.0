From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: [PATCH 11/11] nilfs2: clean trailing semicolons in macros
Date: Mon, 09 May 2016 23:17:03 +0900 (JST)
Message-ID: <20160509.231703.1481729973362188932.konishi.ryusuke@lab.ntt.co.jp>
References: <1461935747-10380-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<1461935747-10380-12-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OLOxeXOVZCzTcByDo4xrmcsXSyTlY0AZHnhP0ePqUjM=;
        b=oEm7KiyWW61k8+BFympTDat7TiKBpzQvJSDoRga6lKV1xLduSfauAiTZb4wJrOc/aY
         cY41lP+ihQ+fYBKovvwlRpXO71cvc4kLuDW05w9mFGvScWLvgy1M1KggzKMn3x4nDIkm
         xhsMo09/QgVEYnnxWYGsmfpreokG+AXo96Fn7rnQTgeBAWsKr4i+bQ9W5kNOJ1LmDg84
         oQt6Tb9+ZYqhxppDgt65RX+on3+LpQB1By1DA/wsI4RebTVaeDj9+fz1zo81orjJ9GGx
         LEMLBhL+tysd1i2orLQZaGdDHftt8heBm+XNnLhInIlw/Wnkp3Q7Wy1kzBUKWd92GG9p
         wYVQ==
In-Reply-To: <1461935747-10380-12-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

Hi Andrew,

On Fri, 29 Apr 2016 22:15:47 +0900, Ryusuke Konishi wrote:
> Remove trailing semicolons from macros, as suggested by checkpatch.pl.
> 
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
> ---
<snip>
> diff --git a/fs/nilfs2/sysfs.h b/fs/nilfs2/sysfs.h
> index 677e3a1..648cedf 100644
> --- a/fs/nilfs2/sysfs.h
> +++ b/fs/nilfs2/sysfs.h
> @@ -66,7 +66,7 @@ struct nilfs_##name##_attr { \
>  			char *); \
>  	ssize_t (*store)(struct kobject *, struct attribute *, \
>  			 const char *, size_t); \
> -};
> +}
>  
>  NILFS_COMMON_ATTR_STRUCT(feature);
>  
> @@ -77,7 +77,7 @@ struct nilfs_##name##_attr { \
>  			char *); \
>  	ssize_t (*store)(struct nilfs_##name##_attr *, struct the_nilfs *, \
>  			 const char *, size_t); \
> -};
> +}
>  
>  NILFS_DEV_ATTR_STRUCT(dev);
>  NILFS_DEV_ATTR_STRUCT(segments);
> @@ -93,7 +93,7 @@ struct nilfs_##name##_attr { \
>  			char *); \
>  	ssize_t (*store)(struct nilfs_##name##_attr *, struct nilfs_root *, \
>  			 const char *, size_t); \
> -};
> +}
>  
>  NILFS_CP_ATTR_STRUCT(snapshot);
>  

Could you apply the following amendment ?

The above patch didn't modify the same style issue in nilfs2/sysfs.c.
This addition covers the remaining places.

Thanks,
Ryusuke Konishi
