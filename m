From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 7/7] mm: return an ERR_PTR from __filemap_get_folio
Date: Sat, 21 Jan 2023 15:28:15 +0100
Message-ID: <20230121142815.GA6786@lst.de>
References: <20230121065755.1140136-8-hch@lst.de> <202301211944.5T9l1RgA-lkp@intel.com>
Mime-Version: 1.0
Return-path: <linux-ext4-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <202301211944.5T9l1RgA-lkp@intel.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: kernel test robot <lkp@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, Linux Memory Management List <linux-mm@kvack.org>, linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, cluster-devel@redhat.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nilfs@vger.kernel.org

On Sat, Jan 21, 2023 at 07:52:54PM +0800, kernel test robot wrote:
> Hi Christoph,
> 
> I love your patch! Perhaps something to improve:

And I don't love all this hugging when something doesn't work.  It feels
passive aggressive.

That being said, in this case the error is becaue the series is against
linux-next, so applying it to mainline won't work.

