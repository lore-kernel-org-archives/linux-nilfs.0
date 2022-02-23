From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] nilfs2: pass the operation to bio_alloc
Date: Thu, 24 Feb 2022 00:25:20 +0900
Message-ID: <CAKFNMomTz6cpQNv1ABT6UaT8z=Ou98E9juoZupc71FUxN46_qg@mail.gmail.com>
References: <20220222154634.597067-1-hch@lst.de> <20220222154634.597067-4-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1BZ0n/VXuB4e+b9N79/HKBcV1lFL5+uSe4QaX/5c2kY=;
        b=V2NZd/1W3V3wsR/bZWYyX1ajF8T1xlMT/2MYjmionIym5JJTz6F7twH//YkxTeQXF0
         Kl20Sy5kTW/v6HoyzBLeCETx+N4AdOINs6qDKzRuG3W2fy+aXUDyv/m0zaPGncxe4I1u
         U3bUQiCGDQpT7A01SNUUM6g6qEuhVWOb/IRTr1AI0+1n8G8QcByT00Xo3SRhCOth+fsj
         y4xWLsZaDWB88jTXzBz44uVgddZfj/PLsM6onazKGdpTpjZPWMnoX9w615Dmc0u99a7t
         s0YnWE+yLWNVg3lL3Wg9hc5WjZwM0qWAWiMX9IUwTjThS7HKVT6Rog9SkZEqohzBzPNd
         5YYQ==
In-Reply-To: <20220222154634.597067-4-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Feb 23, 2022 at 12:46 AM Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
>
> Refactor the segbuf write code to pass the op to bio_alloc instead of
> setting it just before the submission.
>
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---
>  fs/nilfs2/segbuf.c | 20 +++++++++-----------
>  1 file changed, 9 insertions(+), 11 deletions(-)

Acked-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Looks good for the 'for-5.18' branch of linux-block tree.

Thanks,
Ryusuke Konishi
