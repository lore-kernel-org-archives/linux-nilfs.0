From: Adrian Ulrich <adrian-4ZM2p5qjiQGewZBzVTKGGg@public.gmane.org>
Subject: Re: nilfs2 fails to mount after io/error
Date: Sun, 7 Dec 2008 13:23:35 +0100
Message-ID: <20081207132335.868f8479.adrian@blinkenlights.ch>
References: <20081204092947.c29d230d.adrian@blinkenlights.ch>
	<20081204.215805.88483726.ryusuke@osrg.net>
	<20081204140431.ec72f1ec.adrian@blinkenlights.ch>
	<20081207.040509.20004012.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20081207.040509.20004012.ryusuke-sG5X7nlA6pw@public.gmane.org>
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

Hi Ryusuke,

> will, hopefully, correct your partition.
> (I'm not sure because it's not yet tested enough)

Thanks a lot for the patch: Running fsck0 fixed the problem and i was
able to mount the filesystem.

So far everything looks fine (data is stll there and i can write to the filesystem),
but: I got this in my syslog:

 segctord starting. Construction interval = 5 seconds, CP frequency < 30 seconds
 NILFS warning: mounting fs with errors


Should i worry about this?


Regards,
 Adrian
