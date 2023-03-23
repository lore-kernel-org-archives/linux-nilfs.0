From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH v3 01/10] kobject: introduce
 kobject_del_and_put()
Date: Thu, 23 Mar 2023 13:16:20 +0800
Message-ID: <ZBvgpBzEuFuyOD/c@ovpn-8-16.pek2.redhat.com>
References: <20230322165830.55071-1-frank.li@vivo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:
 Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=HoUzTMO8R5MhPq7S8OoMssryl9/6eR6zluDti49MEro=; b=ksJwEn04P0AFim9batU1ReBLtB
 +Edt7LuLU1GHjbc4k4aXBE3vKCGtDkMJi/Y8IXBOWpZqHYJFOEiPkI6jLs9sD2lpwmcmaNVPHu6pn
 mz9mtF+TTEK/oUfkMLZoZPB7QjeRi9yq3MWM1xkwJboPLW9fdkfkq9aKU32GwtAKPCKs=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To
 :From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=HoUzTMO8R5MhPq7S8OoMssryl9/6eR6zluDti49MEro=; b=UEj9/Iz4oslweW9JWLntHLh5y0
 6JbG6KpoMyRf+8JynJx83cDDTsjTvuzeB11y+jtMjbDBC7/xJc6rycA872b+jHK62yNKGF1aGOh7j
 yIofsoR6lWSv5gAyTHzHjSLDHzb4+ZUFI/mhKCGK+oCSqOvVBy8kIUNBe+/UXS2RzeMw=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1679548609;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=HoUzTMO8R5MhPq7S8OoMssryl9/6eR6zluDti49MEro=;
 b=C96ibbiIuzN3zlyh6zyQ8Fswhj48p5IeO4UJvpUfhLHTHmPNbleUia9lT07XxvEa/+V+ul
 QR/9MGJy2B5pbNLGBdLVZfxlyWj528TB+X8tjDaHPxybajNXKBd5TFMLn176WfPkydQZK4
 /v71z2/MFv13R9PdHMp7qvSOAmEpfCg=
Content-Disposition: inline
In-Reply-To: <20230322165830.55071-1-frank.li@vivo.com>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Yangtao Li <frank.li@vivo.com>
Cc: rafael@kernel.org, djwong@kernel.org, joseph.qi@linux.alibaba.com, linux-mtd@lists.infradead.org, naohiro.aota@wdc.com, linux-nilfs@vger.kernel.org, richard@nod.at, mark@fasheh.com, trond.myklebust@hammerspace.com, xiang@kernel.org, josef@toxicpanda.com, ming.lei@redhat.com, huyue2@coolpad.com, dsterba@suse.com, jlbec@evilplan.org, jefflexu@linux.alibaba.com, jaegeuk@kernel.org, konishi.ryusuke@gmail.com, linux-nfs@vger.kernel.org, clm@fb.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, anna@kernel.org, linux-fsdevel@vger.kernel.org, jth@kernel.org, linux-erofs@lists.ozlabs.org, damien.lemoal@opensource.wdc.com, linux-btrfs@vger.kernel.org

On Thu, Mar 23, 2023 at 12:58:30AM +0800, Yangtao Li wrote:
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
> + * If refcount is 0, call kobject_cleanup().
> + */
> +static inline void kobject_del_and_put(struct kobject *kobj)
> +{
> +	kobject_del(kobj);
> +	kobject_put(kobj);
> +}

kobject_put() actually covers kobject removal automatically, which is
single stage removal. So if you see the two called together, it is
safe to kill kobject_del() directly.


thanks,
Ming
