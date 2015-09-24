From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 1/3] BTRFS: support NFSv2 export
Date: Thu, 24 Sep 2015 11:59:02 +1000
Message-ID: <87r3lowpax.fsf@notabene.neil.brown.name>
References: <20150508001142.31129.7604.stgit@notabene.brown> <20150508001623.31129.91695.stgit@notabene.brown> <20150511081309.GI23255@suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20150511081309.GI23255@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
To: dsterba@suse.cz
Cc: Josef Bacik <jbacik@fb.com>, Chris Mason <clm@fb.com>, Jan Kara <jack@suse.cz>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

David Sterba <dsterba@suse.cz> writes:

> On Fri, May 08, 2015 at 10:16:23AM +1000, NeilBrown wrote:
>> The "fh_len" passed to ->fh_to_* is not guaranteed to be that same as
>> that returned by encode_fh - it may be larger.
>>=20
>> With NFSv2, the filehandle is fixed length, so it may appear longer
>> than expected and be zero-padded.
>>=20
>> So we must test that fh_len is at least some value, not exactly equal
>> to it.
>>=20
>> Signed-off-by: NeilBrown <neilb@suse.de>
>
> Acked-by: David Sterba <dsterba@suse.cz>

Thanks.  However I just checked mainline and this still hasn't been
applied.
Should I resend it to someone?  Who?

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWA1jnAAoJEDnsnt1WYoG5KSAP/1716nmLGCRjmTwtXVI5R3mL
io6SgWlTwBJvZYAF+vFys7UO5bgLnATHysY56EV5Pj3Ky3dWVz5NGap+qjCuyHNX
fyCsXgfwbACB9zoYlKqADDsNMa0hpnUC0sLYiDzG9OyjQDaJyDPlv5mNJCFWHnyE
fAohkp+OzBwi+v+SxFjtA5NjwGxzmJ2EXdxy5+klwspMcdLlbSLwveSOYMLxsh2b
ZA5px7VCs6+lPDPZyI1u7nmv3z1NEBB+JZMcJhP3GJGBlv/f2aTGlaCaCHfI77EV
zGOgZeTz6vkSw8kQTzq70sBGQsCyOBwioA7QgAXfiiQlfhYQZTV6bLPgPF9Qauu4
C5x+8TreFMjUvAtFIbt18W4tiWSZqSj8uEfcwZSMBN6L+J76GDbT38FUr6ZoeAfj
FLk9CZQEEb+ZolaMUi9l0dMgFdXKnciU3C601bHJPgedQVyxlM7Tx1d6qNFunmzE
f0UnbuuoQJViY3ILQETE7XUxRtBp+VZSMZHxXNa3MbPqkV4P8cPZhiSlXGX9OOyn
IFoT2a3xfvD1tJm2Hf2E7xUmbu+i4RBQvwc1KJJVK+VZpShN1M/c+FsuN2smCmzV
KMDxqGAVmLDeJRzaoe0/WCLaBkG2sQcSqTH+FQUBwaElC2lL4ouDxqw2m1NVB/6p
I+nRdvvjXrX/s1Jrq3jd
=Zrth
-----END PGP SIGNATURE-----
--=-=-=--
