From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 09/10] shmem: Convert shmem_unlock_mapping()
 to use filemap_get_folios()
Date: Wed, 8 Jun 2022 01:08:33 -0700
Message-ID: <YqBZAfkVrhnYDPsK@infradead.org>
References: <20220605193854.2371230-1-willy@infradead.org>
 <20220605193854.2371230-10-willy@infradead.org>
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
 bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=MNnqrCn8HtMrUfTQA7U9Htr3pW
 07tu9vuXI8mp45ac5mw6laOD7JmiHzxydlN+oJQ9ZGZ+NWVG/0VPf4Rf15E0caNgLb9DEBpV/F9MF
 HnDVkdZEh9QowvumhcnHtjFQ3ILtF/SHjgUOYXFXaj6n8CLuEwQUTXUT7heG8K+irqjU=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To
 :From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=RQKWo0ERPuLDfwzGIpKVNH+G+A
 llbZk2N4xbtJHwRj5J3Us1fI2w1M57aFTFj8NQRhbDLwa5X7UNBM2YSUH0bw6OVDXH4Ko8hdai+1T
 fE6YbQyZsPkw6fP1UHs8rO9IRk8Myh6WPg2Z0JMrPNVo+jLQpeG2DjcfpYkvOEcxJi+s=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=3cnx77aEV9ed1U61xp/G5ppYoC
 GQdV19NA5Zjh94mlg39m8oYleQd3p92aWhRHUC787oYI83C10dsGBkQTqFYQWSRoU0jo0nLi/eLGO
 vc57FWTqxLrP5xWC4eqVu2tcHejLq3rjTqLMB76difj/XFxT2vRLMmoJDzwIBMI0idzEe5CNfbct3
 FoqeyFA/A6/UM5gI+Ucvh28xIdnWHD/ASL0NNeqV1f5YEeUarH2yfExavYt0iKNs/04JLZI1GhuuU
 fvaRqMrliicgJ2QrHEokN/B8W3mNReB0m6foXDCuqodWwDTMKkyDAcrXahHQJsfyHJoqLqUvRKoie
 U7WEme4Q==;
Content-Disposition: inline
In-Reply-To: <20220605193854.2371230-10-willy@infradead.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
