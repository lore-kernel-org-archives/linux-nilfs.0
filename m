From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 7/9] gfs2: handle a NULL folio in
 gfs2_jhead_process_page
Date: Wed, 18 Jan 2023 16:00:33 +0000
Message-ID: <Y8gXodKIUneO+XQb@casper.infradead.org>
References: <20230118094329.9553-1-hch@lst.de>
 <20230118094329.9553-8-hch@lst.de>
Mime-Version: 1.0
Return-path: <cluster-devel-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1674057653;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=GSOq94AXmVvB2t/Hu5/HVPL9U2Xr3S2Gs4mgbP3Jze4=;
	b=dxLnax5C7VJoRAi2utyOmhrf0egsXDWQQSBaAl6ki09HE4JaMenkXHmUWv3v8Tcwl14vAE
	kuKjkmKUp90PFEqIOpv6jczTGjVGCAvw4WO/5hDoqx8lv25yBWr9xKBX4JBOBm/CKvkuny
	Q15cufmloCdVQivEe/kTzV0pIUOyE2E=
In-Reply-To: <20230118094329.9553-8-hch@lst.de>
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

On Wed, Jan 18, 2023 at 10:43:27AM +0100, Christoph Hellwig wrote:
> filemap_get_folio can return NULL, so exit early for that case.

I'm not sure it can return NULL in this specific case.  As I understand
this code, we're scanning the journal looking for the log head.  We've
just submitted the bio to read this page.  I suppose memory pressure
could theoretically push the page out, but if it does, we're doing the
wrong thing by just returning here; we need to retry reading the page.

Assuming we're not willing to do the work to add that case, I think I'd
rather see the crash in folio_wait_locked() than get data corruption
from failing to find the head of the log.

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/gfs2/lops.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
> index 1902413d5d123e..51d4b610127cdb 100644
> --- a/fs/gfs2/lops.c
> +++ b/fs/gfs2/lops.c
> @@ -472,6 +472,8 @@ static void gfs2_jhead_process_page(struct gfs2_jdesc *jd, unsigned long index,
>  	struct folio *folio;
>  
>  	folio = filemap_get_folio(jd->jd_inode->i_mapping, index);
> +	if (!folio)
> +		return;
>  
>  	folio_wait_locked(folio);
>  	if (folio_test_error(folio))
> -- 
> 2.39.0
> 

