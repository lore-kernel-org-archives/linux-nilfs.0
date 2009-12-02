From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: nilfs_cleanerd problem
Date: Thu, 03 Dec 2009 01:17:32 +0900 (JST)
Message-ID: <20091203.011732.85411657.ryusuke@osrg.net>
References: <1259743921.7717.3.camel@Stanowisko-25>
	<20091203.010653.90356741.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20091203.010653.90356741.ryusuke-sG5X7nlA6pw@public.gmane.org>
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

(resent)
On Thu, 03 Dec 2009 01:06:53 +0900 (JST), Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wrote:
> Hi,
> On Wed, 02 Dec 2009 09:52:01 +0100, Bukasz Wojcicki <lwojcicki-V+nj596LuoKHKKo6LODCOg@public.gmane.org> wrote:
> > I use kernel v2.6.20.4 with nilfs 2.0.18 and nilfs-utils 2.0.14.
> > When nilfs_cleanerd is starting I've got:
> > 
> > Dec  2 09:47:35 ep93xx user.err kernel: NILFS: GC failed during
> > preparation: cannot read source blocks: err=-5
> > Dec  2 09:47:35 ep93xx daemon.err nilfs_cleanerd[1312]: cannot clean
> > segments: Input/output error
> > Dec  2 09:47:35 ep93xx daemon.info nilfs_cleanerd[1312]: shutdown
> > 
> > 
> > Lukasz
> 
> Looks I/O error hit on your device.
> Can you read the partition as a file as follows ?
> 
>  # dd if=/dev/xxx of=/nilfs-disk
> 
> or if it's too big, try
> 
>  # dd if=/dev/xxx of=/dev/null
> 
> 
> Regards,
> Ryusuke Konishi
