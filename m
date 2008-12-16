From: "Paul L" <ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: lockups?
Date: Tue, 16 Dec 2008 08:15:54 -0500
Message-ID: <856033f20812160515p5e3657e3m7cc4c061a8cb75a3@mail.gmail.com>
References: <856033f20812151951t2411ec88g8075616cf9e3e96f@mail.gmail.com>
	<20081216.210034.01578004.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20081216.210034.01578004.ryusuke-sG5X7nlA6pw@public.gmane.org>
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

On 12/16/08, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wrote:
> Debugging STR problem is usually hard.
> I don't know the magic bullet for it.
>
> If you can change the screen to an active console using
> Ctrl-Alt-F[1-7] (in case of Debian) during the lockup, you may
> identify the process and function causing the problem:

Like I said, the laptop would completely lock up and not
respond to any key press.

>  - In case not applying nilfs2 to the root directory.
>  - without X environment.
>  - without the cleaner daemon. (i.e. STRs after killing the cleanerd)
>  - without writable mount (i.e. STRs without remount r/w)
>
> Any ideas?

If I recall correctly, every time when I had this was after the laptop
had at least one resume from suspend-to-ram. Only in one occation
it locked up immediately. Other times, it kept working for hours and I
could suspend it and wake it up again without problem.

So maybe I'll repeat this, and try out the conditions you mentioned.
I'll post again when I have more info. Thanks!

-- 
Regards,
Paul Liu

Yale Haskell Group
http://www.haskell.org/yale
