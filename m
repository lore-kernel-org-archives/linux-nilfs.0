From: John Huttley <John-jE24nFfhqzU3hwNNidygWXTaI6DYlTYJ@public.gmane.org>
Subject: cleanerd stopping
Date: Sun, 09 Nov 2008 12:44:40 +1300
Message-ID: <49162468.8020503@mib-infotech.co.nz>
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
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

Hi,
I've found that the cleaner will only run for a day or so, then it stops.

The log is as follows.

2008-11-07T22:02:22+13:00 nilfs_cleanerd[7232]: wake up
2008-11-07T22:02:22+13:00 nilfs_cleanerd[7232]: ncleansegs = 285
2008-11-07T22:02:22+13:00 nilfs_cleanerd[7232]: 2 segments selected to 
be cleaned
2008-11-07T22:02:24+13:00 nilfs_cleanerd[7232]: segment 30 cleaned
2008-11-07T22:02:24+13:00 nilfs_cleanerd[7232]: segment 31 cleaned
2008-11-07T22:02:24+13:00 nilfs_cleanerd[7232]: wait 3.719660000
2008-11-07T22:02:27+13:00 nilfs_cleanerd[7232]: wake up
2008-11-07T22:02:27+13:00 nilfs_cleanerd[7232]: ncleansegs = 285
2008-11-07T22:02:27+13:00 nilfs_cleanerd[7232]: 2 segments selected to 
be cleaned
2008-11-07T22:02:29+13:00 nilfs_cleanerd[7232]: segment 32 cleaned
2008-11-07T22:02:29+13:00 nilfs_cleanerd[7232]: segment 33 cleaned
2008-11-07T22:02:29+13:00 nilfs_cleanerd[7232]: wait 3.674263000
2008-11-07T22:02:32+13:00 nilfs_cleanerd[7232]: wake up
2008-11-07T22:02:32+13:00 nilfs_cleanerd[7232]: ncleansegs = 285
2008-11-07T22:02:32+13:00 nilfs_cleanerd[7232]: 2 segments selected to 
be cleaned
2008-11-07T22:02:34+13:00 nilfs_cleanerd[7232]: segment 34 cleaned
2008-11-07T22:02:34+13:00 nilfs_cleanerd[7232]: segment 35 cleaned
2008-11-07T22:02:34+13:00 nilfs_cleanerd[7232]: wait 3.497175000
2008-11-07T22:02:37+13:00 nilfs_cleanerd[7232]: wake up
2008-11-07T22:02:37+13:00 nilfs_cleanerd[7232]: ncleansegs = 285
2008-11-07T22:02:37+13:00 nilfs_cleanerd[7232]: 2 segments selected to 
be cleaned
2008-11-07T22:02:39+13:00 nilfs_cleanerd[7232]: cannot clean segments: 
No such file or directory
2008-11-07T22:02:39+13:00 nilfs_cleanerd[7232]: shutdown



Regards,

John
