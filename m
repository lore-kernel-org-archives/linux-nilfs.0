From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: directory entries
Date: Tue, 02 Sep 2008 01:51:56 +0900 (JST)
Message-ID: <20080902.015156.126164477.ryusuke@osrg.net>
References: <20080826132944.GA17045@aardappel.13thmonkey.org>
	<20080901.143956.08023399.ryusuke@osrg.net>
	<20080901110730.GA21008@aardappel.13thmonkey.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20080901110730.GA21008-5cYspOl2ggRz6xQTk39kMVfVdRo2wo/d@public.gmane.org>
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
To: reinoud-S783fYmB3Ccdnm+yROfE0A@public.gmane.org
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

On Mon, 1 Sep 2008 13:07:30 +0200, Reinoud Zandijk wrote:
> Dear folks, dear Ryusuke,
> 
> On Mon, Sep 01, 2008 at 02:39:56PM +0900, Ryusuke Konishi wrote:
> > Or, we can just think the ``main'' stream was replaced by the
> > continued snapshot every time it is mounted in rw-mode.  In this case,
> > the head is regarded to be moved to the new (latest) checkpoint.  This
> > is actually convenient for the recovery in which a user pushed
> > ``recover button'' for the snapshot.
> > 
> > Note that even the old head becomes a plain checkpoint, it's still
> > mountable and continuable again by being changed to a snapshot.
> 
> sounds reasonable yes... but why would that give problems with the DAT 
> file? If you allways load the DAT, CP and SU descriptors from the latest 
> checkpoint as recorded in the superroot even when mounting a snapshot 
> read-write all is ok i think.

Good question.
Without garbage collection, things become simple like that.

With the garbage collection, however, the older versions of the DAT,
SU and CP cannot be selected because part of their entries may be
invalidated or reused; they will become meaningless by a GC.
Consequently, the NILFS2 GC removes the old blocks belonging to these
meta data files or old super roots instead of moving them to a new
log.  As the result, only the latest files are available against these
three files.

> The `old head' will be preserved initially as 
> will be all allocations. If you want to keep the old head you'll have to 
> make it a snapshot and thus protect all entries that have the old head 
> snapshot in their intervals.

Yeah, but I think we don't have to necessarily keep the old
checkpoint.  Even if we keep the previous head, changing its
checkpoint to a snapshot can be done when appending a writable
snapshot to the head.

> Changing the `old head' snapshot to a checkpoint will just result in the 
> cleaned up AFAICS. Do you expect trouble with the current interval code in 
> the cleaner?

Sorry for confusing you.  I mean copying the snapshot to a new
checkpoint which is appended after the latest checkpoint; I don't
mean downgrading the old snapshot to a checkpoint.

Because the NILFS2 GC never reclaims the current checkpoint (the
current head), we don't have to change the continued head to a
snapshot until switching it again to other snapshots.

>  I can't see why the DAT would need change.

As I mentioned above, we cannot use the past version of the DAT.  So,
to allow multiple forks, we have to maintain multiple lifetime
information for each virtual block address in the single DAT.

> > To that end, this file must be extended to handle multiple lifetimes
> > per block, and this would complicate the DAT.  Without the DAT file,
> > things are not so difficult.  This would be achieved in a future, but
> > in the meantime, I'll use rsync to continue snapshots ;)
> 
> are you thinking about removing the DAT file?? I thought it was the 
> addition to v2.0 :)

No, it was achieved in v1.0 :)
Unfortunately we cannot go back to the world without the GC, so I
cannot remove the DAT file.

> > > We could also give snapshot/head a name; then 
> > > increasing checkpoints is no issue if you keep the head name
> > 
> > Yeah, this would be possible by adding another meta data file
> > (e.g. tag file) which maps the HEAD names to checkpoint numbers of
> > snapshots.  When keeping multiple writeable snapshots, this kind of
> > extension would be demanded than now.  However, I'd rather do this in
> > userland with a regular file (i.e. a DB file) or with TAG files each
> > of which simply records a checkpoint number.
> 
> The extra meta file sounds good but i dont like the `userland' DB solution; 
> it would make nilfs dependent on DB4 (or the like) and it could make it 
> non-selfcontaining.

I think we can introduce the tags without bringing them into the
NILFS2 kernel module.  Only the mount program and snapshot tools need
the tags, and the conversions from tags to checkpoint numbers can be
done in userland.

Adding the tag file is not bad idea, but this would increase the
performance penalty as well as the lines of kernel code.  That is the
reason why I hesitate to admit this meta file.

Regards,
Ryusuke Konishi
