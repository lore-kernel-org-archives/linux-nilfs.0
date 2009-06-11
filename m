From: Luis Useche <luis-43oy+cWvsXk3uPMLIKxrzw@public.gmane.org>
Subject: Re: Stressing GC
Date: Thu, 11 Jun 2009 11:39:50 -0400
Message-ID: <20090611153950.GA26921@apu.cs.fiu.edu>
References: <20090610210859.GA17619@apu.cs.fiu.edu>
	<4A30856F.3000103@0bits.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4A30856F.3000103-/hCUnnzDXf0AvxtiuMwx3w@public.gmane.org>
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

On Thu, Jun 11, 2009 at 08:17:51AM +0400, Dave wrote:
> On 06/11/09 01:08, Luis Useche wrote:
> > Hi Guys,
> > 
> > I was doing some experiments on nilfs2 to stress the garbage collection
> > with different file system usage. Unfortunately, it was unable to pass the
> > first test since nilfs reports no space available eventhough there are no
> > files in the file system! I guess the GC is not collecting space fast
> > enough and the file system ends up with no space available.
> > 
> > Do you have any workaround to this problem?
> 
> I don't understand. There is no 'problem' to workaround. This is by 
> design. You're right, the GC has to reclaim your deleted files before it 
> release the space to the filesystem. If you remove all your checkpoints 
> and wait for your 'protection_period' interval you should see you space 
> reappear. The whole idea or nilfs is that you could do a 'rm -rf *' and 
> be left with no files, but still recover all your files from a 
> checkpoint that happened for you automatically a few seconds ago.

Thanks for your response.

I still think is a problem. IMHO, it is not correct to report no available
space when you don't have any file in the file system. I would think that
in this situations, instead of reporting to the application "no space
left", the correct action is to throttle the GC (ignoring the
configurations) so that enough rooms is made for the incoming requests
ASAP. I guess this is object of debate and I see points in favor and
against. At the end, this probably depends on the user: (1) protect old
data or (2) have the application running as long as some space is
available.

In any case, in my experiment, I want to stress exactly this situation.
LFS tends to decrease its performance dramatically when it is running out
of space. I want to see how fast the performance is decreased when the
usage of the file system is incremented.

With the current GC implementation, I am unable to do my experiment. I set
"protection_period 0" but still have the problem. Besides, this is
probably not the right solution either since the GC can do unnecessary work
that can underestimate the potential of nilfs. I need the first option (1)
from the first paragraph above.

Are there any workaround I can use to make this work.

Thanks in advance,
-- 
Luis Useche <luis-43oy+cWvsXk3uPMLIKxrzw@public.gmane.org>
Ph.D. Student
Florida International University
