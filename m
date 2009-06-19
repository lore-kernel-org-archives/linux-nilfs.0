From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: More test results
Date: Fri, 19 Jun 2009 12:01:57 +0900 (JST)
Message-ID: <20090619.120157.123615651.ryusuke@osrg.net>
References: <mailman.1.1245034801.3147.users@nilfs.org>
	<20090615124359.536e8685@simplux>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090615124359.536e8685@simplux>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, mniederle-RbZlAiThDcE@public.gmane.org

Hi Michael,
On Mon, 15 Jun 2009 12:43:59 +0200, "Dipl.-Ing. Michael Niederle" wrote:
> Hi!
>
> I reinstalled my pen drive and continued testing just doing my
> regular work. (I always work on a pen drive based system.)  I did
> *not* start the gc-daemon and worked without any problems for
> several hours. Free space was reduced by several GBs - but I started
> with plenty of free space left.
>
> During the night I run the gc to claim back unused space. In the
> morning the gc seemed to have crashed again. The PC still worked but
> essential parts of the system were frozen - so no clean shutdown was
> possible.
>
> This time the system was severely damaged. The next reboot failed
> with an error message (failed mount). (Sorry, I was in a hurry and
> did not memoize the exact reading of the message.)

Hmm, did you apply any change to accelerate GC?
Do you think how can I rate up the reproducibility of your problem?

Sounds some effort is needed to clean up quality problems of the
garbage collection.

> Another issue: Sometimes the gc stops after some time leaving the
> following message in the kernel log. (The message seems to stem from
> another part of the kernel, but I'm sure it is connected to the
> gc-daemon.)
>
> vmap() failed while attempting to map about 256 MB of memory

This message means that an ioctl routine of nilfs failed to allocate
virtual memory in kernel.  Setting nsegments_per_clean to a high value
makes this likely.

> (Sorry, once more - I had stored the exact message on the crashed
> file system and had to repeat it from memory.)
>
> I'm using an unmodified 2.6.30 kernel with builtin nilfs (no module).
> 
> Greetings, Michael

Thanks,
Ryusuke Konishi
