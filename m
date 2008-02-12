From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Deadlocks! help, please!
Date: Tue, 12 Feb 2008 21:57:57 +0900
Message-ID: <1202821077.9432.99.camel@localhost.localdomain>
References: <20080121.140129.01311807.ryusuke@osrg.net>
	<20080122000052.215084db@vosztok>
	<1200970920.2844.59.camel@localhost.localdomain>
	<20080205.182829.44149266.ryusuke@osrg.net>
	<20080207110930.3df85a70@vosztok>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20080207110930.3df85a70@vosztok>
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

Hi G=E1bor,

On Thu, 2008-02-07 at 11:09 +0100, Gergely G=E1bor wrote:
> I have installed it (with some other patches: the one for the mount opt=
ion bug,=20
> and other for udivdi (that is needed to link the module properly at me)=
 and=20
> started a download in rtorrent for the night. It has not ferrzed, but i=
 have=20
> experianced massive memory leaks, either on the cleaner, or int he modu=
le.
>  now i'm trying to reproduce the bug with fs running without cleaner.=20
> if it will not arise in a day, i'll try the cleaner as well.=20
> I have a question about the cleaner, that might help my find the bug:
>  can I send a signal to the cleaner to finish and commit unfinished cha=
nges and
> and can I manually start a cleaner (possibly with valgrind)?

Yes, you can manually start and shutdown the cleaner.

> Can I send signals to pause cleaning (for example I go on battery), and=
 to resume?

No, the cleaner doesn't support pause/resume by signal, however=20
you can do the same thing by the manual shutdown and restart.

> This leak error ate up all my memory, and forced all apps to swap, slow=
ing the
>  system down so much, that it took almost an hour to exit rtorrent...
> unfortunalety i forgot to vmstat after the kill of the cleaner, before=20
> umounting the fs. If I kill the fs will it not leave garbage (i mean ba=
dly formed
> entries in the log) after itself if it will, will those entries be clea=
ned up?=20

Yes, they will.  NILFS is designed not to leave garbage.
However, the NILFS module holds memory for b-tree pages globally, so it
may eat some memory even after umount.

> after i umounted the partition, i had my ram back cleanly (i'd say that=
 this=20
> was possibly the cleaner, as the module was left in memory even after t=
he umount,
>  still the ram wasn't wasted...) Is that possible, that the ram was not=
 wasted,=20
> but the cleaner/fs is bit inefficient, or can't be made simpler, and I =
should=20
> buy more ram? it ate ~440Mb of memory. (i have 512Mb)

OK, I will review the patch to find out an elemental leak bug.
For now, the latest (unpublished) version seems to work properly=20
in my environment.

We will soon release nilfs-2.0.0.
I'd like to clean things up with the release.
Since we don't want -testing release anymore, we may release it
even if the problem ramains.
If I can find the leak bug in time, I will include it in the release.

> Otherwise the patch seems to work cleanly I haven't applied the
> previous patch=20
> you proposed, should I have tried? (it gave errors)

You don't have to apply the previous patch;  the new patch includes the
previous change.

> Possibly if you set up a git/hg/other repo, life'd be more convinient.
> they made my life simpler even in my small school projects.

Sorry for inconvenience.
We also have a plan to make a git (or other kind of) repository
after it gets settled.  So please wait a little longer.

Best regards,
--=20
Ryusuke Konishi
NILFS team NTT
http://www.nilfs.org/
