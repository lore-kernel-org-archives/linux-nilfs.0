From: Sven Eckelmann <sven-KaDOiPu9UxWEi8DpZVb4nw@public.gmane.org>
Subject: Re: [PATCH] nilfs-utils: Work around uncleanable full filesystem
Date: Mon, 14 Jan 2013 19:55:27 +0100
Message-ID: <2856062.J1h4ec8Fju@bentobox>
References: <1358178899-26347-1-git-send-email-sven@narfation.org> <37A149BD-4D8E-4C55-9301-428034C5B9DA@dubeyko.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4441251.K3O1dz2NRy"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=narfation.org;
	s=20121; t=1358189729;
	bh=FlyMDXfD/m+5myRwGMWzpiGyRK8wrOSkZnKPYdHJWKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gjp1HCa9T10l7B5CyIITqQiGVCzajunKJwy5ihTRk2DLj0nMjdChD5caX46QBNMyC
	 w46A9Kbog2/mZ/jwLNI3P1u/M21JE53VEP6Lx8ejGNp73a+DYfgRPWldlymIzjiln6
	 BwzAUsS615NOhKD7BOfs+0QOAwLfvcuhL3e1rPE8=
In-Reply-To: <37A149BD-4D8E-4C55-9301-428034C5B9DA-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--nextPart4441251.K3O1dz2NRy
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Monday 14 January 2013 22:49:50 Vyacheslav Dubeyko wrote:
> Hi Sven,
> 
> On Jan 14, 2013, at 6:54 PM, Sven Eckelmann wrote:
> > The filesystem can end up in a state were the filesystem is full and the
> > returned ss_nongc_ctime is smaller than sui_lastmod of all reclaimable
> > segments. The garbage collector will not clean anything and therefore no
> > new room for new files will be available and ss_nongc_ctime/sui_lastmod
> > will not be updated without using special tools. This makes the
> > filesystem unusable without manual recovery.
> > 
> > Signed-off-by: Sven Eckelmann <sven-KaDOiPu9UxWEi8DpZVb4nw@public.gmane.org>
> > --
> > This problem appeared on a current 3.2 stable kernel (Debian Wheezy
> > build). I am not an FS developer and have therefore not much background
> > knowledge about the NILFS codebase. Nevertheless, this problem hit me
> > quite hard after creating some files on a nilfs partition until it was
> > full and deleting them again.
> > 
> > $ for i in `seq 0 150`; do dd if=/dev/zero of=foo$i count=22528; done
> > $ rm foo*
> > 
> > Looking at the output debugging output using
> > 
> > $ watch -n .5 'df -h;tail /var/log/syslog;'
> 
> As I understand, you did such sequence of actions:
> 1. Generate such count of files that the whole size of used space was about
> the partition size. 2. Delete all generated files.
> 3. Expect that previously used space is become fully free.
> 
> Am I correct?

Nearly. Here is my config file:

protection_period       0
min_clean_segments      10%
max_clean_segments      20%
clean_check_interval    5
selection_policy        timestamp
nsegments_per_clean     8
mc_nsegments_per_clean  8
cleaning_interval       5
mc_cleaning_interval    1
retry_interval          40
use_mmap
log_priority            debug


and an alternative version

protection_period       20
min_clean_segments      10%
max_clean_segments      20%
clean_check_interval    5
selection_policy        timestamp
nsegments_per_clean     8
mc_nsegments_per_clean  8
cleaning_interval       5
mc_cleaning_interval    1
retry_interval          40
use_mmap
log_priority            debug

So I would have expected that nilfs would have some free space again after 20 
seconds (+ time it needs to free stuff). But it did not and I've showed the 
reason in my explanation (threshold vs. the time stored in each reclaimable  
segment).

At least "no free space after a work day" was not the expected result using 
this setup.

> I think that you have some misunderstanding of NILFS2 working. The GC of
> NILFS2 works in background and it needs to wait sometime before segments
> will be clean. If you have necessity to begin cleaning immediately then you
> can execute "nilfs-clean -p 0". Did you try to use it?
> 
> I think that you try to achieve by this patch the result of  "nilfs-clean -p
> 0".

This was default set in the configuration file and therefore I did not have to 
set it manually using nilfs-clean -p 0.

> Sorry, if I misunderstand something. Please, correct me if I am wrong.

See above.

Kind regards,
	Sven

--nextPart4441251.K3O1dz2NRy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCgAGBQJQ9FSfAAoJEF2HCgfBJntG/RQP/RLF6LhLwgWSXSPhignC24o3
Oiw8xqIocCFoqwc8RF6Ge1491z38r6baZUgzlu/wPzwd/pwVgEEIzPANhiZlMgnc
msiDF0pewrsL/4JaPzdjoFZC3CkmGbBPp05IChXJtU22RjLH07pxypoYK1sIXEpo
UtVXDP2+hFPXwmRMQ9PxzJoXxeI2R3o8u7lqZ3R4QG9KTSqTnCpN8gUDvVoU6lGv
oLlyfQsSZ4/TS3UyL8bdXBwJ3Lgc3yWUV+H6PVKzPVe4GE5RNpegWI9aRAHeI1/9
mGVxzbdTU1uQDVanJHcl6vEjeYdE9V5Kh6bdfbSfGC4f1u7q/HR+noh24lPGi9S4
SXuVNd9ldV2qoTR2bhn3VNP2SxphuDI7lInfvRAaIFzVEIgU4RRzdnEulMsUYr00
jQwiUSbLGQntDv4sIY4F165Md10gZrr5eLsfn+fe+jwob7idi6b+WSN8MuhOCVtb
N2+ke7hrkoC4EeFxr2C3n92YCXNSNBUqdpELys6UBjIqMWau9VT6ecaZThtt841Z
UX0tYaV0DdKDz2gi5wrUDZdMzeebsXz/LZbgUi7eOVPqahO+5i9qWmEzA4+p3q79
UyStxcKC+4LvgAfmkP2U2cGf7zFX1TnOZn8FEJe5ioHqykYPzw3gTf3hydg5IQW7
BENXGmzHv5OQLU5Rc8Xn
=KNmX
-----END PGP SIGNATURE-----

--nextPart4441251.K3O1dz2NRy--

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
