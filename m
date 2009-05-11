From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Can't mount nilfs - error searching super root.
Date: Tue, 12 May 2009 03:52:01 +0900 (JST)
Message-ID: <20090512.035201.81813641.ryusuke@osrg.net>
References: <20090422.234455.05227091.ryusuke@osrg.net>
	<3313c4ab0905100750p503664acl3b44d043db3d23ae@mail.gmail.com>
	<3313c4ab0905110832r6ca78e18h570a6f89d6078be6@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <3313c4ab0905110832r6ca78e18h570a6f89d6078be6-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, milosdsax-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Hi,
On Mon, 11 May 2009 17:32:48 +0200, Milos Jana wrote:
> The first patch modifies the file /fs/nilfs2/ioctl.c, while NILFS 2.0.12 and
> current git version have this file located under the path /fs/ioctl.c.
> Anyway, I have replaced all strings "/fs/nilfs/" with "/fs/", which allowed
> me to apply the first patch, but the second one and compilation failed:
> 
> $ patch -p1 < patch1.patch
> patching file fs/ioctl.c
> Hunk #6 succeeded at 572 (offset -2 lines).
> Hunk #7 succeeded at 606 (offset -2 lines).
> 
> $ patch -p1 < patch2.patch
> patching file fs/ioctl.c
> Hunk #1 FAILED at 25.
> Hunk #5 FAILED at 432.
> Hunk #6 succeeded at 448 (offset -2 lines).
> Hunk #7 succeeded at 469 (offset -2 lines).
> Hunk #8 succeeded at 478 (offset -2 lines).
> Hunk #9 succeeded at 486 (offset -2 lines).
> Hunk #10 succeeded at 506 (offset -2 lines).
> 2 out of 10 hunks FAILED -- saving rejects to file fs/ioctl.c.rej
> patching file fs/nilfs.h
> Hunk #1 succeeded at 245 (offset 9 lines).
> patching file fs/segment.c
> Hunk #1 succeeded at 2789 (offset 200 lines).
> Hunk #2 succeeded at 2807 (offset 200 lines).
> patching file fs/segment.h

<snip>

Sorry for confusing you.

These patches I have recently posted on this mailing list is not
against out-of-tree modules but against linux-2.6.30-rc5 (i.e. Linus'
kernel tree). And, these will not solve your problem.

I'll apply corresponding patches to the nilfs2-module git tree after
Linus merged into the mainline.


Regards,
Ryusuke Konishi
