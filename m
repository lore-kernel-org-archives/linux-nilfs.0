From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v2 5/9] dax: set error in mapping when writeback fails
Date: Thu, 9 Mar 2017 17:21:06 -0700
Message-ID: <20170310002106.GD30285@linux.intel.com>
References: <20170308162934.21989-1-jlayton@redhat.com>
 <20170308162934.21989-6-jlayton@redhat.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20170308162934.21989-6-jlayton@redhat.com>
Sender: owner-linux-mm@kvack.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Layton <jlayton@redhat.com>
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org, konishi.ryusuke@lab.ntt.co.jp, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org, ross.zwisler@linux.intel.com, jack@suse.cz, neilb@suse.com, openosd@gmail.com, adilger@dilger.ca, James.Bottomley@HansenPartnership.com

On Wed, Mar 08, 2017 at 11:29:30AM -0500, Jeff Layton wrote:
> In order to get proper error codes from fsync, we must set an error in
> the mapping range when writeback fails.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>

Yep, paired with the changes to filmap_write_and_wait() and
filemap_write_and_wait_range(), this seems fine.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
