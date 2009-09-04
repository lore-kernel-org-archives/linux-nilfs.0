From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Changing date/time = complete data loss?
Date: Fri, 04 Sep 2009 17:47:17 +0900 (JST)
Message-ID: <20090904.174717.07553199.ryusuke@osrg.net>
References: <debc30fc0909030427v2814dbd8ja7345f0b69cd4a7d@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <debc30fc0909030427v2814dbd8ja7345f0b69cd4a7d-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Hi,
On Thu, 3 Sep 2009 07:27:32 -0400, J=E9r=F4me Poulin wrote:
> Yesterday I was installing a router in which there was OpenVPN
> service, and had to generate a new certificate, those router seem to
> have the date/time set differently in a way I have to undo my clock of
> 4 hours (I am at GMT-4) so the certificate are valid and not from the
> future and prevent OpenVPN to connect, so I changed the time, did my
> operations, it took 1 hour, and reverted to my real time using
> ntp-client.
> When the protection period expired I noticed in my lssu-gtk that the
> bands were looking like below:
> =3D=3D=3D=3D|..................=3D=3D=3D=3D=3D
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D...............
> .......=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =

> =3D means used and . unused, as you can see there was a band in the
> middle which was used then unused space again, the log was not
> contiguous, I checked lssu and have seen the time was in the future
> for that middle band, I didn't take care about this and let it do its
> usual garbage collection, when I came back home and turned on my
> laptop, it took 30 minutes and started to GC the middle part, 15
> minutes later I had some applications starting to segfault for "no
> actual reason", looked at the log, there was a lot of btree errors in
> NilFS, so I decided to reboot in single mode to mount the partition
> again, it complained I was mounting a FS with errors, so I remounted
> read-only and decided to backup everything.
>
> At this point I noticed most of the data on the partition was already
> corrupt, so I dd'ed /dev/zero, mkfs.nilfs2 and restored everything
> remembering I should never change date again until further notice! At
> least I had a backup from yesterday and the only changes I had since
> are stuff I can acquire elsewhere (backup of router config and
> certificate I will regenerate and change on router.)
> =

> I guess nilfs_cleanerd should use the internal sequence number instead
> of the timestamp which can change to do the garbage collection, is
> that a good guess?
> =

> Was that a known issue? I'll take this time to ask, even if it would
> probably not have fixed the problem, if a fsck.nilfs is underway?

Thank you for your feedback.

The cleanerd tries to reclaim the oldest segment comparing timestamps
recorded on sufile.  So the above behavior is a natural result if you
turn back the system clock.

In theory, this does not matter because nilfs is designed so that the
userland cleaner daemon can select arbitrary in-use segment for
garbage collection.  The current cleanerd is using the ring-buffer
algorithm just as a matter of convenience, but it's not necessary for
proper GC operation.

After the recent analysis of the FS-corruption problem, I now suspect
that the corruption is caused by some problem of read routines in
which nilfs wrongly refers to the blocks that GC has already moved.

The above allocation pattern shortens margin, I mean, the time period
from when GC marks the segments freed, to when nilfs actually
overwrites them with new logs.  I think that is the reason why
rewinding of clock increases probability of the FS-corrutpion.

I will continue to look into the problem of read routines and make
patches to settle this problem.

Thanks,
Ryusuke Konishi
