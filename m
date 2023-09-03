From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/11] vfs: add nowait parameter for file_accessed()
Date: Mon, 4 Sep 2023 08:30:52 +1000
Message-ID: <ZPUJHAKzxvXiEDYA@dread.disaster.area>
References: <20230827132835.1373581-1-hao.xu@linux.dev>
 <20230827132835.1373581-8-hao.xu@linux.dev>
 <ZOvA5DJDZN0FRymp@casper.infradead.org>
 <c728bf3f-d9db-4865-8473-058b26c11c06@linux.dev>
 <ZO3cI+DkotHQo3md@casper.infradead.org>
 <642de4e6-801d-fcad-a7ce-bfc6dec3b6e5@linux.dev>
Mime-Version: 1.0
Return-path: <linux-ext4-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1693780255; x=1694385055; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Nv6YpToDNZJcA/Ccz8YHJKQ8zE37n7OYKvDh05ivZ8M=;
        b=eLvFMZ6HweV3i75Mje3KyiQMHp72f3fVYJp4X8QBR1sUoWt5LbUe2oYe6gz7J03xSV
         aHsv7iDil4KTnD32vRddboJhyW5dIQThpWZBfmdQlNdU/+SQKnZqTkI+8YNmhDFqSNM4
         M/5uOEBZigGEpPC3vmfjiwnDFOd47IixsMl044OpUX7QG234XdFYwtba/jPyi6PCo/kZ
         okP+nX6zzbLjyilv/Ocy1qCe5aC4gkdgDOfyh92JWGe8bVg+DmwjlPuuV3kM/V8mAkRG
         YMrGVWwsvVs5uRT8A9BN8JD3DAOcyXyqtn49LxBGuGru+09OFjvSzk6tINPlQnplnbJD
         r/Aw==
Content-Disposition: inline
In-Reply-To: <642de4e6-801d-fcad-a7ce-bfc6dec3b6e5@linux.dev>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hao Xu <hao.xu@linux.dev>
Cc: Matthew Wilcox <willy@infradead.org>, io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Dominique Martinet <asmadeus@codewreck.org>, Pavel Begunkov <asml.silence@gmail.com>, Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>, "Darrick J . Wong" <djwong@kernel.org>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-cachefs@redhat.com, ecryptfs@vger.kernel.org, linux-nfs@vger.kernel.org, linux-unionfs@vger.kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org, linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, codalist@coda.cs.cmu.edu, linux-f2fs-devel@lists.sourcefo

On Wed, Aug 30, 2023 at 02:11:31PM +0800, Hao Xu wrote:
> On 8/29/23 19:53, Matthew Wilcox wrote:
> > On Tue, Aug 29, 2023 at 03:46:13PM +0800, Hao Xu wrote:
> > > On 8/28/23 05:32, Matthew Wilcox wrote:
> > > > On Sun, Aug 27, 2023 at 09:28:31PM +0800, Hao Xu wrote:
> > > > > From: Hao Xu <howeyxu@tencent.com>
> > > > > 
> > > > > Add a boolean parameter for file_accessed() to support nowait semantics.
> > > > > Currently it is true only with io_uring as its initial caller.
> > > > 
> > > > So why do we need to do this as part of this series?  Apparently it
> > > > hasn't caused any problems for filemap_read().
> > > > 
> > > 
> > > We need this parameter to indicate if nowait semantics should be enforced in
> > > touch_atime(), There are locks and maybe IOs in it.
> > 
> > That's not my point.  We currently call file_accessed() and
> > touch_atime() for nowait reads and nowait writes.  You haven't done
> > anything to fix those.
> > 
> > I suspect you can trim this patchset down significantly by avoiding
> > fixing the file_accessed() problem.  And then come back with a later
> > patchset that fixes it for all nowait i/o.  Or do a separate prep series
> 
> I'm ok to do that.
> 
> > first that fixes it for the existing nowait users, and then a second
> > series to do all the directory stuff.
> > 
> > I'd do the first thing.  Just ignore the problem.  Directory atime
> > updates cause I/O so rarely that you can afford to ignore it.  Almost
> > everyone uses relatime or nodiratime.
> 
> Hi Matthew,
> The previous discussion shows this does cause issues in real
> producations: https://lore.kernel.org/io-uring/2785f009-2ebb-028d-8250-d5f3a30510f0@gmail.com/#:~:text=fwiw%2C%20we%27ve%20just%20recently%20had%20similar%20problems%20with%20io_uring%20read/write
> 

Then separate it out into it's own patch set so we can have a
discussion on the merits of requiring using noatime, relatime or
lazytime for really latency sensitive IO applications. Changing code
is not always the right solution...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
