From: Reinoud Zandijk <reinoud-S783fYmB3Ccdnm+yROfE0A@public.gmane.org>
Subject: directory entries
Date: Sat, 23 Aug 2008 22:38:53 +0200
Message-ID: <20080823203853.GA19421@aardappel.13thmonkey.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1285281161=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
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


--===============1285281161==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Dear folks,

i wondered why directory lengths are specified in blocksize units resulting 
in the last dirent in the block to fill up the space with its rec_len. 
Searching for free space to enter a directory entry i could use 
rec_len - NILFS_DIR_REC_LEN(last_dir_enty->namelen) as free space indicator 
but i wondered if it might not be a better practice to allow zero-length 
dir entries that are used to fill up the rest of the block with its 
rec_len.

Thoughts?

With regards,
Reinoud



--liOOAslEiF7prFVr
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (NetBSD)

iQEVAwUBSLB1XYKcNwBDyKpoAQLITgf/QpBjDV4FT+IH+ixrClYpvD5xDOA3arXZ
6jQzR7NuK+YZUGb2BWnNzZxHXPwifyfKewHkvOnQ9EXQCqWepPicetmmkGLTV4/5
/gfKsd1w6YhL9OhAgt8XoaA6gDkd3HxuvQLc0UCjNPWovpvfRvI6vBylt9uYB5xY
s2J2Ahb8gIsbVnQVDklBf9kLWQi8NZbCM3axuSoshZXoQiW7T7Weo/wrIpyvvrOU
1xI5QNzPhOzRHP4+/W2mWZYiskEieYKIkkU8fjx062+Qj2fthMXEDhoU55J5DHYa
fNFgK/k2gERbHzNslcjXDTUElKPRRq/abanPRV+7d8c78zsH92FJbg==
=hA6x
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--

--===============1285281161==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============1285281161==--
