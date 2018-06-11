From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v13 18/72] xarray: Add MAINTAINERS entry
Date: Mon, 11 Jun 2018 07:05:45 -0700
Message-ID: <20180611140639.17215-19-willy@infradead.org>
References: <20180611140639.17215-1-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:
 To:From:Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=dGkzfC0RM7gc5d0orX2hU4DPQ3QLXn+i7TNcZAss9dw=; b=Ucy2Tb13nCNnlteoru1crQ3erl
 NS5ALxG/ZuzTk2TxKUlC4r3ktCi54n1ut1oz2CXeRxGy7+JRtdGh+VRJjV8eZLriP68LTTku5Mpar
 7MbmqD+gx/RaXx1PmEy9At7Me9AyzTHFA9xsPE/XC6PlpapgCKed3RlMPvu3Zk6pdOrk=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=dGkzfC0RM7gc5d0orX2hU4DPQ3QLXn+i7TNcZAss9dw=; b=UPmjZfA8lqaEty5ZvJqYikadgQ
 0Ssh0HJnEI7aSokn3SBr+pg88Vj5fWY952xb+ZcaLNEBmC2heVkSQdzMYhUGhQYrZRQ3L/zEbFsZy
 Et2W8ZDfPR8QN6rcKdm+sA26eg9gk1rG+9HnK4OmK0oalwu4pn+E3NQlQeFeQs5zUir8=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=dGkzfC0RM7gc5d0orX2hU4DPQ3QLXn+i7TNcZAss9dw=; b=XkMgaY6AkOoFJHfIkcQxrYlMO
 dlWV9Rg5erA1rsPqNft1xX8dPajTtdB+gjPNxrcuCqHlIYzXwFLIQGMdBuReV63+atIWOt6yBlShi
 tgEPlcuW7gt3Yh2n6/QeJauiX1o5746sAc8My6YKcdHy7+m1rq0bNlg8+XLFpN+1nj1/Aj4zpuInK
 2+EWJE5mb4nqNshK/sIAIAVorQzWsEM/c5CzNE/HIYo9FL90KABaL9ApCD7opp0YuRy8vTgiUL+v/
 g8I3Be4GM3RfGfqbmuZT7JlbSh/yX4PDebgn7wHQMhRjJ/T0AB9FHFc3ZckzlTywspmfvxZXNNv0j
 CcuJvsE+Q==;
In-Reply-To: <20180611140639.17215-1-willy@infradead.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, linux-f2fs-devel@lists.sourceforge.net, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>

From: Matthew Wilcox <mawilcox@microsoft.com>

Add myself as XArray and IDR maintainer.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 MAINTAINERS | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 14fbc6e94774..afb6678188b1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15598,6 +15598,18 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/vdso
 S:	Maintained
 F:	arch/x86/entry/vdso/
 
+XARRAY
+M:	Matthew Wilcox <mawilcox@microsoft.com>
+M:	Matthew Wilcox <willy@infradead.org>
+L:	linux-fsdevel@vger.kernel.org
+S:	Supported
+F:	Documentation/core-api/xarray.rst
+F:	lib/idr.c
+F:	lib/xarray.c
+F:	include/linux/idr.h
+F:	include/linux/xarray.h
+F:	tools/testing/radix-tree
+
 XC2028/3028 TUNER DRIVER
 M:	Mauro Carvalho Chehab <mchehab@kernel.org>
 L:	linux-media@vger.kernel.org
-- 
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
