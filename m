From: Reinoud Zandijk <reinoud-S783fYmB3Ccdnm+yROfE0A@public.gmane.org>
Subject: Re: Stressing GC
Date: Thu, 11 Jun 2009 17:20:40 +0200
Message-ID: <20090611152040.GF21314@aardappel.13thmonkey.org>
References: <20090610210859.GA17619@apu.cs.fiu.edu>
	<4A30856F.3000103@0bits.com>
	<20090611153950.GA26921@apu.cs.fiu.edu>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20090611153950.GA26921-F34IG+UkkWQ4ZZIPogyGsg@public.gmane.org>
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

Dear folks,

On Thu, Jun 11, 2009 at 11:39:50AM -0400, Luis Useche wrote:
> On Thu, Jun 11, 2009 at 08:17:51AM +0400, Dave wrote:
> > On 06/11/09 01:08, Luis Useche wrote:
> > > I was doing some experiments on nilfs2 to stress the garbage collection
> > > with different file system usage. Unfortunately, it was unable to pass the
> > > first test since nilfs reports no space available eventhough there are no
> > > files in the file system! I guess the GC is not collecting space fast
> > > enough and the file system ends up with no space available.
> > > 
> > > Do you have any workaround to this problem?
>
> With the current GC implementation, I am unable to do my experiment. I set
> "protection_period 0" but still have the problem. Besides, this is
> probably not the right solution either since the GC can do unnecessary work
> that can underestimate the potential of nilfs. I need the first option (1)
> from the first paragraph above.
> 
> Are there any workaround I can use to make this work.

idealiter there should be an analog to VMS's purge command, say purge_nilfs or
`nilfs purge /mnt' that flushes all data not protected by a snapshot or the
last checkpoint.

Could this be something?

Another more blunt method is say newfs'ing a disc, create a snapshot sometime,
mess around with it and later revert back to the snapshot.

With regards,
Reinoud
