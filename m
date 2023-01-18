From: Christoph Hellwig <hch@lst.de>
Subject: Re: [Cluster-devel] [PATCH 7/9] gfs2: handle a NULL folio in
 gfs2_jhead_process_page
Date: Wed, 18 Jan 2023 17:42:34 +0100
Message-ID: <20230118164234.GB7584@lst.de>
References: <20230118094329.9553-1-hch@lst.de> <20230118094329.9553-8-hch@lst.de> <Y8gXodKIUneO+XQb@casper.infradead.org> <CAHc6FU7Exz2kr+x7jvK1mi5ENOVCOXruP7qKSdPsyhSwmfMhDA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHc6FU7Exz2kr+x7jvK1mi5ENOVCOXruP7qKSdPsyhSwmfMhDA@mail.gmail.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-nilfs@vger.kernel.org, Hugh Dickins <hughd@google.com>, cluster-devel@redhat.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org

On Wed, Jan 18, 2023 at 05:24:32PM +0100, Andreas Gruenbacher wrote:
> We're actually still holding a reference to the folio from the
> find_or_create_page() in gfs2_find_jhead() here, so we know that
> memory pressure can't push the page out and filemap_get_folio() won't
> return NULL.

Ok, I'll drop this patch.
