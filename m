From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Constant checkpointing and cleanerd activity -
 doesn't play nice with mount --bind ?
Date: Wed, 01 Apr 2009 01:09:51 +0900 (JST)
Message-ID: <20090401.010951.130984382.ryusuke@osrg.net>
References: <20090331.234437.112904649.ryusuke@osrg.net>
	<20090401.001059.06956465.ryusuke@osrg.net>
	<591bc86b0903310814t2814ab95ie71077d5bb59f99d@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <591bc86b0903310814t2814ab95ie71077d5bb59f99d-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, san-UZOCzndLCy9BDgjK7y7TUQ@public.gmane.org

Hi,
On Tue, 31 Mar 2009 15:14:48 +0000, Alex Bitney <san-UZOCzndLCy9BDgjK7y7TUQ@public.gmane.org> wrote:
> On Tue, Mar 31, 2009 at 3:10 PM, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wrote:
> 
> > On Tue, 31 Mar 2009 23:44:37 +0900 (JST), Ryusuke Konishi <
> > ryusuke-sG5X7nlA6pw@public.gmane.org> wrote:
> >
> > Let me add one thing.  Since the bind-mount and original r/w-mount
> > share the same device, only one cleanerd is enough for them.  (In
> > fact, two cleanerds conflict with one another).  So, we can give over
> > the GC functionality to the original mount point without incident.
> 
> 
> Just a question; why can't you use single cleaner? It would detect all
> mounted partitions and perform needed tasks, maybe in parallel, as needed.

Well, single (shared) cleanerd approach indeed sounds better in the
long term.  The merit of the current pid and signal based (individual
cleaner) approach is its simplicity.  So, I think we should make the
shift to the single cleaner approach if things get unmanageable within
the current way.

The reason why we are not using the shared cleaner, is just we took
the present way when we first designed it.

Regards,
Ryusuke Konishi
