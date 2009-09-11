From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: How does NILFS2 handle directory management
Date: Fri, 11 Sep 2009 15:23:18 +0900 (JST)
Message-ID: <20090911.152318.31679049.ryusuke@osrg.net>
References: <20090910192619.GA1263@heethoofdje.13thmonkey.org>
	<20090911.102118.69189169.ryusuke@osrg.net>
	<2324ff2b0909102058g1ee407fco3f2482b4732dacca@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <2324ff2b0909102058g1ee407fco3f2482b4732dacca-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, tangyorangesour-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Hi Prasenjit Giri,
On Fri, 11 Sep 2009 09:28:55 +0530, Prasenjit Giri <tangyorangesour-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Fri, Sep 11, 2009 at 6:51 AM, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wrote:
> 
> > Hi Prasenjit Giri, and Reinoud,
> > On Thu, 10 Sep 2009 21:26:19 +0200, Reinoud Zandijk <wrote:
> > > Hi Prasenjit Giri,
> > >
> > > On Fri, Sep 11, 2009 at 12:46:04AM +0530, Prasenjit Giri wrote:
> > > > Even after looking through various sites, forums, mailing lists I could
> > not
> > > > uncover the present directoy management of NILFS2.
> > > >
> > > > As I see a B-tree directory management in your long term to do list, it
> > > > would be really nice if someone would ought to share the information
> > > > regarding the present directory management of NILFS2
> > >
> > > Currently directories are recorded just as a sequential file but not
> > filled
> > > with user data but with dirent entries in their blocks like ext2fs does.
> > > Nothing special about that :)
> > >
> > > I dont know if b+tree directory management would be preferable though.
> > With
> > > some smart caching all directory operations can be made O(1) anyway.
> > >
> > > With regards,
> > > Reinoud Zandijk
> >
> > Yes, directory is a file and it's already managed with b-tree like
> > other files.  However, the current directory design is not O(log n),
> > and is actually slow especially for file creation.
> >
> > So, it leaves room for considering the true "b-tree directory
> > management".
> >
> > OTOH, the replacement has the following points to notice:
> >
> >  1) It may complicate the log writer.
> >
> >    The current log writer is designed on the basis that every data
> >    and meta data is a file.  In NILFS, inodes, segment usage state,
> >    and checkpoints, are managed with correponding meta-data files.
> >
> >    The true "b-tree directory management" may break this uniformity.
> >
> >  2) A disk format change is required.
> >    (We can deem this a trade-off at this stage)
> >
> > This may be a -v3 material.  But anyway, patch proposals are welcome.
> >
> > Thank you,
> > Ryusuke Konishi
> >
> 
> 
> 
> Hello Reinoud Zandijk, Ryusuke Konishi
> 
> This has been more than helpful as I was at complete lost. But with this new
> side of it could you explain the quoted, " --- true 'b-tree directory
> management' --- ".
> 
> I've on this mail list, looking for ideas that would be feasible for an
> undergrad project -- though this adds a very unpleasant twist.
> 
> Is writable snapshot feasible ? If so, is there an abstract for this
> purpose? Is it doable in a years time?
> 
> Or could you all please suggest an alternative on such grounds.
> With regards,
> Prasenjit Giri
> Rajesh D. Yadav
> Ashwin Goel
> Sunil V. Chitkote
> 
> 
> -- 
> Prasenjit Giri

Sorry for my late reply.  The Reinoud's mail reminded me your
question.

> Is writable snapshot feasible ? If so, is there an abstract for this
> purpose? Is it doable in a years time?

Well, it is a desired feature.  But, I think the writable snapshot on
nilfs is a bit challenging.

It needs extending checkpoint file to allow branching.  The current
nilfs sequentially numbers checkpoints, and there is no branch on the
series.

One possible approach is to allocate checkpoints of branches in high
order zone of checkpoint numbers:

  --> checkpoint number

 |--------------------+            ...       |---|   ...  |---|  
       past cno   current cno              series of      series of
                                           checkpoints    branch-b
                                           for writable
                                           snapshot-A

In addition, it needs to enhance DAT file.

The current DAT file has the following entries.  The GC of nilfs uses
the [start, end) values to judge each block is live or dead for given
checkpoint period [cno1, cno2].

struct nilfs_dat_entry {
        __le64 de_blocknr;  /* disk block address */
        __le64 de_start;    /* start checkpoint number */
        __le64 de_end;      /* end checkpoint number this block died */
        __le64 de_rsv;
};

Live blocks are copied in GC, whreas dead blocks are discarded.

If the writable snapshot makes a branch on checkpoints, this entry
needs to be enhanced to have multiple [start, end) ranges.

One possible approach is to use the reserved field and chain multiple
entries to have multiple ranges.

How do you think these ?

> Or could you all please suggest an alternative on such grounds.

How about developing a new garbage collector.

The current GC has several problems:

 * it doesn't adjust GC speed. it reclaims in constant speed
   even while the I/O load is very high.
   it doesn't icrease speed even if the partition is in a near disk
   full condition.

 * it select the oldest segment for GC, and doesn't take account of
   the number of live or dead blocks in the segment.

 * it doesn't have defrag work.

The garbage collector is implemented as a userland daemon, so we can
easily replace it with a new one.

Regards,
Ryusuke Konishi
