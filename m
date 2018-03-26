From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v9 00/61] XArray v9
Date: Mon, 26 Mar 2018 15:36:48 -0700
Message-ID: <20180326153648.27f53e9a1398812203745257@linux-foundation.org>
References: <20180313132639.17387-1-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180313132639.17387-1-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Matthew Wilcox <willy@infradead.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org

On Tue, 13 Mar 2018 06:25:38 -0700 Matthew Wilcox <willy@infradead.org> wrote:

> This patchset is, I believe, appropriate for merging for 4.17.
> It contains the XArray implementation, to eventually replace the radix
> tree, and converts the page cache to use it.

I looked at this from a for-4.17 POV and ran out of nerve at "[PATCH v9
09/61] xarray: Replace exceptional entries".  It's awfully late.

"[PATCH v9 08/61] page cache: Use xa_lock" looks sufficiently
mechanical to be if-it-compiles-it-works, although perhaps that
shouldn't be in 4.17 either.  Mainly because it commits us to merging
the rest of XArray and there hasn't been a ton of review and test
activity.



It looks like btrfs has changed in -next:

--- a/fs/btrfs/inode.c~page-cache-use-xa_lock-fix
+++ a/fs/btrfs/inode.c
@@ -7445,7 +7445,7 @@ out:
 
 bool btrfs_page_exists_in_range(struct inode *inode, loff_t start, loff_t end)
 {
-	struct radix_tree_root *root = &inode->i_mapping->page_tree;
+	struct radix_tree_root *root = &inode->i_mapping->i_pages;
 	bool found = false;
 	void **pagep = NULL;
 	struct page *page = NULL;
_

