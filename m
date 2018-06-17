From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v14 19/74] xarray: Add MAINTAINERS entry
Date: Sat, 16 Jun 2018 18:59:57 -0700
Message-ID: <20180617020052.4759-20-willy@infradead.org>
References: <20180617020052.4759-1-willy@infradead.org>
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
 bh=0xwqQnlfUM1sDyJOL5OYBxl3xxx0qTseCxmywLTPNeM=; b=PTtkujsBc4frC6rZAA/dGXvscP
 OyorHpfwmaGJbdjQ8IvpDeVBtn+YxYesY2RDGIllG4Ks7rYLWfOmXMzr55iPrNQ3CYZ8+lSnphc0w
 Q1TcLXUOsq2ERgetTQMNSIpsUl+ymDEyS7T1klKFpdUm04+Vb0MORJkZL7tzQ8kpRR+k=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=0xwqQnlfUM1sDyJOL5OYBxl3xxx0qTseCxmywLTPNeM=; b=A6FJCz/F9otKM5AfDePRLeR60X
 DOSg+ixeSdyZuJSXjsVgxokGjAeRnCifuGwiie7RRILNP8edMJNJx8kOaOuzmxrBIBts6BoIhBc4g
 DUANGRpNzmpn9FrFN0uEttqo6xMrLh4DKwO4uW2Y6vGTVEwPfORwV6ASM37K9Z8kBdEk=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=0xwqQnlfUM1sDyJOL5OYBxl3xxx0qTseCxmywLTPNeM=; b=rXhq53UjsLheBQaP2NvHHNl1B
 NtkSd3HSz3W5yBifjn2oAKy6CslDhXpm87KMUhIVb/jwTAmGZxS0m02urExadB2IQwJ4LjGI8FlZf
 D3sQHRuHec4ta9Jgce0zYU9g58sTbrub4m7OZugSL56CCFEq/STp4VAwxti/Iw1B4ICnFuo8OWZiU
 7pmdc1ydvJoN+ohifSVW4gAjwxLS30T8nuMMAX/VebUklL34uNyMEENPQHEWWmyNhs2lcgQFyKyvN
 QU95VFJ6kUBTqvyfIb1+E9nHyUnrnNdDf0R4ZneyFIvvqFCWE351vFOXETbz1SPq13dFGnpIUDM7S
 bk2myy/XA==;
In-Reply-To: <20180617020052.4759-1-willy@infradead.org>
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
Cc: linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Matthew Wilcox <willy@infradead.org>, linux-f2fs-devel@lists.sourceforge.net, Nicholas Piggin <npiggin@gmail.com>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>

Add myself as XArray and IDR maintainer.

Signed-off-by: Matthew Wilcox <willy@infradead.org>
---
 MAINTAINERS | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6dc2c9cb2d7b..959cc42e33ad 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15596,6 +15596,17 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/vdso
 S:	Maintained
 F:	arch/x86/entry/vdso/
 
+XARRAY
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
