From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: return an ERR_PTR from __filemap_get_folio v2
Date: Mon, 23 Jan 2023 10:59:45 -0800
Message-ID: <20230123105945.958075d46b0a05ffd545e276@linux-foundation.org>
References: <20230121065755.1140136-1-hch@lst.de>
        <20230121170641.121f4224a0e8304765bb4738@linux-foundation.org>
        <20230122072006.GA3654@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674500386;
        bh=2yFoKdoKKqEamhYFBDRoT6KlUCqYPuttTvyUAJee7i0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PTA9WnWXDRVRH3BYoeH6vvai2HfaIdW2CBrUAdXzNrMN+mQ6RDUPJgRmyTIsDPmZ6
         B3BxtiZviM/Q8578OmBqKx+w5fWGwikIveFpV7Rd57D0slJAyWYh3D1yH/kKio6EbJ
         bcJvq1bWpOCmWp11HPjaAOnEhbqlmyHoUsKLr4Y0=
In-Reply-To: <20230122072006.GA3654-jcswGhMUV9g@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, 22 Jan 2023 08:20:06 +0100 Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:

> On Sat, Jan 21, 2023 at 05:06:41PM -0800, Andrew Morton wrote:
> > This patchset doesn't apply to fs/btrfs/ because linux-next contains
> > this 6+ month-old commit:
> 
> Hmm.  It was literally written against linux-next as of last morning,
> which does not have that commit.

Confused.  According to 
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/fs/btrfs/disk-io.c#n4023

it's there today.  wait_dev_supers() has been foliofied.
