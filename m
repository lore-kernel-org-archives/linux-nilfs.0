From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/10] filemap: Remove find_get_pages_range()
 and associated functions
Date: Wed, 8 Jun 2022 01:08:50 -0700
Message-ID: <YqBZEiDMpRkfv8Sz@infradead.org>
References: <20220605193854.2371230-1-willy@infradead.org>
 <20220605193854.2371230-11-willy@infradead.org>
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
 bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=DXvPKHG4heiifsoWV1f7JEOy/E
 NHbHs0g2hW12T/PEh7iNFxP1j+ETLwUkC6ohf7H/s9rlm+fYIYRAlKX439CEcADPNreTaWbOsUW4x
 iWfw8cF63nAMCFYF/PMrwCFivXWnV7rJW3F3A3TqO/nN75jfX+c/8Hvfb7cNUsUND1wM=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To
 :From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=lMv+Y/oMYOkpTlAfT4GxJAcPH/
 jXZ4EEi7XntC73nMJs2mwsaOo5t86MpmxTtOIPRNvsoybHq0rJ6W/P+ZcQulOa+Ksg2kqpR/GXuGC
 AVGDq4pih4WXz8IOWBpbN7/JwYnyNz7IgkzdA6aoptZHMTnHe1T0AK32FAyDYM4UDQq8=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=0eYK4eNkjtJKdknPy5/wSZcBvo
 AqCDwW6wvaqMZFZWI0qJkiFqC3i4HRRyEcrcuVv4VY7JPwK2+4BJwhaFp4AILjsiuQHT8hEhxlNBR
 RN83ElGwFfZJkUlKpXjZFe7w5bKrv1IJS6VONCILDvamga8brJNUarUWGIMuUAO+0iIpisSKhO++7
 PM+NKTpqESO5RxlajC4Q6dmhXti5ZOEjKij2v2P/lzK8DV+01ONvM93R5sWD+wmKWssu8iDOmiEdK
 OUy+Fy1knUi2HfzvCbBhHR4NymttlBqxQV3Eg8E7EmcVxzZhXbASPV37qjkYEW2XYl4oWpW/0ZhKa
 WauDkmtg==;
Content-Disposition: inline
In-Reply-To: <20220605193854.2371230-11-willy@infradead.org>
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
