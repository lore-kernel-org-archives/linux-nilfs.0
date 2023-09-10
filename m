From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/11] vfs: add nowait parameter for file_accessed()
Date: Mon, 11 Sep 2023 08:01:24 +1000
Message-ID: <ZP48tAg2iS0UzKQf@dread.disaster.area>
References: <20230827132835.1373581-1-hao.xu@linux.dev>
 <20230827132835.1373581-8-hao.xu@linux.dev>
 <ZOvA5DJDZN0FRymp@casper.infradead.org>
 <c728bf3f-d9db-4865-8473-058b26c11c06@linux.dev>
 <ZO3cI+DkotHQo3md@casper.infradead.org>
 <642de4e6-801d-fcad-a7ce-bfc6dec3b6e5@linux.dev>
 <ZPUJHAKzxvXiEDYA@dread.disaster.area>
 <6489b8cb-7d54-1e29-f192-a3449ed87fa1@gmail.com>
Mime-Version: 1.0
Return-path: <ecryptfs-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1694383288; x=1694988088; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EyybjuBSw2AsBAibBPVqGccWs6P0JtTeGBB0Kwx90Dw=;
        b=b1Q+Djrc6DRgK0lSMIXf6OVmm1S98Rb1dJdV/4AjeMobXYoqxa/k4Xb7XAYcmCuvbB
         T8pFPhiJHk/Ig8CcU4is+jZGfReesXQjqK7ULjc+VZz110Uqhy1NjrWTu4Ej2kgb1UEn
         ZHgnS7dDfuM0nrDuRkgBy+D/YOBtPecXxWCyUh6h/0/NlsJyyOwKHQwSKYYxfVY7xjkS
         7I+QxdaDiDVRMV8qekGuV48jZlbOlbc6skR8a29kp5hS8zsrhWfeCv9XIJ/gwMURSkPX
         Ncgzq9d3+KaDgvRq3XsvmeqBjcqt9Lc7ewxeY00IZtUnccPI4WIduUYqP2aDlo+H2VFl
         7yRw==
Content-Disposition: inline
In-Reply-To: <6489b8cb-7d54-1e29-f192-a3449ed87fa1@gmail.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Hao Xu <hao.xu@linux.dev>, Matthew Wilcox <willy@infradead.org>, io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Dominique Martinet <asmadeus@codewreck.org>, Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>, "Darrick J . Wong" <djwong@kernel.org>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-cachefs@redhat.com, ecryptfs@vger.kernel.org, linux-nfs@vger.kernel.org, linux-unionfs@vger.kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org, linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, codalist@coda.cs.cmu.edu, linux-f2fs-devel@lists.sourceforge.net, cluster-devel

On Fri, Sep 08, 2023 at 01:29:55AM +0100, Pavel Begunkov wrote:
> On 9/3/23 23:30, Dave Chinner wrote:
> > On Wed, Aug 30, 2023 at 02:11:31PM +0800, Hao Xu wrote:
> > > On 8/29/23 19:53, Matthew Wilcox wrote:
> > > > On Tue, Aug 29, 2023 at 03:46:13PM +0800, Hao Xu wrote:
> > > > > On 8/28/23 05:32, Matthew Wilcox wrote:
> > > > > > On Sun, Aug 27, 2023 at 09:28:31PM +0800, Hao Xu wrote:
> > > > > > > From: Hao Xu <howeyxu@tencent.com>
> > > > > > > 
> > > > > > > Add a boolean parameter for file_accessed() to support nowait semantics.
> > > > > > > Currently it is true only with io_uring as its initial caller.
> > > > > > 
> > > > > > So why do we need to do this as part of this series?  Apparently it
> > > > > > hasn't caused any problems for filemap_read().
> > > > > > 
> > > > > 
> > > > > We need this parameter to indicate if nowait semantics should be enforced in
> > > > > touch_atime(), There are locks and maybe IOs in it.
> > > > 
> > > > That's not my point.  We currently call file_accessed() and
> > > > touch_atime() for nowait reads and nowait writes.  You haven't done
> > > > anything to fix those.
> > > > 
> > > > I suspect you can trim this patchset down significantly by avoiding
> > > > fixing the file_accessed() problem.  And then come back with a later
> > > > patchset that fixes it for all nowait i/o.  Or do a separate prep series
> > > 
> > > I'm ok to do that.
> > > 
> > > > first that fixes it for the existing nowait users, and then a second
> > > > series to do all the directory stuff.
> > > > 
> > > > I'd do the first thing.  Just ignore the problem.  Directory atime
> > > > updates cause I/O so rarely that you can afford to ignore it.  Almost
> > > > everyone uses relatime or nodiratime.
> > > 
> > > Hi Matthew,
> > > The previous discussion shows this does cause issues in real
> > > producations: https://lore.kernel.org/io-uring/2785f009-2ebb-028d-8250-d5f3a30510f0@gmail.com/#:~:text=fwiw%2C%20we%27ve%20just%20recently%20had%20similar%20problems%20with%20io_uring%20read/write
> > > 
> > 
> > Then separate it out into it's own patch set so we can have a
> > discussion on the merits of requiring using noatime, relatime or
> > lazytime for really latency sensitive IO applications. Changing code
> > is not always the right solution...
> 
> Separation sounds reasonable, but it can hardly be said that only
> latency sensitive apps would care about >1s nowait/async submission
> delays. Presumably, btrfs can improve on that, but it still looks
> like it's perfectly legit for filesystems do heavy stuff in
> timestamping like waiting for IO. Right?

Yes, it is, no-one is denying that. And some filesystems are worse
than others, but none of that means it has to be fixed so getdents
can be converted to NOWAIT semantics.

ie. this patchset is about the getdents NOWAIT machinery, and
fiddling around with timestamps has much, much wider scope than just
NOWAIT getdents machinery. We'll have this discussion about NOWAIT
timestamp updates when a RFC is proposed to address the wider
problem of how timestamp updates should behave in NOWAIT context.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
