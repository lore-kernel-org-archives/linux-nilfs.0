From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: NILFS stability?
Date: Mon, 08 Jun 2009 14:30:22 +0900 (JST)
Message-ID: <20090608.143022.12860205.ryusuke@osrg.net>
References: <8A38A27F-33F4-44C1-AFCC-EACCEBE8E8EF@karlsbakk.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <8A38A27F-33F4-44C1-AFCC-EACCEBE8E8EF-ooPBL11mRiZbRRN4PJnoQQ@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, roy-ooPBL11mRiZbRRN4PJnoQQ@public.gmane.org

Hi,
On Sun, 7 Jun 2009 19:06:47 +0200, Roy Sigurd Karlsbakk wrote:
> Hi all
> 
> I just came across NILFS, and have setup a VM to test it and it works  
> well so far. Initial testing shows very high system time when  
> compiling a linux kernel on the NILFS filesystem. I have tried using  
> oprofile to monitor this, but something is fscked up on this system,  
> so oprofile doesn't seem to work. I'll get back to this later if I get  
> the chance.

Thank you for the information.
The high load may come from garbage collection.

In that case, I think you can narrow down the cause by looking the
load of nilfs_cleanerd with top command, etc.
 
> So, is NILFS somehow stable? Is it in use somewhere? I see it's in v2,  
> but I've never heard of it before today.

I believe NILFS is almost stable, and we are using NILFS for daily
use.  We haven't yet apply it for commercial use.  We had released
NILFSv1 to the public, but v1 are not maintained and its development
was obsoleted because it couldn't achieve garbage collector.

I think NILFS2 should be named as NILFS v1.0, but it wasn't as a
result.

Anyway, in NILFS2, some important feature like xattributes,
posix-ACLs, or on-disk atime are not yet implemented.  In addition,
performance tuning, GC improvement, bugfixes of the reported problems
in the list, are needed.  We also have a possiblity to change
application binary interface (i.e. ioctl) or disk format if absolutely
necessary.  The nilfs is classified to _experimental_ in kernel, and I
think it's a bit early to get off the flag.

> Thank you for feedback on this
> 
> roy

Cheers,
Ryusuke Konishi
