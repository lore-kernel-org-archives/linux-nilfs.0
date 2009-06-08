From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: NIlfs panic
Date: Tue, 09 Jun 2009 02:13:16 +0900 (JST)
Message-ID: <20090609.021316.123404780.ryusuke@osrg.net>
References: <4A29F15F.7020804@0bits.com>
	<4A2CAE34.1050003@0bits.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <4A2CAE34.1050003-/hCUnnzDXf0AvxtiuMwx3w@public.gmane.org>
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
To: dave-/hCUnnzDXf0AvxtiuMwx3w@public.gmane.org
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi Dave,
On Mon, 08 Jun 2009 10:22:44 +0400, Dave <dave-/hCUnnzDXf0AvxtiuMwx3w@public.gmane.org> wrote:
> On 06/06/09 08:32, Dave wrote:
> > Hi
> > 
> > Ryusuke Konishi wrote:
> >> Hi,
> >> On Fri, 05 Jun 2009 22:44:31 +0400, Dave wrote:
> >>> Hi,
> >>>
> >>> Was running a make, find and i paniced. I know this i'm running tanited
> >>> due to nvidia closed binary, but it may be something worth looking at.
> >> I've identified the function and instruction arising the fault.
> >>
> >> Two questions:
> >>
> >>   - The kernel seems 2.6.28 not 2.6.30.
> >>     Which version of nilfs2-modules did you applied?
> >>     2.0.14 ? or HEAD on nilfs2-modules.git ?
> > 
> > It's 2.0.14 and yes on 2.6.28 (haven't moved to 2.6.29 because of
> > forcedeth network bug).
> > 
> >>   - Is is reproducible?
> > 
> > I'll try again today.
> > 
> 
> I've been unable to reproduce this so far and i've not lost any data in 
> the original panic so i'll just have to wait see if it happens again in 
> the future. At least we have the panic recorded in the mailing list for 
> future.

Thank you.  The repeatability itself is an important hint.  Some kind
of (rare) timing problem likely remains around delete or truncate path
of regular files.  If we can narrow down suspicious code path or
conditions, I will try to review the path.  Please send us report if
you meet a successive problem.

Thanks,
Ryusuke Konishi
