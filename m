From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 08/10] vmscan: Add
 check_move_unevictable_folios()
Date: Wed, 8 Jun 2022 17:32:34 +0100
Message-ID: <YqDPIv5IgNHK/pJT@casper.infradead.org>
References: <20220605193854.2371230-1-willy@infradead.org>
 <20220605193854.2371230-9-willy@infradead.org>
 <YqBYxNPu3tLiN5kI@infradead.org>
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
 bh=yuOErhko23VBUcg027gdjVhvOvMdHidC/agADdmeN/Y=; b=KdxXy8N/Vv1xYBo21zUoTWk4T3
 VMc7ixczls1Yfx5ol19Fb6s11RHfg0b+CzVRAtKUBe/MAVIlvDIp8wuyBZrJfKPYnVYp5HWsJpvpU
 XPKTmvrD3th3W8Jh3eGFJjiTYmDUgTaw2V0KhOyjQ1JjVdIgF6JZpMs5exyv9VczGmpc=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To
 :From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=yuOErhko23VBUcg027gdjVhvOvMdHidC/agADdmeN/Y=; b=KqMEP8axwE5QErqh5v9PA3mtbc
 I1wc5KEAJTYToEhrAe8X3Py4+r9KWYt4ES4iHeH3hEAP7aA7cstO22UTlyldpI6NzeKQKHoyyz1It
 nCn/1GZr+Cjontl3pfQOmeNNV1hPpHPCddYmBymeiK9IMUhaWtZkbB+dmghiQgcoGmWs=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
 References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=yuOErhko23VBUcg027gdjVhvOvMdHidC/agADdmeN/Y=; b=nK+QsAgyGVY4TqcqJIoqZb6pH6
 YH1l2lYZf2/HITuH4w313bKJpwgqgeL/Ajc+m5rAf7pnUDHd5+MIIqK9hox1IXUCjje8LUpumKfOs
 QEjG/a+V60NeULTByNwEGajh4NfgcD085VL6n+uTDiZlJ4QoXsBzw1tu8Uz6cY8dMROHVuLQLYmqG
 qmgcxmIS8DTwPbCCgU89ftwLODb+/P6u3LKC47leSNnpJ713XKmla3pD/TAZxU/Z/KXlxhXOgy684
 zB+mPggGwK2XDitwHO4afJMsYTpIn0LQ8rEaDkJNUysQjD3kPC6FQJOHcCHCSsAkws+g1Sq8TP2wI
 T8qDvWvw==;
Content-Disposition: inline
In-Reply-To: <YqBYxNPu3tLiN5kI@infradead.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Wed, Jun 08, 2022 at 01:07:32AM -0700, Christoph Hellwig wrote:
> On Sun, Jun 05, 2022 at 08:38:52PM +0100, Matthew Wilcox (Oracle) wrote:
> > Change the guts of check_move_unevictable_pages() over to use folios
> > and add check_move_unevictable_pages() as a wrapper.
> 
> The changes here look fine, but please also add patches for converting
> the two callers (which looks mostly trivial to me).

I do want to get rid of pagevecs entirely, but that conversion isn't
going to happen in time for the next merge window.  for_each_sgt_page()
is a little intimidating.
