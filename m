From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: Re: [PATCH v3 01/10] kobject: introduce kobject_del_and_put()
Date: Thu, 23 Mar 2023 08:31:30 +0900
Message-ID: <5e7e8187-f514-c65e-2615-26762a329590@opensource.wdc.com>
References: <20230322165830.55071-1-frank.li@vivo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1679527900; x=1711063900;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=q9SHaaGc/iP3oUCDDkuobziv3fI8u5euiS4kcHH3kx8=;
  b=q0jI5mXQr/arP2vSPzmxZavpeKNWba+5EFBe8ijAr4zxf1IWPVBQGdZQ
   IYlscgu/NT8uVe9Z0/is9uDt94FaAz2du7nVVi27yJ/Aj2/+el+2+42cl
   TlzR7Fw1ce7t+PesirhFvNA8d1g+RRrR/UFiIgyOprOGe3ts6IMF0dwJQ
   18Y6aJPyeB7EN2NJ1KkhPMmRuLtkRpCqVyXXkLRooZZRWgFf5CVK+d9FT
   /Xcy93IuITjkPE6HNOXzEGO5S389gxPO2ieHADzMxE6dvPlJ4AjSo3gk2
   oPBgl6iDeroxF2GGwDn0T42f/4ZsrZLtNj5rLaU/IypH5Bnpdfz3Tp31l
   g==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1679527897; x=1682119898; bh=q9SHaaGc/iP3oUCDDkuobziv3fI8u5euiS4
        kcHH3kx8=; b=JGNufdCwdGSw+94EX16K+0u2kFMVp2NvMLIq1nJZeab8uhMdwEp
        ofeBGEWeT3XCiWuOQ9cadh1ZCGt6neqeNZZyT2OBS+H2o1Cvu5cncPD0EDzjH1AD
        myqHohfVKhmuEzn/VGtFJ7tfYD8TReeVYC7gO1HyzUKJhYf0JQ75JgZThXcZk9KL
        CPRoJq87xivOlYq6xPGnJMI9lRYbH4wI6+ISXQTY6SIHsRlxQ7o3g3F5XwT9hVKt
        fLnDy4FDSd0EN1mp9Ihw418Ej9XwY+ZX1tAKbEbdvAyv0qiLal1fF184rj8UhwDY
        6eTC3LRkgdQnQyirrpmiYNHdXAQDoGEBDdg==
Content-Language: en-US
In-Reply-To: <20230322165830.55071-1-frank.li@vivo.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Yangtao Li <frank.li@vivo.com>, clm@fb.com, josef@toxicpanda.com, dsterba@suse.com, xiang@kernel.org, chao@kernel.org, huyue2@coolpad.com, jefflexu@linux.alibaba.com, jaegeuk@kernel.org, trond.myklebust@hammerspace.com, anna@kernel.org, konishi.ryusuke@gmail.com, mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, richard@nod.at, djwong@kernel.org, naohiro.aota@wdc.com, jth@kernel.org, gregkh@linuxfoundation.org, rafael@kernel.org
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-f2fs-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On 3/23/23 01:58, Yangtao Li wrote:
> There are plenty of using kobject_del() and kobject_put() together
> in the kernel tree. This patch wraps these two calls in a single helper.
> 
> Signed-off-by: Yangtao Li <frank.li@vivo.com>
> ---
> v3:
> -convert to inline helper
> v2:
> -add kobject_del_and_put() users
>  include/linux/kobject.h | 13 +++++++++++++
>  lib/kobject.c           |  3 +--
>  2 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/kobject.h b/include/linux/kobject.h
> index bdab370a24f4..e21b7c22e355 100644
> --- a/include/linux/kobject.h
> +++ b/include/linux/kobject.h
> @@ -112,6 +112,19 @@ extern struct kobject * __must_check kobject_get_unless_zero(
>  						struct kobject *kobj);
>  extern void kobject_put(struct kobject *kobj);
>  
> +/**
> + * kobject_del_and_put() - Delete kobject.
> + * @kobj: object.
> + *
> + * Unlink kobject from hierarchy and decrement the refcount.

Unlink kobject from hierarchy and decrement its refcount.

> + * If refcount is 0, call kobject_cleanup().

That is done by kobject_put() and not explicitly done directly in this helper.
So I would not mention this to avoid confusion as you otherwise have a
description that does not match the code we can see here.

With that fixed, this looks OK to me, so feel free to add:

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

> + */
> +static inline void kobject_del_and_put(struct kobject *kobj)
> +{
> +	kobject_del(kobj);
> +	kobject_put(kobj);
> +}
> +
>  extern const void *kobject_namespace(const struct kobject *kobj);
>  extern void kobject_get_ownership(const struct kobject *kobj,
>  				  kuid_t *uid, kgid_t *gid);
> diff --git a/lib/kobject.c b/lib/kobject.c
> index f79a434e1231..e6c5a3ff1c53 100644
> --- a/lib/kobject.c
> +++ b/lib/kobject.c
> @@ -876,8 +876,7 @@ void kset_unregister(struct kset *k)
>  {
>  	if (!k)
>  		return;
> -	kobject_del(&k->kobj);
> -	kobject_put(&k->kobj);
> +	kobject_del_and_put(&k->kobj);

Nit: You could simplify this one to be:

	if (k)
		kobject_del_and_put(&k->kobj);

and drop the return line.

>  }
>  EXPORT_SYMBOL(kset_unregister);
>  

-- 
Damien Le Moal
Western Digital Research

