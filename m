From: Alexander Schier <alex-W0ZHf6uU1cg@public.gmane.org>
Subject: Re: Kernel Bug while deleting files (with rsync)
Date: Thu, 27 Mar 2008 14:23:27 +0100
Message-ID: <20080327132327.GA3562@laxu.de>
References: <20080325102553.GA10853@laxu.de>
	<1206445521.3131.60.camel@localhost.localdomain>
	<20080326.220532.62697306.ryusuke@osrg.net>
	<20080326164723.GA31518@laxu.de>
	<1206587021.3100.47.camel@localhost.localdomain>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1206587021.3100.47.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
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
On Thu, Mar 27, 2008 at 12:03:41PM +0900, Ryusuke Konishi wrote:
> Thanks!
> =EF=BB=BFAccording to your log, the problem is a reference count leak o=
f a
> b-tree node buffer.
>=20
> Could you tell me the concrete way to reproduce the bug with rsync ?=20
I have ~5 GB data at the nilfs2, with one snapshot. It was intended for b=
ackup,
with rsyc from another host:
rsync -avPz --delete /home/ hostwithnilfs2:/media/backup/home/

but it tells me ca. 5 deleted files, and then the BUG is triggered.
Then i cannot umount the filesystem, rmmod does not work, and shutdown
hangs, too.

Alex
