From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: nilfs_cpfile_delete_checkpoints: cannot delete
 block
Date: Sun, 10 May 2009 18:10:00 +0900 (JST)
Message-ID: <20090510.181000.90094737.ryusuke@osrg.net>
References: <4A006EAB.6000206@prnet.org> <4A00944B.2020105@prnet.org>
	<20090506.120204.27533580.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090506.120204.27533580.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
To: admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi,
On Wed, 06 May 2009 12:02:04 +0900 (JST), Ryusuke Konishi wrote:
> Hi,
> On Tue, 05 May 2009 21:32:27 +0200, David Arendt wrote:
> > Hi,
> > 
> > after cleaner was running for 2 hours and freeing up 200gbytes of space 
> > I had the following crash:
> > 
> > nilfs_cpfile_delete_checkpoints: cannot delete block: cno=76377, range = 
> > [75980, 76972)
> > NILFS: GC failed during preparation: cannot delete checkpoints: err=-2
> > NILFS_PAGE_BUG(c10d67e0): cnt=2 index#=74049180 flags=0x40000835 
> > mapping=f71d10d4 ino=0
> >  BH[0] d3cbdb30: cnt=2 block#=74049180 state=0x2002b
> > ------------[ cut here ]------------
> > kernel BUG at /home/admin/x/nilfs-2.0.12/fs/btnode.c:233!
> 
> The log shows a btree routine, nilfs_btree_propagate() has detected an
> orphan btree node in the page cache.  Looks another inconsistency.
> 
> I'd like to know if this is a regression of the previous patch or not
> ( I guess it's not ). If you see this for new volumes, please let me
> know.
> 
> I'll digging into the btree code to hunt this later.
> 
> Thanks,
> Ryusuke Konishi

I haven't yet identified if this is a regression or not.

The previous patch has included several changes.  So, I will send a
moderate patch for upstream.

Regards,
Ryusuke Konishi
