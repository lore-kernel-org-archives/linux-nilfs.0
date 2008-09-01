From: Shaya Potter <spotter-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
Subject: Re: directory entries
Date: Mon, 01 Sep 2008 01:51:51 -0400
Message-ID: <48BB82F7.4070607@cs.columbia.edu>
References: <20080825155243.GA12855@aardappel.13thmonkey.org>	<20080826.192942.104752679.ryusuke@osrg.net>	<20080826132944.GA17045@aardappel.13thmonkey.org>
	<20080901.143956.08023399.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20080901.143956.08023399.ryusuke-sG5X7nlA6pw@public.gmane.org>
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

As I mentioned a while ago, we jury rigged writable snapshots by 
combining nilfs w/ unionfs.

Instead of writing to the root of the file system, you right to a subdir.

so we start w/ /nilfs/t0

when we want to rollback and continue to work

we mount the ro snapshot on /s0 and create /nilfs/t1 use unionfs to 
union together /s0 (ro) and /nilfs/t1 (rw).

Ryusuke Konishi wrote:
> Dear Reinoud,
> 
> On Tue, 26 Aug 2008 15:29:44 +0200, Reinoud Zandijk wrote:
>>>> But how to number checkpoints and snapshots then?
>>> I don't like CVS revision like extension.
>>> Just appending derived checkpoints (from a snapshot) to current head,
>>> seems to be preferable.  What do you think?
>> For option (2) new data/modifications can we written out only under the old 
>> checkpoint number like the cleaner does.... but if you create a new 
>> checkpoint for it ... i dunno; that would break the rule `the last 
>> checkpoint is the head'.
> 
> Or, we can just think the ``main'' stream was replaced by the
> continued snapshot every time it is mounted in rw-mode.  In this case,
> the head is regarded to be moved to the new (latest) checkpoint.  This
> is actually convenient for the recovery in which a user pushed
> ``recover button'' for the snapshot.
> 
> Note that even the old head becomes a plain checkpoint, it's still
> mountable and continuable again by being changed to a snapshot.
> 
> To realize writable snapshots on this interpretation, However, we have
> to solve technical problems around the DAT file.  The DAT file, which
> is a table file to map virtual disk addresses to actual disk addreses,
> also maintains lifetime information of each disk block, which is used
> to perform garbage collection.
> 
> To that end, this file must be extended to handle multiple lifetimes
> per block, and this would complicate the DAT.  Without the DAT file,
> things are not so difficult.  This would be achieved in a future, but
> in the meantime, I'll use rsync to continue snapshots ;)
> 
>> We could also give snapshot/head a name; then 
>> increasing checkpoints is no issue if you keep the head name
> 
> Yeah, this would be possible by adding another meta data file
> (e.g. tag file) which maps the HEAD names to checkpoint numbers of
> snapshots.  When keeping multiple writeable snapshots, this kind of
> extension would be demanded than now.  However, I'd rather do this in
> userland with a regular file (i.e. a DB file) or with TAG files each
> of which simply records a checkpoint number.
> 
> 
> Regards,
> Ryusuke Konishi
> _______________________________________________
> users mailing list
> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
> https://www.nilfs.org/mailman/listinfo/users
