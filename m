From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/10] buffer: Convert clean_bdev_aliases()
 to use filemap_get_folios()
Date: Wed, 8 Jun 2022 01:01:10 -0700
Message-ID: <YqBXRiyJtkL+V77R@infradead.org>
References: <20220605193854.2371230-1-willy@infradead.org>
 <20220605193854.2371230-3-willy@infradead.org>
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
 bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=DeGHIx+pe6gTVwwx/d8dncyuCO
 qagA5v44G5heXhTf8hzkFj3fqklMB2FPxJnxPNsCD9YFjAb9MPQ1eeVfkU0lQznI/fP43C4Mi2KmM
 Rl2FZlHiQeXRSza+pp2WroNp/WOgBle87ZLP+La5n8S1IumKPz9JxhzPJjC7PUyjKdOY=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To
 :From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ZsPfvbQOwgJCKO/C4n88OjcmK7
 o+YnDDMQyZUG/XoSP2Sdes6cx2bbQCmlFiF2oH4gji1ltO6DwaUa+/a49TepI9WhkmDaaN3xlmS1X
 neMo52fxXuiyQZYKnjHjUAubI5QxpOtCjHu4jvjJPv1nlomUDSovWC4zvRK9p0+BgHiY=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Cpz2dmkD6/IlhBDYO7S5JMhRau
 9fVEf3Lzxf9uPszpeqFJyME73K48PKk/ybD2zlmA3UtHerDQ9jfpO6mHpCLL+OIjpMVJ/fULN4RJZ
 GZxzr5VKIoLcLv4aCAI/06v+ClCZx8SguXOP13kVVFKQAYlluzdEe8J9WZyfBeTeQfidsF33thNUe
 je+ufCFEnbLltrsfVgnzqqY0FUi9w3I321TEMpQgHl9gXIKR8oCqaokbN5TXMMzLE/A6Ozk/TEmmH
 gqSWVvVDPTrR7Bg2BGyJvHp33jFAKJ0Cyrf0YLKBCbkJvTOxV8gjqZ1F591JinRckDC0dMC76VMOs
 GwWeQxsA==;
Content-Disposition: inline
In-Reply-To: <20220605193854.2371230-3-willy@infradead.org>
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
