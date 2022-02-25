From: "Theodore Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH 2/3] ext4: pass the operation to bio_alloc
Date: Fri, 25 Feb 2022 17:07:11 -0500
Message-ID: <YhlTD2R8pFzb9oot@mit.edu>
References: <20220222154634.597067-1-hch@lst.de>
 <20220222154634.597067-3-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220222154634.597067-3-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Feb 22, 2022 at 04:46:33PM +0100, Christoph Hellwig wrote:
> Refactor the readpage code to pass the op to bio_alloc instead of setting
> it just before the submission.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Acked-by: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
