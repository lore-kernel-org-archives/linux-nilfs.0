From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v10 16/62] xarray: Add MAINTAINERS entry
Date: Thu, 29 Mar 2018 20:41:59 -0700
Message-ID: <20180330034245.10462-17-willy@infradead.org>
References: <20180330034245.10462-1-willy@infradead.org>
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
 bh=wbnFSxXaAtxKEgwK47fNR3JYe179XgflReJKy5UZui8=; b=B2fx7+hWFGlt1ekS5h3sn/S7zh
 FHRoczPlInyE+JlX2xBRfvH0F5koAoS+mQ9moPsdaTf6pptbGjmfOFWNzzvsKsaix/DXjCUJm9/lC
 x/w6KN6FKfuD/+H7Vqp47qnqLTb4GBhnheS6HG7BhofQE1v3c0Ht67p1DUQXMJZaaFRE=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=wbnFSxXaAtxKEgwK47fNR3JYe179XgflReJKy5UZui8=; b=ey2B2AtPf/uWr0/vFva4UH8Hz+
 UknUVG7ZowtzmAuP0eHD5apIccIv1FqiO2QotFQ7eCMBJpXokx2NfDIS/wzLvkDwtaYqn4nbYCDAw
 2azJ4cc9MHrhJaDB9FfSTFanKPFRWOA9X/oe+n/cBNhO3uUcPTNz5bM/k9GjO1kI+++g=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=wbnFSxXaAtxKEgwK47fNR3JYe179XgflReJKy5UZui8=; b=XjBY5/ar9XPjCIsMJ/R/BH5Ms
 49fe4yPRYbr7oeoptgJofWRgjIP+dvNYh/K7UX/15gfRxAwspM+HJzXvSiTf4IBdzaww/xsP6Ipwd
 UB1DexGWr1Sf7/0URmqaLBAYpS3AtqZTvNwu5LmT4NAEtg9TVXPayTR0XNTV2Pt6pVCrdXIoqjva4
 lCEtRu5YF8nPXdbTdal0fG1wIqZ2q9fanrEMLaEPZXI2Q0MQLvbLAICRFmWEeAs718M70K6xAFL5Z
 u7U8UESwe+/X/XVft9Gspya8av5EMVL2nskZW3vXRQh6ZWTskkj5mTBP5vAq86SL+S5XOwiIuRRKj
 wz/D0bv6w==;
In-Reply-To: <20180330034245.10462-1-willy@infradead.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Cc: linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, James Simmons <jsimmons@infradead.org>, Jaegeuk Kim <jaegeuk@kernel.org>, Andreas Dilger <andreas.dilger@intel.com>, Nicholas Piggin <npiggin@gmail.com>, linux-f2fs-devel@lists.sourceforge.net, Oleg Drokin <oleg.drokin@intel.com>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>, Mike Kravetz <mike.kravetz@oracle.com>

From: Matthew Wilcox <mawilcox@microsoft.com>

Add myself as XArray and IDR maintainer.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 MAINTAINERS | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 49236216a871..5da3adc1fabc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15327,6 +15327,18 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/vdso
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
2.16.2


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
