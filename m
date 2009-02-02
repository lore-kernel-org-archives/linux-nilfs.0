From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: NilFS cleanerd bugreport
Date: Mon, 02 Feb 2009 16:24:55 +0900 (JST)
Message-ID: <20090202.162455.88658401.ryusuke@osrg.net>
References: <20090128205223.GA416@aardappel.13thmonkey.org>
	<20090130.231853.99024523.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090130.231853.99024523.ryusuke-sG5X7nlA6pw@public.gmane.org>
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

Hi,
On Fri, 30 Jan 2009 23:18:53 +0900 (JST), Ryusuke Konishi wrote:
> Hi Reinoud,
> On Wed, 28 Jan 2009 21:52:23 +0100, Reinoud Zandijk wrote:
> > Dear folks, dear Ryusuke,
> > 
> > I've found a bug in the cleanerd/nilfs interaction that might give rise to the
> > various problems we've seen recently with the cleanerd. It comes down to the
> > wrong counting of the number of dirty segments and the wrong counting of the
> > number of checkpoints.
> > 
> > I created this disc using the NiLFS version 2.05 with 2.06 userland (AFAIK)
> > with mkfs.nilfs and created a sparse file on it with my sparse file generator
> > I created for UDF testing. It dismounted fine giving a nilfs_dump
> > `vnd0e-dump-3'. When i remounted it again, the cleanerd started after a while
> > and after unmounting it gives `vnd03-dump-3-cleanerd'. A diff shows:
> <snip>
> > And the su and cp files give:
> > 
> > @@ -30743,34 +31480,34 @@
> >  Reading file `SU.out` for 1 blocks (4 Kb)
> >  
> >  	SU file dump
> > -		nclean       491
> > -		ndirty       8
> > +		nclean       496
> > +		ndirty       21474836483
> >  		last alloced 7
> >  
> >  		Segment 0
> > -		Last modified Sun Jan 25 17:05:28 2009
> > -		Containing nblks 2047
> > -		Flags            0x2<DIRTY>
> > +		Last modified Thu Jan  1 01:00:00 1970
> > +		Containing nblks 0
> > +		Flags            0x0
> > 
> > ......
> > 
> > @@ -30789,136 +31526,72 @@
> >  
> >  Reading file `CP.out` for 1 blocks (4 Kb)
> >  	CP file dump
> > -		Number of checkpoints 8
> > +		Number of checkpoints 8589934596
> >  		Number of snapshots   0
> >  
> >  		Checkpoint number    1
> > -		Flags                0x0
> > +		Flags                0x2<INVALID>
> >  		Checkpoints in block 0
> >  		Created at Sun Jan 25 17:05:10 2009
> >  		Blocks incremented   11
> >  		Inodes count         3
> >  		Blocks count (red.)  9
> > 
> > ny idea as to if and why this can happen?
> 
> looks underflow or collision of updates.

This turn out to be the bug of counter operations on the cpfile and
sufile.

Here, I attach a test patch to fix the problem.
After some tests and submission to -mm tree, I'll push it to the git
repo.

Reinoud, thank you for finding this problem.

Regards,
Ryusuke Konishi

---
 fs/cpfile.c |    2 +-
 fs/sufile.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cpfile.c b/fs/cpfile.c
index 1e9ce4c..45bfe82 100644
--- a/fs/cpfile.c
+++ b/fs/cpfile.c
@@ -357,7 +357,7 @@ int nilfs_cpfile_delete_checkpoints(struct inode *cpfile,
 		kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
 		header = nilfs_cpfile_block_get_header(cpfile, header_bh,
 						       kaddr);
-		le64_add_cpu(&header->ch_ncheckpoints, -tnicps);
+		le64_add_cpu(&header->ch_ncheckpoints, -(u64)tnicps);
 		nilfs_mdt_mark_buffer_dirty(header_bh);
 		nilfs_mdt_mark_dirty(cpfile);
 		kunmap_atomic(kaddr, KM_USER0);
diff --git a/fs/sufile.c b/fs/sufile.c
index 7b73a5f..9f0a988 100644
--- a/fs/sufile.c
+++ b/fs/sufile.c
@@ -331,7 +331,7 @@ int nilfs_sufile_freev(struct inode *sufile, __u64 *segnum, size_t nsegs)
 	kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
 	header = nilfs_sufile_block_get_header(sufile, header_bh, kaddr);
 	le64_add_cpu(&header->sh_ncleansegs, nsegs);
-	le64_add_cpu(&header->sh_ndirtysegs, -nsegs);
+	le64_add_cpu(&header->sh_ndirtysegs, -(u64)nsegs);
 	kunmap_atomic(kaddr, KM_USER0);
 	nilfs_mdt_mark_buffer_dirty(header_bh);
 	nilfs_mdt_mark_dirty(sufile);
-- 
1.5.6.5
