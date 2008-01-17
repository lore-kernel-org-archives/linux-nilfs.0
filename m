From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Deadlocks! help, please!
Date: Thu, 17 Jan 2008 16:58:37 +0900
Message-ID: <1200556717.3085.94.camel@localhost.localdomain>
References: <20080116222500.60e78090@vosztok>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20080116222500.60e78090@vosztok>
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

On Wed, 2008-01-16 at 22:25 +0100, Gergely G=E1bor wrote:
> Hello!
>=20
> Yesterday I have made the transition from xfs to nilfs on the /home
> partition of my notebook, and since then, with the same usage as
> before,i have experienced deadlocks 3 times.
>=20
> The situations were the following:
>=20
> using gimp to cut a picture
> browsing web with epiphany browser
> epiphany again
>=20
> rtorrent was running in the background.

Sorry for inconvenience.
I will try to reproduce the problem by using same applications.
I may ask for your help to get information if I cannot.

> What I experienced:
>=20
> suddenly hdd activity starts. possibly because of swapping (i have
> 512m ram, and only gimp/epiphany are likely to eat much ram, i use
> wmaker and console based programs mostly)
>=20
> i can't kill gimp/epi, i can log in at other VT-s with root, but
> not with user. thing that touch /home (even ls!), sync simply get
> stuck, and even kill -9 can't kill the stuck program. therefore i
> must assume it got stuck in some syscall, in kernel mode or
> something similiar, possibly in the nilfs2 module. I must assume
> this, as the hangs seemed to be in connection with /home.
>=20
> i couldn't restart the computer cleanly,had to power-cycle it, and
> after restart the system got alive as expected (i noticed there is
> no fsck util. isn't fsck needed? is a roll forward from last cp
> done at mount? ) The garbage collector couldn't have donethis,,=20
> in theory, as i ordered it to have a 3 day long protection interval.

Yes, NILFS automatically recovers at mount time, so you don't have to
run fsck normally. NILFS does a roll forward during recovery, and
restarts from the last checkpoint that was completely written to disk.

This recovery, howerver, cannot rescue corrupted filesystem due to
destructive writes to the device nor a bug of NILFS.  So, it doesn't
mean that fsck.nilfs2 is needless.

> my GC put the following message to the logs:
>=20
> Jan 16 01:19:00 vosztok nilfs_cleanerd[29597]: start
> Jan 16 01:19:00 vosztok nilfs_cleanerd[29597]: cannot create cleanerd o=
n /dev/vosztok_vg/home
> Jan 16 01:19:00 vosztok nilfs_cleanerd[29597]: shutdown
> Jan 16 17:51:54 vosztok nilfs_cleanerd[4254]: close /var/run/nilfs_clea=
nerd-dm-1.pid
> Jan 16 17:51:54 vosztok nilfs_cleanerd[4254]: unlink /var/run/nilfs_cle=
anerd-dm-1.pid
> Jan 16 17:51:54 vosztok nilfs_cleanerd[4254]: shutdown
> Jan 16 17:54:34 vosztok nilfs_cleanerd[9661]: start
> Jan 16 17:54:35 vosztok nilfs_cleanerd[9661]: open /var/run/nilfs_clean=
erd-dm-1.pid
>=20
> And the module gave these messages:
>=20
> Jan 16 17:54:34 vosztok kernel: NILFS warning (device dm-1): nilfs_sync=
_super: barrier-based sync failed. disabling barriers
> Jan 16 17:54:34 vosztok nilfs_cleanerd[9661]: start
> Jan 16 17:54:35 vosztok nilfs_cleanerd[9661]: open /var/run/nilfs_clean=
erd-dm-1.pid

Hmm, the line
> Jan 16 01:19:00 vosztok nilfs_cleanerd[29597]: cannot create cleanerd o=
n /dev/vosztok_vg/home

seems to show a related or unrelated abnormal state of the GC.
But I think we need different information to identify the problem.

> Please help me, (as tough i love nilfs even after this short
> interval of use, this quite reduces the user experience :) ) and tell
> me how, and what information should I provide to help you fix the
> problem.

Thanks :), we'll ask for your help later.

Regards,
--=20
Ryusuke Konishi
NILFS team NTT
http://www.nilfs.org/
