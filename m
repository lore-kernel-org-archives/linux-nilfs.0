From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Can't mount nilfs - error searching super root.
Date: Wed, 22 Apr 2009 23:44:55 +0900 (JST)
Message-ID: <20090422.234455.05227091.ryusuke@osrg.net>
References: <3313c4ab0902110709v1e9783fcm8f3dad6507f40347@mail.gmail.com>
	<20090212.143408.130857730.ryusuke@osrg.net>
	<3313c4ab0904220618r22b62e7qa8b239ccbcf02270@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <3313c4ab0904220618r22b62e7qa8b239ccbcf02270-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: milosdsax-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi!
On Wed, 22 Apr 2009 15:18:33 +0200, Milos Jana <milosdsax-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi again,
> Is it safe for me to try to mount my drive with current release of nilfs and
> nilfs-utils? Release notes are quite short, I'm not sure if disk format
> change may affect me and whether "Some reported bugs of userland tools were
> fixed" also include "error searching super root" problem.
> Regards, MJ

The disk format compatibility is not broken for x86.  You can try the
latest nilfs2-utils and nilfs2-module.

Since the "error searching super root" problem is not a bug of mount
procedure but a result of incomplete disk write, it will occur for the
nilfs2 drive in question.

Even after you create a new partition with mkfs.nilfs2, it could be
reproduced if the device or (or the device driver) still has the
problem on sync write.  So please do not put valuable data on the
nilfs2 partition.

I'd like to know the root cause of the problem and take measures if I
can do something on file system layer.
I appreciate if you retry using nilfs on the device.

Thanks,
Ryusuke Konishi

> On Thu, Feb 12, 2009 at 7:34 AM, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wrote:
> 
> > Hi,
> > On Wed, 11 Feb 2009 16:09:32 +0100, Milos Jana wrote:
> > > Uhm... does it mean that data from my pendrive in unrecoverable? Is there
> > > any chance that future release on fsck0.nilfs will be able to recover it?
> > > On Fri, Jan 30, 2009 at 1:03 PM, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
> > wrote:
> >
> > Oh, sorry. I once looked into the fsck0, but it was paused because I
> > had to do so many things.  I'll increase priority for this if you
> > really need it.  Meanwhile I'm worrying that the same trouble occurs
> > again and again even if fsck0 will be improved.
> >
> > I feel we think removing the cause of the problem because
> > making better fsck will take some time.
> > And I wonder why the pendrive does not write all data for cleanly
> > unmounted partition so often.  It may need bugfix for the device driver,
> > for example it may have a silent error problem (i.e. it may complete
> > I/O operations even if it couldn't handle them properly).
> >
> > Anyway, I will be able to back to fsck0 after a while.
> >
> > Regards,
> > Ryusuke
