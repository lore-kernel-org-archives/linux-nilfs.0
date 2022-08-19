From: David Laight <David.Laight-ZS65k/vG3HxXrIkS9f7CXA@public.gmane.org>
Subject: RE: [PATCH] nilfs2: delete unnecessary checks before brelse()
Date: Fri, 19 Aug 2022 21:31:45 +0000
Message-ID: <0d78d24dd26441818dbaedffde611485@AcuMS.aculab.com>
References: <20220819081700.96279-1-chi.minghao@zte.com.cn>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220819081700.96279-1-chi.minghao-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
Content-Language: en-US
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "'cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org'" <cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Minghao Chi <chi.minghao-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>, Zeal Robot <zealci-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>

From: cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
> Sent: 19 August 2022 09:17
> 
> The brelse() function tests whether its argument is NULL
> and then returns immediately.
> Thus remove the tests which are not needed around the shown calls.

The test is the caller makes sense if it is a 'hot' path
and bh is normally NULL.

	David

> 
> Reported-by: Zeal Robot <zealci-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
> Signed-off-by: Minghao Chi <chi.minghao-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
> ---
>  fs/nilfs2/btree.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
> index f544c22fff78..b3b5a46488c2 100644
> --- a/fs/nilfs2/btree.c
> +++ b/fs/nilfs2/btree.c
> @@ -1668,8 +1668,7 @@ static int nilfs_btree_check_delete(struct nilfs_bmap *btree, __u64 key)
>  	maxkey = nilfs_btree_node_get_key(node, nchildren - 1);
>  	nextmaxkey = (nchildren > 1) ?
>  		nilfs_btree_node_get_key(node, nchildren - 2) : 0;
> -	if (bh != NULL)
> -		brelse(bh);
> +	brelse(bh);
> 
>  	return (maxkey == key) && (nextmaxkey < NILFS_BMAP_LARGE_LOW);
>  }
> @@ -1717,8 +1716,7 @@ static int nilfs_btree_gather_data(struct nilfs_bmap *btree,
>  		ptrs[i] = le64_to_cpu(dptrs[i]);
>  	}
> 
> -	if (bh != NULL)
> -		brelse(bh);
> +	brelse(bh);
> 
>  	return nitems;
>  }
> --
> 2.25.1

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

