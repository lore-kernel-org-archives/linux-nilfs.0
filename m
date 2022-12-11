From: Chao Yu <chao@kernel.org>
Subject: Re: [f2fs-dev] [PATCH v4 16/23] f2fs: Convert f2fs_sync_meta_pages()
 to use filemap_get_folios_tag()
Date: Sun, 11 Dec 2022 14:03:57 +0800
Message-ID: <489f2daa-4559-6c32-71e2-8bab65fb8154@kernel.org>
References: <20221102161031.5820-1-vishal.moola@gmail.com>
 <20221102161031.5820-17-vishal.moola@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <ceph-devel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670738642;
        bh=U9Rhp55xf6rXsF3RAaS6Y+CbURUJS89vuN+H36qlHoI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=gvn7tDTwTp770J0jxxGbJ/eD63c2MIQ371jcBZF6XySVsl5cwc/6/VJo7EmthNzpR
         ox3i1TMBwhRRllHhRuEMj7/Ug14/jRwkSLG9TzG1xFIyrs+jBie1F8LMjwY/9KeJtK
         eIJeshb0ZiuFM2HlcrQabSdC3HRmw7LCtQjh0nG2y2NaUW5CC69gWekQmEFR96jvA+
         W3ZPJEJYx+e3y7DQ4q8N6XLP/qxyzl9WAQoFLBlxikvESbccCCFgAfPRaObz5IC/oX
         VspM7gm8zxvpsnKEKbW6OjUEbeBubLYFyePfm/TrC3WWIJWxybX8d6rAxbBHKq/UQM
         W5JZ+7R9vuEBQ==
Content-Language: en-US
In-Reply-To: <20221102161031.5820-17-vishal.moola@gmail.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: linux-cifs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mm@kvack.org, ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org

On 2022/11/3 0:10, Vishal Moola (Oracle) wrote:
> Convert function to use folios throughout. This is in preparation for the
> removal of find_get_pages_range_tag(). This change removes 5 calls to
> compound_head().
> 
> Initially the function was checking if the previous page index is truly the
> previous page i.e. 1 index behind the current page. To convert to folios and
> maintain this check we need to make the check
> folio->index != prev + folio_nr_pages(previous folio) since we don't know
> how many pages are in a folio.
> 
> At index i == 0 the check is guaranteed to succeed, so to workaround indexing
> bounds we can simply ignore the check for that specific index. This makes the
> initial assignment of prev trivial, so I removed that as well.
> 
> Also modified a comment in commit_checkpoint for consistency.
> 
> Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>

Acked-by: Chao Yu <chao@kernel.org>

Thanks,
