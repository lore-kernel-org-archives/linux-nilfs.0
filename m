From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 14/31] rnbd-srv: don't pass a holder for
 non-exclusive blkdev_get_by_path
Date: Tue,  6 Jun 2023 09:39:33 +0200
Message-ID: <20230606073950.225178-15-hch@lst.de>
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
 bh=ztkxfQZOrJwul1KAYrLXXe/nILhr8nj1ARAshLgAmpo=; b=DHvUvvG1am1mSQLVYXkTavx2X5
 KQRwFJMXFzUJWJxm3Ip8xAkq2CnsD8d8n9NRubLb5May9oNold8I4MvVb7jSCYVsmGHgYoKxVahkw
 AaCcUfYrHCUMaj2of4q4tDE6iyD/KlpkjbSPh5XY1Qam5AxQzEMzf6i8kObqBPQfo3Ns=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=ztkxfQZOrJwul1KAYrLXXe/nILhr8nj1ARAshLgAmpo=; b=jqX/geiLJvtV3VeydPV/C2p4vT
 UirAqZIKX9xIB3c0BBPbf+LEorofD0MWjWyonQAQ6Gg+dlkmc5ZZqXj+ioWP6/vrEq7QviB70CCDi
 Qk+yK9iWqrHAxkqeo/MPH+MAsrFgY7qfmvovESolW3g93Au91flrhtv/f5CQjzt88BIE=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=ztkxfQZOrJwul1KAYrLXXe/nILhr8nj1ARAshLgAmpo=; b=4nsl8wvHdv5d9DMdBb+YsmJ2Jo
 YMpgQafUGMvI1nLz/yYkr6L9dV0x8mohva9pdX5uxNEMiIG4MKeBWvMNokgrgk/pUMVHb0U4PVjmJ
 CqrJwmXEnSU+Q9fqhPNCkPAq42WoQYGnBRzfZmRf3UBYFlrSxYzASzb233dZn/4l1TZ3QLDIgRYCU
 8r42kGjZtZOSmbhGViEWkgkx0QQoD8vDM7LcRF12Te9gSfsmc3Qc0EaMZCeRjZIKN0CUaswNGVdkO
 gOTCn1zBakzCYWVHd2+tJKiSE7vKRD8vak+WC7w7TQK/BuTzBrj4fSvUopFL/RmMMlxJSAfMqxD9U
 FsiTZm2w==;
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

Passing a holder to blkdev_get_by_path when FMODE_EXCL isn't set doesn't
make sense, so pass NULL instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/rnbd/rnbd-srv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/rnbd/rnbd-srv.c b/drivers/block/rnbd/rnbd-srv.c
index cec22bbae2f9a5..ce505e552f4d50 100644
--- a/drivers/block/rnbd/rnbd-srv.c
+++ b/drivers/block/rnbd/rnbd-srv.c
@@ -719,7 +719,7 @@ static int process_msg_open(struct rnbd_srv_session *srv_sess,
 		goto reject;
 	}
 
-	bdev = blkdev_get_by_path(full_path, open_flags, THIS_MODULE, NULL);
+	bdev = blkdev_get_by_path(full_path, open_flags, NULL, NULL);
 	if (IS_ERR(bdev)) {
 		ret = PTR_ERR(bdev);
 		pr_err("Opening device '%s' on session %s failed, failed to open the block device, err: %d\n",
-- 
2.39.2
