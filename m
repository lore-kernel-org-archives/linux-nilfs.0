From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: nilfs_cleanerd on root partition
Date: Mon, 22 Jun 2009 01:05:10 +0900 (JST)
Message-ID: <20090622.010510.133415216.ryusuke@osrg.net>
References: <20090621134418.GA4836@lh.kyla.fi>
	<20090621140234.GB4836@lh.kyla.fi>
	<20090621143708.GC4836@lh.kyla.fi>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090621143708.GC4836-7bsdmvTMBDzHOG6cAo2yLw@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, sliedes-kf+aQKke1yb1KXRcyAk9cg@public.gmane.org

Hi,
On Sun, 21 Jun 2009 17:37:08 +0300, Sami Liedes wrote:
> On Sun, Jun 21, 2009 at 05:02:34PM +0300, Sami Liedes wrote:
> > You say I should start the cleanerd by running
> > 
> >  # nilfs_cleanerd /dev/sdb1 /
> > 
> > However nothing in the output of `nilfs_cleanerd -h' indicates
> > anything of the second parameter (mount point). Looking at the source,
> > that's how mount.nilfs2 runs it too, and that's exactly the case where
> > it fails.
> 
> OK, I debugged a bit and figured out what the real problem is. It's
> the fact that nilfs_find_fs() is too strict about the mount points
> being the same. Namely, it considers /media/lacie and /media/lacie/ to
> be different mount points (it merely does a strcmp()).
>
> /proc/mounts always uses the former syntax, so if the mount command is
> something like `mount /dev/mapper/lacie /media/lacie/ -t nilfs2', the
> cleanerd is not started because mount passes "/media/lacie/" as the
> mount point, and nilfs_find_fs() expects it to not have the last
> slash.
> 
> 	Sami

Grr, that's an elementary and influential bug.  Okay, I'll fix it.

Sami, thank you for finding this!

Cheers,
Ryusuke Konishi
