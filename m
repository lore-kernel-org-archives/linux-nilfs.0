From: Sven Eckelmann <sven-KaDOiPu9UxWEi8DpZVb4nw@public.gmane.org>
Subject: Re: [PATCH] nilfs-utils: Work around uncleanable full filesystem
Date: Tue, 15 Jan 2013 09:34:07 +0100
Message-ID: <2639510.KI9IMQ2FZo@bentobox>
References: <1358178899-26347-1-git-send-email-sven@narfation.org> <1358234057.2105.12.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3013770.Nrof15fnCM"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=narfation.org;
	s=20121; t=1358238848;
	bh=OLQXU9Hkn6FIwiFz5X0tCBZB5Q4i9GGwqKQ6VB54/AM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KZJalgYvwpLaYJkh+yzoqGEa2WgwRmYOyX0QqtGdZxqGon9j13pBh/Tn8MSdFX2YI
	 sjy43z05rL0Hw+2XrxVq1z/0ipSKvvRO3RfjCzy8ybkCCvSLqUazDMQZ4fkGA+Xlil
	 N8ZUHjbrrFp7r25QbjCZar+SUtCRDqZQ6SPDZxZo=
In-Reply-To: <1358234057.2105.12.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--nextPart3013770.Nrof15fnCM
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Tuesday 15 January 2013 11:14:17 Vyacheslav Dubeyko wrote:
[...]
> > Signed-off-by: Sven Eckelmann <sven-KaDOiPu9UxWEi8DpZVb4nw@public.gmane.org>
> > ---
> > 
> >  sbin/cleanerd/cleanerd.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/sbin/cleanerd/cleanerd.c b/sbin/cleanerd/cleanerd.c
> > index bfcd893..12ed975 100644
> > --- a/sbin/cleanerd/cleanerd.c
> > +++ b/sbin/cleanerd/cleanerd.c
> > @@ -592,7 +592,7 @@ nilfs_cleanerd_select_segments(struct nilfs_cleanerd
> > *cleanerd,> 
> >  	 * selected. */
> >  	
> >  	thr = (config->cf_selection_policy.p_threshold != 0) ?
> >  	
> >  		config->cf_selection_policy.p_threshold :
> > -		sustat->ss_nongc_ctime;
> > +		~0ULL;
> 
> As I understand the code of nilfs_cleanerd, this code is correct without
> your changing. The ss_nongc_ctime is the creation time of the last
> segment not for GC. When thr is set then it compared with sui_lastmod.
> The sui_lastmod is the timestamp of last modification. So, the
> nilfs_cleanerd works right.

Depends on the definition of right. In a complete environment using the current 
nilfs kernel code it needs to _work around_ this problem. But yes, the culprit 
must be the kernel side.

> I think that this is a bug on the kernel side. My current vision is that
> in some environment the ns_nongc_ctime can be not updated correctly. So,
> you have such threshold that prevent from segments clearing.

Yes, one problem for example is the non-monotonic behaviour of many timekeeper 
functions.

Kind regards,
	Sven
--nextPart3013770.Nrof15fnCM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCgAGBQJQ9RR/AAoJEF2HCgfBJntGMYIQAM7gIy9o0ny1KKARVB0Tsm1W
O83qVuR7og25kSJnBzDKAqtYULBlUHv+dM0o0xKSiMLSh/Tr6LpOIHWw+DaASSyt
ape7QQJNEKGe/6p7OrXsevKuMznfMuoo+ub50r+qA6lP8jBdctHzqsJxx2O3VmfT
F12CsarbqpWwAoyvbL9Tv2ky11iY7FICt1j0yvNAXsQmu9P5a7yv/sw+aqLctMav
0nNsJQxAIntaGVnCOBUAfoFnlNiB6wikrMveYpr9iAf69Oq6G6VZGa7xAd5JmnD7
RyaM+Nm9gm/tlwQecQTKeztG1XMpgUo3b5gJfTCeFDd4gW+uHeHlI1IN0jv+6OXd
OFNpmF0WPf02ySX4MCLshgXQL0J71y3EQK+xyULEPV4A2tm+4L6Co99mlZto97/4
+ftRrmNCtMcFwL7voAipxIsIZ6nNTD2Z7oB/OcSp4GlSmhNoUEwm7EmOvtFs7dDZ
u81842c8v584+Dgki/Oz8O9fgkte6H5MabdcPPHrDM3IVVF5UBBcY2Tr8fnYVlDj
jabXagkqgnMkXPmfTSVI38MNCYJEnwqBy468CkMKHsXy02Ndx9LFQzpBM+M2OAkl
x2e1h8Jblerfje1v/+VoAVsLH8BK1AQSl+aKo9110GfUstLEk6iK4pcOHsB8jSvO
/VoCg8I9nDOe5PbFmpb2
=Vmsx
-----END PGP SIGNATURE-----

--nextPart3013770.Nrof15fnCM--

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
