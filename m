From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 07/11] vfs: add nowait parameter for file_accessed()
Date: Sun, 27 Aug 2023 22:32:20 +0100
Message-ID: <ZOvA5DJDZN0FRymp@casper.infradead.org>
References: <20230827132835.1373581-1-hao.xu@linux.dev>
 <20230827132835.1373581-8-hao.xu@linux.dev>
Mime-Version: 1.0
Return-path: <bpf+bounces-8814-glkb-bpf=m.gmane-mx.org@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/6hpsLsV03ieW4vELbhOk4pxiCIUuyn6Bpw1V8QuWjA=; b=vTYL9F6nmyMC1z4vgUQ57UMuze
	c8bgt9vFOKWzPspRsbeTFLgLHz/hKRnLtd9UWTyKshqJF7eN4C3F+EMjcufK9pmtU6JnMc8dQv1Vt
	5InC4HIkUznFa/hnNRczUUX7xHbrfZD4svYR9Kg0wslB46dSko8l2iAdkLRH/H5iWuiyt8iN5XazN
	QityxWl2yb3p6DSle3T84m2jiGMPG15FtuhdmZtjHlUbcKD8n1NBcGDOexBbj8JBeLDTA1BEKmInL
	888FPoRnfrZ00U1GiFcxw/e4IZGsn0ijlmA9d45AXC5VifFlQ9hZQtQ/XxGEdq6/5qdn+lFw1Ut3Y
	+YmC6jBQ==;
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:bpf+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:bpf+unsubscribe@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20230827132835.1373581-8-hao.xu@linux.dev>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hao Xu <hao.xu@linux.dev>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Dominique Martinet <asmadeus@codewreck.org>, Pavel Begunkov <asml.silence@gmail.com>, Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>, Dave Chinner <david@fromorbit.com>, "Darrick J . Wong" <djwong@kernel.org>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-cachefs@redhat.com, ecryptfs@vger.kernel.org, linux-nfs@vger.kernel.org, linux-unionfs@vger.kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org, linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, codalist@coda.cs.cmu.edu, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mm@kvack.org, linux-nilfs@vger.kernel.org, devel@lists.orangefs.

On Sun, Aug 27, 2023 at 09:28:31PM +0800, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> Add a boolean parameter for file_accessed() to support nowait semantics.
> Currently it is true only with io_uring as its initial caller.

So why do we need to do this as part of this series?  Apparently it
hasn't caused any problems for filemap_read().

> +++ b/mm/filemap.c
> @@ -2723,7 +2723,7 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
>  		folio_batch_init(&fbatch);
>  	} while (iov_iter_count(iter) && iocb->ki_pos < isize && !error);
>  
> -	file_accessed(filp);
> +	file_accessed(filp, false);
>  
>  	return already_read ? already_read : error;
>  }
> @@ -2809,7 +2809,7 @@ generic_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
>  		retval = kiocb_write_and_wait(iocb, count);
>  		if (retval < 0)
>  			return retval;
> -		file_accessed(file);
> +		file_accessed(file, false);
>  
>  		retval = mapping->a_ops->direct_IO(iocb, iter);
>  		if (retval >= 0) {
> @@ -2978,7 +2978,7 @@ ssize_t filemap_splice_read(struct file *in, loff_t *ppos,
>  
>  out:
>  	folio_batch_release(&fbatch);
> -	file_accessed(in);
> +	file_accessed(in, false);
>  
>  	return total_spliced ? total_spliced : error;
>  }

