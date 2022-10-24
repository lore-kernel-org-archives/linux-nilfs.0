From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v3 03/23] filemap: Convert
 __filemap_fdatawait_range() to use filemap_get_folios_tag()
Date: Mon, 24 Oct 2022 21:06:57 +0100
Message-ID: <Y1bwYd7tz76/fb5n@casper.infradead.org>
References: <20221017202451.4951-1-vishal.moola@gmail.com>
 <20221017202451.4951-4-vishal.moola@gmail.com>
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
 bh=7MsR0R1NbSyB2Djzw/hFUhA/+5S6z5HyXDOZO3eVnQg=; b=XK2ubwvSo6T8ocK+x68/leqDnJ
 YZWMOBwFZixcYajQ+SKQT4w8Q7zZCGC21P+qwBoaHV49MpAwwKndkw7JikwtU1zlbDNI+fD2r7U8C
 7y1muWaVQrM9OmYEzjekFhcCjoQEzbEKwtMqCN8JShqpZqGUrtXVoGOrJ1jUbSm60yFo=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To
 :From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=7MsR0R1NbSyB2Djzw/hFUhA/+5S6z5HyXDOZO3eVnQg=; b=M52vbdgN1S8DCzzzxr5iz3ZV7l
 8UebY/ugSXICW8fIJvCitU+KXve+D8XG93i6kgWfRQ/VghPRYIrWJyBGAbGrMkAvVst+tBUgKwenr
 wilQx+ZFEndS+RpPCwXx6cvC9KwINzjo4n95A+CLlLU1LIQnx67+qJXv93JG52YDVkYo=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
 References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=7MsR0R1NbSyB2Djzw/hFUhA/+5S6z5HyXDOZO3eVnQg=; b=Sz5j+RyAMJMG8UN49CI/nYQsRM
 4uctA+lYIXec8+kZbgkhU9sfzm2Y04hWo+tPCEQTJyx3zRaNr9Wd20f0mK3a2nGhmAnFPqvsQD/k1
 7mQnl5ZhzhFRoUDkH0U9c9iTvIWHP7suVXqBsD5AMkabioENS46bynM5C22QMostYhwbZ03GBCt64
 C6ho4ykMx3e35M96kmpJGQH3OjDWH4lKrS9MHkdnK3z0AT1XCBM64Ux2LafoYepJsAbGzL+W6zQpV
 iWZYCZcRkajtC2dbalkjT9RGPcA20dSCql/hbVwpp6dr8//HsLsLv88DwGLSugrvIDPH/UYXKAClR
 wLAo/S/g==;
Content-Disposition: inline
In-Reply-To: <20221017202451.4951-4-vishal.moola@gmail.com>
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

On Mon, Oct 17, 2022 at 01:24:31PM -0700, Vishal Moola (Oracle) wrote:
> Converted function to use folios. This is in preparation for the removal
> of find_get_pages_range_tag().

Yes, it is, but this patch also has some nice advantages of its own:

 - Removes a call to wait_on_page_writeback(), which removes a call
   to compound_head()
 - Removes a call to ClearPageError(), which removes another call
   to compound_head()
 - Removes a call to pagevec_release(), which will eventually
   remove a third call to compound_head() (it doesn't today, but
   one day ...)

So you can definitely say that it removes 50 bytes of text and two
calls to compound_head().  And that way, this patch justifies its
existance by itself ;-)

> Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
