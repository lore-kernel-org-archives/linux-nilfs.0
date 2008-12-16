From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: lockups?
Date: Tue, 16 Dec 2008 21:00:34 +0900 (JST)
Message-ID: <20081216.210034.01578004.ryusuke@osrg.net>
References: <856033f20812151951t2411ec88g8075616cf9e3e96f@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <856033f20812151951t2411ec88g8075616cf9e3e96f-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Hi,
On Mon, 15 Dec 2008 22:51:50 -0500, "Paul L" <ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> After using nilfs for both my root and home partition for about a
> week, I had perhaps 4 or 5 lockups, which never occurred before when I
> was using ext2 or reiserfs. At one instance, it locked up immediately
> after the laptop wakes up from the suspend-to-ram mode. 

Oh, really?  In my Debian laptop with nilfs2, both the suspend-to-ram
and hibernation are well-functioning. (lenny 2.6.26-1-686 in my case)

> I wonder if it's due to nilfs2, and what's the best way to help
> debugging this situation. Would it help to turn on some logging?
> Thanks!

Debugging STR problem is usually hard.
I don't know the magic bullet for it.

If you can change the screen to an active console using
Ctrl-Alt-F[1-7] (in case of Debian) during the lockup, you may
identify the process and function causing the problem:

e.g.
 # echo t > /proc/sysrq-trigger 
 # dmesg | less

If the problem is reproducible, separating conditions seems effective;
for example, whether the problem is reproducible or not in the
following condition:

 - In case not applying nilfs2 to the root directory.
 - without X environment.
 - without the cleaner daemon. (i.e. STRs after killing the cleanerd)
 - without writable mount (i.e. STRs without remount r/w)

Any ideas?

Regards,
Ryusuke
