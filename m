From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v2 1/9] mm: fix mapping_set_error call in
 me_pagecache_dirty
Date: Thu, 9 Mar 2017 17:06:48 -0700
Message-ID: <20170310000648.GA30285@linux.intel.com>
References: <20170308162934.21989-1-jlayton@redhat.com>
 <20170308162934.21989-2-jlayton@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170308162934.21989-2-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Layton <jlayton@redhat.com>
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org, konishi.ryusuke@lab.ntt.co.jp, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org, ross.zwisler@linux.intel.com, jack@suse.cz, neilb@suse.com, openosd@gmail.com, adilger@dilger.ca, James.Bottomley@HansenPartnership.com

On Wed, Mar 08, 2017 at 11:29:26AM -0500, Jeff Layton wrote:
> The error code should be negative. Since this ends up in the default
> case anyway, this is harmless, but it's less confusing to negate it.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
