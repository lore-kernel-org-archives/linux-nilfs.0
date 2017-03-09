From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/3] mm/fs: get PG_error out of the writeback reporting
 business
Date: Thu, 9 Mar 2017 09:21:37 -0500
Message-ID: <20170309142137.lz7cba4was3jfyyt@thunk.org>
References: <20170305133535.6516-1-jlayton@redhat.com>
 <1488724854.2925.6.camel@redhat.com>
 <20170306230801.GA28111@linux.intel.com>
 <20170307102622.GB2578@quack2.suse.cz>
 <20170309025725.5wrszri462zipiix@thunk.org>
 <20170309090449.GD15874@quack2.suse.cz>
 <1489056471.2791.2.camel@redhat.com>
 <20170309110225.GF15874@quack2.suse.cz>
 <1489063392.2791.8.camel@redhat.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=thunk.org; s=ef5046eb;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=bGYulTVb+yZUtHu2rGEFXbx3QGqO/ekmZonhFkI48UE=;
	b=N4nSvRVyf1tds37dU6wWMaF+7P3i//2aLuMhAnEbnwVi20axaKADKe3WA9j8kL7ms3BeomMeVXG5swG5xoO3VwYzci9NKdUEl6z/51IuHxat799Dm5y+fUXA4cGmbbK2nc3E33qWArkNBLHb0kbxJ0/aU1cZeLA1E40TheDVsHQ=;
Content-Disposition: inline
In-Reply-To: <1489063392.2791.8.camel@redhat.com>
Sender: owner-linux-mm@kvack.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Layton <jlayton@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Ross Zwisler <ross.zwisler@linux.intel.com>, viro@zeniv.linux.org.uk, konishi.ryusuke@lab.ntt.co.jp, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org, NeilBrown <neilb@suse.com>

On Thu, Mar 09, 2017 at 07:43:12AM -0500, Jeff Layton wrote:
> 
> Maybe we need a systemwide (or fs-level) tunable that makes ENOSPC a
> transient error? Just have it hang until we get enough space when that
> tunable is enabled?

Or maybe we need a new kernel-internal errno (ala ERESTARSYS) which
means it's a "soft ENOSPC"?  It would get translated to ENOSPC if it
gets propagated to userspace, but that way for devices like dm-thin or
other storage array with thin volumes, it could send back a soft
ENOSPC, while for file systems where "ENOSPC means ENOSPC", we can
treat those as a hard ENOSPC.

						- Ted

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
