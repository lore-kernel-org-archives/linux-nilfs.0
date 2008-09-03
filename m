From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: directory entries
Date: Thu, 04 Sep 2008 01:32:50 +0900 (JST)
Message-ID: <20080904.013250.10595435.ryusuke@osrg.net>
References: <20080901110730.GA21008@aardappel.13thmonkey.org>
	<20080902.015156.126164477.ryusuke@osrg.net>
	<20080902150226.GA28292@aardappel.13thmonkey.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20080902150226.GA28292-5cYspOl2ggRz6xQTk39kMVfVdRo2wo/d@public.gmane.org>
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

Hi Reinoud,

On Wed, 3 Sep 2008 14:39:40 +0200, Reinoud Zandijk wrote:
> Hmmm, I forgot that the virtual adresses will get multiplexed unless new 
> virtual adresses are used... that suxs. So basicly each virtual address 
> needs an indicator on which head its on and if its not the current head, a 
> new virtual address needs to be assigned on write... hmmm
> 
> maybe we should cancel the idea of multiple heads for now? :)

Yep, so it's classified to the future TODOs :)


On Tue, 2 Sep 2008 17:02:26 +0200, Reinoud Zandijk wrote:
> > > The extra meta file sounds good but i dont like the `userland' DB solution; 
> > > it would make nilfs dependent on DB4 (or the like) and it could make it 
> > > non-selfcontaining.
> > 
> > I think we can introduce the tags without bringing them into the
> > NILFS2 kernel module.  Only the mount program and snapshot tools need
> > the tags, and the conversions from tags to checkpoint numbers can be
> > done in userland.
> 
> i'd still opt the kernel metafile solution. The best way is also the 
> easiest i think :
> 
> struct nilfs_checkpoint_list {
>         __le64 ssl_next;
>         __le64 ssl_prev;
> };
> 
> struct nilfs_checkpoint {
>         __le32 cp_flags;
>         __le32 cp_checkpoints_count;
>         struct nilfs_checkpoint_list cp_snapshot_list;
>         __le64 cp_cno;
>         __le64 cp_create;
>         __le64 cp_nblk_inc;
>         __le64 cp_inodes_count;
>         __le64 cp_blocks_count;         /* Reserved (might be deleted) */
> 
>         /* Do not change the byte offset of ifile inode.
>            To keep the compatibility of the disk format,
>            additional fields should be added behind cp_ifile_inode. */
>         struct nilfs_inode cp_ifile_inode;
> 
> 	struct nilfs_checkpoint_list cp_head_list;
> 	char cp_headname[16];
> };
>
> So just add a `cp_head_list' inside the nilfs_checkpoint info and a head 
> name. (pitty one can't reorder the entries). If creating a new checkpoint 
> one can update the mounted checkpoint's `cp_head_list' to point to the 
> newly added checkpointnr and write out the new checkpoint. This checkpoint 
> also stores the name so in case the chain is lost due to a software bug or 
> whatever, it can be rebuild. It is also handy for dumping snapshots with 
> their head names.

Sure, it's the primary way.

It has an advantage to list tag names in the lscp command.
But, as you guessed, this is a bit restrictive (i.e. limited length
and single tag per snapshot) as well as it fattens the cpfile.

I won't reply NAK, but I want to reserve this as a last measure and
discuss alternatives carefully because reverting disk format is almost
impossible.

> > Adding the tag file is not bad idea, but this would increase the
> > performance penalty as well as the lines of kernel code.  That is the
> > reason why I hesitate to admit this meta file.
> 
> Is there a performance penalty then? It is at most only checked at 
> mount/unmount time....

I worried about penalties against segment constructions.  But I may do
not have to get so nervous.  At least we have a way around; unless we
write the HEAD tag on the file, we can make updates of the tag file
infrequent.  The update will be needed only when switching to other
forks or manipulating tags.

Cheers,
Ryusuke
