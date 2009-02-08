From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: cleanerd segfault
Date: Mon, 09 Feb 2009 03:09:49 +0900 (JST)
Message-ID: <20090209.030949.111690676.ryusuke@osrg.net>
References: <lB4DD31fNVpx.grrKfnNr@mail.prnet.org>
	<20090205.181904.55833415.ryusuke@osrg.net>
	<20090207.203808.94866640.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090207.203808.94866640.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org

On Sat, 07 Feb 2009 20:38:08 +0900 (JST), Ryusuke Konishi wrote:
> I've pushed out updates that would fix this problem.
> (Both nilfs-utils and nilfs2-modules were updated).
> 
> It turned out to be a regression brought by one of the recent bug
> fixes.  It was lucky that this was found before the next release.

Grr, I found another critical bug on a checkpoint ioctl.
It may be the cause of the GC related troubles.

Please wait trying this until the next patch will be pushed out.

Regards,
Ryusuke
