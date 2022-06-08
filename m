From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/10] filemap: Add filemap_get_folios()
Date: Wed, 8 Jun 2022 01:00:17 -0700
Message-ID: <YqBXEXvP+5XFPy5N@infradead.org>
References: <20220605193854.2371230-1-willy@infradead.org>
 <20220605193854.2371230-2-willy@infradead.org>
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
 bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=d+p+Fuu7nVu5NyJcP4AQbk6iQA
 ttJhQc52o6gzuoMMcvzID+pPyYzWbsVwH/tdVEV8627ZJWHM5Huf7DCsYghkgiTUlbvzXgWk/7nbM
 JKADt0T1zL4UYMwn5CYpZtdoiXo0LMPQEBFyE+kKEOk7jV49qy7avTGXnGT4/JKTyX9E=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To
 :From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=UkiWjwmDcLr0yJqzZEsnZrJ/51
 qOQln6o/Ec/DsuTvuof0XArZeCdoCYo0CJxMjJIVxCr3HtJXJZbD0Wx2Y9RbTHrlwmWIZLR7llnFo
 G1cHMX2BLGKRH9iS57kBIBo2mi8gW8cwiR5hpO7rlbR4ztcwHoFum7UtFX1ZD4cf/ASc=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=hvz+Evx80lG9r40i9z+oGRLp4W
 8d5QtiXjK1Wi5K+rAgs5e9RWwuXib+CjTRQLa9+wd6dJFQHF15dPr8MYUaI+K3MV7s3tE7vT32Wzw
 UQdPD4SRqMbDh2G76OnXuvYxofMGiFAHa0FY/OVG3WCOXOO7V8XG874agdDWEblJNmm5Ra4Af7wx9
 ZEtcZH66LWhitPEIzTRNFl8emrHMf+l0FVLUWULpRIALdxuHLyZSiZ2xUsu20KC73dmSxAdJj8sUB
 FYqcG+9BHK0cs4yL6n3RQsMK2t5/GNRWM8eWV6+hF0fWuUbRybEsChi/qZrCxkDxZqo9ZriIRfJe5
 n+RteQnQ==;
Content-Disposition: inline
In-Reply-To: <20220605193854.2371230-2-willy@infradead.org>
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
