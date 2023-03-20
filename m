From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/7] shmem: remove
 shmem_get_partial_folio
Date: Mon, 20 Mar 2023 14:58:38 +0100
Message-ID: <20230320135838.GA16060@lst.de>
References: <20230307143410.28031-1-hch@lst.de>
 <20230307143410.28031-5-hch@lst.de>
 <9d1aaa4-1337-fb81-6f37-74ebc96f9ef@google.com>
Mime-Version: 1.0
Return-path: <cluster-devel-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679320730;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=9JxuoOXrvBv5R9PUz9wzS/XDpwFhofIR6FWa7Esn6zM=;
	b=Bdmi2I3RYNV83dQy4Q1Um3VCRimEpYAzH5GRQQMMLr1fXMiE4rRHVf4gh3dObWaebTggJs
	XQvmor+Er2hYxjxSNdCMLmgiGcoVm4KtuvG8XUH03TJxfR7nxabKbOaQ2sQRs6eyt+mjGi
	utf52fOi6xRMxpYPx+zvCoHr21UYt8M=
In-Reply-To: <9d1aaa4-1337-fb81-6f37-74ebc96f9ef@google.com>
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
To: Hugh Dickins <hughd@google.com>
Cc: linux-xfs@vger.kernel.org, linux-nilfs@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, linux-afs@lists.infradead.org, cluster-devel@redhat.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-btrfs@vger.kernel.org

On Sun, Mar 19, 2023 at 10:19:21PM -0700, Hugh Dickins wrote:
> I thought this was fine at first, and of course it's good for all the
> usual cases; but not for shmem_get_partial_folio()'s awkward cases.
> 
> Two issues with it.
> 
> One, as you highlight above, the possibility of reading more swap
> unnecessarily.  I do not mind if partial truncation entails reading
> a little unnecessary swap; but I don't like the common case of
> truncation to 0 to entail that; even less eviction; even less
> unmounting, when eviction of all risks reading lots of swap.
> The old code behaved well at i_size 0, the new code not so much.

True.  We could restore that by doing the i_size check for SGP_FIND,
though.

> Replacing shmem_get_partial_folio() by SGP_FIND was a good direction
> to try, but it hasn't worked out.  I tried to get SGPs to work right
> for it before, when shmem_get_partial_page() was introduced; but I
> did not manage to do so.  I think we have to go back to how this was.

Hmm, would be sad to lose this entirely.  One thing I though about
but didn't manage to do, is to rework how the SGP_* flags works.
Right now they are used as en enum, and we actually do numerical
comparisms on them, which is highly confusing.  To be it seems like
having actual flags that can be combined and have useful names
would seem much better.  But I did run out patience for finding good
names and figuring out what would be granular enough behavior
for such flags.

e.g. one would be for limiting to i_size, one for allocating new
folios if none was found, etc.

