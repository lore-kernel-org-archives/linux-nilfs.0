From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 04/10] ext4: Convert
 mpage_map_and_submit_buffers() to use filemap_get_folios()
Date: Wed, 8 Jun 2022 01:03:07 -0700
Message-ID: <YqBXux0cF90xV80C@infradead.org>
References: <20220605193854.2371230-1-willy@infradead.org>
 <20220605193854.2371230-5-willy@infradead.org>
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
 bh=Lmlll0xHee/vEiVot8MaIaDnFq94X7SQmNxMGuo2kIg=; b=KKO/nM/KcbiN0Rs5MKO54sVOqG
 42GUPuuqF1l+/i3Kh63KbQiuAYdcGuXyChOB4L5U/6AQgd0jbNEOqEm0uxHYkFI9Z2/BH+8UVn4ZV
 70kmegFUCtGJjoqByPd+n45e/pPGd1Dul4UvN5s/TR6DQYy/PHUkH0OP8Y5fDIDUcq9A=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To
 :From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=Lmlll0xHee/vEiVot8MaIaDnFq94X7SQmNxMGuo2kIg=; b=Sj2x/wkEvWdZt3H1yW8Icdagca
 w5U6yWxVHUVkszl3WlPxCpuMjOIifxsvk0MvKnNOKbuppl0Jv4c0f8jwh8+O1w2fULRcSrwNZpRkE
 VcouldmzErN7SZoRx6ujdWQfA2q2hn6Hfv/yrT2fYDTaxSzfVShXsAcjZF/08ytXzaMo=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=Lmlll0xHee/vEiVot8MaIaDnFq94X7SQmNxMGuo2kIg=; b=K99MhL27rbGpyk6oZoCQHDJStN
 ATHqNPOPl7fmyyQofTDK54G9VDdXR1JVCTiKCNsyr/ha1NjCveZwfyr+ElXb6XTm4WzMWeGZrNqoP
 5YXYRBZ/7Jh9lheCch0n+4CO+bhipsSd9uBl3meB+fpXyr3N/vuS+NureIBbTXMUob/JPzY9Ita3n
 rPGXBOz7FEXZ8SjNR69uDCDib2RwXZNJiLNaSJtWaPlbu5qnHUXq3m6OFZVDMKd1O9sq9xB+VDKM5
 Dm2DLmp0am4A0lVr3uXzeX8+FPn7RkWsYdGC0GKaalaGr3v/k6XOaJBNnhuKawVGhybCgpknzNBKc
 BwrsYkgw==;
Content-Disposition: inline
In-Reply-To: <20220605193854.2371230-5-willy@infradead.org>
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

On Sun, Jun 05, 2022 at 08:38:48PM +0100, Matthew Wilcox (Oracle) wrote:
> The called functions all use pages, so just convert back to a page.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
