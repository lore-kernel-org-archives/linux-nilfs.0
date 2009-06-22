From: "Dunphy, Bill" <WDunphy-/3AnZwnt+WyVkR+q5Y5grQ@public.gmane.org>
Subject: Re: Write hang on ARM based target
Date: Mon, 22 Jun 2009 12:58:22 -0600
Message-ID: <BAEFA5609CC3AB4BAE1625CAD4C27E5C01900FB9@tdpost.td.tandbergdata.com>
References: <20090612.132344.17157054.ryusuke@osrg.net><20090619.033642.32757627.ryusuke@osrg.net><BAEFA5609CC3AB4BAE1625CAD4C27E5C01900FAC@tdpost.td.tandbergdata.com>
	<20090619.104731.99018736.ryusuke@osrg.net>
	<BAEFA5609CC3AB4BAE1625CAD4C27E5C01900FB3@tdpost.td.tandbergdata.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Content-class: urn:content-classes:message
In-Reply-To: <BAEFA5609CC3AB4BAE1625CAD4C27E5C01900FB3-qPLjlnsG5hmCmmEZ8mJCX5vx1ZQ4fP860E9HWUfgJXw@public.gmane.org>
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

An update.

I've just begun some testing on a different reference design board
utilizing the 88F6281.  This particular board has native support in the
2.6.30 kernel which allowed me to give the in-tree version of NILFS a
go.  This board/kernel version combination ran though the testing
mentioned below without a hitch this weekend (1 million loops).  I've
since performed a number of massive simultaneous data transfers without
any errors.  Performance appeared to be much better from a high level as
well.  So at this point, it appears to me that there is a NILFS
sensitivity to the 2.6.22.18 kernel and/or a board oddity (even though
other file systems worked flawlessly).  My near term plan is to move
forward with this new board/kernel combination.  However, I will keep
the original board and it's 2.6.22.18 kernel up and available if you
would like me to try some other changes - you decide.  In the meanwhile,
I'll start banging away on this platform and report in if I see any
strange behavior.

Bill

-----Original Message-----
From: Dunphy, Bill 
Sent: Friday, June 19, 2009 9:01 AM
To: 'Ryusuke Konishi'
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org; konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org
Subject: RE: [NILFS users] Write hang on ARM based target

Thanks.  That patch integrated successfully.

Ran it again with the following result:

Jun 19 08:38:26 kernel: ========= NILFS SEGMENT INFORMATION ========

Jun 19 08:38:26 kernel: full segment: segnum=39, start=79872, end=81919

Jun 19 08:38:26 kernel: partial segment: start=81162, rest=758

Jun 19 08:38:26 kernel: ------------------ SUMMARY -----------------

Jun 19 08:38:26 kernel: nfinfo     = 4 (number of files)

Jun 19 08:38:26 kernel: nblocks    = 14 (number of blocks)

Jun 19 08:38:26 kernel: sumbytes   = 312 (size of summary in bytes)

Jun 19 08:38:26 kernel: nsumblk    = 1 (number of summary blocks)

Jun 19 08:38:26 kernel: flags      = LOGBGN|LOGEND|SR

Jun 19 08:38:26 kernel: ============================================

Jun 19 08:38:26 kernel: NILFS(segment)
nilfs_segctor_update_payload_blocknr: called                           
Jun 19 08:38:26 kernel: NILFS(segment)
nilfs_segctor_update_payload_blocknr: done                             
Jun 19 08:38:26 kernel: NILFS(segment) nilfs_segctor_fill_in_file_bmap:
called                                
Jun 19 08:38:26 kernel: NILFS(segment) nilfs_segctor_fill_in_file_bmap:
done                                  
Jun 19 08:38:26 kernel: NILFS(segment) nilfs_segctor_fill_in_checkpoint:
called                               
Jun 19 08:38:26 kernel: NILFS(segment) nilfs_segctor_fill_in_checkpoint:
done                                 
Jun 19 08:38:26 kernel: NILFS(segment) nilfs_segctor_update_segusage:
called                                  
Jun 19 08:38:26 kernel: NILFS(segment) nilfs_segctor_update_segusage:
done                                    
Jun 19 08:38:26 kernel: NILFS(segment) nilfs_segctor_fill_in_checksums:
called                                
Jun 19 08:38:26 kernel: NILFS(segment) nilfs_segctor_fill_in_checksums:
done                                  
Jun 19 08:38:26 kernel: NILFS(segment) nilfs_segbuf_write: submitting
summary blocks                          
Jun 19 08:38:26 kernel: NILFS(segment) nilfs_alloc_seg_bio: allocated
bio (max_vecs=16)                       
Jun 19 08:38:26 kernel: NILFS(segment) nilfs_segbuf_write: submitting
normal blocks (index=1)                 
Jun 19 08:38:26 kernel: NILFS(segment) nilfs_submit_seg_bio: submitting
bio (start_sector=649296, size=57344,) Jun 19 08:38:26 kernel:
NILFS(segment) nilfs_segbuf_write: submitted a segment (err=0,
pseg_start=81162, #req)
Jun 19 08:38:26 kernel: NILFS(segment) nilfs_segbuf_wait: called nbio=1

Jun 19 08:38:26 kernel: NILFS(segment) nilfs_segbuf_wait: wait completed

Jun 19 08:38:26 kernel: NILFS(segment) nilfs_segctor_complete_write:
completing segment (flags=0x7)           
Jun 19 08:38:26 kernel: NILFS(segment) nilfs_segctor_complete_write:
completed a segment having a super root )
Jun 19 08:38:26 kernel: NILFS(segment) nilfs_segctor_do_construct:
submitted all segments                     
Jun 19 08:38:26 kernel: NILFS(segment) nilfs_segctor_construct: end
(stage=9)                                 
Jun 19 08:38:26 kernel: NILFS(segment) nilfs_segctor_notify: complete
requests from seq=2 to seq=1            
Jun 19 08:38:26 kernel: NILFS(segment) nilfs_segctor_thread: sequence:
req=1, done=1, state=0                  

Bill

-----Original Message-----
From: Ryusuke Konishi [mailto:ryusuke-sG5X7nlA6pw@public.gmane.org]
Sent: Thursday, June 18, 2009 7:48 PM
To: Dunphy, Bill
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org; konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org
Subject: Re: [NILFS users] Write hang on ARM based target

Hi,
On Thu, 18 Jun 2009 13:48:56 -0600, "Dunphy, Bill" wrote:
> Tried applying patch to latest git pull as well as 2.0.12 and 2.0.14 
> and experienced the following patch issue:
> 
> $ patch -p1 <your.patch
> (Stripping trailing CRs from patch.)
> patching file fs/dat.c
> (Stripping trailing CRs from patch.)
> patching file fs/segment.c
> patch: **** malformed patch at line 50: @@ -2056,12 +2043,11 @@ static

> void nilfs_end_page_io(struct page *page, int err)
> 
> I could attempt to do by hand but decided to let you chime in first.
> 
> Thoughts? 
> 
> Bill

Hmm, strange.

I will attach the compressed one.  It is against the latest git, but
will be also applicable to v2.0.14.

 $ cd nilfs2-module
 $ bunzip -c xxx/nilfs2-fix-hang-after-bio_alloc-failed.patch.bz2 |
patch -p1

How does this go ?

Ryusuke Konishi
