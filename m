From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: directory entries
Date: Tue, 02 Sep 2008 02:31:43 +0900 (JST)
Message-ID: <20080902.023143.104870007.ryusuke@osrg.net>
References: <48BB82F7.4070607@cs.columbia.edu>
	<20080901.171643.74124381.ryusuke@osrg.net>
	<48BBFBEA.2000308@cs.columbia.edu>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <48BBFBEA.2000308-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
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
To: spotter-eQaUEPhvms7ENvBUuze7eA@public.gmane.org
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

On Mon, 01 Sep 2008 10:27:54 -0400, Shaya Potter wrote:
> Ryusuke Konishi wrote:
> > It's working fine.
> > Is there a quicker way?  (Or something to add?)
> 
> well, with new unionfs, you wouldn't use unionctl, but what I did was 
> close, but something more along the lines of
> 
> - to setup
> 
> mkdir /base /nilfs /snap-ro /union
> mount -t ext3 /dev/sdb1 /base
> mount -t nilfs2 /dev/sdb2 /nilfs
> 
> mkdir /nilfs/1
> 
> mount -t unionfs -o dirs=/nilfs/1=rw,/base=ro none /union
> (use union), all writes go to nilfs
>
> - to rollback to a checkpoint, but keep it writable.
> 
> mount -t nilfs2 -o ro,cp=xyz /dev/sdb1 /snap-ro
> mkdir /nilfs/2
> mount -t unionfs -o dirs=/nilfs/2=rw,/nilfs/1=ro,/base=ro none /union
> 
> i.e. chaining the /nilfs/* dirs together with unionfs.

Thank you for letting us know!
It looks nicer than mine.

These may be able to be wrapped in a shell script or in the
mount.nilfs2 helper program.  Or, we may be able to use autofs to make
these mounts automatic.

Cheers,
Ryusuke
