From: Andrea Gelmini <andrea.gelmini-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Crash...
Date: Sat, 1 Aug 2009 15:36:22 +0200
Message-ID: <9cdbb57f0908010636u7296da29p61df192dc35d0d12@mail.gmail.com>
References: <9cdbb57f0907230555k768383c2ld1690d31cc6fff83@mail.gmail.com>
	<20090724.011249.110726474.ryusuke@osrg.net>
	<9cdbb57f0907231402i1a92cb4qfe5a9d81346a4665@mail.gmail.com>
	<20090729.114604.56042421.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090729.114604.56042421.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

2009/7/29 Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>:
> Could you test if the patch makes a difference for the same file ?

Well,
   I used this:
   git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git
(branch fixes)

   I stressed it a lot, and it works perfectly.
   In a few days I will test the 2048 block size, too (even I guess
it's not necessary).

Thanks a lot for your work,
Andrea
