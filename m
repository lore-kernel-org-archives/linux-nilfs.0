From: Michael Conrad <mconrad-HsDW+lVSy7tZ66HEZ9PjWw@public.gmane.org>
Subject: Re: [PATCH nilfs-utils v2 2/4] cleanerd: call _exit(2) twice for
 ensuring not being a session leader
Date: Tue, 07 Jan 2014 16:19:01 -0500
Message-ID: <52CC6F45.9040605@intellitree.com>
References: <1388937165-32692-1-git-send-email-mitake.hitoshi@gmail.com>	<1388937165-32692-3-git-send-email-mitake.hitoshi@gmail.com>	<20140106.022042.112826181.konishi.ryusuke@lab.ntt.co.jp> <20140106.032857.373562363.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140106.032857.373562363.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Hitoshi Mitake <mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hitoshi Mitake <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

On 1/5/2014 1:28 PM, Ryusuke Konishi wrote:
> Oh no, I found this series has a critical issue after I applied them.
>
> The current umount.nilfs2 (and mount.nilfs2 -o remount,nogc) uses pid
> of cleanerd to shutdown it, and this series breaks the logic since the
> fork of cleanerd changes its pid.  That was the true reason why nofork
> option is required.
>
> We need to fix it by reverting the series or other means.
>
> Regards,
> Ryusuke Konishi

 From what I've learned of writing daemons, good practice is:

   * Allow an option for writing a PID file, but don't by default 
(location is often distro-specific)
   * To daemonize, double-fork, chdir("/"), and then redirect stdin, 
stdout, stderr to /dev/null
   * Allow users to request messages to syslog, since stdout is lost.
   * If you want to capture the PID, have an option to print it on 
stderr before redirecting to /dev/null.  The caller can read a pipe to 
find the final PID of the daemon.
   * Allow the option to run the program in the foreground (i.e. do not 
daemonize at all) for debugging or in case you want to run the daemon 
from a monitoring program which wait()s on it.  In this case do not 
close stdout, so that debugging messages may be seen on the terminal, or 
the messages can be piped to a logger.

Until now, I had thought "-n" was the "no-daemonize" option, which I 
thought was strange for mount to use.

-Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
