From: Vishal Moola <vishal.moola@gmail.com>
Subject: Re: [PATCH v4 00/23] Convert to
 filemap_get_folios_tag()
Date: Thu, 3 Nov 2022 09:38:48 -0700
Message-ID: <CAOzc2pzFMU-XiGZ9bsp40JkpYVSzQuxs2VXgfw_p9abkj4GrFw@mail.gmail.com>
References: <20221102161031.5820-1-vishal.moola@gmail.com>
 <20221103070807.GX2703033@dread.disaster.area>
Mime-Version: 1.0
Return-path: <cluster-devel-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667493550;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=Kh3PemVjLOMzD+zXkDJxoTeXa2tk+grc1up9htYz3yQ=;
	b=gypOwzOWHSduWhyOXMq1NhaBjACAZ3yflokA37vzTq+oejH+ScTQv96oMTKuHb6k016mMu
	LPoa29047uWhbujIgtrMdlYyOTXOqhJGl20LpIIJd4uZ2jmZd2JvVpKDFGtzSNfEMvTCQ1
	gbTAKYlFP3lIgMN7g6zX3lIaf4kG9fk=
In-Reply-To: <20221103070807.GX2703033@dread.disaster.area>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Chinner <david@fromorbit.com>
Cc: linux-cifs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org

On Thu, Nov 3, 2022 at 12:08 AM Dave Chinner <david@fromorbit.com> wrote:
>
> On Wed, Nov 02, 2022 at 09:10:08AM -0700, Vishal Moola (Oracle) wrote:
> > This patch series replaces find_get_pages_range_tag() with
> > filemap_get_folios_tag(). This also allows the removal of multiple
> > calls to compound_head() throughout.
> > It also makes a good chunk of the straightforward conversions to folios,
> > and takes the opportunity to introduce a function that grabs a folio
> > from the pagecache.
> >
> > F2fs and Ceph have quite a lot of work to be done regarding folios, so
> > for now those patches only have the changes necessary for the removal of
> > find_get_pages_range_tag(), and only support folios of size 1 (which is
> > all they use right now anyways).
> >
> > I've run xfstests on btrfs, ext4, f2fs, and nilfs2, but more testing may be
> > beneficial. The page-writeback and filemap changes implicitly work. Testing
> > and review of the other changes (afs, ceph, cifs, gfs2) would be appreciated.
>
> Same question as last time: have you tested this with multipage
> folios enabled? If you haven't tested XFS, then I'm guessing the
> answer is no, and you haven't fixed the bug I pointed out in
> the write_cache_pages() implementation....
>

I haven't tested the series with multipage folios or XFS.

I don't seem to have gotten your earlier comments, and I
can't seem to find them on the mailing lists. Could you
please send them again so I can take a look?

