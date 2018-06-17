From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v14 01/74] Update email address
Date: Sat, 16 Jun 2018 18:59:39 -0700
Message-ID: <20180617020052.4759-2-willy@infradead.org>
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
 bh=MLScAEuK5LQwXVL8ayl66WZYDQJNv/NZDK6KmEnVNRY=; b=OESwmE7vcIUxuVhP3Gpw464H9m
 GHdsxqOiFPJGhd9NQNT68JvO1kAXSukMs7UTYaIcmDoZNsK4/+2Zv9lpfAb6O3/iwVZ48qXcsMoYO
 QtFkW45KMbc2Chb1ah9Bg6jGBndHkiyr1S1F4FDtXZcpoZXqs2ev/i0mUL1tsIYT2sds=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=MLScAEuK5LQwXVL8ayl66WZYDQJNv/NZDK6KmEnVNRY=; b=EuJOJz7MLHQ1NqwVeNLKkNl4Zb
 GDjwi+4Uc3Km+7Dh+Tz3w/mFd+tEzGSn3semU+aWijCHKU0H/arubF27E5jbDqp4IeTS+K7WttKgh
 mJ59rvosV3K6zfxyqfeICbi1AvKszq69VeE3gQb4KXDs+N1hSukp2Gqw4MvxZ1T/pVZY=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=MLScAEuK5LQwXVL8ayl66WZYDQJNv/NZDK6KmEnVNRY=; b=X2RZT5b4RqlqxNVagds5F2UuG
 F+PBquSCdj3ms+w0+Js50wBcrhx9sZCTJRWatKF/97qugOdZv9Dk+NpcsOPDonusRk9VkSSPozY4k
 smI1iv6PDq1s9JACIZ6OWfc0ijAlOcELJy+Ko2TFMtPsOmfH2q6uHj8RJQBK4EPRAQMYbCpC2Lz1g
 yiu+GjEHKnPiZ1BF+pfRpc9V/KC4jL/ZUtNWP1nHUCTaEfu689yB28dHmQVT+IUAvISXTqCj2/T18
 cxS3XJ+60mRJquf8fPewLbOqYAFEsa7FTMQUB9My6bfAu74wLS1Hz7cotHF03qZM4HGw2DtuAw3JH
 Q9xI3L9zw==;
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

Redirect some older email addresses that are in the git logs.

Signed-off-by: Matthew Wilcox <willy@infradead.org>
---
 .mailmap               | 7 +++++++
 MAINTAINERS            | 6 +++---
 include/linux/xarray.h | 2 +-
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/.mailmap b/.mailmap
index 29ddeb1bf015..a80dca923d32 100644
--- a/.mailmap
+++ b/.mailmap
@@ -114,6 +114,13 @@ Mark Brown <broonie@sirena.org.uk>
 Mark Yao <markyao0591@gmail.com> <mark.yao@rock-chips.com>
 Martin Kepplinger <martink@posteo.de> <martin.kepplinger@theobroma-systems.com>
 Martin Kepplinger <martink@posteo.de> <martin.kepplinger@ginzinger.com>
+Matthew Wilcox <willy@infradead.org> <matthew.r.wilcox@intel.com>
+Matthew Wilcox <willy@infradead.org> <matthew@wil.cx>
+Matthew Wilcox <willy@infradead.org> <mawilcox@linuxonhyperv.com>
+Matthew Wilcox <willy@infradead.org> <mawilcox@microsoft.com>
+Matthew Wilcox <willy@infradead.org> <willy@debian.org>
+Matthew Wilcox <willy@infradead.org> <willy@linux.intel.com>
+Matthew Wilcox <willy@infradead.org> <willy@parisc-linux.org>
 Matthieu CASTET <castet.matthieu@free.fr>
 Mauro Carvalho Chehab <mchehab@kernel.org> <mchehab@brturbo.com.br>
 Mauro Carvalho Chehab <mchehab@kernel.org> <maurochehab@gmail.com>
diff --git a/MAINTAINERS b/MAINTAINERS
index f15bc83753f5..6dc2c9cb2d7b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -529,7 +529,7 @@ F:	Documentation/hwmon/adt7475
 F:	drivers/hwmon/adt7475.c
 
 ADVANSYS SCSI DRIVER
-M:	Matthew Wilcox <matthew@wil.cx>
+M:	Matthew Wilcox <willy@infradead.org>
 M:	Hannes Reinecke <hare@suse.com>
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
@@ -4268,7 +4268,7 @@ S:	Maintained
 F:	drivers/i2c/busses/i2c-diolan-u2c.c
 
 FILESYSTEM DIRECT ACCESS (DAX)
-M:	Matthew Wilcox <mawilcox@microsoft.com>
+M:	Matthew Wilcox <willy@infradead.org>
 M:	Ross Zwisler <ross.zwisler@linux.intel.com>
 L:	linux-fsdevel@vger.kernel.org
 S:	Supported
@@ -8452,7 +8452,7 @@ F:	drivers/message/fusion/
 F:	drivers/scsi/mpt3sas/
 
 LSILOGIC/SYMBIOS/NCR 53C8XX and 53C1010 PCI-SCSI drivers
-M:	Matthew Wilcox <matthew@wil.cx>
+M:	Matthew Wilcox <willy@infradead.org>
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/scsi/sym53c8xx_2/
diff --git a/include/linux/xarray.h b/include/linux/xarray.h
index 2dfc8006fe64..9e4c86853fa4 100644
--- a/include/linux/xarray.h
+++ b/include/linux/xarray.h
@@ -4,7 +4,7 @@
 /*
  * eXtensible Arrays
  * Copyright (c) 2017 Microsoft Corporation
- * Author: Matthew Wilcox <mawilcox@microsoft.com>
+ * Author: Matthew Wilcox <willy@infradead.org>
  */
 
 #include <linux/spinlock.h>
-- 
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
