From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v8 25/63] xarray: Add MAINTAINERS entry
Date: Tue,  6 Mar 2018 11:23:35 -0800
Message-ID: <20180306192413.5499-26-willy@infradead.org>
References: <20180306192413.5499-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=zplCmU9+9f/8Z6OwfiY1p6q4BmhmwOOZVTob47pP2iw=; b=WVuaHQTe2OOV0djUA/leT6702
        n4u8knT6PFGrPolL90Uxve3QnoAX6z7gr7WMm9D1lR7ZkLhK3mW9NXvFHOXu/VjLqArhXsmICG+Hy
        hxnPkepajWbaTIufIE8PVEiSRn+F0xavGP2SEajWk/Kae4tF8Kb6J+grL7fqOkRfj4foQNApG2igP
        LCoOYL8s3Y/KiovGIy3wmr5RI7ZzK2FJJO51WtRmSkcQmJDQL6nM7qFapLDjMTBIU7oeXTM6JWzSs
        C6NEuANWFFiKHyA/XWYWPI3izl1NX/LvrQpBWQHNhRF/4orshP5ZyJ1fmysHfcDLIpl1A6uQPgm13
    
In-Reply-To: <20180306192413.5499-1-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

Add myself as XArray and IDR maintainer.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 MAINTAINERS | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6d78237066ab..08613d97a74d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15293,6 +15293,18 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/vdso
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
 M:	Mauro Carvalho Chehab <mchehab@s-opensource.com>
 M:	Mauro Carvalho Chehab <mchehab@kernel.org>
-- 
2.16.1

