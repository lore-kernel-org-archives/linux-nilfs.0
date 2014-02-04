From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH 3/4] nilfs2: add nilfs_sufile_set_suinfo to update
 segment usage
Date: Wed, 05 Feb 2014 02:23:09 +0900 (JST)
Message-ID: <20140205.022309.85397785.konishi.ryusuke@lab.ntt.co.jp>
References: <1391446244-1435-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<20140203133818.5b78761c08846f2d1216b6e2@linux-foundation.org>
	<20140205.014137.417300930.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140205.014137.417300930.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 05 Feb 2014 01:41:37 +0900 (JST), Ryusuke Konishi wrote:
> On Mon, 3 Feb 2014 13:38:18 -0800, Andrew Morton wrote:
>> On Tue,  4 Feb 2014 01:50:43 +0900 Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org> wrote:
>> 
>>> From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
>>> 
>>> This patch introduces the nilfs_sufile_set_suinfo function, which
>>> expects an array of nilfs_suinfo_update structures and updates the
>>> segment usage information accordingly.
>>> 
>>> This is basically a helper function for the newly introduced
>>> NILFS_IOCTL_SET_SUINFO ioctl.
>>> 
>>> ..
>>> +		sup = (void *)sup + supsz;
>>> +		if (sup >= supend)
>>> +			break;
>>> +
>>> +		prev_blkoff = blkoff;
>>> +		blkoff = nilfs_sufile_get_blkoff(sufile, sup->sup_segnum);
>>> +		if (blkoff == prev_blkoff)
>>> +			continue;
>>> +
>>> +		/* get different block */
>>> +		mark_buffer_dirty(bh);
>>> +		brelse(bh);
>> 
>> put_bh() will suffice - we know bh != NULL.
> 
> Agreed.  I will fix it later.

Here is the fix.

Ryusuke Konishi
--
From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs2: add nilfs_sufile_set_suinfo to update segment usage
 fix

Use put_bh() instead of brelse() because we know bh != NULL.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/sufile.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index c37b5f0..5628b99 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -978,13 +978,13 @@ ssize_t nilfs_sufile_set_suinfo(struct inode *sufile, void *buf,
 
 		/* get different block */
 		mark_buffer_dirty(bh);
-		brelse(bh);
+		put_bh(bh);
 		ret = nilfs_mdt_get_block(sufile, blkoff, 1, NULL, &bh);
 		if (unlikely(ret < 0))
 			goto out_mark;
 	}
 	mark_buffer_dirty(bh);
-	brelse(bh);
+	put_bh(bh);
 
  out_mark:
 	if (ncleaned || ndirtied) {
@@ -994,7 +994,7 @@ ssize_t nilfs_sufile_set_suinfo(struct inode *sufile, void *buf,
 	}
 	nilfs_mdt_mark_dirty(sufile);
  out_header:
-	brelse(header_bh);
+	put_bh(header_bh);
  out_sem:
 	up_write(&NILFS_MDT(sufile)->mi_sem);
 	return ret;
-- 
1.7.9.3


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
