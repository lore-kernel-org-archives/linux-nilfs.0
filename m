From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v2 2/9] mm: drop "wait" parameter from write_one_page
Date: Thu, 9 Mar 2017 17:07:07 -0700
Message-ID: <20170310000707.GB30285@linux.intel.com>
References: <20170308162934.21989-1-jlayton@redhat.com>
 <20170308162934.21989-3-jlayton@redhat.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20170308162934.21989-3-jlayton@redhat.com>
Sender: owner-linux-mm@kvack.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Layton <jlayton@redhat.com>
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org, konishi.ryusuke@lab.ntt.co.jp, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org, ross.zwisler@linux.intel.com, jack@suse.cz, neilb@suse.com, openosd@gmail.com, adilger@dilger.ca, James.Bottomley@HansenPartnership.com

On Wed, Mar 08, 2017 at 11:29:27AM -0500, Jeff Layton wrote:
> The callers all set it to 1. Also, make it clear that this function will
> not set any sort of AS_* error, and that the caller must do so if
> necessary. No existing caller uses this on normal files, so none of them
> need it.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
