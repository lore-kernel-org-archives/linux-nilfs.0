From: Reinoud Zandijk <reinoud-S783fYmB3Ccdnm+yROfE0A@public.gmane.org>
Subject: Re: directory entries
Date: Tue, 2 Sep 2008 17:02:26 +0200
Message-ID: <20080902150226.GA28292@aardappel.13thmonkey.org>
References: <20080826132944.GA17045@aardappel.13thmonkey.org>
	<20080901.143956.08023399.ryusuke@osrg.net>
	<20080901110730.GA21008@aardappel.13thmonkey.org>
	<20080902.015156.126164477.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0150338645=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20080902.015156.126164477.ryusuke-sG5X7nlA6pw@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Mime-version: 1.0
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org


--===============0150338645==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Ryusuke, hi folks,

On Tue, Sep 02, 2008 at 01:51:56AM +0900, Ryusuke Konishi wrote:
> > sounds reasonable yes... but why would that give problems with the DAT 
> > file? If you allways load the DAT, CP and SU descriptors from the latest 
> > checkpoint as recorded in the superroot even when mounting a snapshot 
> > read-write all is ok i think.
> 
> Good question.
> Without garbage collection, things become simple like that.
> 
> With the garbage collection, however, the older versions of the DAT,
> SU and CP cannot be selected because part of their entries may be
> invalidated or reused; they will become meaningless by a GC.
> Consequently, the NILFS2 GC removes the old blocks belonging to these
> meta data files or old super roots instead of moving them to a new
> log.  As the result, only the latest files are available against these
> three files.

True, in my implementation i allways go for the latest checkpoint's DAT, CP 
and SU even when mounting a previous snapshot since older ones don't make 
sense anymore as you already stated.

> >  I can't see why the DAT would need change.
> 
> As I mentioned above, we cannot use the past version of the DAT.  So,
> to allow multiple forks, we have to maintain multiple lifetime
> information for each virtual block address in the single DAT.

I dont think thats needed. In the case with no history retention at all all 
snapshots will be retained anyway regardless of how they are created/forked 
right? So each snapshot keeps mountable and updateable. There will only be 
a number of ifiles alive for each snapshot one like its already now.

If you'd like you modify the GC to keep say the history for a specified 
time it only means that it needs to keep the history for the specified time 
for all the snapshots that can be mounted as `head'.

> > The extra meta file sounds good but i dont like the `userland' DB solution; 
> > it would make nilfs dependent on DB4 (or the like) and it could make it 
> > non-selfcontaining.
> 
> I think we can introduce the tags without bringing them into the
> NILFS2 kernel module.  Only the mount program and snapshot tools need
> the tags, and the conversions from tags to checkpoint numbers can be
> done in userland.

i'd still opt the kernel metafile solution. The best way is also the 
easiest i think :


struct nilfs_checkpoint_list {
        __le64 ssl_next;
        __le64 ssl_prev;
};

struct nilfs_checkpoint {
        __le32 cp_flags;
        __le32 cp_checkpoints_count;
        struct nilfs_checkpoint_list cp_snapshot_list;
        __le64 cp_cno;
        __le64 cp_create;
        __le64 cp_nblk_inc;
        __le64 cp_inodes_count;
        __le64 cp_blocks_count;         /* Reserved (might be deleted) */

        /* Do not change the byte offset of ifile inode.
           To keep the compatibility of the disk format,
           additional fields should be added behind cp_ifile_inode. */
        struct nilfs_inode cp_ifile_inode;

	struct nilfs_checkpoint_list cp_head_list;
	char cp_headname[16];
};

So just add a `cp_head_list' inside the nilfs_checkpoint info and a head 
name. (pitty one can't reorder the entries). If creating a new checkpoint 
one can update the mounted checkpoint's `cp_head_list' to point to the 
newly added checkpointnr and write out the new checkpoint. This checkpoint 
also stores the name so in case the chain is lost due to a software bug or 
whatever, it can be rebuild. It is also handy for dumping snapshots with 
their head names.

It hardly takes any coding and has minimal inpact on the rest.

> Adding the tag file is not bad idea, but this would increase the
> performance penalty as well as the lines of kernel code.  That is the
> reason why I hesitate to admit this meta file.

Is there a performance penalty then? It is at most only checked at 
mount/unmount time....

BTW, its a pitty the data structures are not tagged and/or versioned :-/ it 
would be handy to be able to recognize and reorganise things.

With regards,

Reinoud

--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (NetBSD)

iQEVAwUBSL1VgoKcNwBDyKpoAQKthQgAmeZ4o94kaRhU6th5RYH7HqbIZOXDEmUb
3OqFOlrjTnUmXbSaJZjIWLZlpWEX2vLVqgIHyErkx8ta7DkVvyysMvkSF7lkPyeO
tiSMfCGrowgjCaALZBfmz1adFrUsAm35h0cmT7ckbuW+KlVQhDjG/8Kyi0UNU8CO
NQJIU89VPtUUjtndWdx3B4hawwhiZTqMpUdJg+NLw0JQ7n5cy4z4o/5aVoT1Zj6i
DhQnj7nGJDRPqjQNHv1rW4yHbINZyYVxXBeVY4x7H4vGMjuDuuft/EzIRg1Dp3a/
RXbwM3SoWRVojI16i9GeG1VmfEQ/eb0g4ewX/3KvgaDXc3yGMrgEcQ==
=90an
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--

--===============0150338645==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============0150338645==--
