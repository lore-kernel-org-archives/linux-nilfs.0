From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [SPAM] Inquiry: disk format change in the future
Date: Thu, 20 Aug 2009 02:34:32 +0900 (JST)
Message-ID: <20090820.023432.30519722.ryusuke@osrg.net>
References: <200908191131.56412.yann.morin.1998@anciens.enib.fr>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <200908191131.56412.yann.morin.1998-i2lMhxPFobAPxyCoDXghUg@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, yann.morin.1998-i2lMhxPFobAPxyCoDXghUg@public.gmane.org

Hi,
On Wed, 19 Aug 2009 11:31:56 +0200, "Yann E. MORIN" wrote:
> Hello All!
> 
> I've searched the archives, but could not find the answer to the
> following questions:
> 
>  - will there be, or what is the probability of, a disk format change
>    in the near future (few months)?

We still have some possibilities for the format change at this time.

Basically I intend to keep the disk format, but some new features like

- Extended attributes, ACLs
- Rollback
- Checkpoint based remote replication

may require it.  So far, we haven't seen any specific requisition.
 
>  - if so, what would be the plan for migrating existing file systems
>    to the new format?

In that case, I think we should provide a migration tool along with
the change.
 
> I'm contemplating using nilfs2 as the file system for my server, as
> it offers all the features I need. OTOH, I would be quite disapointed
> if migrating my existing file systems to the new format would imply
> (too long a) down-time.

Quite right.  I think it's good if the garbage collector or something
can convert the disk format running background.

> Anyway, keep up the very good work! nilfs2 is very nice! :-)

Thank you!

Ryusuke Konishi
 
> Regards,
> Yann E. MORIN.
> 
> PS. I already tried sending this message, but 24h later, it has not shown
>     up on the list archives. Sorry in advance if it eventually comes up.
> YEM.
> 
> --
