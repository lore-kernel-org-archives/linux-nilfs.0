From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 06/23] btrfs: Convert
 btree_write_cache_pages() to use filemap_get_folio_tag()
Date: Fri, 2 Sep 2022 14:28:35 +0200
Message-ID: <20220902122835.GU13489@twin.jikos.cz>
References: <20220901220138.182896-1-vishal.moola@gmail.com>
 <20220901220138.182896-7-vishal.moola@gmail.com>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:
 Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender:Content-Transfer-Encoding:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=+jpnO5WGU41jzsfLpSuXHy9sFbG9yNfncDVPRsohl2M=; b=Q/opi+9HwSArFj1fEXEpj3+ugj
 sitgWtC2oE+4KLo8RrWntumSZny9+0m3YQhmKx47TsDNDEKkX5J/OLsu3qAtBoLVu5EV2DUGkB6fq
 1eFtJAZPDN/O8908cNMUJhdzQGyp7xuF+SfSxhTf8UCHNzqCBWWTV2Sus8mczItdBiWU=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Reply-To:Message-ID:
 Subject:Cc:To:From:Date:Sender:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=+jpnO5WGU41jzsfLpSuXHy9sFbG9yNfncDVPRsohl2M=; b=TuFt7ZX0LxkkcsjKiY5YTwXjWf
 3NttpCjmfTfsMn6x9SIlNHHP6v0eoSJW61iMjrWa6BDwiwx8l7WiaaEYzSuJUKArfvB0qvdCjcckT
 zLdTpRXsfM3PCmuqe6e1l5BFtD/l+XwcpyMCE+PSRhQuk8hT8bnqL7eXNuob/5JdvRiU=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1662122035;
 h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
 cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=+jpnO5WGU41jzsfLpSuXHy9sFbG9yNfncDVPRsohl2M=;
 b=dKOpAPRGGbiosk2vfP4sbjBaI5m8lQFe+z7FpTyWw9pEnj0bEiWiDPnO1UeKqaZYUVF7GC
 ONk4tq9i9RomYL73tc0i75G+W/Y2WurBqQm1X0ZnNdCyY6+A3tfjQIULxRDW7sVSNHDLVK
 B4nOJyx0osNlSRLidjvyKAcuC+5ig5g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1662122035;
 h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
 cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=+jpnO5WGU41jzsfLpSuXHy9sFbG9yNfncDVPRsohl2M=;
 b=qk0qxrr0n9Qkr7w2j/qhhhqoaKRZLn5cucefTX6b4AiNFX5ESRDBTgsDgN8onErCkEW3tI
 iDveCGWCyj8cdjDQ==
Content-Disposition: inline
In-Reply-To: <20220901220138.182896-7-vishal.moola@gmail.com>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org

On Thu, Sep 01, 2022 at 03:01:21PM -0700, Vishal Moola (Oracle) wrote:
> Converted function to use folios throughout. This is in preparation for
> the removal of find_get_pages_range_tag().
> 
> Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>

Acked-by: David Sterba <dsterba@suse.com>
