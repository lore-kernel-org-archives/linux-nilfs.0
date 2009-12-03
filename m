From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: nilfs_cleanerd problem
Date: Thu, 03 Dec 2009 18:56:55 +0900 (JST)
Message-ID: <20091203.185655.55999146.ryusuke@osrg.net>
References: <1259743921.7717.3.camel@Stanowisko-25>
	<20091203.010653.90356741.ryusuke@osrg.net>
	<1259830135.10111.8.camel@Stanowisko-25>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1259830135.10111.8.camel@Stanowisko-25>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, lwojcicki-V+nj596LuoKHKKo6LODCOg@public.gmane.org

Hi,
On Thu, 03 Dec 2009 09:48:55 +0100, Lukasz Wojcicki <lwojcicki-V+nj596LuoKHKKo6LODCOg@public.gmane.org> wrote:
> Too late.
> I reformat SSD disk to FAT32 and format to NILFS2 again. Now it work
> correctly.

No, no. I suspect some kind of media error happened.  My intention is
just reading the block device for narrowing down the cause.  So, it's
independent with which filesystem is written on the device.

> When I've got another error yesterday too. I've got ETIME error (from
> linux kernel) while transferring large file (log) from SSD disk. This
> situation was place, when nilfs_cleanerd was running and I execute
> lscp . Then (after long time) nilfs_cleanerd was stopped .

Seems that the ETIME error comes from the device layer because nilfs
doesn't return it.  I suspect cleanerd actually caused the issue.  But
it seems to me that cleanerd degraded or overloaded your device.

So, I thought we first should test the device itself.

Regards,
Ryusuke Konishi
