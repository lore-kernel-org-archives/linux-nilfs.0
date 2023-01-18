From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: Re: [PATCH 9/9] mm: return an ERR_PTR from
 __filemap_get_folio
Date: Wed, 18 Jan 2023 21:39:08 +0900
Message-ID: <CAKFNMomcjvUSh-nS1MqptYdiT-1frRsmHgx2mHBBm_588kprrQ@mail.gmail.com>
References: <20230118094329.9553-1-hch@lst.de>
 <20230118094329.9553-10-hch@lst.de>
Mime-Version: 1.0
Return-path: <cluster-devel-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1674045911;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=DJFKWs0jtm8hl4SVQnbbNh8Row9y5eHKj6s/8aaU3Dc=;
	b=DUhtoW5n2th4qivtYIetMf0JIYrhJ5h51BFfwMsRNuNQr6k1bm0anekRzV7dgcS9hzR30W
	EW8lO88mhPoOoV7Yi2Q6Elo6dUdjtta0uufVUH7X2Wlubw9QuRLUREFo7CQ3KjjbXFslxJ
	G8ghCkdtrLmQNJviXV+qfze2bJdkj6c=
In-Reply-To: <20230118094329.9553-10-hch@lst.de>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-nilfs@vger.kernel.org, Hugh Dickins <hughd@google.com>, Matthew Wilcox <willy@infradead.org>, cluster-devel@redhat.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org

On Wed, Jan 18, 2023 at 7:41 PM Christoph Hellwig wrote:
>
> Instead of returning NULL for all errors, distinguish between:
>
>  - no entry found and not asked to allocated (-ENOENT)
>  - failed to allocate memory (-ENOMEM)
>  - would block (-EAGAIN)
>
> so that callers don't have to guess the error based on the passed
> in flags.
>
> Also pass through the error through the direct callers:

> filemap_get_folio, filemap_lock_folio filemap_grab_folio
> and filemap_get_incore_folio.

As for the comments describing the return values of these callers,
isn't it necessary to rewrite the value from NULL in case of errors ?

Regards,
Ryusuke Konishi

