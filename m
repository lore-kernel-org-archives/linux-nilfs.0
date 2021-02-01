From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 04/17] block: split bio_kmalloc from
	bio_alloc_bioset
Date: Mon, 1 Feb 2021 13:22:04 +0100
Message-ID: <20210201122204.GA22727@lst.de>
References: <20210126145247.1964410-1-hch@lst.de>
	<20210126145247.1964410-5-hch@lst.de>
	<20210130035646.GH308988@casper.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20210130035646.GH308988@casper.infradead.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Matthew Wilcox <willy@infradead.org>
Cc: Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>, Naohiro Aota <naohiro.aota@wdc.com>, linux-nilfs@vger.kernel.org, Chao Yu <chao@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org, David Sterba <dsterba@suse.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, drbd-dev@tron.linbit.com, Jaegeuk Kim <jaegeuk@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, linux-mm@kvack.org, Philipp Reisner <philipp.reisner@linbit.com>, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org

On Sat, Jan 30, 2021 at 03:56:46AM +0000, Matthew Wilcox wrote:
> On Tue, Jan 26, 2021 at 03:52:34PM +0100, Christoph Hellwig wrote:
> > bio_kmalloc shares almost no logic with the bio_set based fast path
> > in bio_alloc_bioset.  Split it into an entirely separate implementation.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  block/bio.c         | 167 ++++++++++++++++++++++----------------------
> >  include/linux/bio.h |   6 +-
> >  2 files changed, 86 insertions(+), 87 deletions(-)
> 
> This patch causes current linux-next to OOM for me when running xfstests
> after about ten minutes.  Haven't looked into why yet, this is just the
> results of a git bisect.

I've run tests on linux-next all weekend and could not reproduce
the issue.  Can you share your .config?
