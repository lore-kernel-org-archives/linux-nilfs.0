From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [SPAM] Set the protection period to zero
Date: Tue, 02 Jun 2009 21:05:52 +0900 (JST)
Message-ID: <20090602.210552.76002031.ryusuke@osrg.net>
References: <007501c9e34f$fad3b5f0$f07b21d0$@iis.u-tokyo.ac.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <007501c9e34f$fad3b5f0$f07b21d0$@iis.u-tokyo.ac.jp>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, yongkun-b/Nwfc8pyCekRP3n4FtbsiGn5s73+xxf@public.gmane.org

Hi,
On Tue, 2 Jun 2009 16:01:40 +0900, "Yongkun Wang" wrote:
> Hey guys,
> 
> I want to set the protection period to zero, to disable the snapshot
> or checkpoint.  What I want is a simple log-structured file
> system. The GC can clean the obsolete blocks by interval only.
> 
> Is that possible?

I don't think it's achieved just by setting protection period to zero,
but it's possible by rewriting a few functions in cleanerd.c.

Of course, it's not exactly the same because nilfs kernel codes still
performs additional work needed to create checkpoints.

But, does it have a point for you?


Regards,
Ryusuke Konishi
