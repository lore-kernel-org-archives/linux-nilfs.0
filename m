From: Gergely =?UTF-8?B?R8OhYm9y?= <elentirmo.gilgalad-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Deadlocks! help, please!
Date: Thu, 7 Feb 2008 11:09:30 +0100
Message-ID: <20080207110930.3df85a70@vosztok>
References: <20080121.140129.01311807.ryusuke@osrg.net>
	<20080122000052.215084db@vosztok>
	<1200970920.2844.59.camel@localhost.localdomain>
	<20080205.182829.44149266.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0010773407=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=gamma;
	h=domainkey-signature:received:received:date:from:to:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type;
	bh=hzsWtvjz4fdmZPqLyB/7IIzfnYH3eQyB3CKr0CbwGlg=;
	b=lGO+XG40dqGqZREbWsdeCt4uu+E0sD8JD43wPokq1zgE2guEzLa1NGp2NBnoDYzpWfnB61fwHTLB6KN4ONmhHdOB2JVMf7KT8yQdabv59ffe61sMotKSJzZ75udQw2Nhfp+qkzROsxaA5m6TIyfAIjAv2P7Nxi+rLASLVhvkrJA=
In-Reply-To: <20080205.182829.44149266.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

--===============0010773407==
Content-Type: multipart/signed; boundary="Sig_/ESeWQHNJN=EpTjXWe=2tV6u";
	protocol="application/pgp-signature"; micalg=PGP-SHA1

--Sig_/ESeWQHNJN=EpTjXWe=2tV6u
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 05 Feb 2008 18:28:29 +0900 (JST)
Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wrote:

> Hi G=C3=A1bor,
>=20
> From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
> Subject: Re: [NILFS users] Deadlocks! help, please!
> Date: Tue, 22 Jan 2008 12:02:00 +0900
> > On Tue, 2008-01-22 at 00:00 +0100, Gergely G=C3=A1bor wrote:
> > > > Here I attach a test patch to fix the problem.
> > > > Could you try the patch ?
> > > >=20
> > > > So, if rtorrent (or something else) hang again, then
> > > > send me a copy of /proc/slabinfo, please.
> > > It hang again,
> >=20
> > Ugh! OK, I'll continue to work on it.
>=20
> Today I could reproduce the hang problem, and succeeded in capturing
> a stack trace of the suspended cleaner process.
>=20
> After short analysis, a suspicious bug was found in a write routine
> of NILFS.  It seems to be the root cause of this problem.
>=20
> I will attach a revised patch below.
> Could you try the patch?
>=20
> It is applicable to nilfs-2.0.0-testing-8 as usual,
> (Ignore hunks, they are harmless)
>=20
I have installed it (with some other patches: the one for the mount option =
bug, and other for udivdi (that is needed to link the module properly at me=
) and started a download in rtorrent for the night. It has not ferrzed, but=
 i have experianced massive memory leaks, either on the cleaner, or int he =
module. now i'm trying to reproduce the bug with fs running without cleaner=
. if it will not arise in a day, i'll try the cleaner as well. I have a que=
stion about the cleaner, that might help my find the bug: can I send a sign=
al to the cleaner to finish and commit unfinished changes and exit after th=
at? and can I manually start a cleaner (possibly with valgrind)? Can I send=
 signals to pause cleaning (for example I go on battery), and to resume?
This leak error ate up all my memory, and forced all apps to swap, slowing =
the system down so much, that it took almost an hour to exit rtorrent... un=
fortunalety i forgot to vmstat after the kill of the cleaner, before umount=
ing the fs. If I kill the fs will it not leave garbage (i mean badly formed=
 entries in the log) after itself if it will, will those entries be cleaned=
 up? after i umounted the partition, i had my ram back cleanly (i'd say tha=
t this was possibly the cleaner, as the module was left in memory even afte=
r the umount, still the ram wasn't wasted...) Is that possible, that the ra=
m was not wasted, but the cleaner/fs is bit inefficient, or can't be made s=
impler, and I should buy more ram? it ate ~440Mb of memory. (i have 512Mb)

Otherwise the patch seems to work cleanly I haven't applied the previous pa=
tch you proposed, should I have tried? (it gave errors) Possibly if you set=
 up a git/hg/other repo, life'd be more convinient. they made my life simpl=
er even in my small school projects.

Sorry for the letter being a bit unstructured, many questions arise in me, =
may as writing the letter and actually asking is simpler than checking out =
myself. (well, i might check out, but why not try asking?)

Best regards:
--=20
Gergely G=C3=A1bor <elentirmo.gilgalad-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

* random fortune:
Before borrowing money from a friend, decide which you need more.
		-- Addison H. Hallock

--Sig_/ESeWQHNJN=EpTjXWe=2tV6u
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFHqtjflZGsj+xzT3kRAgVlAKC0JIWLScG4ztJSEfuwLYvIxY6yRQCgo6AH
jwqrgSYp260fpgYn1dolaA0=
=vMKy
-----END PGP SIGNATURE-----

--Sig_/ESeWQHNJN=EpTjXWe=2tV6u--

--===============0010773407==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============0010773407==--
