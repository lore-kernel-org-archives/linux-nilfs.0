From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Kernel Bug while deleting files (with rsync)
Date: Thu, 27 Mar 2008 12:03:41 +0900
Message-ID: <1206587021.3100.47.camel@localhost.localdomain>
References: <20080325102553.GA10853@laxu.de>
	<1206445521.3131.60.camel@localhost.localdomain>
	<20080326.220532.62697306.ryusuke@osrg.net>
	<20080326164723.GA31518@laxu.de>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20080326164723.GA31518-W0ZHf6uU1cg@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Content-Type: text/plain; charset="iso-8859-1"
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

Hi Alex,

On Wed, 2008-03-26 at 17:47 +0100, Alexander Schier wrote:
> Hi!
>=20
> segctord starting. Construction interval =3D 5 seconds, CP frequency < =
30 seconds
> NILFS warning (device dm-3): nilfs_sync_super: barrier-based sync faile=
d. disabling barriers
>=20
> PAGE_BUG(c1328080): cnt=3D2 index#=3D0 flags=3D0x40000805 mapping=3D000=
00000 ino=3D0
>  BH[0] d66a1cd0: cnt=3D1 block#=3D0 state=3D0x20000
> <snip>
> with rsync again.
>=20
> Alex

Thanks!
=EF=BB=BFAccording to your log, the problem is a reference count leak of =
a
b-tree node buffer.

Could you tell me the concrete way to reproduce the bug with rsync ?=20

Regards,
--=20
Ryusuke Konishi
NILFS team NTT
http://www.nilfs.org/
