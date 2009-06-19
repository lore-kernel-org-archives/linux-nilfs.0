From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: System Lockup while testing nilfs
Date: Fri, 19 Jun 2009 11:18:12 +0900 (JST)
Message-ID: <20090619.111812.23704501.ryusuke@osrg.net>
References: <ddfcb4780906181809w4db9aa15u3a28676083ca3405@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <ddfcb4780906181809w4db9aa15u3a28676083ca3405-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: james.m.long-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi!
On Thu, 18 Jun 2009 21:09:44 -0400, James M Long wrote:
> I am a system engineer that was attracted to nilfs due to some of the
> features that the file system already has. I talked one of our
> developers into doing a performance test against our in house software
> application that is running in a nilfs partition.
> My issue is that the host server continues to lockup during the
> performance test. I thought it may have something to do with the
> server itself, but the performance test runs successfully on the
> server on the same harddrive in a different partition.
> My question is what can I do to monitor and log what the issue is
> since the only way to get back into the machine is to do a hard power
> cycle. I have turned on debug in the nilfs_cleanerd config file and I
> am capturing the log to a separate location. The lockup seems to occur
> right after a "2 segments selected to be cleaned" message was sent.

Thank you for your interest in nilfs.

First, when you meet a hang problem, the magic sysrq feature of kernel
is helpful to trace down the cause.  The following operation will
output stack dump of every task if the sysrq feature is enabled.

 # echo t > /proc/sysrq-trigger
 
In the standalone module version of nilfs, you can get some debug
information by enabling CONFIG_NILFS_DEBUG=y in fs/Makefile.

The standalone package is available from nilfs.org or the git tree
shown in:

[1]  http://www.nilfs.org/git/

In the debug build module, you can adjust verbosity levels of debug
messages:

 level3:
 # echo "-vvv segment -vvv seginfo" > /proc/fs/nilfs2/debug_option

 level2:
 # echo "-vv segment -vv seginfo" > /proc/fs/nilfs2/debug_option

 level1 (default):
 # echo "-v segment -v seginfo" > /proc/fs/nilfs2/debug_option

One problem is that the standalone package does not support the 2.6.30
kernel.  But it is still useful for debugging purpose.

Yesterday, I posted a patch that fixes a hang problem in log writer.
I'm planning to send it upstream, but it's still under testing.

Please try the patch. It's available from the archive:

[2] https://www.nilfs.org/pipermail/users/2009-June/000713.html


Cheers,
Ryusuke Konishi

> gentoo distribution
> 2.6.30 kernel x86
> nilfs-utils 2.0.12
> partition 466GB
> application is postgresql, sqlite and lucene and python
> all db's and indexes are being written into the nilfs partition so
> there are tons of file changes happening at all times during the test.
> During the test, the file system is growing at a rate of 3 MB/sec and
> the test runs for greater than 4 hours straight. The total data the
> test writes is about 1.4 gig when it completes, but as I stated in
> before, most of the data is in lucene indexes, postgresql and sqlite
> db's.
> 
> I am under the impression that our application is hammering the file
> system with too many read and write requests at the same time.
> 
> Thanks for any suggestions,
> 
> James...
