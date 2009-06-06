From: Dave <dave-/hCUnnzDXf0AvxtiuMwx3w@public.gmane.org>
Subject: Re: NIlfs panic
Date: Sat, 06 Jun 2009 08:29:14 +0400
Message-ID: <4A29F09A.6090609@0bits.com>
References: <4A29678F.10306@0bits.com>
	<20090606.122631.12792376.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090606.122631.12792376.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>, ryusuke-sG5X7nlA6pw@public.gmane.org

Hi

Ryusuke Konishi wrote:
> Hi,
> On Fri, 05 Jun 2009 22:44:31 +0400, Dave wrote:
>> Hi,
>>
>> Was running a make, find and i paniced. I know this i'm running tanited
>> due to nvidia closed binary, but it may be something worth looking at.
>
> I've identified the function and instruction arising the fault.
>
> Two questions:
>
>   - The kernel seems 2.6.28 not 2.6.30.
>     Which version of nilfs2-modules did you applied?
>     2.0.14 ? or HEAD on nilfs2-modules.git ?

It's 2.0.14 and yes on 2.6.28 (haven't moved to 2.6.29 because of 
forcedeth network bug).

>   - Is is reproducible?

I'll try again today.

Thanks
Mitch
