From: Andrea Gelmini <andrea.gelmini-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Crash...
Date: Sat, 1 Aug 2009 15:39:17 +0200
Message-ID: <9cdbb57f0908010639l26c26182ma121b0d7672003e0@mail.gmail.com>
References: <9cdbb57f0907230555k768383c2ld1690d31cc6fff83@mail.gmail.com>
	<20090724.011249.110726474.ryusuke@osrg.net>
	<9cdbb57f0907231402i1a92cb4qfe5a9d81346a4665@mail.gmail.com>
	<9cdbb57f0907231420y4122d649y69fee2273a05b4cc@mail.gmail.com>
	<873a8jhsbd.wl%jir@sekiba.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <873a8jhsbd.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
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

2009/7/27 Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>:
> Can you reproduce the bug without using lvm volume?

Hi,
   to trigger the ops I had to write a file >4G.
   Anyway, with latest Ryusuke's patch, I had no problem at all, even
with nilfs on top of MD+LVM.

Thanks a lot,
Andrea
