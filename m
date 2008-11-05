From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: mkcp does not follow symbolic links
Date: Wed, 05 Nov 2008 12:04:14 +0900 (JST)
Message-ID: <20081105.120414.128884447.ryusuke@osrg.net>
References: <474dca090811040116o5f2d1d05ka9bdeabef4f8c672@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <474dca090811040116o5f2d1d05ka9bdeabef4f8c672-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, smithpdo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Hi,

On Tue, 4 Nov 2008 11:16:01 +0200, "Peter Smith" wrote:
> Hi
> 
> It seems that mkcp does not follow symbolic links
> 
> The command
> mkcp -s /dev/disk/by-id/usb-ST325031_5RY1_888888888888-0:0-part3
> gives this message:
> mkcp: /dev/disk/by-id/usb-ST325031_5RY1_888888888888-0:0-part3: cannot open
> NILFS
> 
> I use the 'disk/by-id' path because it is stable, despite
> removing/installing other drives
> 
> I solve the problem in my code by converting the symbolic link to a real
> path such as /dev/sde3
> and then mkcp works as expected.
> 
> I mention this because it is a potential trap for the unwary.
> 
> My environment is Suse Linux 10.3

Thanks for reporting this issue.

This comes from the nilfs2-utils stab library.
Hence, other tools including lscp, chcp, or lssu have the same problem.

I'll put it in our bugtrack list.

With regards,
Ryusuke Konishi
