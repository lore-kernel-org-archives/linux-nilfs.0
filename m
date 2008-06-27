From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: users Digest, Vol 27, Issue 3
Date: Fri, 27 Jun 2008 17:27:28 +0900 (JST)
Message-ID: <20080627.172728.108412355.ryusuke@osrg.net>
References: <mailman.1.1214535602.30509.users@nilfs.org>
	<60424.87.251.152.38.1214546611.squirrel@mail.teratelecom.ru>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <60424.87.251.152.38.1214546611.squirrel-2gm8jUAbe7J69i0UsrCe/SjHesifYMBh@public.gmane.org>
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

On Fri, 27 Jun 2008 10:03:31 +0400 (MSD), Oleg Volkov wrote:
> > Please let me know some details.
> >
> > How did you load the NILFS2 module (nilfs2.ko)
> > before mounting the root partition created by NILFS2 ?
> > Are you using an initrd image with nilfs2.ko ?
> 
> I patch kernel sources

I got it, thanks for the useful patch.

> > What kind of message was printed in the problem,
> > or did it hang up ?
> 
> # mount -f /
> /sbin/mount.nilfs2: invalid option -- f
> 
> 
> mount -o remount,ro /
> mount -o remount,rw /
> It's my mistake.
> I did not correctly /etc/fstab
> 
> ---
> Oleg Volkov

I realized that the recent mount program passes this option
to helper mount programs, but the current mount.nilfs2
does not support it.
OK, I will add the option to mount.nilfs2 later.

Thanks again for letting me know this.

Cheers,
Ryusuke Konishi
