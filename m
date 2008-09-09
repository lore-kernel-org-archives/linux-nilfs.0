From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Reading and writing a large file
Date: Tue, 09 Sep 2008 15:00:01 +0900 (JST)
Message-ID: <20080909.150001.12454717.ryusuke@osrg.net>
References: <48C56255.7080807@cs.wisc.edu>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <48C56255.7080807-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, ahollowa-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org

Hi!,

On Mon, 08 Sep 2008 12:35:17 -0500, Allison Holloway wrote:
> I want to run a program in NILFS that performs lots of random and 
> sequential reads and writes on a large file.  The program uses pread64 
> and pwrite64 to do the file accesses; I'm accessing the data 32KB at a 
> time, and I give the location as the logical offset within the file.  It 
> works fine on my department's AFS file system, but I'm having 2 issues 
> with NILFS:
> 1) pwrite64 will sometimes fail, and I haven't figured out what it 
> correlates to.  I know sometimes it's because the disk has run out of 
> room, but I'm not sure that that is always the cause.

I've tested pwrite64 and pread64, but I couldn't reproduce this problem
so far.  Can you get the error code? (did you see codes other than
ENOSPC?)
And, could you tell me the kernel version that you are using?
(is it distro kernel or vanilla kernel?)

> 2) Garbage collection/ cleanup.  After enough blocks of the file have 
> been rewritten (possibly multiple times), I'll get a disk full error.  
> Then, even if I've deleted all the files in my nilfs partition, I cannot 
> create a new non-empty file.  Is there a way to speed up the garbage 
> collection process, or better interleave it with the program so I don't 
> get these "disk full" errors?

Yeah, to resolve disk full errors we have to make GC work, but just
deleting files is not enough because NILFS will try to preserve 
all recent updates and cannot free it until time passes.

You can accelerate GC by changing some parameters as follows:

1) Shorten protection period.
   This parameter gives the period how long NILFS protects non-snapshot
   checkpoints from their creation time.
   Default period is set to 1 hour (3600 in seconds).
   You can shorten this by rewriting the ``protection_period'' line
   of ``/etc/nilfs_cleanerd.conf'' file.

2) Accelerate GC
   Two parameters in /etc/nilfs_cleanerd.conf defines the GC speed:

   - nsegments_per_clean (default: 2 segments)
     The maximum number of segments cleaned at a time.
     Increasing this value accelarates GC.

   - cleaning_interval (default: 5 seconds)
     Cleaning interval in seconds.
     Decreasing this value boosts the GC frequency.

Note that you have to send a HUP signal to the GC daemon to reflect
these changes.  (Or just do umount and mount)

 # <edit /etc/nilfs_cleanerd.conf>
 # mount
 ...
 /dev/hdb1 on /home/ type nilfs2 (rw,gcpid=2255)
 # kill -HUP 2255


Cheers,
Ryusuke
