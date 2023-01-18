From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/9] shmem: remove
 shmem_get_partial_folio
Date: Wed, 18 Jan 2023 17:43:58 +0100
Message-ID: <20230118164358.GD7584@lst.de>
References: <20230118094329.9553-1-hch@lst.de>
 <20230118094329.9553-5-hch@lst.de> <Y8f6sShghKuFim5E@bfoster>
Mime-Version: 1.0
Return-path: <cluster-devel-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1674060253;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=XTcn6EOmvdcaySj22rnAGZTgHq4wvd/ke03TGVcbMbc=;
	b=dI6RKkMRNq1KaN5ttckxEW9uzUAistM3ppfToFoBS5PvXkEMhoslbYm94Fj/GCDgoyRdSA
	A2d9Juow7vo+k+/rn9U0I+sICypuRSjpWXc/fyW5UEShfG/RsOfdgQcDGX+AHKPdJ69evO
	lBK0tZL8SgEaZZnNVqakwdnRTGXlX2o=
In-Reply-To: <Y8f6sShghKuFim5E@bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, linux-nilfs@vger.kernel.org, Hugh Dickins <hughd@google.com>, Matthew Wilcox <willy@infradead.org>, linux-afs@lists.infradead.org, cluster-devel@redhat.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-btrfs@vger.kernel.org

On Wed, Jan 18, 2023 at 08:57:05AM -0500, Brian Foster wrote:
> This all seems reasonable to me at a glance, FWIW, but I am a little
> curious why this wouldn't split up into two changes. I.e., switch this
> over to filemap_get_entry() to minimally remove the FGP_ENTRY dependency
> without a behavior change, then (perhaps after the next patch) introduce
> SGP_FIND in a separate patch. That makes it easier to review and
> potentially undo if it happens to pose a problem in the future. Hm?

The minimal change to filemap_get_entry would require to add the
lock, check mapping and retry loop and thus add a fair amount of
code.  So I looked for ways to avoid that and came up with this
version.  But if there is a strong preference to first open code
the logic and then later consolidate it I could do that.

