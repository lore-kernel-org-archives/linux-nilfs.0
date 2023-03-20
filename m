From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: Re: [RESEND,PATCH v2 01/10] kobject: introduce kobject_del_and_put()
Date: Tue, 21 Mar 2023 06:38:58 +0900
Message-ID: <2229e074-d78e-3bd5-bf06-a53e9ad57d02@opensource.wdc.com>
References: <20230320184657.56198-1-frank.li@vivo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1679348447; x=1710884447;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bxVzq8suDNih9SH1Ok62kaz7FvxQWlE5bz197aYsbjU=;
  b=LUVw5dRJ90uBDRvjp39yvQw4760mYAUl+t/0g6+iI2YqNwYoYLhupTqT
   pjoSh6+QgoBeNRSGTZTys+5jXvXwOOFwXCJIYlJGboIULyurKl3iLguQM
   DJYGjv0fHLDtXPkiUdwSj52kw4ajAWkwqpkTcacr9cTdqGhBuNVFh8q0/
   XaEWxjE0Zri71iyP6an/aXlOgLfFw10FaRlWKs3EQZUWRv/chjS/f7/ki
   59boqd9CQJrXySoyJouKQxa5DwZdMAmRXN/s/LicpHkO6aRnvpWgvnYJ7
   /i29GjT2Ttt8MXRM2RhbFLoIz1JJONxENLqwoodMjF4wS+UsStomr9KDI
   A==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1679348345; x=1681940346; bh=bxVzq8suDNih9SH1Ok62kaz7FvxQWlE5bz1
        97aYsbjU=; b=EKxs8rpUot/qFRHAvND09IIAv6cqU/2Lev47PpifnoY6Vn42PvZ
        bLqMSLk5W+AyQuqTGKwodJfY4iDfhinl9cyIK7N2mtXEWEbGsMTiKxFf0DCuYwfv
        U7tD4WDxe1pbv3HNUfmVAdcHrTAMKvexZTU0GM1jYO4oNPGmPiD77lxKs2Zw8Hzb
        PwIdTneUr52J5sAiu9A7XMDGoEBHZesZf8Ek4BS/umk2gVFaA1nuC+gmt+D5Qto6
        f5pqaIAayhxw2wlTZV+cAvKH6KJ3w/adruI7wi3ZwobRCy9apzq/Jd2TLBhGAwdK
        dxo6IBbJ/jukaj9W89Dx0kqPLMgyapwzAcw==
Content-Language: en-US
In-Reply-To: <20230320184657.56198-1-frank.li@vivo.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Yangtao Li <frank.li@vivo.com>, clm@fb.com, josef@toxicpanda.com, dsterba@suse.com, xiang@kernel.org, chao@kernel.org, huyue2@coolpad.com, jefflexu@linux.alibaba.com, jaegeuk@kernel.org, trond.myklebust@hammerspace.com, anna@kernel.org, konishi.ryusuke@gmail.com, mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, richard@nod.at, djwong@kernel.org, naohiro.aota@wdc.com, jth@kernel.org, gregkh@linuxfoundation.org, rafael@kernel.org
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-f2fs-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On 3/21/23 03:46, Yangtao Li wrote:
> There are plenty of using kobject_del() and kobject_put() together
> in the kernel tree. This patch wraps these two calls in a single helper.
> 
> Signed-off-by: Yangtao Li <frank.li@vivo.com>
> ---
> v2:
> -add kobject_del_and_put() users
> resend patchset to gregkh, Rafael and Damien
>  include/linux/kobject.h |  1 +
>  lib/kobject.c           | 17 +++++++++++++++--
>  2 files changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/kobject.h b/include/linux/kobject.h
> index bdab370a24f4..782d4bd119f8 100644
> --- a/include/linux/kobject.h
> +++ b/include/linux/kobject.h
> @@ -111,6 +111,7 @@ extern struct kobject *kobject_get(struct kobject *kobj);
>  extern struct kobject * __must_check kobject_get_unless_zero(
>  						struct kobject *kobj);
>  extern void kobject_put(struct kobject *kobj);
> +extern void kobject_del_and_put(struct kobject *kobj);
>  
>  extern const void *kobject_namespace(const struct kobject *kobj);
>  extern void kobject_get_ownership(const struct kobject *kobj,
> diff --git a/lib/kobject.c b/lib/kobject.c
> index 6e2f0bee3560..8c0293e37214 100644
> --- a/lib/kobject.c
> +++ b/lib/kobject.c
> @@ -731,6 +731,20 @@ void kobject_put(struct kobject *kobj)
>  }
>  EXPORT_SYMBOL(kobject_put);
>  
> +/**
> + * kobject_del_and_put() - Delete kobject.
> + * @kobj: object.
> + *
> + * Unlink kobject from hierarchy and decrement the refcount.
> + * If refcount is 0, call kobject_cleanup().
> + */
> +void kobject_del_and_put(struct kobject *kobj)
> +{
> +	kobject_del(kobj);
> +	kobject_put(kobj);
> +}
> +EXPORT_SYMBOL_GPL(kobject_del_and_put);

Why not make this an inline helper defined in include/linux/kobject.h instead of
a new symbol ?

> +
>  static void dynamic_kobj_release(struct kobject *kobj)
>  {
>  	pr_debug("kobject: (%p): %s\n", kobj, __func__);
> @@ -874,8 +888,7 @@ void kset_unregister(struct kset *k)
>  {
>  	if (!k)
>  		return;
> -	kobject_del(&k->kobj);
> -	kobject_put(&k->kobj);
> +	kobject_del_and_put(&k->kobj);
>  }
>  EXPORT_SYMBOL(kset_unregister);
>  

-- 
Damien Le Moal
Western Digital Research

