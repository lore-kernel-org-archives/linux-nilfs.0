From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH v4 72/73] xfs: Convert mru cache to XArray
Date: Wed, 6 Dec 2017 12:36:48 +1100
Message-ID: <20171206012901.GZ4094@dastard>
References: <20171206004159.3755-1-willy@infradead.org>
 <20171206004159.3755-73-willy@infradead.org>
Mime-Version: 1.0
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171206004159.3755-73-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Rehas Sachdeva <aquannie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Dec 05, 2017 at 04:41:58PM -0800, Matthew Wilcox wrote:
> From: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> 
> This eliminates a call to radix_tree_preload().

.....

>  void
> @@ -431,24 +424,24 @@ xfs_mru_cache_insert(
>  	unsigned long		key,
>  	struct xfs_mru_cache_elem *elem)
>  {
> +	XA_STATE(xas, &mru->store, key);
>  	int			error;
>  
>  	ASSERT(mru && mru->lists);
>  	if (!mru || !mru->lists)
>  		return -EINVAL;
>  
> -	if (radix_tree_preload(GFP_NOFS))
> -		return -ENOMEM;
> -
>  	INIT_LIST_HEAD(&elem->list_node);
>  	elem->key = key;
>  
> -	spin_lock(&mru->lock);
> -	error = radix_tree_insert(&mru->store, key, elem);
> -	radix_tree_preload_end();
> -	if (!error)
> -		_xfs_mru_cache_list_insert(mru, elem);
> -	spin_unlock(&mru->lock);
> +	do {
> +		xas_lock(&xas);
> +		xas_store(&xas, elem);
> +		error = xas_error(&xas);
> +		if (!error)
> +			_xfs_mru_cache_list_insert(mru, elem);
> +		xas_unlock(&xas);
> +	} while (xas_nomem(&xas, GFP_NOFS));

Ok, so why does this have a retry loop on ENOMEM despite the
existing code handling that error? And why put such a loop in this
code and not any of the other XFS code that used
radix_tree_preload() and is arguably much more important to avoid
ENOMEM on insert (e.g. the inode cache)?

Also, I really don't like the pattern of using xa_lock()/xa_unlock()
to protect access to an external structure. i.e. the mru->lock
context is protecting multiple fields and operations in the MRU
structure, not just the radix tree operations. Turning that around
so that a larger XFS structure and algorithm is now protected by an
opaque internal lock from generic storage structure the forms part
of the larger structure seems like a bad design pattern to me...

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
