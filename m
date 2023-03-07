From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: return an ERR_PTR from __filemap_get_folio v3
Date: Tue, 7 Mar 2023 16:23:50 +0100
Message-ID: <CAHc6FU4G5S+5S+1OdatY3apQvmDcvzOQSPPPQdQZTwMNjSq5tw@mail.gmail.com>
References: <20230307143410.28031-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cluster-devel-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678202847;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=49sjefw2FKulo5Vz5tQGPSxZQZKzbcJ05HQTQwuGmNA=;
	b=jLeRHPeHke0slPpc+64YqKo7nWYShDFUWGR9hmSxmyvLh5o+TVEwX39B8iPy0Ff+VPF8CK
	Db/c99noTgy3DrVgjoIpyLLiNCyHRV4r9/buwsK1FGhKY5zUEZ62DlNLu0fVA2liNtSYnN
	B1cJ8kv+O8Y5zTe8V3IcJFeMKP+c7i0=
In-Reply-To: <20230307143410.28031-1-hch@lst.de>
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
Content-Type: text/plain; charset="windows-1252"
To: Christoph Hellwig <hch@lst.de>
Cc: cluster-devel@redhat.com, linux-nilfs@vger.kernel.org, Hugh Dickins <hughd@google.com>, Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org

On Tue, Mar 7, 2023 at 4:07=E2=80=AFPM Christoph Hellwig <hch@lst.de> wrote=
:
> __filemap_get_folio and its wrappers can return NULL for three different
> conditions, which in some cases requires the caller to reverse engineer
> the decision making.  This is fixed by returning an ERR_PTR instead of
> NULL and thus transporting the reason for the failure.  But to make
> that work we first need to ensure that no xa_value special case is
> returned and thus return the FGP_ENTRY flag.  It turns out that flag
> is barely used and can usually be deal with in a better way.

Thanks for working on this cleanup; looking good at a first glance.

Andreas

