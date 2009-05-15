From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: users Digest, Vol 38, Issue 13
Date: Fri, 15 May 2009 09:36:11 +0900 (JST)
Message-ID: <20090515.093611.94859942.ryusuke@osrg.net>
References: <mailman.1.1242270001.16807.users@nilfs.org>
	<20090514193916.1d8e982e@simplux>
	<20090515.092143.09779544.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090515.092143.09779544.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
Cc: milosdsax-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Fri, 15 May 2009 09:21:43 +0900 (JST), Ryusuke Konishi wrote:
> On Thu, 14 May 2009 19:39:16 +0200, "Michael Niederle" wrote:
> > The todo-list mentions that more copies of the superblock are needed. I
> > strongly agree! I think this should be one of the top items on the todo-list.
> > 
> > Greetings, Michael
> 
> The latest nilfs already has secondary super block in tail of
> partition.  But it looks insufficient for this pendrive problem.
> 
> I think ensuring write on unmount should come before that.

Just a quick note.  The write on unmount is already _DONE_ on the
source code.  I here mean some enhanced operation like diskcache
flushing.

Ryusuke Konishi
