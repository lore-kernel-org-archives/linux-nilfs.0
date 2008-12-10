From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: (no subject)
Date: Wed, 10 Dec 2008 11:31:11 +0900 (JST)
Message-ID: <20081210.113111.30450794.ryusuke@osrg.net>
References: <856033f20812081303v12353110jf51704b81d2a760@mail.gmail.com>
	<20081209.202059.122418779.ryusuke@osrg.net>
	<856033f20812090816l183c974dj9eed760b3deedb8c@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <856033f20812090816l183c974dj9eed760b3deedb8c-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi Paul,
On Tue, 9 Dec 2008 11:16:33 -0500, "Paul L" wrote:
> Strangely, the init scripts already did a remount of the root
> partition (with remount option), but cleanerd is not invoked. I had to
> do it for a second time in rc.local, then it becomes ok.

I heard that the nilfs_cleanerd depends on /usr/lib/libnilfs.so.*.
Could you confirm whether these dynamic libraries are installed in the
initrd?

> > Interesting.
> >
> > Could you tell me what brand of SSD is used in the netbook?
> 
> It's Intel SSD (SSDPAM0008G1EA), a very slow SSD with only 5-6 MB/s
> write speed. My netbook is Acer Aspire One model AOA110.

Informative. Thanks.

I recognize that nilfs2 performance fairly depends on devices, and it
still has much things to do well at various devices.
The nature of nilfs2 which sequentially uses the disk partition almost
entirely (like a ring buffer), well suited to your device.

Anyhow, thanks for letting us know.

Regards,
Ryusuke
