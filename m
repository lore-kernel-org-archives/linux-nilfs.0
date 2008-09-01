From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: directory entries
Date: Mon, 01 Sep 2008 17:16:43 +0900 (JST)
Message-ID: <20080901.171643.74124381.ryusuke@osrg.net>
References: <20080826132944.GA17045@aardappel.13thmonkey.org>
	<20080901.143956.08023399.ryusuke@osrg.net>
	<48BB82F7.4070607@cs.columbia.edu>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <48BB82F7.4070607-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, spotter-eQaUEPhvms7ENvBUuze7eA@public.gmane.org

On Mon, 01 Sep 2008 01:51:51 -0400, Shaya Potter wrote:
> As I mentioned a while ago, we jury rigged writable snapshots by 
> combining nilfs w/ unionfs.

Yeah, I remember.
It sounds much better at least than switching with rsync :)

> Instead of writing to the root of the file system, you right to a subdir.
> 
> so we start w/ /nilfs/t0
> 
> when we want to rollback and continue to work
> 
> we mount the ro snapshot on /s0 and create /nilfs/t1 use unionfs to 
> union together /s0 (ro) and /nilfs/t1 (rw).

I've tried this without making sub directories:

 # mkdir /nilfs /snap-ro /snap-rw /change
 # mount -t nilfs2 /dev/sdb1 /nilfs
 ...
 # mkcp -s
 # lscp
             CNO        DATE     TIME  MODE  SKT   NBLKINC       ICNT
             ...
           62305  2008-09-01 16:13:28  ss     -        488         39
           62306  2008-09-01 16:13:33  cp     -          8         39

 # mount -t nilfs2 -o ro,cp=62305 /dev/sdb1 /snap-ro
 # mount -t unionfs -o dirs=/snap-ro=rw unionfs /snap-rw
 # unionctl /snap-rw --add --before /snap-ro --mode rw /change
 <use /snap-rw as a writable snapshot mount>

 # mount
 ...
 /dev/sdb1 on /nilfs type nilfs2 (rw,gcpid=9512)
 /dev/sdb1 on /snap-ro type nilfs2 (ro,cp=62305)
 unionfs on /snap-rw type unionfs (rw,dirs=/snap-ro=rw)

It's working fine.
Is there a quicker way?  (Or something to add?)

Cheers,
Ryusuke
