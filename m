From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: cleanerd stopping
Date: Wed, 17 Dec 2008 00:14:37 +0900 (JST)
Message-ID: <20081217.001437.44157644.ryusuke@osrg.net>
References: <49162468.8020503@mib-infotech.co.nz>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <49162468.8020503-jE24nFfhqzU3hwNNidygWXTaI6DYlTYJ@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, John-jE24nFfhqzU3hwNNidygWXTaI6DYlTYJ@public.gmane.org

On Sun, 09 Nov 2008 12:44:40 +1300, John Huttley wrote:
> Hi,
> I've found that the cleaner will only run for a day or so, then it stops.
> 
> The log is as follows.
<snip>
> 2008-11-07T22:02:37+13:00 nilfs_cleanerd[7232]: wake up
> 2008-11-07T22:02:37+13:00 nilfs_cleanerd[7232]: ncleansegs = 285
> 2008-11-07T22:02:37+13:00 nilfs_cleanerd[7232]: 2 segments selected to 
> be cleaned
> 2008-11-07T22:02:39+13:00 nilfs_cleanerd[7232]: cannot clean segments: 
> No such file or directory
> 2008-11-07T22:02:39+13:00 nilfs_cleanerd[7232]: shutdown

I've found a bug of nilfs2 kernel module (in ioctl code) that may
cause this error.

If the bug was the cause, it should occur for volumes having numerous
snapshots, or on the machine whose amount of memory is low.

I would like to fix this early.

Regards,
Ryusuke
