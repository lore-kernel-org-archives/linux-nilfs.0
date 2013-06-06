From: Reinoud Zandijk <reinoud-qavaossjCcEdnm+yROfE0A@public.gmane.org>
Subject: Re: Broken nilfs2 filesystem
Date: Thu, 6 Jun 2013 11:20:54 +0200
Message-ID: <20130606092054.GA201@diablo.13thmonkey.org>
References: <1369809573.2253.31.camel@slavad-ubuntu>
 <20130529.233757.27789741.konishi.ryusuke@lab.ntt.co.jp>
 <1369894385.2255.8.camel@slavad-ubuntu>
 <20130530.155543.480320022.konishi.ryusuke@lab.ntt.co.jp>
 <1370501769.2202.36.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VS++wcV0S1rZb1Fb"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1370501769.2202.36.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

just my $0.02 so to say:

On Thu, Jun 06, 2013 at 10:56:09AM +0400, Vyacheslav Dubeyko wrote:
> First of all, unfortunately, I can't reproduce the issue yet, currently.
> I suspect that in this issue the aging state of volume, peculiarity of
> workload and environment play very important role. As I remember, all
> reporters of likewise symptoms (broken bnode error messages) talked
> about several months of successful working of NILFS2 file system.

sounds to me as if a b-tree is in a perculiar state and that updating the
btree results in this corruption.

Have you tried to mount one of the checkpoints/snapshots earlier as RO and see
if those are correct? If so, dumping both DATs and both btrees might give a
clue as to what went wrong. If only it gives a clue as to how complicated the
btree is before the updating and what actions are taken on it.

With regards,
Reinoud


--VS++wcV0S1rZb1Fb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (NetBSD)

iQEcBAEBAgAGBQJRsFR2AAoJEIKcNwBDyKpodxwH/03ar3SNTtAgZT+mOSrYSIxY
IRbDNHCIGdyY5uq8ZQTc1pdpSjzJUkzXQb0/sqkOyQ6MXNHvXlyjDsarj0DpwcDq
HiRnUx3t7tKqrA5Pb0SpP6L+GuNKisgg/8zzazoFz0DyxHASYT+MF89jW8uWUdNL
qw7iKbl95q7+b8/SxdoR9CgY6jB6d5+OailVO9SGPCe16/PY8iC1jUrHfRl/Nuix
jlgMbNXHr4Z9AJflOjlZZ9XgIITShOHUUFq35SoTBFuwhHu6/iYjA/u+LwbGIl9T
VroGMzf8n79FbYhrDBzgPHRi0y041d6sNywaQ0f2LvIJS75JFp9uYL6+vnGSa7E=
=3d9q
-----END PGP SIGNATURE-----

--VS++wcV0S1rZb1Fb--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
