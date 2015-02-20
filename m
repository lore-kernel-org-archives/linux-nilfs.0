From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 1/1] nilfs2: fix potential memory overrun on inode
Date: Fri, 20 Feb 2015 13:58:42 -0800
Message-ID: <20150220135842.0cd5c9338316a8a20b6a604a@linux-foundation.org>
References: <1424439995-613-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<1424439995-613-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424439995-613-2-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, 20 Feb 2015 22:46:35 +0900 Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org> wrote:

> Each inode of nilfs2 stores a root node of a b-tree, and it turned out
> to have a memory overrun issue:
> 
> Each b-tree node of nilfs2 stores a set of key-value pairs and the
> number of them (in "bn_nchildren" member of nilfs_btree_node struct),
> as well as a few other "bn_*" members.
> 
> Since the value of "bn_nchildren" is used for operations on the
> key-values within the b-tree node, it can cause memory access overrun
> if a large number is incorrectly set to "bn_nchildren".
> 
> For instance, nilfs_btree_node_lookup() function determines the range
> of binary search with it, and too large "bn_nchildren" leads
> nilfs_btree_node_get_key() in that function to overrun.
> 
> As for intermediate b-tree nodes, this is prevented by a sanity check
> performed when each node is read from a drive, however, no sanity
> check has been done for root nodes stored in inodes.
> 
> This patch fixes the issue by adding missing sanity check against
> b-tree root nodes so that it's called when on-memory inodes are read
> from ifile, inode metadata file.

How would one trigger this overrun?  Mount an fs with a deliberately
corrupted/inconsistent fs image?

Memory overrun sounds nasty so I'm thinking we add cc:stable to this
one.  OK?

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
