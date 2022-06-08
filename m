From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/10] nilfs2: Convert
 nilfs_copy_back_pages() to use filemap_get_folios()
Date: Wed, 8 Jun 2022 01:04:53 -0700
Message-ID: <YqBYJbOewoivkYLT@infradead.org>
References: <20220605193854.2371230-1-willy@infradead.org>
 <20220605193854.2371230-8-willy@infradead.org>
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
 bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=V2uWzMwrSD5Qk076yRNy70BrjH
 dZj1enYitEuJOUkNFVCChVbSlPx9j7oDNRY/7VykuG2VkzaSohY1BedV6eZlpdUmfYBnpnJ1n/bbi
 iwRKOV7yHvxb8yhYYvc2JmVRyXFxvlPouPgFcjGcxlYzwkPbfnmJCFZ60MbZLdZf90n4=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To
 :From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=WV5T5+RLSmOYIQvRuIG9xgApkO
 PwKJ7YI0IQso0kfltod9L0LP4Au6Pz9X0oMDyUfx2fF5Lxqde0oOVIA5TLvkAA15Ux71itO3c3znS
 VkBy87UazkffUQMzdFtDEVqqyzeglhW8MguPbaGpWWlEACB2eaKGfbj8ihpZIsEd4kuc=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=uTkyumChc70KtIuNyLTdXxO+oQ
 borZTJd8LxTPWmuZ/XquzEzuIdedULldzBhdEHphcrLPqltCiEbceO3o0E6EgHRgLjbfCKqpBN/YC
 HwvOemZGMqxQq9dZCymr+JtoTq9TKXB3rL0p2cUrMNi3v5H4tC+9mLgqGUnCOS/7XnaJBrRSo/8uE
 RjvstYA0Pjf7/9wLnFTeLcez/E7rroZLSbW1WhhRa08Nl3JbA7x6gCvTf50o2htErpjhN1gWFEg0N
 o0q9mx7u47FLx9YJ0STZmliYZCR+4k8DYfX6RlyOLBwHoJETbCNh4FYXqK8PlLZ7uCedfHrWViZ15
 S6cFGrDQ==;
Content-Disposition: inline
In-Reply-To: <20220605193854.2371230-8-willy@infradead.org>
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
