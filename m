From: nezmer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: Re: Pause intervals when copying/extracting an	archive
Date: Sat, 6 Jun 2009 16:49:28 +0300
Message-ID: <20090606134928.GA22242@nezmer.homelinux.org>
References: <20090516171555.GA21962@nezmer.homelinux.org>
	<20090517.122816.105794011.ryusuke@osrg.net>
	<20090605193256.GA3663@nezmer.homelinux.org>
	<20090606.045653.133237039.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20090606.045653.133237039.ryusuke-sG5X7nlA6pw@public.gmane.org>
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

On Sat, Jun 06, 2009 at 04:56:53AM +0900, Ryusuke Konishi wrote:
> Hi,
> On Fri, 5 Jun 2009 22:32:56 +0300, nezmer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> > Sorry for the late reply .
> > 
> > I tried to use deplock but I always get this :
> > SysRq : Show Locks Held
> > INFO: lockdep is turned off.
> > 
> > sysrq t works . I hope the attached file will be helpful .
> 
> Thanks for the log!
> 
> According to you log, the performance problem seems to be caused
> by a wait function in segment constructor of nilfs.
> 
> If you have a chance, please try the following coupled patch which
> comes from two patches queued for 2.6.31.  The upper half of the patch
> greatly improves read performance, and the lower part may have effect
> on the write performance.
> 
> Regards,
> Ryusuke Konishi

Unfortunately , the patches didn't help . I tried another flash disk. I
tried another archive (.tar.gz this time)  and the problem is still
there .

Is It possible the problem is related to snapshotting ? (the pauses
happen around 7 times in 40 seconds)
