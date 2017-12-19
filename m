From: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: Storing errors in the XArray
Date: Mon, 18 Dec 2017 16:27:39 -0800
Message-ID: <d8390a61-9fd9-79a7-63e9-c5f343e0f339@infradead.org>
References: <20171206004159.3755-1-willy@infradead.org>
 <20171206004159.3755-9-willy@infradead.org>
 <66ad068b-1973-ca41-7bbf-8a0634cc488d@infradead.org>
 <20171215171012.GA11918@bombadil.infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=r+4zHLjy/ixJA9QYp4zSoyB45HkMWIAx6+OQTfkhZlY=; b=MR5qGJHqR2j3sayLK9E4No+n2p
        26j/1g5ipv8G7MIh/ZVRAVoCHiHuvF1+9UlwVxJJYK/KxB0RpCgJaM7chktkAOf1CmWi4q6uiBaO+
        E1i2wKYmC4t6r9db9m7V/UY0nJj7fbvOqFm4/jAYMajxgEz+NS1+3rYx1YIHTeh9nt7M21ofKTHrl
        XdnbuGm7YVPmXl/z0YyP/tLaolhvQjKqJoXIaGv82ZuT4JtgB9Oe190wrFie2WvtbujmrP68YUUHU
        8OiRy6vb7vJds6SjY2zwd649YF7Gy7EcfX1m9A+RvdRdG/hbyDeKCgmyhRRR5/C6GC0uddY7qGjee
      
In-Reply-To: <20171215171012.GA11918-PfSpb0PWhxZc2C7mugBRk2EX/6BAtgUQ@public.gmane.org>
Content-Language: en-US
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Rehas Sachdeva <aquannie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 12/15/2017 09:10 AM, Matthew Wilcox wrote:
> On Mon, Dec 11, 2017 at 03:10:22PM -0800, Randy Dunlap wrote:
>>> +The XArray does not support storing :c:func:`IS_ERR` pointers; some
>>> +conflict with data values and others conflict with entries the XArray
>>> +uses for its own purposes.  If you need to store special values which
>>> +cannot be confused with real kernel pointers, the values 4, 8, ... 4092
>>> +are available.
>>
>> or if I know that they values are errno-range values, I can just shift them
>> left by 2 to store them and then shift them right by 2 to use them?
> 
> On further thought, I like this idea so much, it's worth writing helpers
> for this usage.  And test-suite (also doubles as a demonstration of how
> to use it).
> 
> diff --git a/include/linux/xarray.h b/include/linux/xarray.h
> index c616e9319c7c..53aa251df57a 100644
> --- a/include/linux/xarray.h
> +++ b/include/linux/xarray.h
> @@ -232,6 +232,39 @@ static inline bool xa_is_value(const void *entry)
>  	return (unsigned long)entry & 1;
>  }
>  
> +/**
> + * xa_mk_errno() - Create an XArray entry from an error number.
> + * @error: Error number to store in XArray.
> + *
> + * Return: An entry suitable for storing in the XArray.
> + */
> +static inline void *xa_mk_errno(long error)
> +{
> +	return (void *)(error << 2);
> +}
> +
> +/**
> + * xa_to_errno() - Get error number stored in an XArray entry.
> + * @entry: XArray entry.
> + *
> + * Return: The error number stored in the XArray entry.
> + */
> +static inline unsigned long xa_to_errno(const void *entry)
> +{
> +	return (long)entry >> 2;
> +}
> +
> +/**
> + * xa_is_errno() - Determine if an entry is an errno.
> + * @entry: XArray entry.
> + *
> + * Return: True if the entry is an errno, false if it is a pointer.
> + */
> +static inline bool xa_is_errno(const void *entry)
> +{
> +	return (((unsigned long)entry & 3) == 0) && (entry > (void *)-4096);

	Some named mask bits would be ^^^ preferable there.
#define MAX_ERRNO	4095 // from err.h
	                                         && (entry >= (void *)-MAX_ERRNO);

> +}
> +
>  /**
>   * xa_is_internal() - Is the entry an internal entry?
>   * @entry: Entry retrieved from the XArray
> diff --git a/tools/testing/radix-tree/xarray-test.c b/tools/testing/radix-tree/xarray-test.c
> index 43111786ebdd..b843cedf3988 100644
> --- a/tools/testing/radix-tree/xarray-test.c
> +++ b/tools/testing/radix-tree/xarray-test.c
> @@ -29,7 +29,13 @@ void check_xa_err(struct xarray *xa)
>  	assert(xa_err(xa_store(xa, 1, xa_mk_value(0), GFP_KERNEL)) == 0);
>  	assert(xa_err(xa_store(xa, 1, NULL, 0)) == 0);
>  // kills the test-suite :-(
> -//     assert(xa_err(xa_store(xa, 0, xa_mk_internal(0), 0)) == -EINVAL);
> +//	assert(xa_err(xa_store(xa, 0, xa_mk_internal(0), 0)) == -EINVAL);
> +
> +	assert(xa_err(xa_store(xa, 0, xa_mk_errno(-ENOMEM), GFP_KERNEL)) == 0);
> +	assert(xa_err(xa_load(xa, 0)) == 0);
> +	assert(xa_is_errno(xa_load(xa, 0)) == true);
> +	assert(xa_to_errno(xa_load(xa, 0)) == -ENOMEM);
> +	xa_erase(xa, 0);
>  }
>  
>  void check_xa_tag(struct xarray *xa)
> 

Thanks,
-- 
~Randy
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
