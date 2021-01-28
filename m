From: Chaitanya Kulkarni <Chaitanya.Kulkarni-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [RFC PATCH 02/34] block: introduce and use bio_new
Date: Thu, 28 Jan 2021 08:33:10 +0000
Message-ID: <DM6PR04MB4972DA86892CF4531440064F86BA9@DM6PR04MB4972.namprd04.prod.outlook.com>
References: <20210128071133.60335-1-chaitanya.kulkarni@wdc.com>
	<20210128071133.60335-3-chaitanya.kulkarni@wdc.com>
	<BL0PR04MB6514C554B4AC96866BC1B16FE7BA9@BL0PR04MB6514.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5792380515446082079=="
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
	d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
	t=1611822797; x=1643358797;
	h=from:to:cc:subject:date:message-id:references: mime-version;
	bh=xyFzKQ8uoezlRr8spXa07wubVm2nVcnNVG+r0aHkSAk=;
	b=peeYSGKwLqFPztko7OK7xYjiXOMZD/mx6PyTNnIqBEQGb13a07E8Faqr
	X0rLNRkNu+QBY1RSthNcmG52lIei+N8A7rTH87i9v+PruTRIKTLdw5Chm
	0guJKxw7FLxQri0SCczKsP+CvU7hJyAF6iaJ+E9EXYwFj096zSsP1VfQ7
	nEEAV2BOyDJBKnwhAEhSk8TRUULWH80xWdWsoFCo0HFy9px5o4fZUcSqz
	w6zLqplL9ki42iFgdFYhbtquxv29i/Gb0uhK3Ze0I6A98/9SA2LQ0DOHb
	5eqAIY84eMU1ygCrsvhq2CjEwvB/HDWdDEPjpyrhJB+VwLRCRrYFOajQn g==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com; 
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=27WeiOixIPFPDfcazPu+NAilOtkMrK3W6qpnHMGnQ1I=;
	b=rp96NNkAqQELe/BqLJVlZ2yZRQDtAF1Vg8+XD3tQvfPezlagCPgze9Vv+QZAGIP8YAqtZ1GpnQ9qPZ4bJK0AmuaAleG5bCohRymbY+4GneQyX4eg53WphXHojQqDdpTgk/tRayLh5AEjUFltKyCnkHZlpN7DImA6Zfrx5D0zzPI=
Content-Language: en-US
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: Damien Le Moal <Damien.LeMoal-Sjgp3cTcYWE@public.gmane.org>, "linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org" <drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>, "xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org" <xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fscrypt-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fscrypt-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jfs-discussion-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <jfs-discussion-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org" <o>
Cc: "shaggy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <shaggy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "sergey.senozhatsky.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <sergey.senozhatsky.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "tiwai-l3A5Bk7waGM@public.gmane.org" <tiwai-l3A5Bk7waGM@public.gmane.org>, "djwong-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <djwong-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "gustavoars-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <gustavoars-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "joseph.qi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org" <joseph.qi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, "pavel-+ZI9xUNit7I@public.gmane.org" <pavel-+ZI9xUNit7I@public.gmane.org>, "alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org" <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "mark-qFb/fKtWg+rQT0dZR+AlfA@public.gmane.org" <mark-qFb/fKtWg+rQT0dZR+AlfA@public.gmane.org>, "osandov-b10kYP2dOMg@public.gmane.org" <osandov-b10kYP2dOMg@public.gmane.org>, "ebiggers-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <ebiggers-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "ngupta-KNmc09w0p+Ednm+yROfE0A@public.gmane.org" <ngupta-KNmc09w0p+Ednm+yROfE0A@public.gmane.org>, Naohiro Aota <Naohiro.Aota-Sjgp3cTcYWE@public.gmane.org>, "konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "hare-l3A5Bk7waGM@public.gmane.org" <hare-l3A5Bk7waGM@public.gmane.org>, "ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <min>

--===============5792380515446082079==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_DM6PR04MB4972DA86892CF4531440064F86BA9DM6PR04MB4972namp_"

--_000_DM6PR04MB4972DA86892CF4531440064F86BA9DM6PR04MB4972namp_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

On 1/27/21 11:21 PM, Damien Le Moal wrote:

On 2021/01/28 16:12, Chaitanya Kulkarni wrote:


Introduce bio_new() helper and use it in blk-lib.c to allocate and
initialize various non-optional or semi-optional members of the bio
along with bio allocation done with bio_alloc(). Here we also calmp the
max_bvecs for bio with BIO_MAX_PAGES before we pass to bio_alloc().

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni-Sjgp3cTcYWE@public.gmane.org><mailto:chait=
anya.kulkarni-Sjgp3cTcYWE@public.gmane.org>
---
 block/blk-lib.c     |  6 +-----
 include/linux/bio.h | 25 +++++++++++++++++++++++++
 2 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index fb486a0bdb58..ec29415f00dd 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -14,17 +14,13 @@ struct bio *blk_next_bio(struct bio *bio, struct block_=
device *bdev,
                        sector_t sect, unsigned op, unsigned opf,
                        unsigned int nr_pages, gfp_t gfp)
 {
-       struct bio *new =3D bio_alloc(gfp, nr_pages);
+       struct bio *new =3D bio_new(bdev, sect, op, opf, gfp, nr_pages);

        if (bio) {
                bio_chain(bio, new);
                submit_bio(bio);
        }

-       new->bi_iter.bi_sector =3D sect;
-       bio_set_dev(new, bdev);
-       bio_set_op_attrs(new, op, opf);
-
        return new;
 }

diff --git a/include/linux/bio.h b/include/linux/bio.h
index c74857cf1252..2a09ba100546 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -826,5 +826,30 @@ static inline void bio_set_polled(struct bio *bio, str=
uct kiocb *kiocb)
        if (!is_sync_kiocb(kiocb))
                bio->bi_opf |=3D REQ_NOWAIT;
 }
+/**
+ * bio_new -   allcate and initialize new bio
+ * @bdev:      blockdev to issue discard for
+ * @sector:    start sector
+ * @op:                REQ_OP_XXX from enum req_opf
+ * @op_flags:  REQ_XXX from enum req_flag_bits
+ * @max_bvecs: maximum bvec to be allocated for this bio
+ * @gfp_mask:  memory allocation flags (for bio_alloc)
+ *
+ * Description:
+ *    Allocates, initializes common members, and returns a new bio.
+ */
+static inline struct bio *bio_new(struct block_device *bdev, sector_t sect=
or,
+                                 unsigned int op, unsigned int op_flags,
+                                 unsigned int max_bvecs, gfp_t gfp_mask)
+{
+       unsigned nr_bvec =3D clamp_t(unsigned int, max_bvecs, 0, BIO_MAX_PA=
GES);
+       struct bio *bio =3D bio_alloc(gfp_mask, nr_bvec);


I think that depending on the gfp_mask passed, bio can be NULL. So this sho=
uld
be checked.


true, I'll add that check.




+
+       bio_set_dev(bio, bdev);
+       bio->bi_iter.bi_sector =3D sector;
+       bio_set_op_attrs(bio, op, op_flags);


This function is obsolete. Open code this.


true, will do.




+
+       return bio;
+}

 #endif /* __LINUX_BIO_H */



Thanks for the comments Damien.

--_000_DM6PR04MB4972DA86892CF4531440064F86BA9DM6PR04MB4972namp_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
</head>
<body>
<div class=3D"moz-cite-prefix">On 1/27/21 11:21 PM, Damien Le Moal wrote:<b=
r>
</div>
<blockquote type=3D"cite" cite=3D"mid:BL0PR04MB6514C554B4AC96866BC1B16FE7BA=
9@BL0PR04MB6514.namprd04.prod.outlook.com">
<pre class=3D"moz-quote-pre" wrap=3D"">On 2021/01/28 16:12, Chaitanya Kulka=
rni wrote:=0A=
</pre>
<blockquote type=3D"cite" style=3D"color: #007cff;">
<pre class=3D"moz-quote-pre" wrap=3D"">Introduce bio_new() helper and use i=
t in blk-lib.c to allocate and=0A=
initialize various non-optional or semi-optional members of the bio=0A=
along with bio allocation done with bio_alloc(). Here we also calmp the=0A=
max_bvecs for bio with BIO_MAX_PAGES before we pass to bio_alloc().=0A=
=0A=
Signed-off-by: Chaitanya Kulkarni <a class=3D"moz-txt-link-rfc2396E" href=
=3D"mailto:chaitanya.kulkarni-Sjgp3cTcYWE@public.gmane.org" moz-do-not-send=3D"true">&lt;chaitan=
ya.kulkarni-Sjgp3cTcYWE@public.gmane.org&gt;</a>=0A=
---=0A=
 block/blk-lib.c     |  6 +-----=0A=
 include/linux/bio.h | 25 +++++++++++++++++++++++++=0A=
 2 files changed, 26 insertions(+), 5 deletions(-)=0A=
=0A=
diff --git a/block/blk-lib.c b/block/blk-lib.c=0A=
index fb486a0bdb58..ec29415f00dd 100644=0A=
--- a/block/blk-lib.c=0A=
+++ b/block/blk-lib.c=0A=
@@ -14,17 +14,13 @@ struct bio *blk_next_bio(struct bio *bio, struct block_=
device *bdev,=0A=
 			sector_t sect, unsigned op, unsigned opf,=0A=
 			unsigned int nr_pages, gfp_t gfp)=0A=
 {=0A=
-	struct bio *new =3D bio_alloc(gfp, nr_pages);=0A=
+	struct bio *new =3D bio_new(bdev, sect, op, opf, gfp, nr_pages);=0A=
 =0A=
 	if (bio) {=0A=
 		bio_chain(bio, new);=0A=
 		submit_bio(bio);=0A=
 	}=0A=
 =0A=
-	new-&gt;bi_iter.bi_sector =3D sect;=0A=
-	bio_set_dev(new, bdev);=0A=
-	bio_set_op_attrs(new, op, opf);=0A=
-=0A=
 	return new;=0A=
 }=0A=
 =0A=
diff --git a/include/linux/bio.h b/include/linux/bio.h=0A=
index c74857cf1252..2a09ba100546 100644=0A=
--- a/include/linux/bio.h=0A=
+++ b/include/linux/bio.h=0A=
@@ -826,5 +826,30 @@ static inline void bio_set_polled(struct bio *bio, str=
uct kiocb *kiocb)=0A=
 	if (!is_sync_kiocb(kiocb))=0A=
 		bio-&gt;bi_opf |=3D REQ_NOWAIT;=0A=
 }=0A=
+/**=0A=
+ * bio_new -	allcate and initialize new bio=0A=
+ * @bdev:	blockdev to issue discard for=0A=
+ * @sector:	start sector=0A=
+ * @op:		REQ_OP_XXX from enum req_opf=0A=
+ * @op_flags:	REQ_XXX from enum req_flag_bits=0A=
+ * @max_bvecs:	maximum bvec to be allocated for this bio=0A=
+ * @gfp_mask:	memory allocation flags (for bio_alloc)=0A=
+ *=0A=
+ * Description:=0A=
+ *    Allocates, initializes common members, and returns a new bio.=0A=
+ */=0A=
+static inline struct bio *bio_new(struct block_device *bdev, sector_t sect=
or,=0A=
+				  unsigned int op, unsigned int op_flags,=0A=
+				  unsigned int max_bvecs, gfp_t gfp_mask)=0A=
+{=0A=
+	unsigned nr_bvec =3D clamp_t(unsigned int, max_bvecs, 0, BIO_MAX_PAGES);=
=0A=
+	struct bio *bio =3D bio_alloc(gfp_mask, nr_bvec);=0A=
</pre>
</blockquote>
<pre class=3D"moz-quote-pre" wrap=3D"">I think that depending on the gfp_ma=
sk passed, bio can be NULL. So this should=0A=
be checked.=0A=
</pre>
</blockquote>
true, I'll add that check.<br>
<blockquote type=3D"cite" cite=3D"mid:BL0PR04MB6514C554B4AC96866BC1B16FE7BA=
9@BL0PR04MB6514.namprd04.prod.outlook.com">
<pre class=3D"moz-quote-pre" wrap=3D"">=0A=
</pre>
<blockquote type=3D"cite" style=3D"color: #007cff;">
<pre class=3D"moz-quote-pre" wrap=3D"">+=0A=
+	bio_set_dev(bio, bdev);=0A=
+	bio-&gt;bi_iter.bi_sector =3D sector;=0A=
+	bio_set_op_attrs(bio, op, op_flags);=0A=
</pre>
</blockquote>
<pre class=3D"moz-quote-pre" wrap=3D"">This function is obsolete. Open code=
 this.=0A=
</pre>
</blockquote>
true, will do.<br>
<blockquote type=3D"cite" cite=3D"mid:BL0PR04MB6514C554B4AC96866BC1B16FE7BA=
9@BL0PR04MB6514.namprd04.prod.outlook.com">
<pre class=3D"moz-quote-pre" wrap=3D"">=0A=
</pre>
<blockquote type=3D"cite" style=3D"color: #007cff;">
<pre class=3D"moz-quote-pre" wrap=3D"">+=0A=
+	return bio;=0A=
+}=0A=
 =0A=
 #endif /* __LINUX_BIO_H */=0A=
=0A=
</pre>
</blockquote>
</blockquote>
<p>Thanks for the comments Damien.<br>
</p>
</body>
</html>

--_000_DM6PR04MB4972DA86892CF4531440064F86BA9DM6PR04MB4972namp_--

--===============5792380515446082079==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
drbd-dev mailing list
drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
https://lists.linbit.com/mailman/listinfo/drbd-dev

--===============5792380515446082079==--
