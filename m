From: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: IOzone testing
Date: Sat, 26 Sep 2009 09:27:28 -0400
Message-ID: <debc30fc0909260627n12616bddif87b25f0ae64b6f5@mail.gmail.com>
References: <4ABE0553.3090502@att.net>
	<debc30fc0909260554s21969638h280d9e6f89b7596e@mail.gmail.com> 
	<4ABE0AD7.7000904@att.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <4ABE0AD7.7000904-fOdFMYwuEsI@public.gmane.org>
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
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

On Sat, Sep 26, 2009 at 8:13 AM, Jeff Layton <laytonjb-fOdFMYwuEsI@public.gmane.org> wrote:
> It will only stop the clean up of checkpoints outside of policy - correct?
> So it won't stop them from being created but it will stop the cleaning
> process.
>
It will completely stop cleaning checkpoints, which is what is
consuming drive I/O. Checkpoints in themselve don't use much
ressources, cleaning them however does.

>
> Understood. But for benchmarks like IOzone where you are creating
> files and most likely syncing, this will trigger a checkpoint. I haven't
> looked too much at IOzone but it might even be causing a sync after
> each record right, again forcing a checkpoint.
>
> So I was looking for some way to control how often checkpoints are
> created - something like the protection_period option for the GC. But
> I understand that the checkpoint is a part of the design of the file system.
>
Checkpoints are created each time a change is commited to disk right,
but creating a checkpoint does not take much system ressources, try
time'ing mkcp, it won't use any ressources, it just writes a marker at
the end of the disk to say that all that is written behind it is good
to use if a crash happens or the user wants to mount the partition in
the past. Increasing checkpoint period would just increases the risk
of losing more data on crash with minimal or no performance gain.

I don't know if you ever worked with shadow copies in Windows but
creating a shadow copie would consume lots of drive I/O and CPU, that
is because NTFS wasn't conceived as a log filesystem like NILFS and
must write structures and files to the disk for whatever changes
happened to the disk, it must also freeze the filesystem and make sure
all writes are atomic before creating the snapshot. While NILFS just
write a checkpoint each time it knows the last write is complete,
converting a checkpoint to a snapshot then is just a matter of
changing a flag so the GC won't remove it afterward.
