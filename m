From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: don't use ->bd_inode to access the block device size v3
Date: Mon, 18 Oct 2021 11:53:08 -0600
Message-ID: <e0784f3e-46c8-c90c-870b-60cc2ed7a2da@kernel.dk>
References: <20211018101130.1838532-1-hch@lst.de>
 <4a8c3a39-9cd3-5b2f-6d0f-a16e689755e6@kernel.dk>
 <20211018171843.GA3338@lst.de>
 <2f5dcf79-8419-45ff-c27c-68d43242ccfe@kernel.dk>
 <20211018174901.GA3990@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YH4oGe9dRfdZQ1d4CvnTMZ1r7HRf2QBAQWpHy9E3Wng=;
        b=UdB/aADcuFPlPcZ5zloyGSC8r8sjGP46bdFZgOczbw//2VtX+qD5PI/hTVyCm/RwVy
         FXAjDscH1TQ3fsg0fSzaSQe7AynSLix9FEl76DQK4y8MTjp/aJVzkmTFFG7c2xS8iXPi
         s+lRVm4eViQimOGv1xw+YUEHZjc66LhnruY2OKJU4kNG1W3nUI3yYhopF97varulsEhH
         lrAHcDhmWx+Ldz3ca7hK3R16UzzOUjcC//cwEEUu4EBzTbKGlwl++3WbIOKHwppSidbZ
         J2GwRHTpqmvpQIvUpXH1LIhuUZWDULALzfc74tUrBZWM1yZdKVE8ClvuVU+5LBey+DKb
         N3Hw==
In-Reply-To: <20211018174901.GA3990-jcswGhMUV9g@public.gmane.org>
Content-Language: en-US
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Coly Li <colyli-l3A5Bk7waGM@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Sterba <dsterba-IBi9RG/b67k@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, OGAWA Hirofumi <hirofumi-UIVanBePwB70ZhReMnHkpc8NsWr+9BEh@public.gmane.org>, Dave Kleikamp <shaggy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Anton Altaparmakov <anton-yrGDUoBaLx3QT0dZR+AlfA@public.gmane.org>, Konstantin Komarov <almaz.alexandrovich-m5I1DM4ARimttCpgsWEBFlaTQe2KTcn/@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Phillip Lougher <phillip-Y7wUz+saRi+tmTQ+vhA3Yw@public.gmane.org>, Jan Kara <jack-IBi9RG/b67k@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 10/18/21 11:49 AM, Christoph Hellwig wrote:
> On Mon, Oct 18, 2021 at 11:40:51AM -0600, Jens Axboe wrote:
>>  static inline loff_t bdev_nr_bytes(struct block_device *bdev)
>>  {
>> -	return i_size_read(bdev->bd_inode);
>> +	return bdev->bd_nr_sectors;
> 
> This hunk needs to go into bdev_nr_sectors, and the bdev_nr_bytes
> probably wants to call bdev_nr_sectors and do the shifting.

Makes sense.

commit dd018a580d0037f65d7dd801cbf3e053f36283de
Author: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Date:   Mon Oct 18 11:39:45 2021 -0600

    block: cache inode size in bdev
    
    Reading the inode size brings in a new cacheline for IO submit, and
    it's in the hot path being checked for every single IO. When doing
    millions of IOs per core per second, this is noticeable overhead.
    
    Cache the nr_sectors in the bdev itself.
    
    Signed-off-by: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>

diff --git a/block/genhd.c b/block/genhd.c
index 759bc06810f8..53495e3391e3 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -58,6 +58,7 @@ void set_capacity(struct gendisk *disk, sector_t sectors)
 
 	spin_lock(&bdev->bd_size_lock);
 	i_size_write(bdev->bd_inode, (loff_t)sectors << SECTOR_SHIFT);
+	bdev->bd_nr_sectors = sectors;
 	spin_unlock(&bdev->bd_size_lock);
 }
 EXPORT_SYMBOL(set_capacity);
diff --git a/block/partitions/core.c b/block/partitions/core.c
index 9dbddc355b40..66ef9bc6d6a1 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -91,6 +91,7 @@ static void bdev_set_nr_sectors(struct block_device *bdev, sector_t sectors)
 {
 	spin_lock(&bdev->bd_size_lock);
 	i_size_write(bdev->bd_inode, (loff_t)sectors << SECTOR_SHIFT);
+	bdev->bd_nr_sectors = sectors;
 	spin_unlock(&bdev->bd_size_lock);
 }
 
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 472e55e0e94f..fe065c394fff 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -39,6 +39,7 @@ struct bio_crypt_ctx;
 
 struct block_device {
 	sector_t		bd_start_sect;
+	sector_t		bd_nr_sectors;
 	struct disk_stats __percpu *bd_stats;
 	unsigned long		bd_stamp;
 	bool			bd_read_only;	/* read-only policy */
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 7b0326661a1e..a967b3fb3c71 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -236,14 +236,14 @@ static inline sector_t get_start_sect(struct block_device *bdev)
 	return bdev->bd_start_sect;
 }
 
-static inline loff_t bdev_nr_bytes(struct block_device *bdev)
+static inline sector_t bdev_nr_sectors(struct block_device *bdev)
 {
-	return i_size_read(bdev->bd_inode);
+	return bdev->bd_nr_sectors;
 }
 
-static inline sector_t bdev_nr_sectors(struct block_device *bdev)
+static inline loff_t bdev_nr_bytes(struct block_device *bdev)
 {
-	return bdev_nr_bytes(bdev) >> SECTOR_SHIFT;
+	return bdev_nr_setors(bdev) << SECTOR_SHIFT;
 }
 
 static inline sector_t get_capacity(struct gendisk *disk)

-- 
Jens Axboe

