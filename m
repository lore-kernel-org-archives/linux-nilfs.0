From: Gergely =?UTF-8?B?R8OhYm9y?= <elentirmo.gilgalad-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Deadlocks! help, please!
Date: Wed, 16 Jan 2008 22:25:00 +0100
Message-ID: <20080116222500.60e78090@vosztok>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0639614246=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=gamma;
	h=domainkey-signature:received:received:date:from:to:subject:message-id:x-mailer:importance:x-priority:mime-version:content-type;
	bh=yGeAc9uOYOVRhRjzueLzmnsjtm13xensWyh6dGz5KtM=;
	b=DjEhdE/34viRAqEr/Y27SrW6BYjGV82YLijleT+qxmx3e8oczV0wHR/YMiZaW13IB0iVt+Nnk+OS5e0wDszQbiB1gBORHo5RxdZ8JhWS8fYjyZKLBgzbXpfevsKPATqIfPnv69asHYYedzs1urEwmZQOtLqz5KqVAYn13+ObCMk=
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

--===============0639614246==
Content-Type: multipart/signed; boundary="Sig_/jcEXSoIDABZ=1orGrEaqIAN";
	protocol="application/pgp-signature"; micalg=PGP-SHA1

--Sig_/jcEXSoIDABZ=1orGrEaqIAN
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello!

Yesterday I have made the transition from xfs to nilfs on the /home partiti=
on of my notebook, and since then, with the same usage as before,i have exp=
erienced deadlocks 3 times.

The situations were the following:

using gimp to cut a picture
browsing web with epiphany browser
epiphany again

rtorrent was running in the background.

What I experienced:

suddenly hdd activity starts. possibly because of swapping (i have 512m ram=
, and only gimp/epiphany are likely to eat much ram, i use wmaker and conso=
le based programs mostly)

i can't kill gimp/epi, i can log in at other VT-s with root, but not with u=
ser. thing that touch /home (even ls!), sync simply get stuck, and even kil=
l -9 can't kill the stuck program. therefore i must assume it got stuck in =
some syscall, in kernel mode or something similiar, possibly in the nilfs2 =
module. I must assume this, as the hangs seemed to be in connection with /h=
ome.

i couldn't restart the computer cleanly,had to power-cycle it, and after re=
start the system got alive as expected (i noticed there is no fsck util. is=
n't fsck needed? is a roll forward from last cp done at mount? ) The garbag=
e collector couldn't have donethis,, in theory, as i ordered it to have a 3=
 day long protection interval.

my GC put the following message to the logs:

Jan 16 01:19:00 vosztok nilfs_cleanerd[29597]: start
Jan 16 01:19:00 vosztok nilfs_cleanerd[29597]: cannot create cleanerd on /d=
ev/vosztok_vg/home
Jan 16 01:19:00 vosztok nilfs_cleanerd[29597]: shutdown
Jan 16 17:51:54 vosztok nilfs_cleanerd[4254]: close /var/run/nilfs_cleanerd=
-dm-1.pid
Jan 16 17:51:54 vosztok nilfs_cleanerd[4254]: unlink /var/run/nilfs_cleaner=
d-dm-1.pid
Jan 16 17:51:54 vosztok nilfs_cleanerd[4254]: shutdown
Jan 16 17:54:34 vosztok nilfs_cleanerd[9661]: start
Jan 16 17:54:35 vosztok nilfs_cleanerd[9661]: open /var/run/nilfs_cleanerd-=
dm-1.pid

And the module gave these messages:

Jan 16 17:54:34 vosztok kernel: NILFS warning (device dm-1): nilfs_sync_sup=
er: barrier-based sync failed. disabling barriers
Jan 16 17:54:34 vosztok nilfs_cleanerd[9661]: start
Jan 16 17:54:35 vosztok nilfs_cleanerd[9661]: open /var/run/nilfs_cleanerd-=
dm-1.pid


Please help me, (as tough i love nilfs even after this short interval of us=
e, this quite reduces the user experience :) ) and tell me how, and what in=
formation should I provide to help you fix the problem.

Thanks in advance:
--=20
Gergely G=C3=A1bor <elentirmo.gilgalad-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

* random fortune:
Little girls, like butterflies, need no excuse.
		-- Lazarus Long

--Sig_/jcEXSoIDABZ=1orGrEaqIAN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFHjnY3lZGsj+xzT3kRAslJAJ9/HJMdukmxij78fIkJlUsaaQ+epQCgu2XU
hKQHCRlV2S8WSLY9GZVSCg8=
=sHRv
-----END PGP SIGNATURE-----

--Sig_/jcEXSoIDABZ=1orGrEaqIAN--

--===============0639614246==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============0639614246==--
