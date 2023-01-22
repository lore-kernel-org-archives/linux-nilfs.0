From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: return an ERR_PTR from __filemap_get_folio v2
Date: Sat, 21 Jan 2023 17:06:41 -0800
Message-ID: <20230121170641.121f4224a0e8304765bb4738@linux-foundation.org>
References: <20230121065755.1140136-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674349602;
        bh=f++QpVWpQpCa5Y2lUzhkXb5vN7dWMnG6EbTBZMDoyqE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K8ITSredLjN6RsWmDw7F2N5WthD7EgH6VTWaz2+ik16Ka/pQziEgWZn04WqCXW071
         r9erU5+Z1B/9XVDshRwPjHKsFWahHPGqUMQB+YcCLd2gj1WLD9x48LlmxmE5voLZAV
         4SleWXBskXm0bHHmpptYnTnhCBrc4uX5NActjowk=
In-Reply-To: <20230121065755.1140136-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, 21 Jan 2023 07:57:48 +0100 Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:

> Hi all,
> 
> __filemap_get_folio and its wrappers can return NULL for three different
> conditions, which in some cases requires the caller to reverse engineer
> the decision making.  This is fixed by returning an ERR_PTR instead of
> NULL and thus transporting the reason for the failure.  But to make
> that work we first need to ensure that no xa_value special case is
> returned and thus return the FGP_ENTRY flag.  It turns out that flag
> is barely used and can usually be deal with in a better way.
> 
> Note that the shmem patches in here are non-trivial and need some
> careful review and testing.

I'll hide for a while, awaiting that review.  Plus...

> Changes since v1:
>  - drop the patches to check for errors in btrfs and gfs2
>  - document the new calling conventions for the wrappers around
>    __filemap_get_folio
>  - rebased against the iomap changes in latest linux-next

This patchset doesn't apply to fs/btrfs/ because linux-next contains
this 6+ month-old commit:

commit 964688b32d9ada55a7fce2e650d85ef24188f73f                
Author:     Matthew Wilcox (Oracle) <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
AuthorDate: Tue May 17 18:03:27 2022 -0400
Commit:     Matthew Wilcox (Oracle) <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
CommitDate: Wed Jun 29 08:51:07 2022 -0400

    btrfs: Use a folio in wait_dev_supers()


Matthew, what's the story here?
