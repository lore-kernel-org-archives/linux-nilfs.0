From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: Re: [PATCH 20/23] nilfs2: Convert
 nilfs_btree_lookup_dirty_buffers() to use filemap_get_folios_tag()
Date: Sun, 4 Sep 2022 02:37:49 +0900
Message-ID: <CAKFNMo=TxJf=47DCnsscu7ZZuDNVi1LDoDHYZo_XscOSzOfi_g@mail.gmail.com>
References: <20220901220138.182896-1-vishal.moola@gmail.com>
 <20220901220138.182896-21-vishal.moola@gmail.com>
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
 bh=umA9pNWUzA7jidUk20/rQkICnueDyRo/bSzQh0Un5OQ=; b=KtBsmggKoNfgNSduuYGn53+YKA
 HbfPQNdlHjR2T4IJPZ88+SB1qwF8sytT7ceSoG5cCkSidL2f0J1uOS/hjBwyqLAerg/C6nWncAcLP
 tfcnMMBM9nyqNPseTGXy02i1u4rOZHxOWmPbhnpvzEaTqEachz1KYBbsdVuUBzNMf8bI=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Type:Cc:To:Subject:Message-ID:Date:From:In-Reply-To:References:
 MIME-Version:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=umA9pNWUzA7jidUk20/rQkICnueDyRo/bSzQh0Un5OQ=; b=FkzHReBilLTeFrTTmlafwzjXOV
 +YDLKVpDg2QCwX7eimp0e+hNawY3g1iMelLORJOsDNGvSxcil5LpvBnxOjymid4wLl6dQItZLAldb
 rfZWU4wvcpjDvEG1HAY9itbiu6GdsQOwA4ndKcj/bHsIG3jFvrK42E22abTzqGnFJ06Y=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date;
 bh=umA9pNWUzA7jidUk20/rQkICnueDyRo/bSzQh0Un5OQ=;
 b=VyzRNIPerqW7I2eLeisbraYtMw+0LYm0zIpPAVWdKSSdHWT/xCWCsp0zWPwXoLJMh+
 goWZU++QcdZPHEow/EbE3MCighBvzGVxClxj+OzcDeg7qVl++yunpPXNQ01tMimk9Nil
 o3xjyWbouw8GEZ5rtVXpCeuyeOvZfUYvXih1iKUWZYS4B5zyr0rs+Qp7tMJsvv3NWnl0
 0RaduV6sEHzrfBKsAnk/xWQvV3uUa4x+tn9f+zR5jX+WCCz3OtcEGQuCgvqQ1qtwV+4e
 nsp1bSuMMrGMJHCG5Ru+yZt8lscOgM/sAHrlB6rqDFjTbCZDBlJetndoMkX0Uq4SD0cg
 qr3g==
In-Reply-To: <20220901220138.182896-21-vishal.moola@gmail.com>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org

On Fri, Sep 2, 2022 at 7:06 AM Vishal Moola (Oracle) wrote:
>
> Convert function to use folios throughout. This is in preparation for
> the removal of find_get_pages_range_tag().
>
> Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> ---
>  fs/nilfs2/btree.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)

Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>

Thanks,
Ryusuke Konishi
