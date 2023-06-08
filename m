From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 23/30] rnbd-srv: replace sess->open_flags with a
 "bool readonly"
Date: Thu,  8 Jun 2023 13:02:51 +0200
Message-ID: <20230608110258.189493-24-hch@lst.de>
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
 bh=dEmPe/bSHgwifwfXlA9VWAbszBT6B/IX1dmN5aeoTUI=; b=ejtkVSrg5BjDc9ijfZ9H5+enuZ
 JLujFMXMOA3uJS7nkqqVKubzBKhgEZgfHsXZb7HPU06QNyxfoG70wleHZpdZ/8OUlBFOTi+Avof+r
 sqOu23ptMIa2WhlFdQPKuFbzT4AxTVlSfDogOxt4MVOD4rZl1wVQ9jVBNgJ0+ecRVOyo=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=dEmPe/bSHgwifwfXlA9VWAbszBT6B/IX1dmN5aeoTUI=; b=VaZM3DTh0AAcoEEF9cvxYu2aga
 U8ZOGwru7MhfxoQ59xUiT0nBp5LYgTDukWN1cUz2Bu90V4TjTWiYEZS7t7GqW7RYQL4PGweRYQfzC
 yKNMBxLjGFGCt8uzdoz198vLAqrL/p2dU4gaC2DCtHX87Xzave1PqeUcnRe7tIYKvshE=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=dEmPe/bSHgwifwfXlA9VWAbszBT6B/IX1dmN5aeoTUI=; b=NX+i/BZ4ePCxmMMGp/hR5K6CcA
 TPgtN6wf7MDHTBMHop0PsFxMQpnsbECsPFDJjw/4zVnSbJBF3q/wPJAXnymMfC5M6qn2IBKvbKyMi
 G/rf3+POhoGtF1lr4x3ZQ5fcyBrOurP/CwYGkhDrrAZJ1T+cuJ/gwnUVyL5GgmUFG82MOCOnZLpIC
 B1Spb85KQeuciZ6cbzhgJ8A6EprWorXBkGpaGF5rt/rKB9jEUn21HybusGIUR8t6LDgFd9pGgO+id
 z2iw43GfIgmh7TQzgUixSGWtmiYfo6AyB+fQZ39N2+Akpbhns4c9w9ZlIH0ysgGvK34QlECJBwE/I
 hEi3Ppgw==;
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

Stop passing the fmode_t around and just use a simple bool to track if
an export is read-only.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Acked-by: Christian Brauner <brauner@kernel.org>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/block/rnbd/rnbd-srv-sysfs.c |  3 +--
 drivers/block/rnbd/rnbd-srv.c       | 15 +++++++--------
 drivers/block/rnbd/rnbd-srv.h       |  2 +-
 3 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/block/rnbd/rnbd-srv-sysfs.c b/drivers/block/rnbd/rnbd-srv-sysfs.c
index d5d9267e1fa5e4..ebd95771c85ec7 100644
--- a/drivers/block/rnbd/rnbd-srv-sysfs.c
+++ b/drivers/block/rnbd/rnbd-srv-sysfs.c
@@ -88,8 +88,7 @@ static ssize_t read_only_show(struct kobject *kobj, struct kobj_attribute *attr,
 
 	sess_dev = container_of(kobj, struct rnbd_srv_sess_dev, kobj);
 
-	return sysfs_emit(page, "%d\n",
-			  !(sess_dev->open_flags & FMODE_WRITE));
+	return sysfs_emit(page, "%d\n", sess_dev->readonly);
 }
 
 static struct kobj_attribute rnbd_srv_dev_session_ro_attr =
diff --git a/drivers/block/rnbd/rnbd-srv.c b/drivers/block/rnbd/rnbd-srv.c
index 29d560472d05ba..b680071342b898 100644
--- a/drivers/block/rnbd/rnbd-srv.c
+++ b/drivers/block/rnbd/rnbd-srv.c
@@ -222,7 +222,7 @@ void rnbd_destroy_sess_dev(struct rnbd_srv_sess_dev *sess_dev, bool keep_id)
 	blkdev_put(sess_dev->bdev, NULL);
 	mutex_lock(&sess_dev->dev->lock);
 	list_del(&sess_dev->dev_list);
-	if (sess_dev->open_flags & FMODE_WRITE)
+	if (!sess_dev->readonly)
 		sess_dev->dev->open_write_cnt--;
 	mutex_unlock(&sess_dev->dev->lock);
 
@@ -561,7 +561,7 @@ static void rnbd_srv_fill_msg_open_rsp(struct rnbd_msg_open_rsp *rsp,
 static struct rnbd_srv_sess_dev *
 rnbd_srv_create_set_sess_dev(struct rnbd_srv_session *srv_sess,
 			      const struct rnbd_msg_open *open_msg,
-			      struct block_device *bdev, fmode_t open_flags,
+			      struct block_device *bdev, bool readonly,
 			      struct rnbd_srv_dev *srv_dev)
 {
 	struct rnbd_srv_sess_dev *sdev = rnbd_sess_dev_alloc(srv_sess);
@@ -576,7 +576,7 @@ rnbd_srv_create_set_sess_dev(struct rnbd_srv_session *srv_sess,
 	sdev->bdev		= bdev;
 	sdev->sess		= srv_sess;
 	sdev->dev		= srv_dev;
-	sdev->open_flags	= open_flags;
+	sdev->readonly		= readonly;
 	sdev->access_mode	= open_msg->access_mode;
 
 	return sdev;
@@ -681,13 +681,12 @@ static int process_msg_open(struct rnbd_srv_session *srv_sess,
 	struct rnbd_srv_sess_dev *srv_sess_dev;
 	const struct rnbd_msg_open *open_msg = msg;
 	struct block_device *bdev;
-	fmode_t open_flags;
+	fmode_t open_flags = FMODE_READ;
 	char *full_path;
 	struct rnbd_msg_open_rsp *rsp = data;
 
 	trace_process_msg_open(srv_sess, open_msg);
 
-	open_flags = FMODE_READ;
 	if (open_msg->access_mode != RNBD_ACCESS_RO)
 		open_flags |= FMODE_WRITE;
 
@@ -736,9 +735,9 @@ static int process_msg_open(struct rnbd_srv_session *srv_sess,
 		goto blkdev_put;
 	}
 
-	srv_sess_dev = rnbd_srv_create_set_sess_dev(srv_sess, open_msg,
-						     bdev, open_flags,
-						     srv_dev);
+	srv_sess_dev = rnbd_srv_create_set_sess_dev(srv_sess, open_msg, bdev,
+				open_msg->access_mode == RNBD_ACCESS_RO,
+				srv_dev);
 	if (IS_ERR(srv_sess_dev)) {
 		pr_err("Opening device '%s' on session %s failed, creating sess_dev failed, err: %ld\n",
 		       full_path, srv_sess->sessname, PTR_ERR(srv_sess_dev));
diff --git a/drivers/block/rnbd/rnbd-srv.h b/drivers/block/rnbd/rnbd-srv.h
index f5962fd31d62e4..76077a9db3dd55 100644
--- a/drivers/block/rnbd/rnbd-srv.h
+++ b/drivers/block/rnbd/rnbd-srv.h
@@ -52,7 +52,7 @@ struct rnbd_srv_sess_dev {
 	struct kobject                  kobj;
 	u32                             device_id;
 	bool				keep_id;
-	fmode_t                         open_flags;
+	bool				readonly;
 	struct kref			kref;
 	struct completion               *destroy_comp;
 	char				pathname[NAME_MAX];
-- 
2.39.2
