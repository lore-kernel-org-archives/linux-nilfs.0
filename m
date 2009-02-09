From: Alex Bitney <san-UZOCzndLCy9BDgjK7y7TUQ@public.gmane.org>
Subject: Cleanerd performance, and symlinks issue observations
Date: Mon, 9 Feb 2009 02:03:59 +0200
Message-ID: <591bc86b0902081603v6159621fo46daf555b5f6f7f2@mail.gmail.com>
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

Hello,

I am using nilfs on root filesystem, too, on 8G SSD drive (Acer Aspire
One). While converting filesystem to nilfs, I used tar, and upon
extraction received 0-length files instead of symlinks in /etc/rc2.d
and similar directories. After that, I started using CPIO and problem
has gone. So, maybe this is TAR issue, not nilfs, some rare
conditions..

Regarding performance of cleanerd. Correct me, if I'm wrong. It seems
to circularly scan the whole filesystem. For some busy parts of the
filesystem it works slower, for parts which will become unused it is
faster. In my /var/log/debug it reports total number of clean segments
each time after cleanup iteration, and it seems that this number is
not increased when nilfs works harder (it means data remains in
place). In the same time I observe intensive write operations. My
question is: why write segments if they are not going to be freed?
Saying "write operations" i mean really hard I/O, long 20mb/sec
reading, followed by long 15mb/sec writing. Maybe this is how SSD
disks work.. but system is unresponsive during this operation.

Several people here already asked for cleanerd GC overview. I have no
ACM access and I don't know whether that document contains it. Could
you please share some details with this mailing list. Or, forget it,
I'm going to read the sources.

I would like to thank you for your great work, too ;)

Regards,
Sanoff.
