From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/7] shmem: open code the page cache lookup in
 shmem_get_folio_gfp
Date: Sun, 19 Mar 2023 22:23:36 -0700 (PDT)
Message-ID: <af178ebb-1076-a38c-1dc1-2a37ccce4a3@google.com>
References: <20230307143410.28031-1-hch@lst.de> <20230307143410.28031-6-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679289819;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AAg/di4awCbENQSDHCw3uwPaVCnYn/JqQu0b5lYNlhA=;
        b=p9Y2XtE4tcxGUhH+2fluWD0s4npx8Ylcmiofp0dtrqwoGanjdCTVnqg/qMO9B2Eqee
         kJXhUMep3Gz11MElDyCICekSrou5OCXn0KcsjLzta/7S4NXBQ0kAPCCVyubft88a3Elh
         nqu9KKJuvvc4mgDntldKav+//BdLjpY+W1y9F+/oC6RLQag0ajP/d8mSihCI0LQHTscN
         iw4DDucZAA8uSQduK5FuwKdRjql9QLvxP/TP1GhC2AgZJo7kkKfwT7aIEbKJ45sCYU3I
         WQfFiYo6WhPxnQFuL1eZb84t4CXllzGE4KX05JrDvIh2ChxlBcEN4ACNkRgNjlZBwVgk
         gQ5A==
In-Reply-To: <20230307143410.28031-6-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 7 Mar 2023, Christoph Hellwig wrote:

> Use the very low level filemap_get_entry helper to look up the
> entry in the xarray, and then:
> 
>  - don't bother locking the folio if only doing a userfault notification
>  - open code locking the page and checking for truncation in a related
>    code block
> 
> This will allow to eventually remove the FGP_ENTRY flag.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Acked-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

but Andrew, please fold in this small improvement to its comment:

[PATCH] shmem: open code the page cache lookup in shmem_get_folio_gfp fix

Adjust the new comment line: shmem folio may have been swapped out.

Signed-off-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---

 mm/shmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1905,7 +1905,7 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 	if (folio) {
 		folio_lock(folio);
 
-		/* Has the page been truncated? */
+		/* Has the folio been truncated or swapped out? */
 		if (unlikely(folio->mapping != mapping)) {
 			folio_unlock(folio);
 			folio_put(folio);
