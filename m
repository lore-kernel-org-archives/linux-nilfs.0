From: Sven Eckelmann <sven-KaDOiPu9UxWEi8DpZVb4nw@public.gmane.org>
Subject: Re: [PATCH] nilfs-utils: Work around uncleanable full filesystem
Date: Tue, 15 Jan 2013 16:17:17 +0100
Message-ID: <2312125.8JVqXAGppa@bentobox>
References: <1358178899-26347-1-git-send-email-sven@narfation.org> <1358258241.2094.9.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1470546.JSNlCRd3jq"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=narfation.org;
	s=20121; t=1358263039;
	bh=rmOrxvx4uFzWerd1BvHNrCQzmdZGse/DFW6HYRizwAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PR4vP157q3hHVSFgUaWOvd5h3E5G5QxZPDyjgjjMu9AvXSPHNkOh7qTM/0T+ZKjYG
	 B57cGAJKLQLBWO2TszhOTiU+mxKi3og2MyS/2L57wJP6xkIZ1rD2RzB5O/8dE+2MSv
	 sc/aytqEsU4feXSxQC1gOQ4KCr+3RBtAREh9ciyw=
In-Reply-To: <1358258241.2094.9.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--nextPart1470546.JSNlCRd3jq
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Tuesday 15 January 2013 17:57:21 Vyacheslav Dubeyko wrote:
> Could you share more details about your environment? What version of
> nilfs-utils do you use?
> 
> Maybe do you have some NILFS2-related error messages in your system log?
> 
> Or, maybe, reproducing path is more complex as you described?

System running Debian Wheezy (amd64) with linux 3.2.35-2 and nilfs-tools 
2.1.4-1. The nilfs partition is a secondary partition on a CFCard and is not 
used in normal situations. There are different processes running in the 
background... for example ntpd. There are no interesting infos in the system 
log (unless you are interested in nilfs_cleanerd output saying nothing else 
than "pause"/"sleep"/"0 segments selected to be cleaned"/...).

Following way is a good way to force a similar problem (this is not the way I 
produced it the first time, but it is a possible scenario):

$ cd /nilfs/
$ ntpdate-debian
$ date -s @`date +'%s'|awk '{ print $1+9000}'`
$ for i in `seq 0 300`; do dd if=/dev/zero of=foo$i count=22528; done
$ sleep 360
$ ntpdate-debian
$ touch asd
$ rm *
$ date -s @`date +'%s'|awk '{ print $1+10000}'`
$ mount -o remount /nilfs/

It is a little bit harsh, but a similar thing can easily happen in real world 
with non-monotonic clocks (but the jumps are usually a little smaller).

Kind regards,
	Sven
--nextPart1470546.JSNlCRd3jq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCgAGBQJQ9XL9AAoJEF2HCgfBJntG5AEQAL/ipsROniIoGpIAs1ZyFVio
2jkJcWJpSaj2SPCjHgPa+ICd2dFrFFpJ24Gch7xzjvyrCUGu2XGzMpqAoNKG6C0n
vZJS2kjItZNsScyb+TE16pD1V9h/MHriH9ZNdDPNWALwP+0Mp9z8QEUY7CCg3Hwc
z7iQ6zzKEnsOs45R0tB57F3C5wBc8kRKywYIc+11fqBd8vTzrCcQQJ5je3Q/6nR2
YEwK0kQQKdg6px6zfDR+SA4QMCBhsy854xa1BmRwhgI5E2q7nQkjVSmG5oLc7hwr
DaiQYBexi9c0UzdRvD882I0VhbtXEUCWiZeZ+ntM03mTiSkQCXd9jCsQOCslCLag
Rd0pnlxdi7VmefJ46uIpXDsxHlPFuE6sN8UiH2z0bUIRS3g17cbIpKB7B3dRZWZ6
1UndzAPKctnYnnnN7GYcvziZYNSipIiRHqvnvqfiXmF17uk5kzMsgzdFsV0ILEbf
qWu8LrFQoTdxk1Xc5JQKs1EYPEVQTQ5X8gl1KwmJlXQaATkMG5to4lob8VoYV/Bq
7WAxAtkvZDYpTbNK2KStKyMJIj8gXLWxxX+0PgJ0XIHGz/6mPbQYZ1iXpQvV4yYl
JfZ+lKL1BFmy47mm18GHnOyMZWq3djvyzBsMxFx7zN8kp+XrgcQPZPzgAwQld4yq
xM5TCA3HnOKHQRjpncYX
=3mHb
-----END PGP SIGNATURE-----

--nextPart1470546.JSNlCRd3jq--

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
