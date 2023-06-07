From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 28/31] block: replace fmode_t with a block-specific
 type for block open flags
Date: Wed, 7 Jun 2023 14:16:58 +0200
Message-ID: <20230607121658.GA13632@lst.de>
References: <20230606073950.225178-1-hch@lst.de> <20230606073950.225178-29-hch@lst.de> <20230607-kocht-kornfeld-a249c6740e38@brauner>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20230607-kocht-kornfeld-a249c6740e38@brauner>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Richard Weinberger <richard@nod.at>, Josef Bacik <josef@toxicpanda.com>, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>, Phillip Potter <phil@philpotter.co.uk>, Coly Li <colyli@suse.de>, Miquel Raynal <miquel.raynal@bootlin.com>, Vignesh Raghavendra <vigneshr@ti.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@ucw.cz>, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-um@lists.infradead.org, linux-scsi@vger.kernel.org, linux-bcache@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.

On Wed, Jun 07, 2023 at 11:21:14AM +0200, Christian Brauner wrote:
> On Tue, Jun 06, 2023 at 09:39:47AM +0200, Christoph Hellwig wrote:
> > The only overlap between the block open flags mapped into the fmode_t a=
nd
> > other uses of fmode_t are FMODE_READ and FMODE_WRITE.  Define a new
>=20
> and FMODE_EXCL afaict

FMODE_EXCL isn't used outside the block layer and removed in the last
patch.

> > +blk_mode_t file_to_blk_mode(struct file *file)
> > +{
> > +	blk_mode_t mode =3D 0;
> > +
> > +	if (file->f_mode & FMODE_READ)
> > +		mode |=3D BLK_OPEN_READ;
> > +	if (file->f_mode & FMODE_WRITE)
> > +		mode |=3D BLK_OPEN_WRITE;
> > +	if (file->f_mode & FMODE_EXCL)
> > +		mode |=3D BLK_OPEN_EXCL;
> > +	if ((file->f_flags & O_ACCMODE) =3D=3D 3)
>=20
> I really don't like magic numbers like this.

I don't like them either, but this is just moved around and not new.

> Groan, O_RDONLY being defined as 0 strikes again...
> Becuase of this quirk we internally map
>=20
> O_RDONLY(0) -> FMODE_READ(1)
> O_WRONLY(1) -> FMODE_WRITE(2)
> O_RDWR(3)   -> (FMODE_READ | FMODE_WRITE)

O_RDWR is 2.

> so checking for the raw 3 here is confusing in addition to being a magic
> number as it could give the impression that what's checked here is
> (O_WRONLY | O_RDWR) which doesn't make sense...

Well, that is exactly what we check for.  This is a 30-ish year old
quirk only used in the floppy driver.

> So my perference would be in descending order of preference:
>=20
> (file->f_flags & O_ACCMODE) =3D=3D (FMODE_READ | FMODE_WRITE)
>=20
> or while a little less clear but informative enough for people familiar
> with the O_RDONLY quirk:
>=20
> if ((file->f_flags & O_ACCMODE) =3D=3D O_ACCMODE)

I don't understand this part.  Especially the above doesn't make
any sense as FMODE_READ and FMODE_WRITE are in a completely different
symbol space to O_*, and not a UAP=D0=86 but a kernel internal thing that
could be renumbered any time.
