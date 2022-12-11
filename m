From: Chao Yu <chao@kernel.org>
Subject: Re: [f2fs-dev] [PATCH v4 15/23] f2fs: Convert last_fsync_dnode() to
 use filemap_get_folios_tag()
Date: Sun, 11 Dec 2022 13:54:49 +0800
Message-ID: <38c34b59-bf57-4eb8-b74b-8b387b792cb8@kernel.org>
References: <20221102161031.5820-1-vishal.moola@gmail.com>
 <20221102161031.5820-16-vishal.moola@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670738094;
        bh=1FZSvg1VV5fd0X4IXRQ/3Im/8nHJEAEA/6Sohp7gUlQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=uAyt4p6s8439vGHDMi+wDqrs/UBniW407/oGUr/VlX4oqYU3iycP0srZfI3sWJrAk
         oofuNsR7Elnf0oZ8BKt0dS8axjhtZvJ0j6tiES7ahWt8kev9t3inWkARx2/K9nG7cI
         k6FKY9tE8hDPlm49a8f0N4xqTeHWaPvHHYzjzjelrk8tw1BRP0HcAY7IfZQqjqjOx5
         NqFxpgU19OcEQb5mNonszOHGo3VC3rR1Z5N6Mkl35bDxXd3J+6JjocaYz71guctbAq
         fWZGh8HuNf8SsH1AjBSLmBvZRFHFPCOiOsvCp82IrSyo8IkRQpwaC4Usy+UVYMCA/E
         BZsWe7ADG/bzw==
Content-Language: en-US
In-Reply-To: <20221102161031.5820-16-vishal.moola@gmail.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: linux-cifs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mm@kvack.org, ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org

On 2022/11/3 0:10, Vishal Moola (Oracle) wrote:
> Convert to use a folio_batch instead of pagevec. This is in preparation for
> the removal of find_get_pages_range_tag().
> 
> Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>

Acked-by: Chao Yu <chao@kernel.org>

Thanks,
