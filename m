From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Split some metadata onto separate device?
Date: Wed, 8 Jun 2011 15:08:37 +0200
Message-ID: <201106081508.39345.dexen.devries@gmail.com>
References: <20110604.022621.01482278.ryusuke@osrg.net> <20110608.214852.237935973.ryusuke@osrg.net> <20110608.215803.224753719.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:user-agent:references
         :in-reply-to:x-face:mime-version:content-type
         :content-transfer-encoding:message-id;
        bh=2gTfSlzpkG4V3L2SokiWJt7YOpl/eFBOjrbpQ4B061o=;
        b=WoVhh3ZVAdoUXsMdsb295ORgSP8cYToxBkQW8D5QadmSsSGSgOsNiFGR5UU2gxUcxd
         6nPQYU3c682BmfjEPDaVul6Om+VZPNdFVoFpiuloncD7uBqezAIFid0IoXvoYJQ93Ei5
         h9ltLgNqEjbwjMUNnKm2tpv/bic8TVZQGgTYM=
In-Reply-To: <20110608.215803.224753719.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi again,


On Wednesday 08 of June 2011 14:58:03 you wrote:
> On Wed, 08 Jun 2011 21:48:52 +0900 (JST), Ryusuke Konishi wrote:
> > On Fri, 3 Jun 2011 19:42:28 +0200, dexen deVries wrote:
> > > By the way, it seems to me that the in-kernel GC does not attempt=
 to
> > > de- fragment files. Is that the case? If so, would probably mean
> > > extents would not help very much for fragmented files. Also, on
> > > magnetic media, a lot of seeking happens in case of fragmented
> > > files.
> >=20
> > Yes, but extents will decrease the amount of metadata, and this has
> > potential for speed up.
> >=20
> > NILFS2 uses 32 bytes metadata per disk block at present.  I guess y=
ou
> > know that the number of DAT blocks are actually indispensable throu=
gh
> > analysis using the dumpseg tool.
>=20
> Oh, looks confusing.  I meant the amount of DAT blocks is not
> negligible.

Understood ;-)

Anyway, isn't some fragmentation avoidance necessary to profit from ext=
ents=20
(that we hope we'll use at some point)?
AFAIK, an extent is only good to describe file blocks if they are laid =
out=20
continuous on the block device.


Cheers,
--=20
dexen deVries

[[[=E2=86=93][=E2=86=92]]]

=46or example, if the first thing in the file is:
   <?kzy irefvba=3D"1.0" rapbqvat=3D"ebg13"?>
an XML parser will recognize that the document is stored in the traditi=
onal=20
ROT13 encoding.

(( Joe English, http://www.flightlab.com/~joe/sgml/faq-not.txt ))
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
