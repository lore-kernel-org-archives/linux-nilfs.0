From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: automount checkpoints
Date: Sat, 06 Sep 2008 00:02:37 +0900 (JST)
Message-ID: <20080906.000237.118984415.ryusuke@osrg.net>
References: <c28029380809050532v4d81f093sa0abe41e92c84dc6@mail.gmail.com>
	<20080905132608.GA26355@aardappel.13thmonkey.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20080905132608.GA26355-5cYspOl2ggRz6xQTk39kMVfVdRo2wo/d@public.gmane.org>
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
To: Giacomo Graziosi <g.graziosi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Reinoud Zandijk <reinoud-S783fYmB3Ccdnm+yROfE0A@public.gmane.org>
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi Giacomo, Hi Reinoud,
On Fri, 5 Sep 2008 15:26:08 +0200, Reinoud Zandijk wrote:
> Hi folks, hi Giacomo,
> 
> On Fri, Sep 05, 2008 at 02:32:58PM +0200, Giacomo Graziosi wrote:
> > I'd like to know if it is possible to mount every checkpoint at once,
> > something like the .zfs/snapshot/ folder used by ZFS (which contains a
> > folder linked to every snapshot, readonly) but for the checkpoints.
> 
> i like the HAMMER fs feature of referencing to every file by 
> checkpoint/snapshot number: dir/file@@14532 gives checkpoint 14532's 
> version of `file' or rootdir@@13 for checkpoint 13's version of the 
> rootdir. HAMMER's `undo(1)' is thus very neat and easy to implement.
> 
> In NilFS it would mean looking up the IFILE for the checkpoint and fetch 
> the same inode... or walk the tree to the same name... effectively making 
> checkpoint X a temporary snapshot, mounting it somewhere and then returning 
> the vnode/inode for that looked up file. Thats going to be fun to 
> implement. OR allways load/keep all checkpoints/snapshots IFILE for the 
> referencing game. Hmmm.....
> 
> As for your question, snapshots ok, but checkpoints? hmm.... it would need 
> refcounting for references to its files to prevent the garbage collector to 
> wreak havoc... 
>
> So, yes, its possible, but easy? there are some `interesting' issues to 
> solve :-D

As Reinoud mentioned, plain checkpoints of NILFS2 are not mountable
due to constraints needed for the garbage collection.

Though NILFS version 1 had an pseudo automount environment using
autofs, it's not yet available for the version 2.

The automount enviromnent of NILFSv1 was written in perl.
Maybe we can do similar things for NILFSv2, but serveral changes would
be needed; the script for v2 has to set up a writeble mount to make
snapshot tools available.  In addition, it has to get a checkpoint
list from the nilfs2 kernel module in different way (using lscp is the
easiest way for this), and it has to change requested checkpoints into
snapshots before mounting them (call chcp?).

Mind you, the NILFSv1 doesn't have garbage collector.
Don't use it for your practical use.

Regards,
Ryusuke
