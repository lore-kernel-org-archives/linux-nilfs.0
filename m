From: Vishal Moola <vishal.moola@gmail.com>
Subject: Re: [PATCH v3 11/23] f2fs: Convert
 f2fs_fsync_node_pages() to use filemap_get_folios_tag()
Date: Mon, 24 Oct 2022 12:31:10 -0700
Message-ID: <CAOzc2pwKoyy4i4zBKhvoKmN8cezUxjDhjYZnK9GLcJniQVPoGA@mail.gmail.com>
References: <20221017202451.4951-1-vishal.moola@gmail.com>
 <20221017202451.4951-12-vishal.moola@gmail.com>
Mime-Version: 1.0
Return-path: <cluster-devel-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666639890;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=ewURVtEZDzlu0i+gVIVlIwdo2AKdKjYywGZcJK82PeY=;
	b=hOKTKEAQhuXdPw7W1FGz9m+WSimVBAqubkJuo9E11/eXEEkQmQ133bTXS7UILXzMqg9TQ6
	Ty1iDFRK75d/7XKi9SidTiwZlzCVS7zCdnISLYwjtaDNVW9Hkye2gNZWeMMez4Oql6cH6K
	CX9ZFfmVVrqhDWDr+4/AbMuMcWPhWz8=
In-Reply-To: <20221017202451.4951-12-vishal.moola@gmail.com>
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
To: linux-fsdevel@vger.kernel.org
Cc: linux-cifs@vger.kernel.org, linux-nilfs@vger.kernel.org, chao@kernel.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mm@kvack.org, jaegeuk@kernel.org, ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org

On Mon, Oct 17, 2022 at 1:25 PM Vishal Moola (Oracle)
<vishal.moola@gmail.com> wrote:
>
> Convert function to use a folio_batch instead of pagevec. This is in
> preparation for the removal of find_get_pages_range_tag().
>
> Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> ---
>  fs/f2fs/node.c | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
>
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index 983572f23896..e8b72336c096 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -1728,12 +1728,12 @@ int f2fs_fsync_node_pages(struct f2fs_sb_info *sbi, struct inode *inode,
>                         unsigned int *seq_id)
>  {
>         pgoff_t index;
> -       struct pagevec pvec;
> +       struct folio_batch fbatch;
>         int ret = 0;
>         struct page *last_page = NULL;
>         bool marked = false;
>         nid_t ino = inode->i_ino;
> -       int nr_pages;
> +       int nr_folios;
>         int nwritten = 0;
>
>         if (atomic) {
> @@ -1742,20 +1742,21 @@ int f2fs_fsync_node_pages(struct f2fs_sb_info *sbi, struct inode *inode,
>                         return PTR_ERR_OR_ZERO(last_page);
>         }
>  retry:
> -       pagevec_init(&pvec);
> +       folio_batch_init(&fbatch);
>         index = 0;
>
> -       while ((nr_pages = pagevec_lookup_tag(&pvec, NODE_MAPPING(sbi), &index,
> -                               PAGECACHE_TAG_DIRTY))) {
> +       while ((nr_folios = filemap_get_folios_tag(NODE_MAPPING(sbi), &index,
> +                                       (pgoff_t)-1, PAGECACHE_TAG_DIRTY,
> +                                       &fbatch))) {
>                 int i;
>
> -               for (i = 0; i < nr_pages; i++) {
> -                       struct page *page = pvec.pages[i];
> +               for (i = 0; i < nr_folios; i++) {
> +                       struct page *page = &fbatch.folios[i]->page;
>                         bool submitted = false;
>
>                         if (unlikely(f2fs_cp_error(sbi))) {
>                                 f2fs_put_page(last_page, 0);
> -                               pagevec_release(&pvec);
> +                               folio_batch_release(&fbatch);
>                                 ret = -EIO;
>                                 goto out;
>                         }
> @@ -1821,7 +1822,7 @@ int f2fs_fsync_node_pages(struct f2fs_sb_info *sbi, struct inode *inode,
>                                 break;
>                         }
>                 }
> -               pagevec_release(&pvec);
> +               folio_batch_release(&fbatch);
>                 cond_resched();
>
>                 if (ret || marked)
> --
> 2.36.1
>

Following up on these f2fs patches (11/23, 12/23, 13/23, 14/23, 15/23,
16/23). Does anyone have time to review them this week?

