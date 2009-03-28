From: nilfs-MZZvbRqs/9F0RdzJJlgK+g@public.gmane.org
Subject: [SPAM]  Re:  continuous backup solution with nilfs
Date: Sat, 28 Mar 2009 15:51:11 +0100
Message-ID: <4844.84.133.179.213.1238251866.squirrel@ssl.its-beck.de>
References: <4577.84.133.242.204.1237943266.squirrel@ssl.its-beck.de>
	<4701.84.133.208.102.1238029603.squirrel@ssl.its-beck.de> 
	<200903271939.10744.Martin@lichtvoll.de>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <200903271939.10744.Martin-3kZCPVa5dk2azgQtNeiOUg@public.gmane.org>
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
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

Hi,

> inconsistent filesystem in snapshooted loop files? You'd need xfs_freeze
> before syncing the raid to get a consistent one, I believe.

well yes, it is inconsistent by the definition of the top filesystem. It
will always be. Running xfs_freeze / sync every 5 seconds is not an
option, and won't be in sync with the nilfs cps anyway.

But: You can chose the checkpoint you restore wisely. lscp lists the
amount of block changes, so you can take the "least corrupted" cp
(possibly a practically clean one). I even think about disabling the
journal to get better space usage. After all, the nilfs loop file is one
big journal.

The restore scenarios where this concept works are one of these:

 * Your server went up in flames / flood / coffee accident. The backup is
a few seconds old and will behave like a crashed / powered off system. It
is available on a separate storage system not affected by the outage. No
one will care about inconsistency :-)

 * New server. Some user having root privileges does a funny thing he saw
on the internets in the shell and you realize he deleted all files,
including the operating system. This one is particulary hard for guys who
think RAID is a backup solution. Good thing you had him on an
indestructible block device.

 * Some collegues are creating and deleting files. They need the
blue-screen operating system for a server, so you put them on a VM.
Suddenly one needs a file he created 290 seconds ago and deleted 65
seconds ago. You'll be the hero of the day, or burned for being a witch.
Or fired, because the file was meant to be lost in an accident, and you
were supposed to say "we're doing nightly backups, there's nothing I can
do about it".

> One thing: Can't you use LVM snapshots in a similar way? Hmmm, I think
> performance would crawl with more than a few snapshots.

I didn't dare to try several thousand snapshots in LVM ;-) Yes, it would
be more appropriate to do this directly with a block device driver, but I
haven't come across one doing this. "NILBD" anyone?

I think the concept needs a bit of improvement, though. If you have the
option of a "smart" iSCSI / AoE storage (being a server you can install
linux on) you can do the nilfs / loop / mdadm stuff on that one and offer
the block device to other servers as a service.

This allows physical servers with any OS doing iSCSI in the concept plus
hard privilege serparation: The guy managing the indestructible block
device servers can be totally independant. So if the local admin runs
amok, he has no ability to take the backup with him. He doesn't even need
to know the iSCSI block device can be restored.

A major issue is the space requirement. Constantly changing databases fill
up the volume quickly. Well, my two here are really worst case, with
several hundred users changing lists all day and a worker process spinning
on filling and regenerating the same table 12 hours a day (which should be
a memory table, but isn't). As I said, disabling the journal might be an
option.

Regards,

Pierre Beck
