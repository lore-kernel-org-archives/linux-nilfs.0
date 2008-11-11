From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: cleaner cpu usage
Date: Tue, 11 Nov 2008 13:46:14 +0900 (JST)
Message-ID: <20081111.134614.32672538.ryusuke@osrg.net>
References: <4917D589.6090407@prnet.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <4917D589.6090407-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
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

On Mon, 10 Nov 2008 07:32:41 +0100, David Arendt wrote:
> Hi,
> 
> I am currently testing nilfs on a 1TB partition with 600GB of data. I
> noticed that I sometimes have through several hours 20% cpu usage by the
> cleaner. During the 20% usage, I have 50% iowait, leading to an overall
> slower system. Is this behaviour normal or is there something I can do
> on my part.

I've tried to reproduce the problem with my 1TB drive, but I didn't
see such high load for the cleanerd so far.  In my system, the cpu
usage by the cleanerd was about ~5% or so.  The phenomenon may depend
on the machine environment.  If you notice the condition that seems to
make the load higher, please let us know.

> If this is normal, I think it should be possible that I
> mount without cleaner and start the cleaner only if I am short on space.
> Is there any argument against doing this ?

Yes, you can manually stop or start the cleanerd.

Or you can possibly reduce the load by changing the following cleaner
parameters in /etc/nilfs_cleanerd.conf:

1) nsegments_per_clean (default: 2 segments)
   The maximum number of segments cleaned at a time.
   Decreasing this value slowdowns GC.

2) cleaning_interval (default: 5 seconds)
   Cleaning interval in seconds.
   Increasing this value moderates the GC frequency.


With regards,
Ryusuke Konishi
