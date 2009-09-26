From: Jeff Layton <laytonjb-fOdFMYwuEsI@public.gmane.org>
Subject: Re: IOzone testing
Date: Sat, 26 Sep 2009 08:36:39 -0400
Message-ID: <4ABE0AD7.7000904@att.net>
References: <4ABE0553.3090502@att.net>
	<debc30fc0909260554s21969638h280d9e6f89b7596e@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <debc30fc0909260554s21969638h280d9e6f89b7596e-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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

J=E9r=F4me Poulin wrote:
> On Sat, Sep 26, 2009 at 8:13 AM, Jeff Layton <laytonjb-fOdFMYwuEsI@public.gmane.org> wrote:
>   =

>> Good morning,
>>
>> I'm running IOzone on a NILFS2 partition and it's running alot
>> slower that I had expected. I'm pretty sure it's because of the
>> checkpoints. I can change the protection_period to something
>> very small (or zero). Would that improve the performance?
>>
>>     =

> The protection period only affects how the cleaner daemon will clean
> the old checkpoints, if 0 I guess it will just clean them up as soon
> as it can but it won't stop creating them. You could, just for
> benchmark purpose, kill nilfs_cleanerd which will stop checkpoint
> related activities.
>   =

It will only stop the clean up of checkpoints outside of policy - correct?
So it won't stop them from being created but it will stop the cleaning =

process.

>> In addition, is there a way to turn off checkpointing?
>>
>>     =

> The whole filesystem is based on those checkpoint, the fact that it is
> a log filesystem makes it so all writes are made at the end of the
> device, and when a write is complete, a checkpoint is made.
>   =


Understood. But for benchmarks like IOzone where you are creating
files and most likely syncing, this will trigger a checkpoint. I haven't
looked too much at IOzone but it might even be causing a sync after
each record right, again forcing a checkpoint.

So I was looking for some way to control how often checkpoints are
created - something like the protection_period option for the GC. But
I understand that the checkpoint is a part of the design of the file system.

Thanks!

Jeff
