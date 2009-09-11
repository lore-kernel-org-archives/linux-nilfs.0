From: Reinoud Zandijk <reinoud-S783fYmB3Ccdnm+yROfE0A@public.gmane.org>
Subject: Re: How does NILFS2 handle directory management
Date: Fri, 11 Sep 2009 07:22:13 +0200
Message-ID: <20090911052213.GA24899@aardappel.13thmonkey.org>
References: <2324ff2b0909101216q31dad1a8y43ea0f229923a0c3@mail.gmail.com>
	<20090910192619.GA1263@heethoofdje.13thmonkey.org>
	<20090911.102118.69189169.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0665773898=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090911.102118.69189169.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: Prasenjit Giri <tangyorangesour-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, reinoud-S783fYmB3Ccdnm+yROfE0A@public.gmane.org, users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org


--===============0665773898==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

On Fri, Sep 11, 2009 at 10:21:18AM +0900, Ryusuke Konishi wrote:
> > I dont know if b+tree directory management would be preferable though. With
> > some smart caching all directory operations can be made O(1) anyway.
> 
> Yes, directory is a file and it's already managed with b-tree like
> other files.  However, the current directory design is not O(log n),
> and is actually slow especially for file creation.

Thats what i was refering to. UDF has the same issue and the same design on
directory structure, only even more complicated since directory entries are
not of a fixed length and may actually span logical sectors/blocks.

I now have code in UDF that i also use in my NiLFS implementation that manages
the first file creation/reference in O(n) but all other files
creation/lookup/delete in O(1)! speeding up large directory copies
modifications/copies enormously, upto thousands of times.

> So, it leaves room for considering the true "b-tree directory
> management".
> 
> OTOH, the replacement has the following points to notice:
> 
>  1) It may complicate the log writer.
> 
>     The current log writer is designed on the basis that every data
>     and meta data is a file.  In NILFS, inodes, segment usage state,
>     and checkpoints, are managed with correponding meta-data files.
> 
>     The true "b-tree directory management" may break this uniformity.

This indeed complicates it a lot. It could still be implemented using `perfect
hashing' techniques in one file but i have no experience with this and updates
may still be expensive.

With regards,
Reinoud

P.S. Ryusuke, did you recieve my mail on the length of partial segments?


--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (NetBSD)

iQEcBAEBAgAGBQJKqd6FAAoJEIKcNwBDyKpohRMIAJyUKqRniDJz679XUizM0OV2
MaxMTHGyIs4fErBDORQNy4gep7+B131nHE+8LsgujadZfCBttQG6+8s7MAGbIUxS
sM/bJ5q2Tj8594pfsKGDdRmQOzEz28pXCg5O3iIciVf66AZyEg04lZ904gt97LrE
AJx3kMXeTdrR2ZYhdDauYYDnK3SJOG12ovyvRQKxkZcM80l0s2ws/RF1NmpSsWM2
hDfY5tMJpqNruEbTrqeEz7lcCzGfTxEzyO2+J5CDUSKT67Fm3V+QlXlj7uH4ld5m
WBU8+RItwJxuQx3yRXR+rf6uQeRPO3IyWZHzWt5VJ7pJyH6NO/dH9vn0ZdQopKs=
=3ykg
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--

--===============0665773898==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============0665773898==--
