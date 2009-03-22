From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: NILFS warning (device sdb1): nilfs_truncate_bmap:
 failed , to truncate bmap (ino=424, err=-2)
Date: Sun, 22 Mar 2009 23:23:49 +0900 (JST)
Message-ID: <20090322.232349.133245797.ryusuke@osrg.net>
References: <49C4D621.6040202@prnet.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <49C4D621.6040202-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org

Hi,
On Sat, 21 Mar 2009 12:57:21 +0100, David Arendt wrote:
> Hi,
> 
> I had a system freeze this morning. This was the error appearing in 
> /var/log/messages shortly before the freeze.
> 
> NILFS warning (device sdb1): nilfs_truncate_bmap: failed ,to truncate 
> bmap (ino=424, err=-2)
> 
> cleanerd has been running for 4 hours.This occured 5 minutes after I 
> killed cleanerd. At the moment were this was occuring, I was also 
> deleting about //250gbytes of files. So it's no sure if it is cleaner 
> related or not.
> 
> The kernel was 2.6.28.8 with nilfs 2.0.11
>
> If have done a find / in order to list all the files after a reboot, and 
> no further nilfs2 error messages have been logged.
> 
> Bye,
> David Arendt

The error code indicates that a nilfs delete routine unexpectedly met
a hole block or failed to translate vblocknr to on-disk block address
while it is truncating btree of a huge file.

Maybe GC is involved.
I don't know the warning is relating to the freeze.

This seems to require digging deeply into the function and GC, so I'll
queue it at a bugtrack for now.

Thanks for reporting.

Ryusuke
