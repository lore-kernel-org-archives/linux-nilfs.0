From: kinneko <kinneko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: NILFS on ARM ?
Date: Mon, 4 Aug 2008 14:28:20 +0900
Message-ID: <7eb9f45c0808032228x48cf27f2h663694f141e331fe@mail.gmail.com>
References: <5d6e2cd0808032215t684f57aclfc699b6c7f4a276c@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <5d6e2cd0808032215t684f57aclfc699b6c7f4a276c-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

Hi,

  I tested NLFS2.0.0 on Marvell Orion Platform.
  The kernel is kernel-image-2.6.12.6-arm1_OLP.0.1_arm.deb based on Marvell LSP.
  I carried out a load test, it works without a problem.

  But I do not understand whether the controller of flash memory and
NILFS2 go well.


2008/8/4, Matt Joyce <matt.joyce-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> Hi,
>
>  I notice there is no obvious support for ARM.
>  Is NILFS suitable for small devices such as the Openmoko Freerunner? [1]
>  This device runs linux and has a microsd slot, volumes would typically
>  be between 512mb to 16gb.
>
>  I'm inexperienced with compiling and using these projects, but I think
>  I may try.
>  This [2] looks like is might be useful.
>
>  Does anyone see any potential problems?
>
>  Regards
>
>  Matt
>
>  [1] http://wiki.openmoko.org/wiki/Neo_FreeRunner_GTA02_Hardware
>  [2] http://wiki.openmoko.org/wiki/Toolchain
>  _______________________________________________
>  users mailing list
>  users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
>  https://www.nilfs.org/mailman/listinfo/users
>
