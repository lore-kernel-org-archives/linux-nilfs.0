From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Dump tools for checkpoints
Date: Mon, 16 Mar 2009 00:12:18 +0900 (JST)
Message-ID: <20090316.001218.90577760.ryusuke@osrg.net>
References: <2883.84.133.202.72.1235869032.squirrel@ssl.its-beck.de>
	<20090308.143916.113539820.ryusuke@osrg.net>
	<2893.84.133.153.87.1236962534.squirrel@ssl.its-beck.de>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <2893.84.133.153.87.1236962534.squirrel-lZV7jZi4TBeO2lRZCxuEEg@public.gmane.org>
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
To: nilfs-MZZvbRqs/9F0RdzJJlgK+g@public.gmane.org
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

On Fri, 13 Mar 2009 17:42:20 +0100, nilfs-MZZvbRqs/9F0RdzJJlgK+g@public.gmane.org wrote:
> Hi,
> 
> > Basically I believe this is possible, but one problem is how to
> > realize rollback of the remote nilfs which will become required when
> > allowing user's updates or garbage collection on the remote device
> > after synchronization.
> 
> let's call them master / slave, I'm confused which one is remote :)
> 
> I assume only the master is writable and slaves don't do any changes or
> cleaning.

If that premise is allowed, things would become so simple.  But, is it
suitable for practical use?

If cleaning is not allowed, the slave partition gets full
periodically.  So, frequent full replications would be needed in that
case.

If we supposed to have very huge slave device, breaking the constraint
could be costly because recovery to the slave state requires a full
replication.
 
> Require that all checkpoints from last sync to present are still existing.
> Upon dump on master, cleanerd has to be suspended and may resume after
> dump. Does that make things easier?

Yes, absolutely.  I have no mind to think the dumping while cleanerd
operates.

The dump tool at least should hold write lock for .nilfs to prevent
cleaning, and I would make the tool so that it suspends and resumes
cleanerd by signals (if I were).

> By the way: When I completely disable cleanerd on the master, wouldn't it
> be possible to define a byte-range on the block device which makes up the
> difference between two checkpoints and copy that to the slaves?

We would get multiple ranges on the device not a single range because
nilfs may allocate segments in non-sequential order.  (Though the
current cleanerd algorithm induces fifo order allocation, it is not
guranteed by nilfs.)

The current sufile doesn't have information on the sequence (or chain)
of allocated segments.  So, it requires scanning of on-disk segment
headers; each on-disk segment header has a next pointer.

If the scanning cost becomes an issue, we can include the next pointer
in sufile to minimize the cost.
 
Regards,
Ryusuke Konishi
