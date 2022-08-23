From: David Sterba <dsterba-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v2 0/7] Convert to filemap_get_folios_contig()
Date: Tue, 23 Aug 2022 19:26:42 +0200
Message-ID: <20220823172642.GJ13489@twin.jikos.cz>
References: <20220816175246.42401-1-vishal.moola@gmail.com>
Reply-To: dsterba-AlSwsSmVLrQ@public.gmane.org
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1661275917;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=k0ks80j7Oad7m+qauu8Z4TAZTDJEgaZRum5ZNUCrL30=;
        b=BmFTIqCkILUYsistd/v/t7Wcameutnc6Uh9zOCOf8JiWKdWZ6Ajxyag5Vfq+mAm0hMDRTI
        YfLrlgi4viQHLwp1CtNqoahnMDfvcntiGAJXFEKd/yTEdyuX/9D3Hf3/DCfuzoEV5YTOKG
        GXzFYzN8tLbokoMi4obQN1l0IOuQXg0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1661275917;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=k0ks80j7Oad7m+qauu8Z4TAZTDJEgaZRum5ZNUCrL30=;
        b=VOQyCer4+nqwPdtU2qYRvacNJcaJjDV3YzIpYwxM1zcz/LIgk1uPCD2aN1aIJkgfVtMLaz
        2vIf0jsKUE6wJLAQ==
Content-Disposition: inline
In-Reply-To: <20220816175246.42401-1-vishal.moola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Vishal Moola (Oracle)" <vishal.moola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Aug 16, 2022 at 10:52:39AM -0700, Vishal Moola (Oracle) wrote:
> This patch series replaces find_get_pages_contig() with
> filemap_get_folios_contig(). I've run xfstests on btrfs. I've also
> tested the ramfs changes. I ran some xfstests on nilfs2, and its
> seemingly fine although more testing may be beneficial.
> ---
> 
> v2:
>   - Removed an unused label in nilfs2
> 
> Vishal Moola (Oracle) (7):
>   filemap: Add filemap_get_folios_contig()
>   btrfs: Convert __process_pages_contig() to use
>     filemap_get_folios_contig()
>   btrfs: Convert end_compressed_writeback() to use filemap_get_folios()
>   btrfs: Convert process_page_range() to use filemap_get_folios_contig()
>   nilfs2: Convert nilfs_find_uncommited_extent() to use
>     filemap_get_folios_contig()
>   ramfs: Convert ramfs_nommu_get_unmapped_area() to use
>     filemap_get_folios_contig()
>   filemap: Remove find_get_pages_contig()
> 
>  fs/btrfs/compression.c           | 26 ++++++------
>  fs/btrfs/extent_io.c             | 33 +++++++--------
>  fs/btrfs/subpage.c               |  2 +-
>  fs/btrfs/tests/extent-io-tests.c | 31 +++++++-------

I've tested the whole branch in my fstest setup, no issues found and
did a light review of the code changes, looks ok as well.

How do you want get the patches merged? As it's an API conversion I can
ack it and let it go via the mm tree. So far there are no conflicts with
our btrfs development patches, I assume it'll be a clean merge in the
future too.

>  fs/nilfs2/page.c                 | 39 ++++++++----------
>  fs/ramfs/file-nommu.c            | 50 ++++++++++++----------
>  include/linux/pagemap.h          |  4 +-
>  mm/filemap.c                     | 71 +++++++++++++++++++-------------
>  8 files changed, 134 insertions(+), 122 deletions(-)
> 
> -- 
> 2.36.1
