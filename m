From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 13/31] bcache: don't pass a stack address to
 blkdev_get_by_path
Date: Tue,  6 Jun 2023 09:39:32 +0200
Message-ID: <20230606073950.225178-14-hch@lst.de>
References: <20230606073950.225178-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Content-Transfer-Encoding:MIME-Version:References:
 In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=5ZtPhPdJKTDTdyqevIERvcb7Bzke9D31HMKtWNK3WW4=; b=Zf13nYjyvvgJ0MGEn4atPzYI5+
 58h5zuHD0N6qHUuRVYgedE4vnYjDWTh6ai9EqdmXkLWzXXZYz8dt3a14aXUCYXyWhQ8uX0QFw33dR
 5ftIfDyVi86/bOX2AI68rAQ67RK9ICDGGjiONgka5fM13XEU6D07b5aN0jVbg/BYwyqE=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=5ZtPhPdJKTDTdyqevIERvcb7Bzke9D31HMKtWNK3WW4=; b=QOqxMGX04H51Qyh25GaxZglRhR
 ewkzKekVD6+lIZ8pVsNopQpDFYIYxJEc/+B/0hJ8qdXjO9/LUyQrDMsBd11Y++5zi6mC50xHvfe+/
 LOmypvapBPeCwg5xL8fEpOFjTZVfurMZiyxTFKeTBwRmrK5+I8nh324QBr0TIXK/50Zc=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=5ZtPhPdJKTDTdyqevIERvcb7Bzke9D31HMKtWNK3WW4=; b=gRieWKPuaV0j1+l/6EHokTx5AR
 fJ9iG0u7eEdZ5ITUuWzcaBMz7SazZpKbhBa8JWs/b+tQxBXGQ26jGp0n5bbvKSKYF5St4mWw5sV58
 NlPGd7KTpiY6mMJokiOqvUgZy50O1OuiToUTVm8l8FoSesj1a/ux5roYKEsl1VC7TVNOUvdGJ1o0Z
 b2A3BXZqefT1Mhf+rZUKaNRFwL/QJGo5HBgUmNcRPexlVzC8k2oxr2OEfmLzJArfHrB4nE7BYfffj
 z11TYMzpABLahJEVJhYTAwiqRj+9PqeqZWhh+qjRE4h5dBVrJhOBgCrETXuloh+7mzgxZFcnmYnwI
 7yDJisCA==;
In-Reply-To: <20230606073950.225178-1-hch@lst.de>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Jens Axboe <axboe@kernel.dk>
Cc: Vignesh Raghavendra <vigneshr@ti.com>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-nvme@lists.infradead.org, Phillip Potter <phil@philpotter.co.uk>, Chris Mason <clm@fb.com>, dm-devel@redhat.com, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>, Jack Wang <jinpu.wang@ionos.com>, linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, Richard Weinberger <richard@nod.at>, linux-pm@vger.kernel.org, linux-um@lists.infradead.org, Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, Christian Brauner <brauner@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.

sb is just an on-stack pointer that can easily be reused by other calls.
Switch to use the bcache-wide bcache_kobj instead as there is no need to
claim per-bcache device anyway.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/bcache/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 94b91c45c9e2a9..4a2aed047aec12 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2560,7 +2560,7 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 	err = "failed to open device";
 	bdev = blkdev_get_by_path(strim(path),
 				  FMODE_READ|FMODE_WRITE|FMODE_EXCL,
-				  sb, NULL);
+				  bcache_kobj, NULL);
 	if (IS_ERR(bdev)) {
 		if (bdev == ERR_PTR(-EBUSY)) {
 			dev_t dev;
-- 
2.39.2
