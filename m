From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v4 00/73] XArray version 4
Date: Wed, 6 Dec 2017 16:58:29 -0700
Message-ID: <20171206235829.GA28086@linux.intel.com>
References: <20171206004159.3755-1-willy@infradead.org>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171206004159.3755-1-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Rehas Sachdeva <aquannie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Dec 05, 2017 at 04:40:46PM -0800, Matthew Wilcox wrote:
> From: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> 
> I looked through some notes and decided this was version 4 of the XArray.
> Last posted two weeks ago, this version includes a *lot* of changes.
> I'd like to thank Dave Chinner for his feedback, encouragement and
> distracting ideas for improvement, which I'll get to once this is merged.
> 
> Highlights:
>  - Over 2000 words of documentation in patch 8!  And lots more kernel-doc.
>  - The page cache is now fully converted to the XArray.
>  - Many more tests in the test-suite.
> 
> This patch set is not for applying.  0day is still reporting problems,
> and I'd feel bad for eating someone's data.  These patches apply on top
> of a set of prepatory patches which just aren't interesting.  If you
> want to see the patches applied to a tree, I suggest pulling my git tree:
> http://git.infradead.org/users/willy/linux-dax.git/shortlog/refs/heads/xarray-2017-12-04
> I also left out the idr_preload removals.  They're still in the git tree,
> but I'm not looking for feedback on them.

Hey Matthew,

Maybe I missed this from a previous version, but can you explain the
motivation for replacing the radix tree with an xarray?  (I think this should
probably still be part of the cover letter?)  Do we have a performance problem
we need to solve?  A code complexity issue we need to solve?  Something else?

- Ross
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
