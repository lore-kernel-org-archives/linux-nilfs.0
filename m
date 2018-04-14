From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v11 15/63] xarray: Add MAINTAINERS entry
Date: Sat, 14 Apr 2018 07:12:28 -0700
Message-ID: <20180414141316.7167-16-willy@infradead.org>
References: <20180414141316.7167-1-willy@infradead.org>
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
 bh=MGPz9CjEi2s929Yu3jDsyThjdMbBnBYyl10KYYtQl5A=; b=hTGV9FDL8eO3x3Jlme44SG0Ljg
 LCrrPqa8Grk2Ks+musQTnxOp2pV5ODmCPnT27eet0gxnFbbrMy/+im/b/hC8ZvMcuwbLs9l7cc8f/
 /A5vtSW8eaQTQRgqOmDBzkA7n4pF3H8VLTZAvOzJ1fs451xQA9wgCHM4TLaksqOhiqE4=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=MGPz9CjEi2s929Yu3jDsyThjdMbBnBYyl10KYYtQl5A=; b=II+3gnhplfmF++rEj8cYKbjQc3
 iCOPcVUr8unIXBTSD3Yu4S6O/29cCg+RGltvZMpn0RAJIEcts02dQZKczCjBS7DMC0WLPRvcQnDc/
 3L/U72DnSkSvd5vzbnsuwnp5ukX/W4/1fydi6gtOnVZz4ZT9othSwAjohzJ4qtgyNYYw=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=MGPz9CjEi2s929Yu3jDsyThjdMbBnBYyl10KYYtQl5A=; b=DxqldRhGYjV8cy8DJTvJNYuex
 wCZCPss/a5yWimKX/gVpFXRPnkDWf6okDRMnTPwIIXPTN/7qgmDxNNWXc02FS7PST5nyjjJmC/qHZ
 JsWK9IHVG2TIzfOct1Y2vtxiajrYZtLblcCTWZYJKcy7uULzNkWV5IIym0VkwwTaHNUABt87bLR+H
 ak+75/12h0ykAvfdzhqo+hPROzz/F5zR4+5p5P/xzeBbKDtQt8bYpznliK7i58uxy21lzXrNtAKYS
 qyPWNAjIMC6hTUEtKMHBSrBzNMWWOsYuYP9/fc7KxMCtWFavAcmnEolWIKkNOZkHUMHeGWFe98Dpt
 SOB3f0MWQ==;
In-Reply-To: <20180414141316.7167-1-willy@infradead.org>
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
index 0a1410d5a621..3fec61e86022 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15386,6 +15386,18 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/vdso
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
2.17.0


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
