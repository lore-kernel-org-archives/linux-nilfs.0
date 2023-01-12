From: Vishal Moola <vishal.moola@gmail.com>
Subject: Re: [PATCH v5 09/23] cifs: Convert
 wdata_alloc_and_fillpages() to use filemap_get_folios_tag()
Date: Thu, 12 Jan 2023 09:19:50 -0800
Message-ID: <CAOzc2pw9WCgHyA2epbz5=HEWN4bFzD4C7zL2452J_egv7iSLrw@mail.gmail.com>
References: <20230104211448.4804-1-vishal.moola@gmail.com>
 <20230104211448.4804-10-vishal.moola@gmail.com>
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
 bh=E+c881Dpe/85Aq62y2qtNDOsySQkmPy3VHLSOKalLuM=; b=dt0DgHHh8y7qP1GfXVc1A+yDzN
 3hTns/qZObTW3VroEQJJRz2rEnJyMulYTa1cN7NsArX8djg83xsATX5PRIHGSIKSMeW4UwHMjRPLd
 a1LquH9AKMNq+ZWH9cI8UCzY4B+Hzs+Ynq9ceLfwuF0pn1EhBRdSXFMFbu+9jKjZVYtU=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Type:Cc:To:Subject:Message-ID:Date:From:In-Reply-To:References:
 MIME-Version:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=E+c881Dpe/85Aq62y2qtNDOsySQkmPy3VHLSOKalLuM=; b=RRpyf/PJDlLjF1EmDNYNKGOvG1
 TGwgb47v2VtxRUDraYQl/N+qBJY9/MfGcfb6S6PSPb5KsVfzXnX8WTZSucgvss6NTA1Q/eHVT3npe
 FfAP3k3wVEtVBh1ZqW/tKMJfOY3y4JycVBym7h6rMrEti4EnAtN/TPZ1tkIKBnjm7msE=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=E+c881Dpe/85Aq62y2qtNDOsySQkmPy3VHLSOKalLuM=;
 b=Pc/Xg/kvl8DhMy2mV5DSv0JY0A6VI9FAm0F9VYc/dWZQyf9ydWoM7408OMWs2Kt4+S
 eCo3wgwd+MlvDDhfoUGkDIHkrJCrglJGkVPgM1Oz/eqrjqRxIUt6ATz63+Zu6orRFNgG
 FQGLvnnrHoT7dPPaTZzgvM7ZMRU4T4kxqvK2dz+jrBacryTz+KXjnEm1lE9Im5xoXhH6
 uaeXjEyPwqRZI6/5GVgzLBgcQ8qcs+by+yaLr7atp5Urs68114vwsX10TNqGRNH04pMs
 QclnYeakKcSogdPbUF9XgR9U7I3ZKCshjFY/gZue60/KZOW51I77izQ6dwI6z0pu5/hK
 x6BA==
In-Reply-To: <20230104211448.4804-10-vishal.moola@gmail.com>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-fsdevel@vger.kernel.org, pc@cjr.nz, tom@talpey.com
Cc: linux-cifs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mm@kvack.org, ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org

On Wed, Jan 4, 2023 at 1:15 PM Vishal Moola (Oracle)
<vishal.moola@gmail.com> wrote:
>
> This is in preparation for the removal of find_get_pages_range_tag(). Now also
> supports the use of large folios.
>
> Since tofind might be larger than the max number of folios in a
> folio_batch (15), we loop through filling in wdata->pages pulling more
> batches until we either reach tofind pages or run out of folios.
>
> This function may not return all pages in the last found folio before
> tofind pages are reached.
>
> Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> ---
>  fs/cifs/file.c | 32 +++++++++++++++++++++++++++++---
>  1 file changed, 29 insertions(+), 3 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 22dfc1f8b4f1..8cdd2f67af24 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -2527,14 +2527,40 @@ wdata_alloc_and_fillpages(pgoff_t tofind, struct address_space *mapping,
>                           unsigned int *found_pages)
>  {
>         struct cifs_writedata *wdata;
> -
> +       struct folio_batch fbatch;
> +       unsigned int i, idx, p, nr;
>         wdata = cifs_writedata_alloc((unsigned int)tofind,
>                                      cifs_writev_complete);
>         if (!wdata)
>                 return NULL;
>
> -       *found_pages = find_get_pages_range_tag(mapping, index, end,
> -                               PAGECACHE_TAG_DIRTY, tofind, wdata->pages);
> +       folio_batch_init(&fbatch);
> +       *found_pages = 0;
> +
> +again:
> +       nr = filemap_get_folios_tag(mapping, index, end,
> +                               PAGECACHE_TAG_DIRTY, &fbatch);
> +       if (!nr)
> +               goto out; /* No dirty pages left in the range */
> +
> +       for (i = 0; i < nr; i++) {
> +               struct folio *folio = fbatch.folios[i];
> +
> +               idx = 0;
> +               p = folio_nr_pages(folio);
> +add_more:
> +               wdata->pages[*found_pages] = folio_page(folio, idx);
> +               folio_get(folio);
> +               if (++*found_pages == tofind) {
> +                       folio_batch_release(&fbatch);
> +                       goto out;
> +               }
> +               if (++idx < p)
> +                       goto add_more;
> +       }
> +       folio_batch_release(&fbatch);
> +       goto again;
> +out:
>         return wdata;
>  }
>
> --
> 2.38.1
>

Could someone review this cifs patch, please? This is one of the
2 remaining patches that need to be looked at in the series.
