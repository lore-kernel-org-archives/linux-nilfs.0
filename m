From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v5 20/78] xarray: Add MAINTAINERS entry
Date: Fri, 15 Dec 2017 14:03:52 -0800
Message-ID: <20171215220450.7899-21-willy@infradead.org>
References: <20171215220450.7899-1-willy@infradead.org>
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
 bh=ENO/3ICkB2Kaqsf8OJF7AWnw4wDYOsIgZhI95uz2BoY=; b=WYyYx79xGbBU1TlUcSvbsLw6vT
 tWe5156brDkAZRkO0RUPG96VWl2HRuWoT6gcA2+Hf+MOkS3ISlEcL/FCCXgo7PHkOVrodfuoJIvKl
 dEs+2Fk+bOh4ezw7kckpXosIAVhZcHLS16iiljDQ3gZg5yKtMamNg5jx+PcCx1WozRgs=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=ENO/3ICkB2Kaqsf8OJF7AWnw4wDYOsIgZhI95uz2BoY=; b=C30pUkfxRsfxRJUTnyaCujsLu6
 KpPGojvhPWcGhDvoMMOBgyboOc1o5VxHZN3Mq4JtkggLHUkVvW/7eQh0k7UX3U69SeYpvNifsF2oe
 lsAhzaHM3m3s56bjEmVDitBB7iVv6qb/kc/vryugLnmJT/oTYLVj+I4/820hQp+O6PTU=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=ENO/3ICkB2Kaqsf8OJF7AWnw4wDYOsIgZhI95uz2BoY=; b=oIUaV5AkmGs9Q2QhE3Rcj5L2I
 PQs4Mubf+Ghnma+08rb3UOu2RCoBE5QAnOd4ui9AREnBFplZv9WQKmk/tiVNVth3EOxj4r1nJqRPp
 ENPXZ7j+CERAOC1YWRVQ7SkPoYE39j6ZpjIw9iskK6f0vrl8V0yGqvLbVYj+Ndd7ckDiQKYpm2ENy
 +37JHyMw1yGHLlRf6mQI5LD3MeQd3lP/kKWaZ7p/5EGQJFDwm6RpvUE/ivFIPsTooulaIx+GOLHn0
 wQ/fPtploeuUXS2ZDThNMCMUn3m5fZw7AwQGAC0QvlXsIV3dCbpQ/p85OvHSl9o0RxG33vlRKreyv
 6XGon7eUA==;
In-Reply-To: <20171215220450.7899-1-willy@infradead.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, linux-xfs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-raid@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, Marc Zyngier <marc.zyngier@arm.com>, linux-usb@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, David Howells <dhowells@redhat.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Rehas Sachdeva <aquannie@gmail.com>, Shaohua Li <shli@kernel.org>, linux-btrfs@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

Add myself as XArray and IDR maintainer.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 MAINTAINERS | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 82ad0eabce4f..bb5ffa12cf8c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14894,6 +14894,18 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/vdso
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
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
