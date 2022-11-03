From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 00/23] Convert to filemap_get_folios_tag()
Date: Fri, 4 Nov 2022 07:47:19 +1100
Message-ID: <20221103204719.GY2703033@dread.disaster.area>
References: <20221102161031.5820-1-vishal.moola@gmail.com>
 <20221103070807.GX2703033@dread.disaster.area>
 <CAOzc2pzFMU-XiGZ9bsp40JkpYVSzQuxs2VXgfw_p9abkj4GrFw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-ext4-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MxS/4UcS9QV06TA42jz+n7cPJ0B1Da1lpvr3ubjc6GY=;
        b=cuP5UtrVPLmPkgDyIU7nXUWip6wPNwEQX83eaiYzuSaa/NwaBOHxdiCCYvHyd3mrWb
         UX4IYw78zXIF0mMu0R7qDreIqrr7PvviOTacDCidW9f3UUssGYk9RosDNLvY+hm88Tz8
         hEooCKFouHczA6F3wBjXPLYrpYIszUEwnYnlDxkOvhuNi8oE//fz5w1SOEhhUUoWt77E
         pAHn5L/ZZzWw3HkpcasZr6hnf6O/XMcGhjxvLwJ33vohngsJ1KBKVvIfn+XAYIa1YRVX
         Vkpw4CNDgLSlpQfjW7+15/HKqs/xOt8+2WdHOo1jGBPReCKhIlOzYbvvyYROh/eydkAD
         rc0Q==
Content-Disposition: inline
In-Reply-To: <CAOzc2pzFMU-XiGZ9bsp40JkpYVSzQuxs2VXgfw_p9abkj4GrFw@mail.gmail.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vishal Moola <vishal.moola@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-nilfs@vger.kernel.org, linux-mm@kvack.org

On Thu, Nov 03, 2022 at 09:38:48AM -0700, Vishal Moola wrote:
> On Thu, Nov 3, 2022 at 12:08 AM Dave Chinner <david@fromorbit.com> wrote:
> >
> > On Wed, Nov 02, 2022 at 09:10:08AM -0700, Vishal Moola (Oracle) wrote:
> > > This patch series replaces find_get_pages_range_tag() with
> > > filemap_get_folios_tag(). This also allows the removal of multiple
> > > calls to compound_head() throughout.
> > > It also makes a good chunk of the straightforward conversions to folios,
> > > and takes the opportunity to introduce a function that grabs a folio
> > > from the pagecache.
> > >
> > > F2fs and Ceph have quite a lot of work to be done regarding folios, so
> > > for now those patches only have the changes necessary for the removal of
> > > find_get_pages_range_tag(), and only support folios of size 1 (which is
> > > all they use right now anyways).
> > >
> > > I've run xfstests on btrfs, ext4, f2fs, and nilfs2, but more testing may be
> > > beneficial. The page-writeback and filemap changes implicitly work. Testing
> > > and review of the other changes (afs, ceph, cifs, gfs2) would be appreciated.
> >
> > Same question as last time: have you tested this with multipage
> > folios enabled? If you haven't tested XFS, then I'm guessing the
> > answer is no, and you haven't fixed the bug I pointed out in
> > the write_cache_pages() implementation....
> >
> 
> I haven't tested the series with multipage folios or XFS.
> 
> I don't seem to have gotten your earlier comments, and I
> can't seem to find them on the mailing lists. Could you
> please send them again so I can take a look?

They are in the lore -fsdevel archive - no idea why you couldn't
find them....

https://lore.kernel.org/linux-fsdevel/20221018210152.GH2703033@dread.disaster.area/
https://lore.kernel.org/linux-fsdevel/20221018214544.GI2703033@dread.disaster.area/

-Dave.
-- 
Dave Chinner
david@fromorbit.com
