From: T-Machine <tmachinecorp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: nilfs_sync_super: barrier sync FAILS
Date: Tue, 23 Jun 2009 15:43:33 -0400
Message-ID: <4A413065.5040704@gmail.com>
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

Hi;
The moment when NILFS dies (a horrible death :-) with "I/O error -> Disk 
Full",
the log:
segctord starting. Construction interval = 5 seconds, CP frequency < 30 
seconds
NILFS warning (device dm-10): nilfs_sync_super: barrier sync failed. 
disabling barriers
...
...
fatal I/O error: no space left on device
Any ideas? (Rolling back works!!! -> nilfs .12 module + utils .12 + 
2.6.27.8 kernel -> no problems.)
Cheers
