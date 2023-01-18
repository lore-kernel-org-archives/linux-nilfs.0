From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 2/9] mm: make mapping_get_entry
 available outside of filemap.c
Date: Wed, 18 Jan 2023 13:49:13 +0000
Message-ID: <Y8f42T6Bd9RdT06O@casper.infradead.org>
References: <20230118094329.9553-1-hch@lst.de>
 <20230118094329.9553-3-hch@lst.de>
Mime-Version: 1.0
Return-path: <cluster-devel-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1674049787;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=ETxjjLavmaOPEk6TMO4SM/B8zpeLHudHeOG1qhddvao=;
	b=S/evgehB41lwrU6gMnhkLtDQRcIXVLVzuEvGZAfSuxsnFopZcE78HMmJ/rN29ONryMa14T
	DW/kfu1y3q9k9T/xPJtB2Ze2MRjZb3lTTo+ihB3o0j5kW88UjAPVDZSBP5z1we74BR6vWU
	iyemJ/6waWd2vZWmSvkGRcgDLVOJKP8=
In-Reply-To: <20230118094329.9553-3-hch@lst.de>
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-nilfs@vger.kernel.org, Hugh Dickins <hughd@google.com>, cluster-devel@redhat.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org

On Wed, Jan 18, 2023 at 10:43:22AM +0100, Christoph Hellwig wrote:
> mapping_get_entry is useful for page cache API users that need to know
> about xa_value internals.  Rename it and make it available in pagemap.h.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

