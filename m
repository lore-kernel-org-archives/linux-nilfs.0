From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 06/10] hugetlbfs: Convert
 remove_inode_hugepages() to use filemap_get_folios()
Date: Wed, 8 Jun 2022 01:04:25 -0700
Message-ID: <YqBYCdMaaSNfBIF7@infradead.org>
References: <20220605193854.2371230-1-willy@infradead.org>
 <20220605193854.2371230-7-willy@infradead.org>
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
 bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=mXIvR7k/zLBO0phG03PxjQG0E6
 faAYfoBJTlCRY459r1wMpxNBpTHFgXpQ1309losbF7AjtW0N/QqEJsWQ32kJ/dWSvH8STOXGY4TUg
 SQaLanfnqRqrr/06ahKj3gk1yhBDMow9libb6mw3j8LBGpipkpy46Pv/MB3RYd698i1M=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To
 :From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=MbR3a6SnOZUxsMha2IfPJjBNUq
 BBRG5HuEFsJIBs3+mjaKLG4KHuZPPD0MafK/O+Ymdgkkh18KmUDiLd+wFF+BhAjxxRfLVEhqA6pZg
 rwc0mmArRrqZgg4VKUqn97sDqe4RwZqxjKQ/tV/1k0WlE2RzapOi8qxhZSnqX85jqzeI=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=l7NT0ps+5Sa+CTK3H9hfJji4Fd
 A7zNd6sKSO21jiFel/Yej67cZcGS8Ks/1Nb+KruI8rTzKZY/l6nUl7fe1mhKhtHOKgFOLFpCU/I/G
 cP/mswbGcgITkNlQgIvaPGgYDXtiGSCr4xWVnIwAtN29JyYy+jnTPkkJrzAdQxZq9Ord8Jn+skutt
 Wrb6S14hig+fqYnKrsb2t0gMBTssRTpRIopwoCZWchk1J7byiNXWATQvPxAOZ2Pw48g8LuX6s5jqy
 eXvItBOcIUJMtZMkd9H0mwoW/g0SRCKPioQvvaw19MER0dpzkRRSveecHr8+snwhAZc8DTbqin7GO
 1gJ0jepw==;
Content-Disposition: inline
In-Reply-To: <20220605193854.2371230-7-willy@infradead.org>
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
