From: Pierre Etchemaite <petchema-5XhUwtNo+r9Wk0Htik3J/w@public.gmane.org>
Subject: Re: __udivdi3
Date: Fri, 04 Jan 2008 15:26:16 +0100
Message-ID: <1199456776.15312.3.camel@attale.agematis.loc>
References: <20080103034154.bf6c74be.elentirmo.gilgalad@gmail.com>
	<200801032238.44785.chris@csamuel.org>
	<20080103161729.c623ad3e.elentirmo.gilgalad@gmail.com>
	<20080104014721.3D7163E06C1@fs.osrg.net>
	<20080104041630.57fd0df6.elentirmo.gilgalad@gmail.com>
	<20080104140246.2A3D83E06C1@fs.osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20080104140246.2A3D83E06C1-121w62HK5dnR7s880joybQ@public.gmane.org>
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

Le vendredi 04 janvier 2008 =E0 23:02 +0900, amagai-sG5X7nlA6pw@public.gmane.org a =E9crit :
> Hi,=20
> please try following patch,=20
>=20
>   cd nilfs-2.0.0-testing-8
>   patch -p0 < patch_file
>   cd fs
>   make clean
>   make
>   make install

I could compile the kernel module, load it, mkfs a partition and mount
the filesystem...

So far, so good with this patch. Thanks!

Best regards,
Pierre.
