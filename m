From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 08/19] dm-thin: use blkdev_issue_flush instead of open
 coding it
Date: Thu, 27 Jan 2022 12:11:40 -0500
Message-ID: <YfLSTPB7UUZKqQKL@redhat.com>
References: <20220124091107.642561-1-hch@lst.de>
 <20220124091107.642561-9-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643303503;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xtKZnu3m4MJ1lsPgVyhgN06mFCH9uLK+At7c0q3e4j8=;
        b=LN8FAamK45sm6noJKUN6tg+JuKEjFXTHjCz0Gz3hQXd7xEnG8vCRHb6CYG8/0sito9KieR
        EoA3uFroRZoPvlL+SDdS4cbDbrpWlWUd6YK5HZdf/U3wzh4GlyqcSS/9tB/oQEndPVNawx
        37imUkamyk+Z/2GOH1G55UuYiAToeOc=
Content-Disposition: inline
In-Reply-To: <20220124091107.642561-9-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Andrew Morton <akpm@linux-foundation.org>, "Md . Haris Iqbal " <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>, Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.co>, Philipp Reisner <philipp.reisner@linbit.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org, ntfs3@lists.linux.dev, xen-devel@lists.xenproject.org, drbd-dev@lists.linbit.com

On Mon, Jan 24 2022 at  4:10P -0500,
Christoph Hellwig <hch@lst.de> wrote:

> Use blkdev_issue_flush, which uses an on-stack bio instead of an
> opencoded version with a bio embedded into struct pool.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Mike Snitzer <snitzer@redhat.com>

