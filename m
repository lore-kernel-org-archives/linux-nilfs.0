From: Shaya Potter <spotter-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
Subject: Re: directory entries
Date: Mon, 01 Sep 2008 10:27:54 -0400
Message-ID: <48BBFBEA.2000308@cs.columbia.edu>
References: <20080826132944.GA17045@aardappel.13thmonkey.org>	<20080901.143956.08023399.ryusuke@osrg.net>	<48BB82F7.4070607@cs.columbia.edu>
	<20080901.171643.74124381.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20080901.171643.74124381.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Ryusuke Konishi wrote:

> 
> I've tried this without making sub directories:
> 
>  # mkdir /nilfs /snap-ro /snap-rw /change
>  # mount -t nilfs2 /dev/sdb1 /nilfs
>  ...
>  # mkcp -s
>  # lscp
>              CNO        DATE     TIME  MODE  SKT   NBLKINC       ICNT
>              ...
>            62305  2008-09-01 16:13:28  ss     -        488         39
>            62306  2008-09-01 16:13:33  cp     -          8         39
> 
>  # mount -t nilfs2 -o ro,cp=62305 /dev/sdb1 /snap-ro
>  # mount -t unionfs -o dirs=/snap-ro=rw unionfs /snap-rw
>  # unionctl /snap-rw --add --before /snap-ro --mode rw /change
>  <use /snap-rw as a writable snapshot mount>
> 
>  # mount
>  ...
>  /dev/sdb1 on /nilfs type nilfs2 (rw,gcpid=9512)
>  /dev/sdb1 on /snap-ro type nilfs2 (ro,cp=62305)
>  unionfs on /snap-rw type unionfs (rw,dirs=/snap-ro=rw)
> 
> It's working fine.
> Is there a quicker way?  (Or something to add?)

well, with new unionfs, you wouldn't use unionctl, but what I did was 
close, but something more along the lines of

- to setup

mkdir /base /nilfs /snap-ro /union
mount -t ext3 /dev/sdb1 /base
mount -t nilfs2 /dev/sdb2 /nilfs

mkdir /nilfs/1

mount -t unionfs -o dirs=/nilfs/1=rw,/base=ro none /union
(use union), all writes go to nilfs

- to rollback to a checkpoint, but keep it writable.

mount -t nilfs2 -o ro,cp=xyz /dev/sdb1 /snap-ro
mkdir /nilfs/2
mount -t unionfs -o dirs=/nilfs/2=rw,/nilfs/1=ro,/base=ro none /union

i.e. chaining the /nilfs/* dirs together with unionfs.
