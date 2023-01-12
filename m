From: Paulo Alcantara via Linux-f2fs-devel
 <linux-f2fs-devel@lists.sourceforge.net>
Subject: Re: [PATCH v5 09/23] cifs: Convert
 wdata_alloc_and_fillpages() to use filemap_get_folios_tag()
Date: Thu, 12 Jan 2023 16:23:54 -0300
Message-ID: <87ilhb36b9.fsf@cjr.nz>
References: <20230104211448.4804-1-vishal.moola@gmail.com>
 <20230104211448.4804-10-vishal.moola@gmail.com>
Reply-To: Paulo Alcantara <pc@cjr.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Content-Type:MIME-Version:Message-ID:Date:
 References:In-Reply-To:Subject:Cc:To:From:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=I2YK0KStoZilkvt5Gd+Z0QXSKrgiOl1UdETNcSgpEpE=; b=B8Cq94+8kjGUgXhRCuxQG7wj2c
 sKcvmeyIGfU4GpZK7dZ875lh88msWgRCrTRl6hqEn2EbMCGwP1Vz3n+SH1j/99bR+NqgH7RWdkpu8
 ld4vEYEt5c5a3Dff2yAF6M8NMxIJEjnnP9NhWnPCcP4gLPT6k6CCvGvXUsDC/tRwVMYw=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Type:MIME-Version:Message-ID:Date:References:In-Reply-To:Subject:
 Cc:To:From:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=I2YK0KStoZilkvt5Gd+Z0QXSKrgiOl1UdETNcSgpEpE=; b=QSv6x9SZG+tJDIogemDI8HXdOu
 fDOy0iBVJew/c2GUKljYytvCIO4rI4JhrCs01j4HpPwkmEaIbGDgiWSMVl2lWf5PD6fazqmAVN8+L
 8XVpM160Q28XOJHzl63kyGUeVHkw3nyJzKgi2lbuUnfcnESZYkTk3tN3M6RKhn8o4Tb4=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
 t=1673551439;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=I2YK0KStoZilkvt5Gd+Z0QXSKrgiOl1UdETNcSgpEpE=;
 b=i+65F8jlt9SrxFye0Gw20zt6UKpTEaqiZQ5hMVqSu0k7iplUUCLaWGe7MPjLIcUXvR2Ze2
 EPZvayy3ujt17G7U6k4N9U3mDmbAViZrJRkdIjJ30e2YmzNFL9kFY3KN4OmLssXkKylqmj
 E8tOKo4JSk3JfhG8aJ26Wc/wDEh7vUicPsX8QXZqm+7WwOK9nS0qxN7D/+flVsxas11Fth
 oU/iflnYw8+Gm87I9cBkOHMwnYst1u7763QKPIvahJlVCd3cUAf31rG9cwxkdB+Sbii/p1
 NDe89irKrvEmsmtdfYfdlUgHuTnNrT2Ps2o/IkqPzfauQjAjCU8/6VVNF8HXCA==
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
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: linux-cifs@vger.kernel.org, linux-nilfs@vger.kernel.org, "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mm@kvack.org, ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org

"Vishal Moola (Oracle)" <vishal.moola@gmail.com> writes:

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

Looks good.

Acked-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
