From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: lockups?
Date: Tue, 16 Dec 2008 23:50:02 +0900 (JST)
Message-ID: <20081216.235002.56335284.ryusuke@osrg.net>
References: <856033f20812151951t2411ec88g8075616cf9e3e96f@mail.gmail.com>
	<20081216.210034.01578004.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20081216.210034.01578004.ryusuke-sG5X7nlA6pw@public.gmane.org>
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

On Tue, 16 Dec 2008 21:00:34 +0900 (JST), Ryusuke Konishi wrote:
> Hi,
> On Mon, 15 Dec 2008 22:51:50 -0500, "Paul L" <ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > After using nilfs for both my root and home partition for about a
> > week, I had perhaps 4 or 5 lockups, which never occurred before when I
> > was using ext2 or reiserfs. At one instance, it locked up immediately
> > after the laptop wakes up from the suspend-to-ram mode. 
> 
> Oh, really?  In my Debian laptop with nilfs2, both the suspend-to-ram
> and hibernation are well-functioning. (lenny 2.6.26-1-686 in my case)

Could you send me your kernel config file?

I'd like to test STR against the same kernel version (and config)
which you are using.

Cheers,
Ryusuke
