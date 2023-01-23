From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 7/7] mm: return an ERR_PTR from __filemap_get_folio
Date: Mon, 23 Jan 2023 16:44:47 +0100
Message-ID: <20230123154447.GP11562@twin.jikos.cz>
References: <20230121065755.1140136-1-hch@lst.de>
 <20230121065755.1140136-8-hch@lst.de>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1674489029;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sUGIH2I54cp4HbnMiIaY15PfXULieuiQ0sW9X9yG6Sc=;
        b=OPXFoGuJ8BkSymKabi8S/f/rmJEkvx+fgrXVqizmYyDI3KhBbMlUuLj8YQectO2Ngl9/Sf
        oGaVWENU63tAhnkYzTuPgH+u6QSbPi1G42bWVBQW/Fd77EpB2+8rwpOtlrkGfwdjkyAjny
        CVCmqcffKPgt8etMatoZ+dSqDZHYXIU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1674489029;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sUGIH2I54cp4HbnMiIaY15PfXULieuiQ0sW9X9yG6Sc=;
        b=xOcYsz+zrkERuCg65RzTgYDWspE7gLGRBq0M143VodPXwP6GO0FzliKs6WdMBcPvTtIt12
        vGjp9a9wvCEfUZBg==
Content-Disposition: inline
In-Reply-To: <20230121065755.1140136-8-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, cluster-devel@redhat.com, linux-mm@kvack.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nilfs@vger.kernel.org

On Sat, Jan 21, 2023 at 07:57:55AM +0100, Christoph Hellwig wrote:
> Instead of returning NULL for all errors, distinguish between:
> 
>  - no entry found and not asked to allocated (-ENOENT)
>  - failed to allocate memory (-ENOMEM)
>  - would block (-EAGAIN)
> 
> so that callers don't have to guess the error based on the passed
> in flags.
> 
> Also pass through the error through the direct callers:
> filemap_get_folio, filemap_lock_folio filemap_grab_folio
> and filemap_get_incore_folio.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/afs/dir.c             | 10 +++++-----
>  fs/afs/dir_edit.c        |  2 +-
>  fs/afs/write.c           |  4 ++--

For

>  fs/btrfs/disk-io.c       |  2 +-

Acked-by: David Sterba <dsterba@suse.com>
