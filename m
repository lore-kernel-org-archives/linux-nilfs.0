From: Reinoud Zandijk <reinoud-S783fYmB3Ccdnm+yROfE0A@public.gmane.org>
Subject: Re: automount checkpoints
Date: Fri, 5 Sep 2008 15:26:08 +0200
Message-ID: <20080905132608.GA26355@aardappel.13thmonkey.org>
References: <c28029380809050532v4d81f093sa0abe41e92c84dc6@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1732827433=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <c28029380809050532v4d81f093sa0abe41e92c84dc6-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Mime-version: 1.0
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>


--===============1732827433==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VS++wcV0S1rZb1Fb"
Content-Disposition: inline


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks, hi Giacomo,

On Fri, Sep 05, 2008 at 02:32:58PM +0200, Giacomo Graziosi wrote:
> I'd like to know if it is possible to mount every checkpoint at once,
> something like the .zfs/snapshot/ folder used by ZFS (which contains a
> folder linked to every snapshot, readonly) but for the checkpoints.

i like the HAMMER fs feature of referencing to every file by 
checkpoint/snapshot number: dir/file@@14532 gives checkpoint 14532's 
version of `file' or rootdir@@13 for checkpoint 13's version of the 
rootdir. HAMMER's `undo(1)' is thus very neat and easy to implement.

In NilFS it would mean looking up the IFILE for the checkpoint and fetch 
the same inode... or walk the tree to the same name... effectively making 
checkpoint X a temporary snapshot, mounting it somewhere and then returning 
the vnode/inode for that looked up file. Thats going to be fun to 
implement. OR allways load/keep all checkpoints/snapshots IFILE for the 
referencing game. Hmmm.....

As for your question, snapshots ok, but checkpoints? hmm.... it would need 
refcounting for references to its files to prevent the garbage collector to 
wreak havoc... 

So, yes, its possible, but easy? there are some `interesting' issues to 
solve :-D

BTW, HAMMERs undo(1) saves heaps of tools to be patched for earlier file 
referencing.

With regards,
Reinoud

--VS++wcV0S1rZb1Fb
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (NetBSD)

iQEVAwUBSMEzb4KcNwBDyKpoAQKAlggArSEKDXyhNckNsBpXvySbq7fqf0pO9sTb
uC5pn+4H8/ZEREZSlSPjSa5hs/l2f5hNcf4VmHxSV2LKK8JMnfZ85THgNz+XQC/0
2fk4uVnLCkZ5HjA5NQlOBN/W1+V++Fjtaee5pgW0fG6ou1HUOAc6JVYoAXpddzUN
rsFF4jP+RfdLKRQruErE7P+5o8W+07GNxdoN1Ljh6IcT4rNdYNT1MoxGzMk+dZvG
eGocqMYmtypTJPwVT2XyQCjeGAvWlPgdOtW+CB++hWM6QDnLcz7iS0tytoqQyJ0/
ldd+OAM+JCLYH3ft749BL7e39HLuMvHg7Vz0+ENhVk+FaYCkOV26uA==
=kf29
-----END PGP SIGNATURE-----

--VS++wcV0S1rZb1Fb--

--===============1732827433==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============1732827433==--
