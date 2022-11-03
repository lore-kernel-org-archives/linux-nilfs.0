From: Vishal Moola <vishal.moola@gmail.com>
Subject: Re: [PATCH 00/23] Convert to filemap_get_folios_tag()
Date: Thu, 3 Nov 2022 14:59:54 -0700
Message-ID: <Y2Q52uQGoqGM4o9m@fedora>
References: <20220901220138.182896-1-vishal.moola@gmail.com>
 <20221018214544.GI2703033@dread.disaster.area>
Mime-Version: 1.0
Return-path: <linux-btrfs-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BXMtoJhRlFWaQLcxjEM+qd1+6PF53F0Hz+I5xM4y+wc=;
        b=LSzE9TH+osvipk73Jg9gpor1ZQe37FTuPrWQ5VUxQIsLQ//7XAFuJQM1KyFIXYAxqx
         BE4yzuk+xifeQgNpMYonk3DPgvpHS7XYbgoNdLomm2aKEkQCHaH0Bc7mrZFzL+9j5ZSy
         b9DDF8m1+3bfZ9iV0lucJ1MqhbByVhp5MZXMvkd4dpduipcwth1ZiKn90EGRhJ8R9r+m
         EJ4boWxUG+nQ4ooKm3DZioH6mkJd/Le4V3cgspEcIdaCLQDHg98SssmSluKeW2l4jPay
         g1Az1Lvo9oZjC2k1yTkOvtryQxynTaEzmqQoj8oo4NJhMXBQYq056FnhoGgEMPlBjEct
         OTAA==
Content-Disposition: inline
In-Reply-To: <20221018214544.GI2703033@dread.disaster.area>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-nilfs@vger.kernel.org, linux-mm@kvack.org, David Howells <dhowells@redhat.com>

On Wed, Oct 19, 2022 at 08:45:44AM +1100, Dave Chinner wrote:
> On Thu, Sep 01, 2022 at 03:01:15PM -0700, Vishal Moola (Oracle) wrote:
> > This patch series replaces find_get_pages_range_tag() with
> > filemap_get_folios_tag(). This also allows the removal of multiple
> > calls to compound_head() throughout.
> > It also makes a good chunk of the straightforward conversions to folios,
> > and takes the opportunity to introduce a function that grabs a folio
> > from the pagecache.
> > 
> > F2fs and Ceph have quite alot of work to be done regarding folios, so
> > for now those patches only have the changes necessary for the removal of
> > find_get_pages_range_tag(), and only support folios of size 1 (which is
> > all they use right now anyways).
> > 
> > I've run xfstests on btrfs, ext4, f2fs, and nilfs2, but more testing may be
> > beneficial.
> 
> Well, that answers my question about how filesystems that enable
> multi-page folios were tested: they weren't. 
> 
> I'd suggest that anyone working on further extending the
> filemap/folio infrastructure really needs to be testing XFS as a
> first priority, and then other filesystems as a secondary concern.
> 
> That's because XFS (via the fs/iomap infrastructure) is one of only
> 3 filesystems in the kernel (AFS and tmpfs are the others) that
> interact with the page cache and page cache "pages" solely via folio
> interfaces. As such they are able to support multi-page folios in
> the page cache. All of the tested filesystems still use the fixed
> PAGE_SIZE page interfaces to interact with the page cache, so they
> don't actually exercise interactions with multi-page folios at all.
> 

Thanks for the explanation! That makes perfect sense. I wholeheartedly
agree, and I'll be sure to test any future changes on XFS to try to
ensure multi-page folio functionality. 

I know David ran tests on AFS, so hopefully those hit multipage folios
well enough. But I'm not sure whether it was just for the AFS patch or
with the whole series applied. Regardless I'll run my own set of tests
on XFS and see if I run into any issues as well.
