From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH v4 00/73] XArray version 4
Date: Wed, 6 Dec 2017 13:17:52 +1100
Message-ID: <20171206021752.GC4094@dastard>
References: <20171206004159.3755-1-willy@infradead.org>
 <20171206014536.GA4094@dastard>
 <20171206015108.GB4094@dastard>
 <MWHPR21MB0845A83B9E89E4A9499AEC2FCB320@MWHPR21MB0845.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <MWHPR21MB0845A83B9E89E4A9499AEC2FCB320-saRRjQKJ25M5MZvj1DUCAM1VXTxX1y3OvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Rehas Sachdeva <aquannie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Dec 06, 2017 at 01:53:41AM +0000, Matthew Wilcox wrote:
> Huh, you've caught a couple of problems that 0day hasn't sent me yet.  Tr=
y turning on DAX or TRANSPARENT_HUGEPAGE.  Thanks!

Dax is turned on, CONFIG_TRANSPARENT_HUGEPAGE is not.

Looks like nothing is setting CONFIG_RADIX_TREE_MULTIORDER, which is
what xas_set_order() is hidden under.

Ah, CONFIG_ZONE_DEVICE turns it on, not CONFIG_DAX/CONFIG_FS_DAX.

Hmmmm.  That seems wrong if it's used in fs/dax.c...

$ grep DAX .config
CONFIG_DAX=3Dy
CONFIG_FS_DAX=3Dy
$ grep ZONE_DEVICE .config
CONFIG_ARCH_HAS_ZONE_DEVICE=3Dy
$

So I have DAX enabled, but not ZONE_DEVICE? Shouldn't DAX be
selecting ZONE_DEVICE, not relying on a user to select both of them
so that stuff works properly? Hmmm - there's no menu option to turn
on zone device, so it's selected by something else?  Oh, HMM turns
on ZONE device. But that is "default y", so should be turned on. But
it's not?  And there's no obvious HMM menu config option, either....

What a godawful mess Kconfig has turned into.

I'm just going to enable TRANSPARENT_HUGEPAGE - madness awaits me if
I follow the other path down the rat hole....

Ok, it build this time.

-Dave.

>=20
> > -----Original Message-----
> > From: Dave Chinner [mailto:david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.or=
g]
> > Sent: Tuesday, December 5, 2017 8:51 PM
> > To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> > Cc: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>; =
Ross Zwisler
> > <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>; Jens Axboe <axb=
oe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>; Rehas
> > Sachdeva <aquannie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>; linux-mm-B=
w31MaZKKs3YtjvyW6yDsg@public.gmane.org; linux-
> > fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-f2fs-devel-5NWGO=
frQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org; linux-
> > nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-btrfs-u79uwXL29TY7=
6Z2rM5mHXA@public.gmane.org; linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.=
org;
> > linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-kernel-u79uwXL=
29TY76Z2rM5mHXA@public.gmane.org
> > Subject: Re: [PATCH v4 00/73] XArray version 4
> >=20
> > On Wed, Dec 06, 2017 at 12:45:49PM +1100, Dave Chinner wrote:
> > > On Tue, Dec 05, 2017 at 04:40:46PM -0800, Matthew Wilcox wrote:
> > > > From: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.=
org>
> > > >
> > > > I looked through some notes and decided this was version 4 of the X=
Array.
> > > > Last posted two weeks ago, this version includes a *lot* of changes.
> > > > I'd like to thank Dave Chinner for his feedback, encouragement and
> > > > distracting ideas for improvement, which I'll get to once this is m=
erged.
> > >
> > > BTW, you need to fix the "To:" line on your patchbombs:
> > >
> > > > To: unlisted-recipients: ;, no To-header on input <@gmail-
> > pop.l.google.com>
> > >
> > > This bad email address getting quoted to the cc line makes some MTAs
> > > very unhappy.
> > >
> > > >
> > > > Highlights:
> > > >  - Over 2000 words of documentation in patch 8!  And lots more kern=
el-doc.
> > > >  - The page cache is now fully converted to the XArray.
> > > >  - Many more tests in the test-suite.
> > > >
> > > > This patch set is not for applying.  0day is still reporting proble=
ms,
> > > > and I'd feel bad for eating someone's data.  These patches apply on=
 top
> > > > of a set of prepatory patches which just aren't interesting.  If you
> > > > want to see the patches applied to a tree, I suggest pulling my git=
 tree:
> > > >
> > https://na01.safelinks.protection.outlook.com/?url=3Dhttp%3A%2F%2Fgit.i=
nfrade
> > ad.org%2Fusers%2Fwilly%2Flinux-
> > dax.git%2Fshortlog%2Frefs%2Fheads%2Fxarray-2017-12-
> > 04&data=3D02%7C01%7Cmawilcox%40microsoft.com%7Ca3e721545f8b4b9dff1
> > 608d53c4bd42f%7C72f988bf86f141af91ab2d7cd011db47%7C1%7C0%7C6364
> > 81218740341312&sdata=3DIXNZXXLTf964OQ0eLDpJt2LCv%2BGGWFW%2FQd4Kc
> > KYu6zo%3D&reserved=3D0
> > > > I also left out the idr_preload removals.  They're still in the git=
 tree,
> > > > but I'm not looking for feedback on them.
> > >
> > > I'll give this a quick burn this afternoon and see what catches fire.=
..
> >=20
> > Build warnings/errors:
> >=20
> > .....
> > lib/radix-tree.c:700:13: warning: =BFradix_tree_free_nodes=BF defined b=
ut not used
> > [-Wunused-function]
> >  static void radix_tree_free_nodes(struct radix_tree_node *node)
> > .....
> > lib/xarray.c: In function =BFxas_max=BF:
> > lib/xarray.c:291:16: warning: unused variable =BFmask=BF
> > [-Wunused-variable]
> >   unsigned long mask, max =3D xas->xa_index;
> >                   ^~~~
> > ......
> > fs/dax.c: In function =BFgrab_mapping_entry=BF:
> > fs/dax.c:305:2: error: implicit declaration of function =BFxas_set_orde=
r=BF; did you
> > mean =BFxas_set_err=BF?  [-Werror=3Dimplicit-function-declaration]
> >   xas_set_order(&xas, index, size_flag ? PMD_ORDER : 0);
> >     ^~~~~~~~~~~~~
> > scripts/Makefile.build:310: recipe for target 'fs/dax.o' failed
> > make[1]: *** [fs/dax.o] Error 1
> >=20
> > -Dave.
> > --
> > Dave Chinner
> > david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org

--=20
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
