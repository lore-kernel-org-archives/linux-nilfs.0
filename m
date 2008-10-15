From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: System crashed by cleanerd
Date: Wed, 15 Oct 2008 12:52:49 +0900 (JST)
Message-ID: <20081015.125249.23118089.ryusuke@osrg.net>
References: <474dca090810130444j1c3ab2a0rd5257f76153f63b@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <474dca090810130444j1c3ab2a0rd5257f76153f63b-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, smithpdo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Hi, Peter.

On Mon, 13 Oct 2008 13:44:34 +0200, "Peter Smith" wrote:
> Hi
> I am a happy and long time user of nilfs2 but have just hit a major snag.
> 
> After mounting my existing Nilfs2 partition,  which has been in use for a
> year,
> as soon as cleanerd starts my entire system crashes.
> (display, mouse and keyboard unresponsive, but can restart with Alt SysReq
> B)
> 
> If I mount with -i option, to disable cleanerd, then I can access my Nilfs2
> partition, with no crashes.
> If I create/mount a new Nilfs2 partition and populate it with a large number
> of files then
> all works normally, including cleanerd.
> 
> So, seemingly, cleanerd has found something it does not like in my old
> partition and this
> causes it to abort.

Thanks for reporting this problem.
We've received the same problem from another user,
and are working on this issue.

I found a related bug in the cleaner daemon and fixed it,
but the cleaner still reproduces crash.
As you guessed, I think it's a cleaner bug and will
review it again.

Anyway I'll keep you informed of my progress for this.

With regards,
Ryusuke Konishi
