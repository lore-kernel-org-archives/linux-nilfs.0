From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/23] Convert to
 filemap_get_folios_tag()
Date: Wed, 19 Oct 2022 08:45:44 +1100
Message-ID: <20221018214544.GI2703033@dread.disaster.area>
References: <20220901220138.182896-1-vishal.moola@gmail.com>
Mime-Version: 1.0
Return-path: <cluster-devel-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666129561;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=rdhpXUGCkMu8VcqIxNAyDKuYCRrF5O3PB114YzTZo88=;
	b=Ctm7+ZVHsZtY7JYwxOOsMHy/XHYPWjq/P0lCsdjeru8VrMRUaT+0GYaeQD5ROhawa4l82s
	KY2MCkpdhMUF06SVsuZ0ItuoYOfkz0LlzDHpDv7+T7gKfcU7+H+UXNRP4oEd3mrEcEFNjJ
	q0XSrQx1rzUfPYxLuDVotItTI9FsgbY=
In-Reply-To: <20220901220138.182896-1-vishal.moola@gmail.com>
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org

On Thu, Sep 01, 2022 at 03:01:15PM -0700, Vishal Moola (Oracle) wrote:
> This patch series replaces find_get_pages_range_tag() with
> filemap_get_folios_tag(). This also allows the removal of multiple
> calls to compound_head() throughout.
> It also makes a good chunk of the straightforward conversions to folios,
> and takes the opportunity to introduce a function that grabs a folio
> from the pagecache.
> 
> F2fs and Ceph have quite alot of work to be done regarding folios, so
> for now those patches only have the changes necessary for the removal of
> find_get_pages_range_tag(), and only support folios of size 1 (which is
> all they use right now anyways).
> 
> I've run xfstests on btrfs, ext4, f2fs, and nilfs2, but more testing may be
> beneficial.

Well, that answers my question about how filesystems that enable
multi-page folios were tested: they weren't. 

I'd suggest that anyone working on further extending the
filemap/folio infrastructure really needs to be testing XFS as a
first priority, and then other filesystems as a secondary concern.

That's because XFS (via the fs/iomap infrastructure) is one of only
3 filesystems in the kernel (AFS and tmpfs are the others) that
interact with the page cache and page cache "pages" solely via folio
interfaces. As such they are able to support multi-page folios in
the page cache. All of the tested filesystems still use the fixed
PAGE_SIZE page interfaces to interact with the page cache, so they
don't actually exercise interactions with multi-page folios at all.

Hence if you are converting generic infrastructure that looks up
pages in the page cache to look up folios in the page cache, the
code that processes the returned folios also needs to be updated and
validated to ensure that it correctly handles multi-page folios. And
the only way you can do that fully at this point in time is via
testing XFS or AFS...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

