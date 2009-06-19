From: James M Long <james.m.long-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: System Lockup while testing nilfs
Date: Thu, 18 Jun 2009 21:09:44 -0400
Message-ID: <ddfcb4780906181809w4db9aa15u3a28676083ca3405@mail.gmail.com>
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

I am a system engineer that was attracted to nilfs due to some of the
features that the file system already has. I talked one of our
developers into doing a performance test against our in house software
application that is running in a nilfs partition.
My issue is that the host server continues to lockup during the
performance test. I thought it may have something to do with the
server itself, but the performance test runs successfully on the
server on the same harddrive in a different partition.
My question is what can I do to monitor and log what the issue is
since the only way to get back into the machine is to do a hard power
cycle. I have turned on debug in the nilfs_cleanerd config file and I
am capturing the log to a separate location. The lockup seems to occur
right after a "2 segments selected to be cleaned" message was sent.

gentoo distribution
2.6.30 kernel x86
nilfs-utils 2.0.12
partition 466GB
application is postgresql, sqlite and lucene and python
all db's and indexes are being written into the nilfs partition so
there are tons of file changes happening at all times during the test.
During the test, the file system is growing at a rate of 3 MB/sec and
the test runs for greater than 4 hours straight. The total data the
test writes is about 1.4 gig when it completes, but as I stated in
before, most of the data is in lucene indexes, postgresql and sqlite
db's.

I am under the impression that our application is hammering the file
system with too many read and write requests at the same time.

Thanks for any suggestions,

James...
