From: David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
Subject: NILFS warning (device sdb1): nilfs_truncate_bmap:
 failed , to truncate bmap (ino=424, err=-2)
Date: Sat, 21 Mar 2009 12:57:21 +0100
Message-ID: <49C4D621.6040202@prnet.org>
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

I had a system freeze this morning. This was the error appearing in 
/var/log/messages shortly before the freeze.

NILFS warning (device sdb1): nilfs_truncate_bmap: failed ,to truncate 
bmap (ino=424, err=-2)

cleanerd has been running for 4 hours.This occured 5 minutes after I 
killed cleanerd. At the moment were this was occuring, I was also 
deleting about //250gbytes of files. So it's no sure if it is cleaner 
related or not.

The kernel was 2.6.28.8 with nilfs 2.0.11

If have done a find / in order to list all the files after a reboot, and 
no further nilfs2 error messages have been logged.

Bye,
David Arendt
