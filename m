From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: cleanerd stopping
Date: Mon, 10 Nov 2008 11:24:11 +0900 (JST)
Message-ID: <20081110.112411.133960074.ryusuke@osrg.net>
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

Hi John,

On Sun, 09 Nov 2008 12:44:40 +1300, John Huttley wrote:
> Hi,
> I've found that the cleaner will only run for a day or so, then it stops.
> 
> The log is as follows.
> 
> 2008-11-07T22:02:22+13:00 nilfs_cleanerd[7232]: wake up
> 2008-11-07T22:02:22+13:00 nilfs_cleanerd[7232]: ncleansegs = 285
> 2008-11-07T22:02:22+13:00 nilfs_cleanerd[7232]: 2 segments selected to 
> be cleaned
<snip>
> 2008-11-07T22:02:34+13:00 nilfs_cleanerd[7232]: wait 3.497175000
> 2008-11-07T22:02:37+13:00 nilfs_cleanerd[7232]: wake up
> 2008-11-07T22:02:37+13:00 nilfs_cleanerd[7232]: ncleansegs = 285
> 2008-11-07T22:02:37+13:00 nilfs_cleanerd[7232]: 2 segments selected to 
> be cleaned
> 2008-11-07T22:02:39+13:00 nilfs_cleanerd[7232]: cannot clean segments: 
> No such file or directory

Did you see any kernel messages on system logs (i.e. /var/log/syslog
or /var/log/messages)?

The cleanerd typically outputs this message when it received a kernel
internal error code ENOENT from the nilfs2 module.

If you didn't see any related kernel messages on the logs, I have to
write a patch to identify the causal function and ask you to test it;
there are several paths that may return this error code.


At the moment, I'm guessing that some kind of meta data information
(e.g. DAT) is broken due to the previous version of cleanerd.


With regards,
Ryusuke Konishi
