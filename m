From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 11/26] nilfs2: Convert nilfs_copy_page() to
 nilfs_copy_folio()
Date: Tue, 19 Sep 2023 14:06:37 +0100
Message-ID: <ZQmc3VHOIh3jOG8Z@casper.infradead.org>
References: <20230919045135.3635437-1-willy@infradead.org>
 <20230919045135.3635437-12-willy@infradead.org>
 <CAKFNMonjfsWBageg6vfWok9vvNEzjhXiqCCb+=cDFuwnTER95A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vG4Tzf8kO0LcYLw+cZi1qYlZspJjy+O6YTZUkpkEyuI=; b=CIE0ya6ucqYQAvryNkDuSTAm9k
        NPgkr3zmhN8Hban2XWHPThsg9/nlIp/ZAtOQIz4Fvp5UOCY8y8q3jv0twkC/5m8C3icPQZxCaFhuw
        aYuHM8P8bwzXylhGBHqoh48NXEt3+0zyDlDxbZq4vJTH1AWpS+0PiivpHN5lyNtpkL1ib7zU/Q6kj
        khYJAPWBVNSzhlkoZlqQwpyBYZwRtybWua479pBO6mACsk43W5DcjN1kPcpusDM956b0LAMqnQYc9
        nm3C4rann0EzGNbm9waRDU9NV/S7jfcHa1zapYylXuZQ5YxiU3iI23KOQowBjNVLjVQFKhaVCPTjj
        oXJZFWfA==;
Content-Disposition: inline
In-Reply-To: <CAKFNMonjfsWBageg6vfWok9vvNEzjhXiqCCb+=cDFuwnTER95A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gfs2-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ntfs-dev-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, ntfs3-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, ocfs2-devel-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, reiserfs-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pankaj Raghav <p.raghav-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>

On Tue, Sep 19, 2023 at 10:01:27PM +0900, Ryusuke Konishi wrote:
> When I tried to test the patchset against 6.6-rc2, I encountered the
> following error during the build:
> 
>  ERROR: modpost: "folio_copy" [fs/nilfs2/nilfs2.ko] undefined!
> 
> It looks like "folio_copy" is not exported to modules.
> 
> I'll correct this manually for now and proceed with the review and
> testing, but could you please fix this build issue in some way ?

Thanks!  I'll export the symbol.  I did build nilfs2 as a module, but I
just did it with "make fs/" which doesn't run modpost.  Appreciate the
testing.
