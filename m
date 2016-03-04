From: Joel Brunenberg <ml-cjJSWhJYEmM@public.gmane.org>
Subject: Re: Feature request: time-shift function
Date: Fri, 4 Mar 2016 14:57:36 +0100
Message-ID: <20160304135736.GG10877@taeko.vm.is.jjim.de>
References: <CAFm8q6fJm-ZYKhGpV0b6PrdbaosSzUz4JUC9-XjiDLUvObQ0TA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MiFvc8Vo6wRSORdP"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=jjim.de; s=dkim200811;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:To:From:Date; bh=dwbcM4UveUqcYOSCsywo+Kcvz8nvBBqQP9jIAs+CVjw=;
	b=V/Zx2P7IkJwTQtJ/wtNTY+KeEm1sh+IQ3varxWlC43tsnQ3XlbGha32bNWGwnm/Z1v1Cs7fpg1zsv3U6nCOXAmfojBBH6uBkSt7m9DzEYM6F8qTrFXQI/GxRkGO7VptZCcNKICqMP8WarAtZ2f5i8hhEvpZHoyDG1rNeELt6l08=;
Content-Disposition: inline
In-Reply-To: <CAFm8q6fJm-ZYKhGpV0b6PrdbaosSzUz4JUC9-XjiDLUvObQ0TA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--MiFvc8Vo6wRSORdP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Feb 05, 2016 at 01:57:40AM +0800, Eric Lan wrote:
> Every checkpoint represent a complete filesystem at a given time. When
> a system corruption occurs, is it possible to mount a specified
> checkpoint (when the system is still clean) as read-write to
> "time-shift" to the state when the bad thing still not happened. Of
> course the checkpoints newer than the "time-shift" point will be
> discarded.

I would also very much like to see an easy method to make the fs "forget"
the checkpoints from a certain point onwards. I guess it would be enough
to satisfy all the features from this mail, Eric would like to see.

Mode of operation would be:

 1 Notice a problem with the data on a system (e.g. update went wrong,
   all libraries are broken. We need to revert)
 2 Verify on an earlier checkpoint, that everything is fine
 3 Revert to that checkpoint, discarding all checkpoints later than
   that.
 4 profit.

I guess though that this is not as trivial as it seems.

Kind regards,

 /jbn

--=20
Joel Brunenberg - Troisdorf
PGP: 0xAD25981C

--MiFvc8Vo6wRSORdP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQJCBAEBAgAsBQJW2ZRHJRpodHRwOi8vcGdwLmpqaW0uZGUvcG9saWN5L3BvbGlj
eS50eHQACgkQ1N3ALa0lmBxAIg/9Eqbz2erMiBPlhCbSZsjQUSaVGTtzbYQQbMtz
BrYw90Us8rDOXXFwKc+czF7y3BNhhk5WcQXPUgbQuN7pfvk405wskWzldy9yQC+4
DANdIvvX6uq0VyIx0fs6ahWtbuAI0xdJxCB4WT/dP3CobhwDQMxqngfNDLy4DAV0
wQTFR97rd1fjTnDwmICbCVvS4qqDVgVdM+jZ2Qa3+f/v2YnSz9oLdhR8kXtgzF6H
SLnFqcRlyhHTu75tkTv8z607j4cErQaWxWQkulr7BtbyXy3SZ6vxMxs7LLuZa+uu
pgdaWXFzeerejlwgmjqKQmtNYWKeU2BBLylEAcElSh6BFLFbCcRmKEkhI3YG551g
ht0EDY5H/HKqJdVArM5/n96V2uw4GZ96yfVpWnZ/kQoEy7IwaeZovZ6yGyfs7GMY
g3qEYSdzG+SrXXNXkl2CmcbS6681lkbcKgSIK5gf1XzqvRNp8IDvzOFRPAhq3skH
sgiyDl+vCLHOjjQqNCPmiNz6xsgvwVxzdnBzwtv+hawmuWohugRzf9bfGM+TxHJR
kILzxuopQm3N8rGhLwUB4N/r1iX65Ns5KfFi8ICOVKPUpQEqPhGpbk0CcLFQO/xb
0vBWXEghswdXutoFAj2zgiuL4PdbLy0OyyiBb+Oq9jQT72OszcQ08NPkMNLSteS8
w0ASAsw=
=VCss
-----END PGP SIGNATURE-----

--MiFvc8Vo6wRSORdP--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
