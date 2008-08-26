From: Reinoud Zandijk <reinoud-S783fYmB3Ccdnm+yROfE0A@public.gmane.org>
Subject: Re: directory entries
Date: Tue, 26 Aug 2008 15:29:44 +0200
Message-ID: <20080826132944.GA17045@aardappel.13thmonkey.org>
References: <20080825.122125.65657043.ryusuke@osrg.net>
	<20080825.123047.128885778.ryusuke@osrg.net>
	<20080825155243.GA12855@aardappel.13thmonkey.org>
	<20080826.192942.104752679.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1611116596=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20080826.192942.104752679.ryusuke-sG5X7nlA6pw@public.gmane.org>
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


--===============1611116596==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Dear Ryusuke,

On Tue, Aug 26, 2008 at 07:29:42PM +0900, Ryusuke Konishi wrote:
> On Mon, 25 Aug 2008 17:52:44 +0200, Reinoud Zandijk wrote:
> > - writable snapshots
> > 
> > This sounds like a fun feature. Would you like to have 1) multiple writable 
> > and snapshotable heads? 2) support updating a snapshot or 3) support 
> > writing to a snapshot that is lost when unmounted?
> 
> What's the difference between (1) and (2), do you mean ?
> The number of read/write mounts concurrently mountable ?
> 
> I'd like to allow read/write mount for snapshots like:
> 
>   # mount -t nilfs2 -o rw,cp=xxx /dev/block /dir
> 
> and maybe (2) is nearest to what I want.
> The (3) seems to be rather restrictive.

well i already guessed so :) though a forkable FS has its advantages! but 
would one really use it in practice? It could be handy for switching 
between configurations and effectively has a COW strategy that keeps the 
diffs for each head between the fork point and the current point but that 
could also be done with an LVM.

> > But how to number checkpoints and snapshots then?
> 
> I don't like CVS revision like extension.
> Just appending derived checkpoints (from a snapshot) to current head,
> seems to be preferable.  What do you think?

For option (2) new data/modifications can we written out only under the old 
checkpoint number like the cleaner does.... but if you create a new 
checkpoint for it ... i dunno; that would break the rule `the last 
checkpoint is the head'. We could also give snapshot/head a name; then 
increasing checkpoints is no issue if you keep the head name; one can then 
search for the `HEAD' name with the highest checkpoint number. Or are you 
suggesting a different way?

> > - data integrity support
> 
> I'd rather expect that the future data integrity extension of block
> layer (e.g. T10 DIF) due to simplicity and performance reason.

yeah, maybe the block level would be better yes; easier at least :-D

> > - B tree base directory management
> > - Extent support
>
> For extent based management, there seem to be some possibilities to apply
> it in NILFS.  For example,
> 
> - Extent tree (like ext4.  This is a possible displacement of B-tree )
> - Extent based DAT (would save disk space consumed by DAT and improve
>   performance)
> - Extent based binfo in segment summary.

Extent based DAT yeah, that could be used yes. An extent tree is quite ... 
a different thing though i dont know how difficult it would be to implement 
an extent based DAT; haven't tried it yet.

With regards,
Reinoud


--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (NetBSD)

iQEVAwUBSLQFSIKcNwBDyKpoAQKn3wf+LkV0MwMoKI+cwHVKfSj4bLWK9Nb3Szkx
+pnNwFWMQnOLBlaynSdoYhNyiGz2YQPQW2YVwqOuugA6QLCi98U8Dv8tpODhg02v
hdZgUWc6CT5cyX67slQm2RC8odrvVciQaEe1Hc6IapXyvbIKKSgqpt/7VIY1r+nU
Zv+9uzdVBoik/ZAhEYnapccajsyBcC7Q2gaJwXgJTXHMAU7+GC7nGEu7BkY0FlM9
jz6Fc9V0gKdrwSiEyRMe/92G9khOf0lUBF+CLVoMd+iFHb9o1ROP8Diyzsl2tA3S
PF73CCOKtOM+TV+IpQ6qtJIWVoAxlvxyvQ8WjliN38ZTl+T+HECFXw==
=iY9e
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--

--===============1611116596==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============1611116596==--
