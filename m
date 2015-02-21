From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH 1/1] nilfs2: fix potential memory overrun on inode
Date: Sat, 21 Feb 2015 10:13:28 +0900 (JST)
Message-ID: <20150221.101328.1613471465739082397.konishi.ryusuke@lab.ntt.co.jp>
References: <1424439995-613-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<20150220135842.0cd5c9338316a8a20b6a604a@linux-foundation.org>
	<20150221.092208.1795135375638032743.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=tHQIDoKJXM5rItZKU5khgilbxa0fZ5lpMG2gcWN83TI=;
        b=LQH41rwJbzRqOU+REsvy819Jf+ybR7fFsVduNb7xcbZEcovnxlzWbexhiPofAzJZNp
         c2sUzOk5nnrLy21cqTaWkzbbcM75DovHz4ccghNdNklj7NoCx3Dziyq0LOqn25rdm8a8
         yvuQ46ZE6RlcT9TkZTLIO3xzduCtYvKBPw6nD8qBLUPBgtMDELnxVQQmkGvQBY6raIRO
         sII6g0/UOtfW3YhdqoVe4JSNwXrJBHoba08qKx8F2hQ0ldVsCwXVD3+zzcJKByBk9/6D
         eiq5WvmyHWbEXK/X24HX8Zi9JQJae89buNgl2/tSFN5hZiXSohrZOq8BF3+1gOpEq0UT
         4TYg==
In-Reply-To: <20150221.092208.1795135375638032743.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, 21 Feb 2015 09:22:08 +0900 (JST), Ryusuke Konishi wrote:
> On Fri, 20 Feb 2015 13:58:42 -0800, Andrew Morton wrote:
>> On Fri, 20 Feb 2015 22:46:35 +0900 Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org> wrote:
>> 
>>> Each inode of nilfs2 stores a root node of a b-tree, and it turned out
>>> to have a memory overrun issue:
>>> 
>>> Each b-tree node of nilfs2 stores a set of key-value pairs and the
>>> number of them (in "bn_nchildren" member of nilfs_btree_node struct),
>>> as well as a few other "bn_*" members.
>>> 
>>> Since the value of "bn_nchildren" is used for operations on the
>>> key-values within the b-tree node, it can cause memory access overrun
>>> if a large number is incorrectly set to "bn_nchildren".
>>> 
>>> For instance, nilfs_btree_node_lookup() function determines the range
>>> of binary search with it, and too large "bn_nchildren" leads
>>> nilfs_btree_node_get_key() in that function to overrun.
>>> 
>>> As for intermediate b-tree nodes, this is prevented by a sanity check
>>> performed when each node is read from a drive, however, no sanity
>>> check has been done for root nodes stored in inodes.
>>> 
>>> This patch fixes the issue by adding missing sanity check against
>>> b-tree root nodes so that it's called when on-memory inodes are read
>>> from ifile, inode metadata file.
>> 
>> How would one trigger this overrun?  Mount an fs with a deliberately
>> corrupted/inconsistent fs image?
> 
> Yes, this can be triggered by mounting an fs with a corrupted image
> deliberately or by chance.
> 
>> Memory overrun sounds nasty so I'm thinking we add cc:stable to this
>> one.  OK?
> 
> Agreed.

Could you apply the following amendment ?

I've got a warning from 0day kernel testing backend:

    fs/nilfs2/btree.c: In function 'nilfs_btree_root_broken':
>> fs/nilfs2/btree.c:394:3: warning: format '%lu' expects argument of type 'long unsigned int', but argument 2 has type 'ino_t' [-Wformat=]
       pr_crit("NILFS: bad btree root (inode number=%lu): level = %d, 
flags = 0x%x, nchildren = %d\n",
       ^

This is output for s390 arch since ino_t doesn't mean "unsigned long"
in s390.

Thanks,
Ryusuke Konishi
--
diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index c645d7c..ecdbae1 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -378,7 +378,7 @@ static int nilfs_btree_node_broken(const struct nilfs_btree_node *node,
  * Return Value: If node is broken, 1 is returned. Otherwise, 0 is returned.
  */
 static int nilfs_btree_root_broken(const struct nilfs_btree_node *node,
-				   ino_t ino)
+				   unsigned long ino)
 {
 	int level, flags, nchildren;
 	int ret = 0;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
