From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: [PATCH 5/7] nilfs2: add bmap function to seek a valid key
Date: Thu, 26 Mar 2015 00:19:32 +0900 (JST)
Message-ID: <20150326.001932.746965246564732016.konishi.ryusuke@lab.ntt.co.jp>
References: <1426171094-27414-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<1426171094-27414-6-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=OZmE5wZ6BBTmFsXsWKbiU9UAYNpuOlcu1bH41AkzllA=;
        b=Vgz1RJz8elhl1h9l3zj8Ilc+bRrwZD7NYeSHlLKp4HteBzgCKgGknQkemthdUXl4c4
         2Ze8nESgQJWtJkyR1KpBAzZd1eCqqEaqnR5EnyTuQnMIVJKYkDKTJVZ2zsyNiVYlubag
         0TfsiUU/jDj0rvFiUYP57ELgpws3WozzjoMuf7H+6salAjGjiGSbAvBl2D3aVgCN7ee+
         wHMx4wlfEvP6/XFYy6kCXnMcxAyURaLAzVUgPUivcMDgTDL4rtYlhYhTQgpNIYZLYBqu
         m8qYy28+NQAzNzVvg6AbhkeO9MhlBA5ms/QSW3713uEsPG+GBq15IbPo9i65yQJS2Fon
         XHyw==
In-Reply-To: <1426171094-27414-6-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Dan Carpenter <dan.carpenter@oracle.com>, kbuild@01.org

Hi Andrew,

On Thu, 12 Mar 2015 23:38:12 +0900, Ryusuke Konishi wrote:
> Add a new bmap function, nilfs_bmap_seek_key(), which seeks a valid
> entry and returns its key starting from a given key.  This function
> can be used to skip hole blocks efficiently.
> 
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
> ---
<snip>
> +static int nilfs_btree_seek_key(const struct nilfs_bmap *btree, __u64 start,
> +				__u64 *keyp)
> +{
> +	struct nilfs_btree_path *path;
> +	const int minlevel = NILFS_BTREE_LEVEL_NODE_MIN;
> +	int ret;
> +

> +	if (start > NILFS_BTREE_KEY_MAX)
> +		return -ENOENT;

Could you apply the following amendment ?

I've got a report from Dan Carpenter that this range check causes a
warning:

 fs/nilfs2/btree.c:1611 nilfs_btree_seek_key() warn: impossible condition '(start > (~0)) => (0-u64max > u64max)'

A range check was needed there in a wip patch, but we no longer need
it.

Thanks,
Ryusuke Konishi
--
diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 841d177..059f371 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -1608,9 +1608,6 @@ static int nilfs_btree_seek_key(const struct nilfs_bmap *btree, __u64 start,
 	const int minlevel = NILFS_BTREE_LEVEL_NODE_MIN;
 	int ret;
 
-	if (start > NILFS_BTREE_KEY_MAX)
-		return -ENOENT;
-
 	path = nilfs_btree_alloc_path();
 	if (!path)
 		return -ENOMEM;
-- 
1.8.3.1
