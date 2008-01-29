From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Other strange things
Date: Tue, 29 Jan 2008 16:53:37 +0900
Message-ID: <1201593217.3629.102.camel@localhost.localdomain>
References: <20080116222500.60e78090@vosztok>
	<1200556717.3085.94.camel@localhost.localdomain>
	<1200561294.3085.131.camel@localhost.localdomain>
	<20080117201046.046f5a55@vosztok>  <20080125124652.5899a66b@vosztok>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20080125124652.5899a66b@vosztok>
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

On Fri, 2008-01-25 at 12:46 +0100, Gergely G=E1bor wrote:
> On Thu, 17 Jan 2008 20:10:46 +0100
> Gergely G=E1bor <elentirmo.gilgalad-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>=20
> Hello!
>=20
> I have made a massuve uptime of 4 days by now, altough i didn't=20
> run rtorrent. yesterday (early today) i noticed that the garbage
> collector might have not honoured the 3 day protection interval,
> but i'm not sure... if it will be repeated, I'll send you lots=20
> of logs.
>=20
> So, tried to start rtorrent now, dut it instantly quit, and the=20
> console was flooded with nice traces and stuff... I attach a=20
> slabinfo and a kern.log. They are big, so i bzip them.
>=20
> ... one other idea. i save this letter now, and sent it after=20
> a restart, with some status report then...
>=20
> rtorrent escapes during the hash check... so it is a filesystem
> corruption or similiar. too bad there is no fsck yet. well, I=20
> make a snapshot, and delete the affected files, and see if the
> problem arises even after that.
>=20
> Best regards:


That's too bad.
But thanks for reporting the problem.

Your report told us that NILFS still has a potential BUG which may
lead to an FS-corruption.

Unfortunately, the BUG point printed in your log was a very general
one in a common b-tree lookup routine, so it's hard to identify
the cause from that.

There are many possibilities.  In the worst case, the cleaner may
degenerate the corruption.

So, I recommend you to make backups of the current mount and=20
important snapshots while you can.
It should be done through ro-mounts or with -i mount option=20
for a rw-mount to turn off the cleaner (see example below).

 # mount -t nilfs2 -i /dev/xxx /mount-point

Though removal of broken files may remedy the problem,
it also has a possibility to mark blocks terminated which is still
in use.  In the latter case, the cleaner might reclaim the in-use
blocks wrongly.

Sorry for not supporting fsck.
At least for the present, please make do with means of backup or=20
others.

Best regards.
--=20
Ryusuke Konishi
NILFS team NTT
http://www.nilfs.org/
