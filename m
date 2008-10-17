From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: System crashed by cleanerd
Date: Fri, 17 Oct 2008 16:07:44 +0900 (JST)
Message-ID: <20081017.160744.98074838.ryusuke@osrg.net>
References: <474dca090810130444j1c3ab2a0rd5257f76153f63b@mail.gmail.com>
	<20081015.125249.23118089.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20081015.125249.23118089.ryusuke-sG5X7nlA6pw@public.gmane.org>
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

On Wed, 15 Oct 2008 12:52:49 +0900 (JST), Ryusuke Konishi wrote:
> On Mon, 13 Oct 2008 13:44:34 +0200, "Peter Smith" wrote:
> > After mounting my existing Nilfs2 partition,  which has been in use for a
> > year,
> > as soon as cleanerd starts my entire system crashes.
> 
> I found a related bug in the cleaner daemon and fixed it,
> but the cleaner still reproduces crash.

I pushed another patch to the nilfs-utils git tree.
I believe it will fix the crash problem this time.

Later I will bump the version of nilfs-utils to 2.0.6.

Regards,
Ryusuke Konishi
