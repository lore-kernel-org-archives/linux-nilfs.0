From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Deadlocks! help, please!
Date: Tue, 22 Jan 2008 12:02:00 +0900
Message-ID: <1200970920.2844.59.camel@localhost.localdomain>
References: <20080117183302.275d051d@vosztok>
	<1200628693.2931.54.camel@localhost.localdomain>
	<1200651072.2931.112.camel@localhost.localdomain>
	<20080121.140129.01311807.ryusuke@osrg.net>
	<20080122000052.215084db@vosztok>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20080122000052.215084db@vosztok>
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

Hi,

On Tue, 2008-01-22 at 00:00 +0100, Gergely G=E1bor wrote:
> > Here I attach a test patch to fix the problem.
> > Could you try the patch ?
> >=20
> > So, if rtorrent (or something else) hang again, then
> > send me a copy of /proc/slabinfo, please.
> It hang again,

Ugh! OK, I'll continue to work on it.

> but i have to note, that i had to respin kernel,=20
> as I used SLUB before (some make oldconfig possibly=20
> defaulted to that or suggested that), and had no /proc/slabinfo.
> With SLUB even with the patch in place, the machine froze,
>  and with SLAB i did a fine ~6 hour uptime, and was just telling
>  a friend that nilfs is just right now, when it stuck :)
> the hang occured when epiphany ( based on gecko. memleaker :( )=20
> eat up a lot of ram, and I was just about to close it.=20
> some massive swapping happened, and the fs hang.
> I attach many stuff, might they help: a log with call trace,=20
> a copy of slabinfo and the kernel config, might that be of any use.

Thanks a lot for providing various information.
Actually I have a machine with a SLUB configured kernel,
but it's not so problematic. I wonder why NILFS hangs so offten=20
in your environment :)
Joking aside, one of key differences that my colleague=20
pointed out, is that your kernel is non-smp one.
We'll try your config to get better environment to debug.

Best regards,
--=20
Ryusuke Konishi
NILFS team NTT
http://www.nilfs.org/
