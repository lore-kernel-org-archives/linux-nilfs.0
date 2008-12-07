From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: nilfs2 fails to mount after io/error
Date: Mon, 08 Dec 2008 01:04:07 +0900 (JST)
Message-ID: <20081208.010407.85941224.ryusuke@osrg.net>
References: <20081204140431.ec72f1ec.adrian@blinkenlights.ch>
	<20081207.040509.20004012.ryusuke@osrg.net>
	<20081207132335.868f8479.adrian@blinkenlights.ch>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20081207132335.868f8479.adrian-4ZM2p5qjiQGewZBzVTKGGg@public.gmane.org>
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
To: adrian-4ZM2p5qjiQGewZBzVTKGGg@public.gmane.org
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi Adrian,
On Sun, 7 Dec 2008 13:23:35 +0100, Adrian Ulrich wrote:
> Hi Ryusuke,
> 
> > will, hopefully, correct your partition.
> > (I'm not sure because it's not yet tested enough)
> 
> Thanks a lot for the patch: Running fsck0 fixed the problem and i was
> able to mount the filesystem.
> 
> So far everything looks fine (data is stll there and i can write to the filesystem),

That's the good news!

> but: I got this in my syslog:
> 
>  segctord starting. Construction interval = 5 seconds, CP frequency < 30 seconds
>  NILFS warning: mounting fs with errors
> 
> 
> Should i worry about this?

This message means that the filesystem has detected some sort of
inconsistency, but you don't have to worry in your case; the error
flag can be marked imprecisely when a filesystem has detected I/O
errors even if no inconsistency occurs.

This flag is not cleared by fsck0 because I haven't yet implemented
the feature which fully verifies coherency of a filesystem. ;)

Well, if you can't ignore the message, I can add a dummy force check
option that does nothing but drop the flag.

Regards,
Ryusuke Konishi
