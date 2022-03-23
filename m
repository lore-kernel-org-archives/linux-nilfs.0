From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [dm-devel] [PATCH 01/19] fs: remove mpage_alloc
Date: Wed, 23 Mar 2022 08:43:19 -0700
Message-ID: <20220323154319.GA2268247@roeck-us.net>
Mime-Version: 1.0
Return-path: <xen-devel-bounces@lists.xenproject.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.xenproject.org/mailman/options/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xenproject.org>
List-Help: <mailto:xen-devel-request@lists.xenproject.org?subject=help>
List-Subscribe: <https://lists.xenproject.org/mailman/listinfo/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=subscribe>
Errors-To: xen-devel-bounces@lists.xenproject.org
Sender: "Xen-devel" <xen-devel-bounces@lists.xenproject.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=roeck-us.net; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:Cc:
	To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=lagRXHohghy8kR3woCuBBmkrcJ/jzmeeFU/A5c+1noo=; b=SKVgFgGANbObFf6amjfV24eu+h
	n0xWMkM27kPmvFAgvKcqFv+hfIHThLfoWcRnd1X8xFUcQP3HR13LA4VzmRqW+O6FeAgRVxjx27KSe
	hl2iN+faBt50LA0zMJAn8QRAKthN0v2Vcku3E5ajko0c30LSgmQO+U3vw8gVUULYf32KGgJo+PCIE
	flVfEntmD6Pxj237DGMtNbwdJvCMhuo0fSfOesmqg5BySHh87KeT7TljcegAXg6iNDlRbUWxBpB1P
	33QYer1vvhIIEQ4VhMb6a9eCkP1nCGe/5sBMPEQF8lCzmBRQ54ViRtb5zi3O8POeIPCXsSH7hXR8d
	33EJ51dQ==;
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-nfs@vger.kernel.org, linux-nilfs <linux-nilfs@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>, Philipp Reisner <philipp.reisner@linbit.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.co>, device-mapper development <dm-devel@redhat.com>, "Md . Haris Iqbal" <haris.iqbal@ionos.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, linux-fsdevel@vger.kernel.org, xen-devel@lists.xenproject.org, Andrew Morton <akpm@linux-foundation.org>, ntfs3@lists.linux.dev, Jack Wang <jinpu.wang@ionos.com>, Pavel Begunkov <asml.silence@gmail.com>, drbd-dev@lists.linbit.com

On Wed, Mar 23, 2022 at 07:42:48AM +0100, Christoph Hellwig wrote:
> On Wed, Mar 23, 2022 at 06:38:22AM +0900, Ryusuke Konishi wrote:
> > This looks because the mask of GFP_KERNEL is removed along with
> > the removal of mpage_alloc().
> > 
> 
> > The default value of the gfp flag is set to GFP_HIGHUSER_MOVABLE by
> > inode_init_always().
> > So, __GFP_HIGHMEM hits the gfp warning at bio_alloc() that
> > do_mpage_readpage() calls.
> 
> Yeah.  Let's try this to match the iomap code:
> 
> diff --git a/fs/mpage.c b/fs/mpage.c
> index 9ed1e58e8d70b..d465883edf719 100644
> --- a/fs/mpage.c
> +++ b/fs/mpage.c
> @@ -148,13 +148,11 @@ static struct bio *do_mpage_readpage(struct mpage_readpage_args *args)
>  	int op = REQ_OP_READ;
>  	unsigned nblocks;
>  	unsigned relative_block;
> -	gfp_t gfp;
> +	gfp_t gfp = mapping_gfp_constraint(page->mapping, GFP_KERNEL);
>  
>  	if (args->is_readahead) {
>  		op |= REQ_RAHEAD;
> -		gfp = readahead_gfp_mask(page->mapping);
> -	} else {
> -		gfp = mapping_gfp_constraint(page->mapping, GFP_KERNEL);
> +		gfp |= __GFP_NORETRY | __GFP_NOWARN;
>  	}
>  
>  	if (page_has_buffers(page))

That fixes the problem for me.

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter

