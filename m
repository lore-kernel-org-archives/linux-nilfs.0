From: Chao Yu <chao@kernel.org>
Subject: Re: [f2fs-dev] [PATCH 05/10] f2fs: Convert
 f2fs_invalidate_compress_pages() to use filemap_get_folios()
Date: Wed, 15 Jun 2022 16:14:12 +0800
Message-ID: <c4db5f98-6b00-99e6-ecf2-63372f20c516@kernel.org>
References: <20220605193854.2371230-1-willy@infradead.org>
 <20220605193854.2371230-6-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655280856;
        bh=k+3SUrAPzRklM1OSV+O/gZAPfDFx88kiFdDt9TP8wi0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=t5unw6qXFjXOZXP3wCnQaVCCZRKnjr3Y7yDD2CCdvPV0FgCG0ZLsOu91d+vP0jN8z
         fmsHRt4/NdxKkEzsf/E6WIZCC7GTcM6NfrbhS9Dz053s2pzeGosoG4/R//xZBa9aDV
         eFh8WtHkVtDTZ2VE/hmqF/sZ1gr8DjkHI9ZAl5d+elWRdNudKVDbMD2ohPrjCQPuvo
         V4oVDwMuUanM4M3NjQvbKBGCN+3dpLTTVSGBr5OEIvX34y2mvIQT8c9GxIzABbihT9
         bLKhsokce4riUp5mQRw77bqwDdnJ3CEi+CEiZVVeIyEwtpdO+AUGC5cMmTspYWtUqZ
         C8r+3BE454s5A==
Content-Language: en-US
In-Reply-To: <20220605193854.2371230-6-willy@infradead.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-fsdevel@vger.kernel.org
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-mm@kvack.org, linux-ext4@vger.kernel.org

On 2022/6/6 3:38, Matthew Wilcox (Oracle) wrote:
> Convert this function to use folios throughout.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Acked-by: Chao Yu <chao@kernel.org>

Thanks,
