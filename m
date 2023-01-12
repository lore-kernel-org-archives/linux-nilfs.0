From: Chao Yu <chao@kernel.org>
Subject: Re: [f2fs-dev] [PATCH v5 14/23] f2fs: Convert
 f2fs_write_cache_pages() to use filemap_get_folios_tag()
Date: Thu, 12 Jan 2023 18:17:54 +0800
Message-ID: <9481a114-04d3-7276-bc82-ee18c685b5a6@kernel.org>
References: <20230104211448.4804-1-vishal.moola@gmail.com>
 <20230104211448.4804-15-vishal.moola@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cluster-devel-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1673518690;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=WIWPZIKq2KjEJ51tFDiaRs+SDZBMmPeDICQjCFzQKiU=;
	b=dIxx7vKs6skhWRkSP3MN6ABqjli1ZG9Lyege6myM1yyK/OM7Tn1td/uO6W69u+CIb/iSx4
	PFjUVtMlHhaxwKP/2echwFJSb4tUfBmf7g7p+npSpP8fmbaP89QqN6PkLLYIYXMJkgeH4o
	mWASZO1KdYT5qp2De7GEFZxl9xBEKeA=
In-Reply-To: <20230104211448.4804-15-vishal.moola@gmail.com>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/cluster-devel>, 
 <mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/cluster-devel/>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/cluster-devel>,
 <mailto:cluster-devel-request@redhat.com?subject=subscribe>
Errors-To: cluster-devel-bounces@redhat.com
Sender: "Cluster-devel" <cluster-devel-bounces@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: linux-cifs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mm@kvack.org, ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org

On 2023/1/5 5:14, Vishal Moola (Oracle) wrote:
> Converted the function to use a folio_batch instead of pagevec. This is in
> preparation for the removal of find_get_pages_range_tag().
> 
> Also modified f2fs_all_cluster_page_ready to take in a folio_batch instead
> of pagevec. This does NOT support large folios. The function currently
> only utilizes folios of size 1 so this shouldn't cause any issues right
> now.
> 
> This version of the patch limits the number of pages fetched to
> F2FS_ONSTACK_PAGES. If that ever happens, update the start index here
> since filemap_get_folios_tag() updates the index to be after the last
> found folio, not necessarily the last used page.
> 
> Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>

Acked-by: Chao Yu <chao@kernel.org>

Thanks,

