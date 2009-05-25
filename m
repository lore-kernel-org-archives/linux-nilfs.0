From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Some problems
Date: Tue, 26 May 2009 06:39:00 +0900 (JST)
Message-ID: <20090526.063900.00723960.ryusuke@osrg.net>
References: <mailman.1.1243047601.4877.users@nilfs.org>
	<20090523221120.086a1002@simplux>
	<20090524.175101.94865345.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090524.175101.94865345.ryusuke-sG5X7nlA6pw@public.gmane.org>
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

On Sun, 24 May 2009 17:51:01 +0900 (JST), Ryusuke Konishi wrote:
> > >rmcp 685
> > rmcp: 685: operation not permitted
> > 
> > What's the cause of this message? (rmcp also failed for all other snapshots;
> > the failed rmcp did not produce any kernel message)
> 
> rmcp is allowed only for plain checkpoints.
> So, you have to change it to the plain checkpoint like
> 
>  # chcp cp 685 1330 ...
>  # rmcp 685 ...
> 
> Actually, you don't have to do the rmcp because the garbage collection
> will delete plain checkpoints.
> 
> I remember someone asked a simliar question before.
> 
> I think we should make the error message more user-friendly.  And we
> should allow force option of rmcp to remove snapshots; the current
> force option does not have this meaning.

I found the current error code against the removal for snapshots is
badly assigned, and rmcp cannot distinguish it from real permission
errors.

So, first I'm thinking to change the error code to EBUSY or something.

Regards,
Ryusuke Konishi
