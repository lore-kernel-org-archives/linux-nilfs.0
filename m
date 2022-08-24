From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 5/7] nilfs2: Convert nilfs_find_uncommited_extent() to
 use filemap_get_folios_contig()
Date: Wed, 24 Aug 2022 13:11:17 +0900
Message-ID: <CAKFNMomaxii8r_B3XA4KdkvcD+9Crm=S=0KE-nDa4+qs78E4dQ@mail.gmail.com>
References: <20220824004023.77310-1-vishal.moola@gmail.com> <20220824004023.77310-6-vishal.moola@gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=1SWmPxwQyH5LYZrwY6U9XBorttydo0GXweh3dw5/QKE=;
        b=aB5Gk0PGmxav71TxeXANmr1pPDPghLTSfQ29XJ8LQy6WvkEb8HPfBSqN5qkhPDpuUS
         7RXfKn4IOpvkyiAGIGpUlc8/7FaY0Z2NXa1XkOs9/zXwUfvDusGj+ct52/rKAulJ6Chf
         lONMykmHKfe4ukqG1F/WMOfl3oqYGykOX1fErzqYsP/7D5TU7VkHGULWyaiGY8oKLumW
         mliTpyuj5LrIBwrR10LcRQMn2zqdmDjcqi2PVcDmmBgJghBAwztDCODbjgnpxCS4XT19
         GW9hWN6b5BneomBEXiE7nAjgVSOuT8gq6lIVEeutl71hFIevTTlSS1BwjFdshjZtW/+L
         dL0A==
In-Reply-To: <20220824004023.77310-6-vishal.moola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Vishal Moola (Oracle)" <vishal.moola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Aug 24, 2022 at 9:43 AM Vishal Moola (Oracle)  wrote:
>
> Converted function to use folios throughout. This is in preparation for
> the removal of find_get_pages_contig(). Now also supports large folios.
>
> Also cleaned up an unnecessary if statement - pvec.pages[0]->index > index
> will always evaluate to false, and filemap_get_folios_contig() returns 0 if
> there is no folio found at index.
>
> Signed-off-by: Vishal Moola (Oracle) <vishal.moola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/nilfs2/page.c | 45 ++++++++++++++++++---------------------------
>  1 file changed, 18 insertions(+), 27 deletions(-)

Acked-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Looks good, thank you!


Ryusuke Konishi
