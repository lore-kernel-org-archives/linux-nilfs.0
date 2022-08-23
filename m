From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v2 2/7] btrfs: Convert __process_pages_contig() to use
 filemap_get_folios_contig()
Date: Tue, 23 Aug 2022 22:35:32 +0200
Message-ID: <20220823203532.GR13489@twin.jikos.cz>
References: <20220816175246.42401-1-vishal.moola@gmail.com>
 <20220816175246.42401-3-vishal.moola@gmail.com>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Return-path: <linux-btrfs-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1661287246;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DdhWZRtupwKymZPlWoKVfVdBWFdhpfcO5trqUY+601M=;
        b=BRmkwi7f8aLtNAbn5NZ0kU3yh8UQ8FxzfrE6j/VbH6DERjgIooshPJTCGQOu02ben4BO1y
        gMDH54ssEIMLDLVk/r1YZuxe0xUp8BmuTfv+ytg0m9FKf00qZ4X7ol10fQjq1be8XnNC8U
        LYOTY+mMDKOERnaMXgtGxmRIdzU/hag=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1661287246;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DdhWZRtupwKymZPlWoKVfVdBWFdhpfcO5trqUY+601M=;
        b=6jXmlpJjUHNRG0mZLnNVdVTH8AL6Ryuaj3ha1hVbhQk9gk+2uu9+ov1ZoNDXRQkYlHn3N3
        +5eQE/buclDhuUCA==
Content-Disposition: inline
In-Reply-To: <20220816175246.42401-3-vishal.moola@gmail.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Tue, Aug 16, 2022 at 10:52:41AM -0700, Vishal Moola (Oracle) wrote:
> Convert to use folios throughout. This is in preparation for the removal of
> find_get_pages_contig(). Now also supports large folios.
> 
> Since we may receive more than nr_pages pages, nr_pages may underflow.
> Since nr_pages > 0 is equivalent to index <= end_index, we replaced it
> with this check instead.
> 
> Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>

Acked-by: David Sterba <dsterba@suse.com>
