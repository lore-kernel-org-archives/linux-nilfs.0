From: Allison Holloway <ahollowa-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Reading and writing a large file
Date: Mon, 08 Sep 2008 12:35:17 -0500
Message-ID: <48C56255.7080807@cs.wisc.edu>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi,

I want to run a program in NILFS that performs lots of random and 
sequential reads and writes on a large file.  The program uses pread64 
and pwrite64 to do the file accesses; I'm accessing the data 32KB at a 
time, and I give the location as the logical offset within the file.  It 
works fine on my department's AFS file system, but I'm having 2 issues 
with NILFS:
1) pwrite64 will sometimes fail, and I haven't figured out what it 
correlates to.  I know sometimes it's because the disk has run out of 
room, but I'm not sure that that is always the cause.
2) Garbage collection/ cleanup.  After enough blocks of the file have 
been rewritten (possibly multiple times), I'll get a disk full error.  
Then, even if I've deleted all the files in my nilfs partition, I cannot 
create a new non-empty file.  Is there a way to speed up the garbage 
collection process, or better interleave it with the program so I don't 
get these "disk full" errors?

Any help or insight you could give would be greatly appreciated!

Thank you,
Allison
