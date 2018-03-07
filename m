From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v8 06/63] btrfs: Use filemap_range_has_page()
Date: Wed, 7 Mar 2018 15:17:20 +0100
Message-ID: <20180307141720.GA23693@twin.jikos.cz>
References: <20180306192413.5499-1-willy@infradead.org>
 <20180306192413.5499-7-willy@infradead.org>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180306192413.5499-7-willy@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org

On Tue, Mar 06, 2018 at 11:23:16AM -0800, Matthew Wilcox wrote:
> From: Matthew Wilcox <mawilcox@microsoft.com>
> 
> The current implementation of btrfs_page_exists_in_range() gives the
> wrong answer if the workingset code has stored a shadow entry in the
> page cache.  The filemap_range_has_page() function does not have this
> problem, and it's shared code, so use it instead.

I'm going to merge this patch. btrfs_page_exists_in_range was full of
bugs from the beginning so I'm more than happy to use the shared one.
Thanks.
