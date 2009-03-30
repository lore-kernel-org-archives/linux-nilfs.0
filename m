From: David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
Subject: Re: NILFS 2.0.12 released
Date: Mon, 30 Mar 2009 21:29:27 +0200
Message-ID: <49D11D97.3020702@prnet.org>
References: <20090330.183317.16041871.ryusuke@osrg.net>
	<f3642e6b0903301002v2e9fe0afj2b2a4b3d9dd2cecd@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <f3642e6b0903301002v2e9fe0afj2b2a4b3d9dd2cecd-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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

Hi,

Many thanks from me too.
Until now everything works completely fine.
I will report back if a problem will appear.

After using the new version, I had twice the following crash:

Call Trace:
 [<c01247be>] copy_process+0xa3e/0xf90
 [<c0124e27>] do_fork+0x77/0x2c0
 [<c017b740>] sys_pipe2+0x40/0x70
 [<c0101622>] sys_clone+0x32/0x40
 [<c0103131>] sysenter_do_call+0x12/0x25

but I will report this to the kernel mailing list as I suspect this has 
nothing to do with nilfs, but was triggered by pure hazard after running 
the new version.

Bye,
David


Andreas Hartmetz wrote:
> On 3/30/09, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wrote:
>   
>> Dear NILFS users,
>>
>> We have released nilfs-2.0.12.
>>
>> This release fixes GC-related problems which are suspected to cause
>> filesystem corruption recently reported in this mailing list.
>>
>> Thanks to David Arendt and Andreas Hartmetz for their feedback and
>> cooperation.  I hope this will stabilize cleaner operation.
>>
>> The updated package is available at:
>> http://www.nilfs.org/en/download.html
>>
>> Thanks,
>> Ryusuke Konishi
>>     
>
> I'm testing it already :)
> If you don't hear back from me you can assume that the problem is
> solved for me - so far there have been no errors. Thanks!
> _______________________________________________
> users mailing list
> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
> https://www.nilfs.org/mailman/listinfo/users
>   
