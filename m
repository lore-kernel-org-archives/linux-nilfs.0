From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: System Lockup while testing nilfs
Date: Fri, 19 Jun 2009 20:18:39 +0900 (JST)
Message-ID: <20090619.201839.116939551.ryusuke@osrg.net>
References: <mailman.1.1245380401.15040.users@nilfs.org>
	<20090619093706.2eb83534@simplux>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090619093706.2eb83534@simplux>
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
Cc: James M Long <james.m.long-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hi,
On Fri, 19 Jun 2009 09:37:06 +0200, "Dipl.-Ing. Michael Niederle" wrote:
> Hi!
> 
> > I have turned on debug in the nilfs_cleanerd config file and I
> > am capturing the log to a separate location. The lockup seems to occur
> > right after a "2 segments selected to be cleaned" message was sent.
> 
> > gentoo distribution
> > 2.6.30 kernel x86
> > nilfs-utils 2.0.12
> 
> This looks very much the same problem I encountered! It seems that under some
> circumstances the GC daemon issues too many read/write requests.
> 
> @Ryusuke Konishi: The last crash occured with default GC settings.
> 
> Greetings, Michael

By default, GC reads and writes 2 segments per 5 seconds.

  1 segment = 8MB (by default)

So, at maximum, it causes roughly 3.2MB read + 3.2MB write per second.

If all blocks in the segments were live, GC will copy all of them into
new logs; that is 6.4MB/s I/O at worst.

If dead blocks occupies 50% of segments, the I/O load is estimated to
be 3.2MB/sec since the number of copy blocks drops by half.

Under the circumstance where many snapshots exist or the protection
period is set long, the rate of the must-copy-blocks can be very high.

Are you onto something?

Essentially, GC should be designed to minimize load in adapting to
situation.  Unfortunately, the current GC is not intelligent at all.
It cannot

 - stop intelligently
 - resume operation intelligently
 - balance reclamation speed, nor
 - select target segments so that the I/O load gets minimized.

Much work to do.

Regards,
Ryusuke Konishi
