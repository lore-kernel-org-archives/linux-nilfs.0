From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: System crashed by cleanerd
Date: Sat, 18 Oct 2008 14:24:59 +0900 (JST)
Message-ID: <20081018.142459.62714216.ryusuke@osrg.net>
References: <20081017.160744.98074838.ryusuke@osrg.net>
	<474dca090810170106r692903cau90ce7aff109876af@mail.gmail.com>
	<474dca090810170141g75e26b22ke382dd74a865dfbe@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <474dca090810170141g75e26b22ke382dd74a865dfbe-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: smithpdo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi,

On Fri, 17 Oct 2008 10:41:48 +0200, "Peter Smith" wrote:
> Wonderful, many thanks, problem solved,  it works
> I have just installed nilfs-utils from the git repository.
> I am now able to mount my old nilfs partition and cleanerd is happily
> working in the background

That's really nice ;-)

> I have noticed, now and in the past, from my disk activity graphs, that
> cleanerd runs for quite a long time after writing to the Nilfs partition. Is
> this to be expected?

The current cleaner is quite "unsmart"; it selects segments to be
reclaimed in fifo order, and cleans them only 2 segments (= 16MB) per
5 seconds by default.

So, if you made a massive amount of changes to the file system or keep
large volume of snapshotted blocks on disk, that could be possible.

If the cleaner never stops even though you leave the file system for
many hours, something would be wrong.

Regards,
Ryusuke Konishi
