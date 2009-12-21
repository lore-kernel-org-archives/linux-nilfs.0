From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Performance problems over AoE
Date: Tue, 22 Dec 2009 03:46:36 +0900 (JST)
Message-ID: <20091222.034636.28059259.ryusuke@osrg.net>
References: <200912190224.46774.krustev@krustev.net>
	<20091219.184346.239007912.ryusuke@osrg.net>
	<200912211821.45366.krustev@krustev.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <200912211821.45366.krustev-sueGvCUcFGXR7s880joybQ@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/options/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: krustev-sueGvCUcFGXR7s880joybQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi,
On Mon, 21 Dec 2009 18:21:39 +0200, Delian Krustev wrote:
> 
> 	Hi,
> 
> Thanks for the answers.
> 
> On Sat, 19 Dec 2009 18:43:46 +0900 (JST) Ryusuke Konishi wrote:
> > Thank you for letting us know the interesting measurement result.
> > 
> > Actually we recognize similar issue on high performance drives, but
> > this looks worse than the cases we know.
> 
> This might be due to the increased latency of the AoE device.

I agree.
 
> > In the 2.6.33 merge window, I sent some series of patches upstream to
> > improve write performance.  And, the effort is still going on.
> > 
> > I would appreciate it if you could try nilfs in kernel 2.6.33-rc1 or
> > optimization patches that will be appeared ongoingly in this list or
> > linux-nilfs.
> 
> OK, I will try it. Just have to figure out on which hardware since the
> setup I've described is on production systems and running early RC kernels
> there is not an option.
> But I will probably find the metal or will create some VM images.

Thank you for your cooperation.

If you prefer customized kernels prior to 2.6.30, I can upload a new
git tree of nilfs2 kmod which backported the latest improvement
patches.

In my debian environment, 2.6.33-rc1 vanilla kernel is, so far,
working nicely.

> > Unfortunately no.  The contiguous check point creation is what nilfs
> > stands for.  But, I think the performance impact of cp creation is not
> > so high unless you are doing osync writes.
> 
> Did you read the part for the cleanerd causing high load on the network
> interface ?

OK, so you mean cp creation by GC.

Yes, it's another issue.  GC of nilfs involves checkpoint creation.
The problem is, the current GC is so stupid and leading to needless
I/O overheads.

You can turn off cleanerd with -i option.

e.g.
 # mount -t nilfs2 -i /dev/xxx /test-dir

And, this is useful when you want to separate the cause of performance
issue.  But anyway, GC should be definitely revised to remedy the
situation.

> And the checkpoints being created with no data modifications ?

Yes, even if you don't modify the filesystem, nilfs internally
requires it for GC.
 
> Do you have a guess for these ?

Well, it looks suffering either or both.  ``mount -i'' would clear up
the matter.

I recognize the current nilfs has both the latency issue and the GC
issue, and I believe both should be improved.

Cheers,
Ryusuke Konishi 
