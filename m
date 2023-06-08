From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 13/30] rnbd-srv: don't pass a holder for
 non-exclusive blkdev_get_by_path
Date: Thu,  8 Jun 2023 13:02:41 +0200
Message-ID: <20230608110258.189493-14-hch@lst.de>
References: <20230608110258.189493-1-hch@lst.de>
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
 bh=nJeSn0dFzLtBpdoOGAwm1AbS6z27iKT17susz8z4QGc=; b=M3bokbcNMv8xjx8V2xkAtwxJe0
 WlLjeZzAt4Hpgctmp8tkdZDdq7kaVWitU2Ub5QIEfmXK5OCX6TfwtOsQ7UeuOeA7FyI7pUW7qHmbM
 ce2vZzZWv2FyKkTkfU0f+F4QsjgMeGHGSsN2I5or5j8Sn6tBsprWf+DlPMWl3o7vy6lQ=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=nJeSn0dFzLtBpdoOGAwm1AbS6z27iKT17susz8z4QGc=; b=gsu88IoYX+kodMMjmDTNfD4FBP
 qe+7jf92TmoL+jytr/IyBq9dh4LE+/BsKkFO9pu2LSF+dMZHV8m+k6f9Q0IUoR4ty3bKyvBnjLt2Z
 LgQkyAQ+QHLrylB41utxpxzgU3r0/ZRZtHfWOSIIg+cGK+WJl4rJOIpfS8qv4WUtzjnk=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=nJeSn0dFzLtBpdoOGAwm1AbS6z27iKT17susz8z4QGc=; b=Kw+UMqKsqyvSoRcI0wGu9Alw90
 yF53v2YX7XlxzU3gMTpcNSzOu9QvUK70WVK7xoQIOagb6InysGmJXcX5tN2CK0mkBJEo+FYI4dyFw
 TQj9f316RjcJmadGi2+bguisL3FSMURmwxplaAwTFwDwYaeW5joP2OJjuwCWM1iciBnW3+Muz2Hwv
 bH6+8T8ogy1SOp89QAPtfqQY/NIEPhy4jA19KlYViYlQU2dADULPnIdd3xxlTtjFpSuPdhr5adIm/
 eZNp5kLhbYiKo593l7n8K4e11/hH2tyYbz5vqmR1h/gUcpsy5RcR8LQT6aK8zN9tE1c4GyD3KvZkI
 OorxxX0Q==;
In-Reply-To: <20230608110258.189493-1-hch@lst.de>
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
Reviewed-by: Hannes Reinecke <hare@suse.de>
Acked-by: Christian Brauner <brauner@kernel.org>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
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
