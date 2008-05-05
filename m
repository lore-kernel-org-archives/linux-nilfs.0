From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: some questions
Date: Tue, 06 May 2008 00:55:11 +0900 (JST)
Message-ID: <20080506.005511.117028003.ryusuke@osrg.net>
References: <481DE17B.3080407@prnet.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <481DE17B.3080407-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
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
Content-Type: Text/Plain; charset="us-ascii"
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org


Hi,

From: David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
Subject: [NILFS users] some questions
Date: Sun, 04 May 2008 18:16:59 +0200
> I am very interested in nilfs2 so I have some questions ?

Sure.

> 1. If I understood well, nilfs is always appending to the end (is this 
> true or is also other data modified, for example to update pointers ?). 
> What is happening if I have deleted files and cleanerd deletes the 
> snapshots ?

If you deletes files, new directory blocks that doesn't have their
entries, are just written out.
When the cleanerd finds a block that is not referred to from any
snapshots, it is identified as removable and will not be copied
during reclamation.

> Will this space be written by further write operations or 
> will it be lost ?

Eventually the abandoned block will be overrode with a new block.

(To be more exact, NILFS manages disk space with units of segments;
 the cleanerd reclaims segments instead of disk blocks. )

> 2. I suppose that some fragmentation will build up, is there any 
> defragmentation tool planned ?

The former is yes.  Unfortunetely, the latter, no.
Though some LFSes defrags during GC, our LFS not.

> 3. How robust is nilfs to device errors like bad sectors ? For example 
> if you have a disk image where bad sectors are replaced by zeros, will 
> you still be able to recover data from other sectors ?

When NILFS detects an I/O error, it tries to mark the segment including
the bad block erroneous. The errorneous segment will never be reused.

Cheers,
Ryusuke Konishi
