From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH v4 00/73] XArray version 4
Date: Wed, 6 Dec 2017 12:51:08 +1100
Message-ID: <20171206015108.GB4094@dastard>
References: <20171206004159.3755-1-willy@infradead.org>
 <20171206014536.GA4094@dastard>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171206014536.GA4094@dastard>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Rehas Sachdeva <aquannie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Dec 06, 2017 at 12:45:49PM +1100, Dave Chinner wrote:
> On Tue, Dec 05, 2017 at 04:40:46PM -0800, Matthew Wilcox wrote:
> > From: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> >=20
> > I looked through some notes and decided this was version 4 of the XArra=
y.
> > Last posted two weeks ago, this version includes a *lot* of changes.
> > I'd like to thank Dave Chinner for his feedback, encouragement and
> > distracting ideas for improvement, which I'll get to once this is merge=
d.
>=20
> BTW, you need to fix the "To:" line on your patchbombs:
>=20
> > To: unlisted-recipients: ;, no To-header on input <@gmail-pop.l.google.=
com>=20
>=20
> This bad email address getting quoted to the cc line makes some MTAs
> very unhappy.
>=20
> >=20
> > Highlights:
> >  - Over 2000 words of documentation in patch 8!  And lots more kernel-d=
oc.
> >  - The page cache is now fully converted to the XArray.
> >  - Many more tests in the test-suite.
> >=20
> > This patch set is not for applying.  0day is still reporting problems,
> > and I'd feel bad for eating someone's data.  These patches apply on top
> > of a set of prepatory patches which just aren't interesting.  If you
> > want to see the patches applied to a tree, I suggest pulling my git tre=
e:
> > http://git.infradead.org/users/willy/linux-dax.git/shortlog/refs/heads/=
xarray-2017-12-04
> > I also left out the idr_preload removals.  They're still in the git tre=
e,
> > but I'm not looking for feedback on them.
>=20
> I'll give this a quick burn this afternoon and see what catches fire...

Build warnings/errors:

.....
lib/radix-tree.c:700:13: warning: =BFradix_tree_free_nodes=BF defined but n=
ot used [-Wunused-function]
 static void radix_tree_free_nodes(struct radix_tree_node *node)
.....
lib/xarray.c: In function =BFxas_max=BF:
lib/xarray.c:291:16: warning: unused variable =BFmask=BF
[-Wunused-variable]
  unsigned long mask, max =3D xas->xa_index;
                  ^~~~
......
fs/dax.c: In function =BFgrab_mapping_entry=BF:
fs/dax.c:305:2: error: implicit declaration of function =BFxas_set_order=BF=
; did you mean =BFxas_set_err=BF?  [-Werror=3Dimplicit-function-declaration]
  xas_set_order(&xas, index, size_flag ? PMD_ORDER : 0);
    ^~~~~~~~~~~~~
scripts/Makefile.build:310: recipe for target 'fs/dax.o' failed
make[1]: *** [fs/dax.o] Error 1

-Dave.
--=20
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
