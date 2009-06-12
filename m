From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Discard Changes
Date: Fri, 12 Jun 2009 13:05:58 +0900 (JST)
Message-ID: <20090612.130558.21013146.ryusuke@osrg.net>
References: <mailman.1.1244516401.12212.users@nilfs.org>
	<20090611083413.1f18a0eb@simplux>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090611083413.1f18a0eb@simplux>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, mniederle-RbZlAiThDcE@public.gmane.org

Hi,
On Thu, 11 Jun 2009 08:34:13 +0200, "Dipl.-Ing. Michael Niederle" wrote:
> Hi!
> 
> I found the item "checkpoint rollback" in the todo-list. By "checkpoint
> rollback" you mean discarding all changes since a given checkpoint?

Yes, exactly.
 
> Such a feature would be *very* nice! I can't imagine that it should be very
> complicated to implement, but I might be wrong.
> 
> In SIMPLUX (a live distribution) users shall have a chance to abolisch
> all changes made in a session. So I would create a snapshot at each startup and
> remove all checkpoints created afterwards to revert to the previous state if
> user decides to do so.
> 
> Greetings, Michael

I imagine it is likely be compilcated in NILFS because a few metadata
files have no past versions in the current implementation.

Nilfs can change checkpoints to snapshots in later.  So, I think the
rollback feature should inherit this characteristics.  That is,
rollback without a prior make-snapshot operation.

Cheers,
Ryusuke Konsihi
