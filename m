From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH] nilfs2: fix data loss with mmap()
Date: Tue, 16 Sep 2014 07:01:30 +0900 (JST)
Message-ID: <20140916.070130.858349725408024032.konishi.ryusuke@lab.ntt.co.jp>
References: <1410810450-2637-1-git-send-email-andreas.rohner@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=518YHNHD8kYRdiMoC3ijtB/2H1hqordAm+T8d3Cg92M=;
        b=wceMUJR3uvpoGinWvxwN4iEWdMaSa9fgBTUks5sRT4isdPnySe4J+zZ/Ri/foYB4wM
         qMyagx9g1izfmL3u2c6f9/S008m/7HRKxkqbkZIpsiP/E5YB/U8hEvVB7/WhCdwh1eCr
         U2XhWSY5rZrv69KfsTKAwh1bRfgJAGtasyIssYj7RIyeOgADThhFqR+wc94KudYSRBl7
         jcukolWu/nOQkC0vyGFQYN6jtIV2K15Dn+bCbaE7Sj0g+1MbfohQMV+UMTD/G+Rl1eSq
         X3E2o5qZ9bT48hL5g+FrYBQqrs8JT/wlVpEQdWTTZFFOQg6/7K/NwabB4En3lfYVRUdW
         kbkw==
In-Reply-To: <1410810450-2637-1-git-send-email-andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Andreas,
On Mon, 15 Sep 2014 21:47:30 +0200, Andreas Rohner wrote:
> This bug leads to reproducible silent data loss, despite the use of
> msync(), sync() and a clean unmount of the file system. It is easily
> reproducible with the following script:
> 
> ----------------[BEGIN SCRIPT]--------------------
> mkfs.nilfs2 -f /dev/sdb
> mount /dev/sdb /mnt
> 
> # create 30MB testfile
> dd if=/dev/zero bs=1M count=30 of=/mnt/testfile
> 
> umount /mnt
> mount /dev/sdb /mnt
> CHECKSUM_BEFORE="$(md5sum /mnt/testfile)"
> 
> # simple tool that opens /mnt/testfile and
> # writes a few blocks using mmap at a 5MB offset
> /root/mmaptest/mmaptest /mnt/testfile 30 10 5
> 
> sync
> CHECKSUM_AFTER="$(md5sum /mnt/testfile)"
> umount /mnt
> mount /dev/sdb /mnt
> CHECKSUM_AFTER_REMOUNT="$(md5sum /mnt/testfile)"
> umount /mnt
> 
> echo "BEFORE MMAP:\t$CHECKSUM_BEFORE"
> echo "AFTER MMAP:\t$CHECKSUM_AFTER"
> echo "AFTER REMOUNT:\t$CHECKSUM_AFTER_REMOUNT"
> ----------------[END SCRIPT]--------------------
> 
> The mmaptest tool looks something like this (very simplified, with
> error checking removed):
> 
> ----------------[BEGIN mmaptest]--------------------
> data = mmap(NULL, file_size - file_offset, PROT_READ | PROT_WRITE,
> 		MAP_SHARED, fd, file_offset);
> 
> for (i = 0; i < write_count; ++i) {
> 	memcpy(data + i * 4096, buf, sizeof(buf));
> 	msync(data, file_size - file_offset, MS_SYNC))
> }
> ----------------[END mmaptest]--------------------
> 
> The output of the script looks something like this:
> 
> BEFORE MMAP:    281ed1d5ae50e8419f9b978aab16de83  /mnt/testfile
> AFTER MMAP:     6604a1c31f10780331a6850371b3a313  /mnt/testfile
> AFTER REMOUNT:  281ed1d5ae50e8419f9b978aab16de83  /mnt/testfile
> 
> So it is clear, that the changes done using mmap() do not survive a
> remount. This can be reproduced a 100% of the time. The problem was
> introduced with the following commit:
> 
> 136e877 nilfs2: fix issue of nilfs_set_page_dirty() for page at EOF
> boundary
> 
> If the page was read with mpage_readpage() or mpage_readpages() for
> example, then  it has no buffers attached to it. In that case
> page_has_buffers(page) in nilfs_set_page_dirty() will be false.
> Therefore nilfs_set_file_dirty() is never called and the pages are never
> collected and never written to disk.
> 
> This patch fixes the problem by also calling nilfs_set_file_dirty() if
> the page has no buffers attached to it.
> 
> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
> ---
>  fs/nilfs2/inode.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
> index 6252b17..9e3c525 100644
> --- a/fs/nilfs2/inode.c
> +++ b/fs/nilfs2/inode.c
> @@ -219,10 +219,10 @@ static int nilfs_writepage(struct page *page, struct writeback_control *wbc)
>  
>  static int nilfs_set_page_dirty(struct page *page)
>  {
> +	struct inode *inode = page->mapping->host;
>  	int ret = __set_page_dirty_nobuffers(page);
>  
>  	if (page_has_buffers(page)) {
> -		struct inode *inode = page->mapping->host;
>  		unsigned nr_dirty = 0;
>  		struct buffer_head *bh, *head;
>  
> @@ -245,6 +245,10 @@ static int nilfs_set_page_dirty(struct page *page)
>  
>  		if (nr_dirty)
>  			nilfs_set_file_dirty(inode, nr_dirty);
> +	} else if (ret) {
> +		unsigned nr_dirty = 1 << (PAGE_SHIFT - inode->i_blkbits);
> +
> +		nilfs_set_file_dirty(inode, nr_dirty);
>  	}
>  	return ret;
>  }
> -- 
> 2.1.0

Thank you for reporting this issue.

I'd like to look into this patch, it looks to point out an important
regression, but it may take some time since I am quite busy this week..

Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
