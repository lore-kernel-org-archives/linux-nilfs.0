From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v9 23/61] xarray: Add MAINTAINERS entry
Date: Tue, 13 Mar 2018 06:26:01 -0700
Message-ID: <20180313132639.17387-24-willy@infradead.org>
References: <20180313132639.17387-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=k2Qy6PUwwi4ot2eeMnfb2Ju8jUdz0wxWHQrxzt9hoj8=; b=uJqu5O7vVITiupXb2JE7k9qcd
        ZLQDDqPNYVYGhpn0F335c8OoCFH4JFBOcTD96FIr32ROejrJJb7fVQ6WEZEKVPprSGU1buDB4bEfE
        8Q5mFStTpsuZQlWdwWfvn3mVC3/UNPSpSZsZYVnqKwUyx6xfSA/tnDOHWo9o9ZcTtnR9kgBLvnr/P
        u1U47ZBrixNFxQkauwNdeQBBNckkpBU8En13UKD8EAz6CNCi50wNJNxods62L1Kv+fpR9LAtDxWXQ
        Tgp4KnHlkzuJ1Aw3q/G2FWmbAMEqqH47RHfIZnj/okZK6psKdS9v1uSyS75u+OcFLoeDQQMFcOrUC
    
In-Reply-To: <20180313132639.17387-1-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

Add myself as XArray and IDR maintainer.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 MAINTAINERS | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8be7d1382ce9..b622179348ae 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15354,6 +15354,18 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/vdso
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

