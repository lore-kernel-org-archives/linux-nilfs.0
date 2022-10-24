From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v3 04/23] page-writeback: Convert
 write_cache_pages() to use filemap_get_folios_tag()
Date: Mon, 24 Oct 2022 21:12:02 +0100
Message-ID: <Y1bxktICFzdSl09W@casper.infradead.org>
References: <20221017202451.4951-1-vishal.moola@gmail.com>
 <20221017202451.4951-5-vishal.moola@gmail.com>
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
 bh=zfO+51g+SbzjZHZNrypaeeN+vqvnYBv2zA15JUzr234=; b=IR42H7PVgQLeAUelwicRB05u3d
 UxaxwBI0a6Gok+SM7Pnj9VCfczBGold0sRyS3mN+x5+PHqmahSIrvTtALbrBIC7iJs/LdKw0M4QzO
 och3TfPOVrQtHyTgZBHyRY88djPicjTLIJcRIC8XnYm7x5pXjceI9S/bDG2qFSbTkfDc=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To
 :From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=zfO+51g+SbzjZHZNrypaeeN+vqvnYBv2zA15JUzr234=; b=OuR5ZJdAzLSjgzYgm9rSxmTKKs
 0SqPAbM6Fp59MY2kaRKVPTt3Gm4xKa6WTjn+osQ/oIpaaRFt2brxOBNPgtavK2JZ0tc5je8UNN8BL
 jw87xVgpNQbcVcKv7MjiB8KULyw4CnUuI+/7LihLiiVqEQwrUNK49V6JtTqHIxM55kEA=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
 References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=zfO+51g+SbzjZHZNrypaeeN+vqvnYBv2zA15JUzr234=; b=RaqCnNQ9CnKiZqVCmkN+ZH26es
 kLhgdeh0QnjBCfJ9xLm3bfufPC+onpDpuX7yC57WcUgCWboa1sRqIpUQkaEy4rcWg0deJJkTrG9u+
 xXp6DPSVRNIdNXEj0v1zthipBMUcrfkJ57SL1LP2AxnvL9I5+1qg9irKUKJ3zBt+VEEu7V2Qj1xHx
 iSoekSSnChWmNwUEq/ZKwqlzS25sZPdvz/dljAvXqfrWGncDV78lZcLCIWkfBrIqe9bJfcs12ezDH
 xxm0RAaFJN7/Pg5LrccD+kzmwLerXwWzlEb5vczrVE1CH+jszY4G6TIyzPH1GguKPCCgf/96pexJS
 Z5w3nhPg==;
Content-Disposition: inline
In-Reply-To: <20221017202451.4951-5-vishal.moola@gmail.com>
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

On Mon, Oct 17, 2022 at 01:24:32PM -0700, Vishal Moola (Oracle) wrote:
> Converted function to use folios throughout. This is in preparation for
> the removal of find_get_pages_range_tag().

And removes eight calls to compound_head(), saving 296 bytes of kernel
text (!)  It also adds support for large folios to this function.

> Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
