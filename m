From: "Paul L" <ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: lockups?
Date: Thu, 25 Dec 2008 21:50:38 -0500
Message-ID: <856033f20812251850i38e2ed69lb311337763b9a65e@mail.gmail.com>
References: <856033f20812151951t2411ec88g8075616cf9e3e96f@mail.gmail.com>
	<20081216.210034.01578004.ryusuke@osrg.net>
	<20081216.235002.56335284.ryusuke@osrg.net>
	<856033f20812190645k262aadd2mc2bd81462aa0518a@mail.gmail.com>
	<1229946960.12078.44.camel@localhost.localdomain>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1229946960.12078.44.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Content-Disposition: inline
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
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Thanks for the advice! I've upgraded to 2.6.28-rc9 and turned off PREEMPT.
Now two days passed, and yet to see one crash. So far so good! I'll report
back after a longer period of testing.

Regards,
Paul Liu

On 12/22/08, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wrote:
> Hi Paul,
>
> On Fri, 2008-12-19 at 09:45 -0500, Paul L wrote:
>> Ok, I managed to capture the crash, this time it happened when I was
>> in console not X. So the screen grab may tell some useful info, just
>> pardon my bad camera skills :P
>>
>> A photo is attached.
>
> Thanks for the photo.
>
> According to the screen dump, a preemption counter which is used
> to kernel interrupt handlings, seems to be unexpectedly raised
> by something and kunmap() kernel function called by nilfs
> unfortunately detected it.
>
> Though I'm looking at the functions which appear in the stack dump,
> there is a possibility that this was caused by some problem of the
> 2.6.28-rc4 kernel.
>
> To separate suspicious kernel functions,
> could you try turning off CONFIG_PREEMPT option?
>
> I've tested the same kernel (i.e. linux-2.6.28-rc4) with your config,
> but not yet succeeded to reproduce your problem.
>
> With regards,
> Ryusuke
>
>
>


-- 
Regards,
Paul Liu

Yale Haskell Group
http://www.haskell.org/yale
