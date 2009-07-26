From: Andrea Gelmini <andrea.gelmini-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Regarding NILFS performance
Date: Mon, 27 Jul 2009 00:07:40 +0200
Message-ID: <9cdbb57f0907261507u6cd6f2cj3fc9ed5d97f7def6@mail.gmail.com>
References: <447f427d0907260807h73b8ce28r7e7c017c5911a0b1@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <447f427d0907260807h73b8ce28r7e7c017c5911a0b1-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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

2009/7/26 havuz goz <dutdurudut-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> Let me elaborate: If the OS was optimized so that it cached
> frequently-accessed and modified small files in ram, it would provide a much
> more responsive user experience. Maybe a fork of NILFS will support this? Or
> optional modes?

That's the work of VFS. It already happens.

A fs must be rocksolid, than you can worry about speed (well, it's
another story if you accept to lost data, but in the fastest way)...
Anyway, if speed is your worry (but not so much the integrity), you
can use a SSD.

Bye,
Andrea
