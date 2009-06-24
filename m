From: "Dunphy, Bill" <WDunphy-/3AnZwnt+WyVkR+q5Y5grQ@public.gmane.org>
Subject: Re: Write hang on ARM based target
Date: Wed, 24 Jun 2009 15:16:49 -0600
Message-ID: <BAEFA5609CC3AB4BAE1625CAD4C27E5C01900FC5@tdpost.td.tandbergdata.com>
References: <20090619.104731.99018736.ryusuke@osrg.net><BAEFA5609CC3AB4BAE1625CAD4C27E5C01900FB3@tdpost.td.tandbergdata.com><BAEFA5609CC3AB4BAE1625CAD4C27E5C01900FB9@tdpost.td.tandbergdata.com>
	<20090623.123505.37056161.ryusuke@osrg.net>
	<BAEFA5609CC3AB4BAE1625CAD4C27E5C01900FBB@tdpost.td.tandbergdata.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Content-class: urn:content-classes:message
In-Reply-To: <BAEFA5609CC3AB4BAE1625CAD4C27E5C01900FBB-qPLjlnsG5hmCmmEZ8mJCX5vx1ZQ4fP860E9HWUfgJXw@public.gmane.org>
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
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Ryusuke,

Here's another data point.  I've run the same test on the new ARM
reference design hardware, but this time running the 2.6.22.18 kernel.
It also hangs after a similar period of time and when examining the
logging output, it appears very similar to the original error.

 Jun 24 15:06:25 kernel: ========= NILFS SEGMENT INFORMATION ========

Jun 24 15:06:25 kernel: full segment: segnum=124, start=253952,
end=255999                                    
Jun 24 15:06:25 kernel: partial segment: start=254180, rest=1820

Jun 24 15:06:25 kernel: ------------------ SUMMARY -----------------

Jun 24 15:06:25 kernel: nfinfo     = 4 (number of files)

Jun 24 15:06:25 kernel: nblocks    = 17 (number of blocks)

Jun 24 15:06:25 kernel: sumbytes   = 344 (size of summary in bytes)

Jun 24 15:06:25 kernel: nsumblk    = 1 (number of summary blocks)

Jun 24 15:06:25 kernel: flags      = LOGBGN|LOGEND|SR

Jun 24 15:06:25 kernel: ============================================

Jun 24 15:06:25 kernel: NILFS(segment)
nilfs_segctor_update_payload_blocknr: called                           
Jun 24 15:06:25 kernel: NILFS(segment)
nilfs_segctor_update_payload_blocknr: done                             
Jun 24 15:06:25 kernel: NILFS(segment) nilfs_segctor_fill_in_file_bmap:
called                                
Jun 24 15:06:25 kernel: NILFS(segment) nilfs_segctor_fill_in_file_bmap:
done                                  
Jun 24 15:06:25 kernel: NILFS(segment) nilfs_segctor_fill_in_checkpoint:
called                               
Jun 24 15:06:25 kernel: NILFS(segment) nilfs_segctor_fill_in_checkpoint:
done                                 
Jun 24 15:06:25 kernel: NILFS(segment) nilfs_segctor_update_segusage:
called                                  
Jun 24 15:06:25 kernel: NILFS(segment) nilfs_segctor_update_segusage:
done                                    
Jun 24 15:06:25 kernel: NILFS(segment) nilfs_segctor_fill_in_checksums:
called                                
Jun 24 15:06:25 kernel: NILFS(segment) nilfs_segctor_fill_in_checksums:
done                                  
Jun 24 15:06:25 kernel: NILFS(segment) nilfs_segbuf_write: submitting
summary blocks                          
Jun 24 15:06:25 kernel: NILFS(segment) nilfs_alloc_seg_bio: allocated
bio (max_vecs=64)                       
Jun 24 15:06:25 kernel: NILFS(segment) nilfs_segbuf_write: submitting
normal blocks (index=1)                 
Jun 24 15:06:25 kernel: NILFS(segment) nilfs_submit_seg_bio: submitting
bio (start_sector=2033440, size=69632)
Jun 24 15:06:25 kernel: NILFS(segment) nilfs_segbuf_write: submitted a
segment (err=0, pseg_start=254180, #re)
Jun 24 15:06:25 kernel: NILFS(segment) nilfs_segbuf_wait: called nbio=1

Jun 24 15:06:25 kernel: NILFS(segment) nilfs_segbuf_wait: wait completed

Jun 24 15:06:25 kernel: NILFS(segment) nilfs_segctor_complete_write:
completing segment (flags=0x7)           
Jun 24 15:06:25 kernel: NILFS(segment) nilfs_segctor_complete_write:
completed a segment having a super root )
Jun 24 15:06:25 kernel: NILFS(segment) nilfs_segctor_do_construct:
submitted all segments                     
Jun 24 15:06:25 kernel: NILFS(segment) nilfs_segctor_construct: end
(stage=9)                                 
Jun 24 15:06:25 kernel: NILFS(segment) nilfs_segctor_notify: complete
requests from seq=1 to seq=1            
Jun 24 15:06:25 kernel: NILFS(segment) nilfs_segctor_thread: sequence:
req=1, done=1, state=0                 

Not too surprising - just eliminates the possibility of bad hardware.

Bill

-----Original Message-----
From: Dunphy, Bill 
Sent: Tuesday, June 23, 2009 9:35 AM
To: 'Ryusuke Konishi'
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org; konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org
Subject: RE: [NILFS users] Write hang on ARM based target

Ryusuke,

This patch failed to integrate with the latest git pull again.  Looking
at the lines it was trying to substitute I can see why.  Being a
relative rookie when it comes to git, am I missing a step here?  My
assumption is that anything we do in unison will be against the latest
and greatest - is this a bad assumption?  My sequence is a bit overkill
but seems to ensure a clean start:

1) git clone http://git.nilfs.org/nilfs-module-git
2) cd nilfs2-module
3) patch -p1 < "your patch"

If you have any suggestions as to how I should be doing this
differently, I'm all ears.  In any event, the good news is that was able
to hand patch the necessary files (segment.c/segment.h) - pretty simple,
straight forward change.  The bad news is that it still ends in a hang
state:

Jun 23 09:12:52 kernel: ========= NILFS SEGMENT INFORMATION ========

Jun 23 09:12:52 kernel: full segment: segnum=22, start=45056, end=47103

Jun 23 09:12:52 kernel: partial segment: start=45413, rest=1691

Jun 23 09:12:52 kernel: ------------------ SUMMARY -----------------

Jun 23 09:12:52 kernel: nfinfo     = 4 (number of files)

Jun 23 09:12:52 kernel: nblocks    = 14 (number of blocks)

Jun 23 09:12:52 kernel: sumbytes   = 312 (size of summary in bytes)

Jun 23 09:12:52 kernel: nsumblk    = 1 (number of summary blocks)

Jun 23 09:12:52 kernel: flags      = LOGBGN|LOGEND|SR

Jun 23 09:12:52 kernel: ============================================

Jun 23 09:12:52 kernel: NILFS(segment)
nilfs_segctor_update_payload_blocknr: called                           
Jun 23 09:12:52 kernel: NILFS(segment)
nilfs_segctor_update_payload_blocknr: done                             
Jun 23 09:12:52 kernel: NILFS(segment) nilfs_segctor_fill_in_file_bmap:
called                                
Jun 23 09:12:52 kernel: NILFS(segment) nilfs_segctor_fill_in_file_bmap:
done                                  
Jun 23 09:12:52 kernel: NILFS(segment) nilfs_segctor_fill_in_checkpoint:
called                               
Jun 23 09:12:52 kernel: NILFS(segment) nilfs_segctor_fill_in_checkpoint:
done                                 
Jun 23 09:12:52 kernel: NILFS(segment) nilfs_segctor_update_segusage:
called                                  
Jun 23 09:12:52 kernel: NILFS(segment) nilfs_segctor_update_segusage:
done                                    
Jun 23 09:12:52 kernel: NILFS(segment) nilfs_segctor_fill_in_checksums:
called                                
Jun 23 09:12:52 kernel: NILFS(segment) nilfs_segctor_fill_in_checksums:
done                                  
Jun 23 09:12:52 kernel: NILFS(segment) nilfs_segbuf_write: submitting
summary blocks                          
Jun 23 09:12:52 kernel: NILFS(segment) nilfs_alloc_seg_bio: allocated
bio (max_vecs=16)                       
Jun 23 09:12:52 kernel: NILFS(segment) nilfs_segbuf_write: submitting
normal blocks (index=1)                 
Jun 23 09:12:52 kernel: NILFS(segment) nilfs_submit_seg_bio: submitting
bio (start_sector=363304, size=57344,) Jun 23 09:12:52 kernel:
NILFS(segment) nilfs_segbuf_write: submitted a segment (err=0,
pseg_start=45413, #req)
Jun 23 09:12:52 kernel: NILFS(segment) nilfs_segbuf_wait: called nbio=1

Jun 23 09:12:52 kernel: NILFS(segment) nilfs_segbuf_wait: wait completed

Jun 23 09:12:52 kernel: NILFS(segment) nilfs_segctor_complete_write:
completing segment (flags=0x7)           
Jun 23 09:12:52 kernel: NILFS(segment) nilfs_segctor_complete_write:
completed a segment having a super root )
Jun 23 09:12:52 kernel: NILFS(segment) nilfs_segctor_do_construct:
submitted all segments                     
Jun 23 09:12:52 kernel: NILFS(segment) nilfs_segctor_construct: end
(stage=9)                                 
Jun 23 09:12:52 kernel: NILFS(segment) nilfs_segctor_notify: complete
requests from seq=1 to seq=1            
Jun 23 09:12:52 kernel: NILFS(segment) nilfs_segctor_thread: sequence:
req=1, done=1, state=0        

Bill

-----Original Message-----
From: Ryusuke Konishi [mailto:ryusuke-sG5X7nlA6pw@public.gmane.org]
Sent: Monday, June 22, 2009 9:35 PM
To: Dunphy, Bill
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org; konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org
Subject: Re: [NILFS users] Write hang on ARM based target

Hi Bill,
On Mon, 22 Jun 2009 12:58:22 -0600, "Dunphy, Bill" wrote:
> An update.
> 
> I've just begun some testing on a different reference design board 
> utilizing the 88F6281.  This particular board has native support in 
> the 2.6.30 kernel which allowed me to give the in-tree version of 
> NILFS a go.  This board/kernel version combination ran though the 
> testing mentioned below without a hitch this weekend (1 million 
> loops).  I've since performed a number of massive simultaneous data 
> transfers without any errors.  Performance appeared to be much better 
> from a high level as well.  So at this point, it appears to me that 
> there is a NILFS sensitivity to the 2.6.22.18 kernel and/or a board 
> oddity (even though other file systems worked flawlessly).  My near 
> term plan is to move forward with this new board/kernel combination.
> However, I will keep the original board and it's 2.6.22.18 kernel up 
> and available if you would like me to try some other changes - you 
> decide.  In the meanwhile, I'll start banging away on this platform 
> and report in if I see any strange behavior.
> 
> Bill

Sorry for my late reply.

I found an inconsistent state in the value of sequence counter shown in
your log.  I think some sort of synchronization problem is present.
If so, I think we should resolve the problem because it may occur in any
RISC architectures.

Could you test if the attached patch makes a difference?

The patch adds volatile specifiers to sequence counters which may be
shared among different tasks.

Thanks,
Ryusuke Konishi
 
> -----Original Message-----
> From: Dunphy, Bill
> Sent: Friday, June 19, 2009 9:01 AM
> To: 'Ryusuke Konishi'
> Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org; konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org
> Subject: RE: [NILFS users] Write hang on ARM based target
> 
> Thanks.  That patch integrated successfully.
> 
> Ran it again with the following result:
> 
> Jun 19 08:38:26 kernel: ========= NILFS SEGMENT INFORMATION ========
> 
> Jun 19 08:38:26 kernel: full segment: segnum=39, start=79872,
> end=81919
> 
> Jun 19 08:38:26 kernel: partial segment: start=81162, rest=758
> 
> Jun 19 08:38:26 kernel: ------------------ SUMMARY -----------------
> 
> Jun 19 08:38:26 kernel: nfinfo     = 4 (number of files)
> 
> Jun 19 08:38:26 kernel: nblocks    = 14 (number of blocks)
> 
> Jun 19 08:38:26 kernel: sumbytes   = 312 (size of summary in bytes)
> 
> Jun 19 08:38:26 kernel: nsumblk    = 1 (number of summary blocks)
> 
> Jun 19 08:38:26 kernel: flags      = LOGBGN|LOGEND|SR
> 
> Jun 19 08:38:26 kernel: ============================================
> 
> Jun 19 08:38:26 kernel: NILFS(segment)
> nilfs_segctor_update_payload_blocknr: called

> Jun 19 08:38:26 kernel: NILFS(segment)
> nilfs_segctor_update_payload_blocknr: done

> Jun 19 08:38:26 kernel: NILFS(segment)
nilfs_segctor_fill_in_file_bmap:
> called                                
> Jun 19 08:38:26 kernel: NILFS(segment)
nilfs_segctor_fill_in_file_bmap:
> done                                  
> Jun 19 08:38:26 kernel: NILFS(segment)
nilfs_segctor_fill_in_checkpoint:
> called                               
> Jun 19 08:38:26 kernel: NILFS(segment)
nilfs_segctor_fill_in_checkpoint:
> done                                 
> Jun 19 08:38:26 kernel: NILFS(segment) nilfs_segctor_update_segusage:
> called                                  
> Jun 19 08:38:26 kernel: NILFS(segment) nilfs_segctor_update_segusage:
> done                                    
> Jun 19 08:38:26 kernel: NILFS(segment)
nilfs_segctor_fill_in_checksums:
> called                                
> Jun 19 08:38:26 kernel: NILFS(segment)
nilfs_segctor_fill_in_checksums:
> done                                  
> Jun 19 08:38:26 kernel: NILFS(segment) nilfs_segbuf_write: submitting
> summary blocks                          
> Jun 19 08:38:26 kernel: NILFS(segment) nilfs_alloc_seg_bio: allocated
> bio (max_vecs=16)                       
> Jun 19 08:38:26 kernel: NILFS(segment) nilfs_segbuf_write: submitting
> normal blocks (index=1)                 
> Jun 19 08:38:26 kernel: NILFS(segment) nilfs_submit_seg_bio: 
> submitting bio (start_sector=649296, size=57344,) Jun 19 08:38:26
kernel:
> NILFS(segment) nilfs_segbuf_write: submitted a segment (err=0, 
> pseg_start=81162, #req) Jun 19 08:38:26 kernel: NILFS(segment)
> nilfs_segbuf_wait: called nbio=1
> 
> Jun 19 08:38:26 kernel: NILFS(segment) nilfs_segbuf_wait: wait 
> completed
> 
> Jun 19 08:38:26 kernel: NILFS(segment) nilfs_segctor_complete_write:
> completing segment (flags=0x7)           
> Jun 19 08:38:26 kernel: NILFS(segment) nilfs_segctor_complete_write:
> completed a segment having a super root ) Jun 19 08:38:26 kernel: 
> NILFS(segment) nilfs_segctor_do_construct:
> submitted all segments                     
> Jun 19 08:38:26 kernel: NILFS(segment) nilfs_segctor_construct: end
> (stage=9)                                 


diff --git a/fs/segment.c b/fs/segment.c index 84201ce..c9c28c2 100644
--- a/fs/segment.c
+++ b/fs/segment.c
@@ -2530,7 +2530,7 @@ void
nilfs_segctor_clear_segments_to_be_freed(struct nilfs_sc_info *sci)
 
 struct nilfs_segctor_wait_request {
 	wait_queue_t	wq;
-	__u32		seq;
+	volatile __u32	seq;
 	int		err;
 	atomic_t	done;
 };
@@ -2699,7 +2699,7 @@ int nilfs_construct_dsync_segment(struct
super_block *sb, struct inode *inode,
 
 struct nilfs_segctor_req {
 	int mode;
-	__u32 seq_accepted;
+	volatile __u32 seq_accepted;
 	int sc_err;  /* construction failure */
 	int sb_err;  /* super block writeback failure */  }; diff --git
a/fs/segment.h b/fs/segment.h index 44dca64..8533783 100644
--- a/fs/segment.h
+++ b/fs/segment.h
@@ -163,8 +163,8 @@ struct nilfs_sc_info {
 	wait_queue_head_t	sc_wait_daemon;
 	wait_queue_head_t	sc_wait_task;
 
-	__u32			sc_seq_request;
-	__u32			sc_seq_done;
+	volatile __u32		sc_seq_request;
+	volatile __u32		sc_seq_done;
 
 	int			sc_sync;
 	unsigned long		sc_interval;
--
1.6.2
