From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: nilfs2 fails to mount after io/error
Date: Thu, 04 Dec 2008 19:25:35 +0900 (JST)
Message-ID: <20081204.192535.44147932.ryusuke@osrg.net>
References: <20081203162628.B82C3829D@blinkenlights.ch>
	<20081204.170654.88475919.ryusuke@osrg.net>
	<200812041931.02528.chris@csamuel.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <200812041931.02528.chris-Ru3vu9m2XlBAfugRpC6u6w@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, chris-Ru3vu9m2XlBAfugRpC6u6w@public.gmane.org

Hi,

On Thu, 4 Dec 2008 19:30:59 +1100, Chris Samuel wrote:
> On Thu, 4 Dec 2008 7:06:54 pm Ryusuke Konishi wrote:
> 
> > This never occurs if the block device is
> > supporting 'write barrier' feature properly.
> >
> > Could you tell me the kernel version that you are using?
> >
> > I feel that an additional disk flush operation may be
> > needed for older kernels or such devices. (Of course,
> > first priority should be on making fsck.)
> 
> It's worth remembering that (unless something has changed recently) filesystems 
> on a logical volume using LVM won't have barriers either.
> 
> cheers,
> Chris

That's right!  It should be counted.

Thanks,
Ryusuke Konishi
