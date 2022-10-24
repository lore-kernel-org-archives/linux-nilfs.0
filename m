From: Vishal Moola <vishal.moola@gmail.com>
Subject: Re: [PATCH v3 01/23] pagemap: Add filemap_grab_folio()
Date: Mon, 24 Oct 2022 12:36:10 -0700
Message-ID: <CAOzc2py2E_zFukvSv-BcDm+mJis44Zp0fksd49mudMkU52HpZA@mail.gmail.com>
References: <20221017202451.4951-1-vishal.moola@gmail.com>
 <20221017202451.4951-2-vishal.moola@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Content-Type:Cc:To:Subject:Message-ID:Date:From:
 In-Reply-To:References:MIME-Version:Sender:Reply-To:Content-Transfer-Encoding
 :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=OhQpzoeVGEwmo14h6MNRUCVjD46EBvZeUnXF6FjYKqc=; b=UO1SAEpLeLCeTEYskhlOCzN1go
 wmQbS0xXYQ2omjesnr+JHE4Fz6J4wlIxCmOggdH1GXLjPdgStGkTyWLTUZYMzEqXXE/heqHk5S9RP
 pttn622/aNeRqh0iQ/B5S+4vk+o8m5gZyDss4jblto9mpp0K48jZ5Zqvu2vBvujF9UDA=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Type:Cc:To:Subject:Message-ID:Date:From:In-Reply-To:References:
 MIME-Version:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=OhQpzoeVGEwmo14h6MNRUCVjD46EBvZeUnXF6FjYKqc=; b=j1+S4fgd33YRE/wPJnbjj321wA
 KQAwqnsgknmA+JccqhrExw8zTZsH8NDV+xKEBzvsVo0g2CgSZZmjdESRmR2y2qm69XJgOos7xPBKS
 T5OxL/vMKs9n3Xr6TVszGdGEQK/9uvYegf0/JhVWeBxR4ymP3AmewC/QZbFBW53FSAM0=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=OhQpzoeVGEwmo14h6MNRUCVjD46EBvZeUnXF6FjYKqc=;
 b=LWqs5CgYoI2G7bwSrxm509BXkoJoj4h1+NAumrnw8GvlsTUUX0V7puTaejDjA+a+Se
 JZxLEhr98Isu6X1gDcr7CkjpAxT8QlsxaP3cMesu5io+uJ/hiaxizHNPmkvonW4ZrSM3
 9FJelnA+mhjpIKDB4wzNLTg8Yl25Bz2AgN5mLB8NjrqH3r4M0xDO+raYYo0KOsCBYSik
 v9TQ8VEWW7hntj+Pu46z7CX8Gt3ApfbvP2i70kguAt+Ou14BtRsnM5RXks+7xrvrVctd
 Sdn2UK8OpZrhDItYKOmqTRxqsyQ+eocL2ZMu5oL7CUQlM4vOpL4lrxfytXhVZRRPAgrU
 MCiQ==
In-Reply-To: <20221017202451.4951-2-vishal.moola@gmail.com>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-fsdevel@vger.kernel.org
Cc: linux-cifs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mm@kvack.org, ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org

On Mon, Oct 17, 2022 at 1:24 PM Vishal Moola (Oracle)
<vishal.moola@gmail.com> wrote:
>
> Add function filemap_grab_folio() to grab a folio from the page cache.
> This function is meant to serve as a folio replacement for
> grab_cache_page, and is used to facilitate the removal of
> find_get_pages_range_tag().
>
> Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> ---
>  include/linux/pagemap.h | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index bbccb4044222..74d87e37a142 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -547,6 +547,26 @@ static inline struct folio *filemap_lock_folio(struct address_space *mapping,
>         return __filemap_get_folio(mapping, index, FGP_LOCK, 0);
>  }
>
> +/**
> + * filemap_grab_folio - grab a folio from the page cache
> + * @mapping: The address space to search
> + * @index: The page index
> + *
> + * Looks up the page cache entry at @mapping & @index. If no folio is found,
> + * a new folio is created. The folio is locked, marked as accessed, and
> + * returned.
> + *
> + * Return: A found or created folio. NULL if no folio is found and failed to
> + * create a folio.
> + */
> +static inline struct folio *filemap_grab_folio(struct address_space *mapping,
> +                                       pgoff_t index)
> +{
> +       return __filemap_get_folio(mapping, index,
> +                       FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
> +                       mapping_gfp_mask(mapping));
> +}
> +
>  /**
>   * find_get_page - find and get a page reference
>   * @mapping: the address_space to search
> --
> 2.36.1
>

Following up on the filemap-related patches (01/23, 02/23, 03/23, 04/23),
does anyone have time to review them this week?
