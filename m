From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Dump tools for checkpoints
Date: Sat, 14 Mar 2009 00:33:35 +0900 (JST)
Message-ID: <20090314.003335.122421671.ryusuke@osrg.net>
References: <2883.84.133.202.72.1235869032.squirrel@ssl.its-beck.de>
	<20090308.143916.113539820.ryusuke@osrg.net>
	<20090312152618.GA25317@aardappel.13thmonkey.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090312152618.GA25317-5cYspOl2ggRz6xQTk39kMVfVdRo2wo/d@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, reinoud-S783fYmB3Ccdnm+yROfE0A@public.gmane.org
Cc: nilfs-MZZvbRqs/9F0RdzJJlgK+g@public.gmane.org

Hi, Reinoud,
On Thu, 12 Mar 2009 16:26:18 +0100, Reinoud Zandijk wrote:
> Dear Ryusuke, dear Pierre,
> 
> On Sun, Mar 08, 2009 at 02:39:16PM +0900, Ryusuke Konishi wrote:
> > Actually I want to realize this feature in some form, and had
> > considered details several times.  What I want to realize is
> > checkpoint based replication including incremental dumping and
> > restoration of file system states.
> 
> depends on the granlarity of the backup; do you want backup time backups or
> checkpoint/snapshot based?

My image of the checkpoint based replication (increment dumping and
restoration) is as follows:

 # sendcp -i <cno-from> <cno-to> [device] | ssh remote-host recvcp [device]

Not backup time backups.  But it's not important for me because time
and checkpoint number is convertible by the checkpoint file.
(though reverse conversion from time to checkpoint number is not efficient)

> The first could be implemented (though not watertight) by comparing
> the DAT files between checkpoint P and Q at backup time. If while
> parsing the filetree at Q a change is noticed in the DAT allocation
> of the vblock the file is changed.

One problem is the DAT file does not have generations.

As I mentioned in the previous mail, past versions of DAT is not
maintained by nilfs though it is written in a copy-on-write manner; GC
breaks past versions of the DAT file.

if we continuosly replicate blocks from client to server, this might
become possible because keeping old DAT blocks would not suffer big
overhead and GC for the DAT (partially having past versions) would not
become so hard.

On the other hand, it is possible to extract vblocks (and their
pblocks) within a period from the DAT file because it has lifetime
information for each vblock.  It's not efficient because it requires
full scan of DAT, but seems to be a ponderable if we give priority to
keep the current design.

Without garbage collection, things are much easier.  It is possible
just by scanning delta from the log at P to the log at Q. sigh.

> The 2nd is easier and more logical; a snapshot is marked as the last
> backup time. Then when the backup is updated, the checkpoints are
> walked and -just like the cleaner- the diff is cleaned up between
> this snapshot and the next backup snapshot. After the backup the old
> backup snapshot is either deleted or is unmarked for backup. This
> way the backup granularity can be controlled by the user in the time
> between backup snapshots.
>
> just an idea, possible? problems?
> 

This is closer to what I want to do, but I'd like to extract delta in
block level without comparing trees.  B-trees can undergo a great
transformation.  So, it seems neither easy nor simple.  If give up the
efficient B-tree comparision, rsync seems enough to me.

In addition, to compare two filesystem generations entirely, the
compare routine must know some meta data structures.  This is likely
to make nilfs bigger and more complex.

I even feel these considerations are iffy.  Maybe we should go into
each approach more.


Regards,
Ryusuke
