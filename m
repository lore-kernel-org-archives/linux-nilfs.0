From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: nilfs2: fix issue with flush kernel thread after remount in RO
 mode because of driver's internal error or metadata corruption
Date: Thu, 25 Apr 2013 10:49:47 +0300
Message-ID: <20130425074947.GB11880@elgon.mountain>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kbuild-JC7UmRfGjtg@public.gmane.org

[ It's weird that kbuild didn't catch this ].

Hello Vyacheslav Dubeyko,

The patch bb594c4767b0: "nilfs2: fix issue with flush kernel thread
after remount in RO mode because of driver's internal error or
metadata corruption" from Apr 18, 2013, leads to the following 
warning:
"fs/nilfs2/inode.c:211 nilfs_writepage()
	 error: we previously assumed 'inode' could be null (see line 195)"

fs/nilfs2/inode.c
   190  static int nilfs_writepage(struct page *page, struct writeback_control *wbc)
   191  {
   192          struct inode *inode = page->mapping->host;
   193          int err;
   194  
   195          if (inode && (inode->i_sb->s_flags & MS_RDONLY)) {
                    ^^^^^
New check.

   196                  /*
   197                   * It means that filesystem was remounted in read-only
   198                   * mode because of error or metadata corruption. But we
   199                   * have dirty pages that try to be flushed in background.
   200                   * So, here we simply discard this dirty page.
   201                   */
   202                  nilfs_clear_dirty_page(page, false);
   203                  unlock_page(page);
   204                  return -EROFS;
   205          }
   206  
   207          redirty_page_for_writepage(wbc, page);
   208          unlock_page(page);
   209  
   210          if (wbc->sync_mode == WB_SYNC_ALL) {
   211                  err = nilfs_construct_segment(inode->i_sb);
                                                      ^^^^^^^^^^^
Old dereference.

   212                  if (unlikely(err))
   213                          return err;
   214          } else if (wbc->for_reclaim)
   215                  nilfs_flush_segment(inode->i_sb, inode->i_ino);
                                            ^^^^^^^^^^^
Old dereference.

   216  
   217          return 0;
   218  }

regards,
dan carpenter

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
