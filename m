From: Dave <dave-/hCUnnzDXf0AvxtiuMwx3w@public.gmane.org>
Subject: Re: Nilfs features
Date: Tue, 02 Jun 2009 12:31:24 +0400
Message-ID: <4A24E35C.6040209@0bits.com>
References: <debc30fc0905292044r311a2842j53832195d0ef88bd@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <debc30fc0905292044r311a2842j53832195d0ef88bd-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>, jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On 05/30/09 07:44, J=E9r=F4me Poulin wrote:
>     checkpointing before installing (which may by default create a
>     snapshot), and then i'd restart the constant checkpointing after i'd
>     finished the install/restore. Please note, i am not comparing nilfs to
> =

>     zfs, but zfs doesn't have constant cp (i think) but does have the
> =

>     feature i mention, i.e you take snapshots when needed (perhaps via a
>     cron job daily, monthly, weekly)
> =

> I just want to give my though on this one, keeping checkpoints as-is =

> seems ideal to me, in this case you have a very granular way to go back =

> in time, however, what you say is right, when installing a new software =

> for example, it's nice to have a way to get back to it, I guess in this =

> case you would just convert the last checkpoint to snapshot before the =

> installation so you have a time mark of where to rollback (and of course =

> have a steady state which won't go away during the installation), right?

Yes correct. Imagine you're installing a fresh OS on a nilfs formatted =

disk. You'd have 1000+ interemediate checkpoints which would be of no =

use. Temporary suspension until the OS is installed is a real life =

use-case. Your filesystem is in 2 states, either no OS or a full OS state.

Cheers
D
