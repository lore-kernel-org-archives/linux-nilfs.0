From: Adrian Ulrich <adrian-4ZM2p5qjiQGewZBzVTKGGg@public.gmane.org>
Subject: Re: nilfs2 fails to mount after io/error
Date: Fri, 28 Nov 2008 15:37:32 +0100
Message-ID: <20081128153732.be4f5cf8.adrian@blinkenlights.ch>
References: <20081126182158.20FD28306@blinkenlights.ch>
	<20081128.164300.47236105.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20081128.164300.47236105.ryusuke-sG5X7nlA6pw@public.gmane.org>
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

> In the meantime, please try the contained patch as follows:

mount.nilfs2 now 'hangs' while mounting the filesystem:

 - CPU-Usage ~ 10%
 - 100% io-wait


Do you think that mount.nilfs2 will ever finish? (It's running since ~15 minutes)


Regards,
 Adrian
