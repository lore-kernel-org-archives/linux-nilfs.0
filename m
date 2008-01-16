From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: reserved space
Date: Wed, 16 Jan 2008 11:45:59 +0900
Message-ID: <1200451559.2920.79.camel@localhost.localdomain>
References: <20080115191828.0a47569d@enyergija>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20080115191828.0a47569d@enyergija>
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

Hi!

On Tue, 2008-01-15 at 19:18 +0100, Gergely G=E1bor wrote:
> Hello!
>=20
> i'm migrating to nilfs on one of my machjines right now, and when I was=
 creating the filesystem,=20
> i met an option of mkfs.nilfs, "-m" that controls the reserved segment =
percentage.
> can this amount be adjusted later? this space is virtually lost, as thi=
s is kept always free for
> the GC to be able to work?

Thanks for your interest.

As you mentioned, the -m option of mkfs.nilfs2 is to set a ratio of
reserved disk space primary for the GC.
To be precise, it works as a margin rather than a fixed work space
for the GC.=20

In this meaning, it is similar to those of ordinary Unix filesystems=20
including ext3 and others;  it makes previledged or removal operations
possible in near disk full conditions.

Unfortunately, it cannot be adjusted later at this point.
(The tool like "tune.nilfs2" that changes parameters written in a=20
 superblock, is not yet implemented.)

> My 2nd question is: what is /usr/bin/lssu supposewd to do?

lssu is an administrative tool to display usage state of segments.
In nilfs, disk space is divided into multiple segments with an
equal size. (We call them "full segments" for convenience).

Each line in lssu output corresponds to a (full) segment, and shows
its index number, state, usage, and a last modified time.

Usually you don't have to use the tool, but it is convenient to view
broadly how the disk space is used as a log.

Enjoy,
--=20
Ryusuke Konishi
NILFS team NTT
http://www.nilfs.org/
